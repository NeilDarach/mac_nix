{ den, ... }:
{
  den.aspects.openssh = {
    nixos =
      { config, ... }:
      {
        services.openssh.enable = true;
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
