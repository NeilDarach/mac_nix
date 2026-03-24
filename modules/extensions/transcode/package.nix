{ inputs, ... }:
{
  den.aspects.transcode = {
    nixos =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [
          (final: previous: {
            inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) transcode;
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
