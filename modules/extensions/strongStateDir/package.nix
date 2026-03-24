{inputs,...}:
{
  den.aspects.strongStateDir = {
    nixos = {pkgs,...}:{
      nixpkgs.overlays = [
        (final: previous: {
          inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) strongStateDir;
        })
      ];
    };
  };
  perSystem =
    { pkgs, ... }:
    let
      script =
        (pkgs.writeScriptBin "strongStateDir" (builtins.readFile ./strongStateDir)).overrideAttrs
          (p: {
            buildCommand = ''
              ${p.buildCommand}
              patchShebangs $out
            '';
          });
      strongStateDir = pkgs.symlinkJoin {
        name = "strongStateDir";
        paths = [
          script
        ]
        ++ (with pkgs; [
          gzip
          gnugrep
          util-linux
          openssh
          zfs
        ]);
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/strongStateDir --prefix PATH : $out/bin";

      };
    in
    {
      packages = { inherit strongStateDir; };
    };
}
