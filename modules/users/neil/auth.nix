{ den, ... }:
{
  den.aspects.neil = {
    nixos =
      { config, lib, ... }:
      {
        sops.secrets = {
          "hashed_passwords/neil" = {
            neededForUsers = true;
          };
          "user_keys/neil/age/private" = {
            path = "/home/neil/.config/sops/age/keys.txt";
            owner = "neil";
            group = "neil";
            mode = "0600";
          };
          "neil_nixbuild" = lib.mkIf config.nix.distributedBuilds {
            key = "user_keys/nixbuild/ed25519/private";
            path = "/home/neil/.ssh/id_nixbuild";
            owner = "neil";
            group = "neil";
            mode = "0600";
          };
        };
        systemd.tmpfiles.rules = [
          "d /home/neil/.config 755 neil neil"
          "d /home/neil/.config/sops 755 neil neil"
          "d /home/neil/.config/sops/age 755 neil neil"
        ];
        users.users.neil = {
          hashedPasswordFile = config.sops.secrets."hashed_passwords/neil".path;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIJ0nGtONOY4QnJs/xj+N4rKf4pCWfl25BOfc8hEczUg neil.darach@gmail.com"
          ];
        };
      };
  };
}
