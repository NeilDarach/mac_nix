{ inputs, den, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells =
        let
          secrets = inputs.secrets;
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              sops
              just
              nixos-anywhere
            ];
            shellHook = ''
              export SECRETS="${toString secrets}/secrets.yaml"
            '';
          };
        };
    };
}
