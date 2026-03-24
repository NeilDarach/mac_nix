{
  # user aspect
  den.aspects.backup = {
    nixos =
      { pkgs, ... }:
      {
        users.users.backup = {
          description = "id to receive automated backups";
          group = "backup";
          shell = pkgs.bash;
          isSystemUser = true;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIND0I1j1eM00jt2Kv0tfH4uk713VIzGWdWpvh6W+nsOK neil@gregor"
          ];
        };
        users.groups.backup = { };
        services.openssh.settings.AllowedUsers = [ "backup" ];
        security.sudo = {
          enable = true;
          extraRules = [
            {
              users = [ "backup" ];
              host = "ALL";
              runAs = "ALL:ALL";
              commands = [
                {
                  command = "/run/current-system/sw/bin/zfs";
                  options = [ "NOPASSWD" ];
                }
              ];
            }
          ];
        };
      };
  };
}
