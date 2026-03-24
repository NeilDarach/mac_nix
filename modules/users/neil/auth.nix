{ den,inputs, ... }:
{
  den.aspects.neil = {
    darwin = {lib,config,...}:{
        imports = [ inputs.sops-nix.darwinModules.sops ];
      sops.secrets = {
          "user_keys/neil/age/private" = {
            path = "/Users/neil/.config/sops/age/keys.txt";
            owner = "neil";
            group = "staff";
            mode = "0600";
          };
          "user_keys/neil/ed25519/private" = {
            path = "/Users/neil/.ssh/id_ed25519";
            owner = "neil";
            group = "staff";
            mode = "0600";
          };
          "neil_nixbuild" = lib.mkIf config.nix.distributedBuilds {
            key = "user_keys/nixbuild/ed25519/private";
            path = "/Users/neil/.ssh/id_nixbuild";
            owner = "neil";
            group = "staff";
            mode = "0600";
          };
      };
    };
    nixos =
      { config, lib, ... }:
      {
        sops.secrets = {
          "hashed_passwords/neil" = {
            neededForUsers = true;
          };
        };
        systemd.tmpfiles.rules = [
          "d /home/neil/.config 755 neil neil"
          "d /home/neil/.config/sops 755 neil neil"
          "d /home/neil/.config/sops/age 755 neil neil"
          "d /home/neil/.ssh 0700 neil neil"
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
