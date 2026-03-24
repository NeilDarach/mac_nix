{
  den.aspects.plex = {
    nixos =
      { pkgs, ... }:
      let
        version = "1.42.2.10156-f737b826c";
        sha256 =
          {
            x86_64-linux = "sha256-1ieh7qc1UBTorqQTKUQgKzM96EtaKZZ8HYq9ILf+X3M=";
            aarch64-linux = "sha256-Vm38oO+zhFyHBy6fDuMphDlaqM43BIdLniQ7VJDMAQU=";
          }
          ."${pkgs.stdenv.hostPlatform.system}";
        arch =
          {
            x86_64-linux = "amd64";
            aarch64-linux = "arm64";
          }
          ."${pkgs.stdenv.hostPlatform.system}";
      in
      {
        nixpkgs.overlays = [
          (final: previous: {
            plex = previous.plex.override {
              plexRaw = previous.plexRaw.overrideAttrs (o: {
                src = final.fetchurl {
                  inherit version sha256;
                  url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver-${version}-${arch}.deb";
                };
              });

            };
          })
        ];
      };
  };
  perSystem =
    { pkgs, ... }:
    let
      script = (pkgs.writeScriptBin "transcode" (builtins.readFile ./transcode)).overrideAttrs (p: {
        buildCommand = ''
          ${p.buildCommand}
          patchShebangs $out
        '';
      });
      cliHandbrake = pkgs.handbrake.override { useGtk = false; };
      tvnamer_cfg = ./tvnamer.json;

      transcode = pkgs.symlinkJoin {
        name = "transcode";
        paths = [
          script
        ]
        ++ (with pkgs; [
          jq
          coreutils
          curl
          tvnamer
          transmission_4
          cliHandbrake
          procps
          findutils
        ]);
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/transcode --set $out/bin --set TVNAMERCFG ${tvnamer_cfg}";

      };
    in
    {
      packages = { inherit transcode; };
    };
}
