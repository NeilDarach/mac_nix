{ den, inputs, ... }:
{
  den.default.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.services.openssh.enable {
        sops = {
          secrets = {
            "host_keys/${config.networking.hostName}/ed25519/private" = {
              path = "/etc/ssh/ssh_host_ed25519_key";
            };
          };
        };
        services.openssh = {
          hostKeys = lib.mkForce [
            {
              type = "ed25519";
              path = "/etc/ssh/ssh_host_ed25519_key";
            }
          ];
          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
            StreamLocalBindUnlink = "yes";
            GatewayPorts = "clientspecified";
            AllowUsers = [ "neil" ];
          };
        };
      };
    };
}
