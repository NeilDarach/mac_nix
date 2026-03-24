{ inputs,... }:
{
  den.aspects.strongStateDir = {
    nixos =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [
          (final: previous: {
            inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) registration;
          })
        ];
      };
  };
  perSystem =
    { pkgs, ... }:
    let
      script = (pkgs.writeScriptBin "registration" (builtins.readFile ./registration)).overrideAttrs (p: {
        buildCommand = ''
          ${p.buildCommand}
          patchShebangs $out
        '';
      });
      registration = pkgs.symlinkJoin {
        name = "registration";
        paths = [
          script
        ]
        ++ (with pkgs; [
          etcd
          findutils
          coreutils
        ]);
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/registration --prefix PATH : $out/bin";

      };
    in
    {
      packages = { inherit registration; };
    };
}
