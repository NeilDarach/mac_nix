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
      imports = [ inputs.impermanence.nixosModules.impermanence ];
      options = {
        local.impermanence = lib.mkEnableOption "Activate impermanence on this host";
      };
      config = lib.mkIf config.local.impermanence {
        environment.persistence."/persist" = {
          hideMounts = true;
          directories = [
            "/etc/nixos"
            "/etc/NetworkManager"
            "/var/lib/nixos"
            "/var/lib/bluetooth"
          ];
          files = [ "/etc/machine-id" ];
        };
        boot.initrd.systemd.enable = true;
        boot.initrd.systemd.services.rollback = {
          description = "Rollback the root filesystem to a pristine state on boot";
          wantedBy = [ "initrd.target" ];
          after = [ "zfs-import-zroot.service" ];
          before = [ "sysroot.mount" ];
          path = [ pkgs.zfs ];
          unitConfig.DefaultDependencies = "no";
          serviceConfigType = "oneshot";
          script = ''
            echo "    >> >> attempting rollback << <<"
            zfs rollback -r zroot/weak/root@blank && echo "    >> >> rollback complete << <<"
          '';
        };
      };
    };
}
