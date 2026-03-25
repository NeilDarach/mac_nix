{ den, ... }:
{
  den.aspects.openssh = {
    nixos =
      { config, lib, ... }:
      {
        services.openssh = {
          enable = true;
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
        sops = {
          secrets = {
            "host_keys/${config.networking.hostName}/ed25519/private" = {
              path = "/etc/ssh/ssh_host_ed25519_key";
            };
          };
        };
      };
  };
}
