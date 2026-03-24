{ den, ... }:
{
  den.aspects.root = {
    nixos =
      { config, lib, ... }:
      {
          sops.secrets = {
            "hashed_passwords/root" = {
              neededForUsers = true;
            };
            "user_keys/root/ed25519/private" = {
              path = "/root/.ssh/id_ed25519";
              owner = "root";
              group = "root";
              mode = "0600";
            };
            "root_nixbuild" = lib.mkIf config.nix.distributedBuilds {
              key = "user_keys/nixbuild/ed25519/private";
              path = "/root/.ssh/id_nixbuild";
              owner = "root";
              group = "root";
              mode = "0600";
            };
            "root_backup" = {
              key = "user_keys/backup/ed25519/private";
              path = "/root/.ssh/id_backup";
              owner = "root";
              group = "root";
              mode = "0600";
            };
          };
          systemd.tmpfiles.rules = [
            "d /root/.ssh 0700 root root"
          ];
          users.users.root = {
            hashedPasswordFile = config.sops.secrets."hashed_passwords/root".path;
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIJ0nGtONOY4QnJs/xj+N4rKf4pCWfl25BOfc8hEczUg neil.darach@gmail.com"
            ];
          };
      };
  };
}
