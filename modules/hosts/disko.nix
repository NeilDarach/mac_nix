{ den, inputs, ... }:
{
  den.aspects.disko = {
    provides = {
      std-zfs = {
        nixos =
          { pkgs, ... }:
          {
            imports = [ inputs.disko.nixosModules.disko ];
            disko.devices = {
              zpool = {
                zroot = {
                  type = "zpool";
                  mode = "";
                  options.cachefile = "none";
                  rootFsOptions = {
                    canmount = "off";
                    acltype = "posix";
                    atime = "off";
                    relatime = "on";
                    recordsize = "64k";
                    dnodesize = "auto";
                    xattr = "sa";
                    normalization = "formD";
                    secondaryCache = "none";
                    "com.sun:auto-snapshot" = "false";
                  };
                  datasets = {
                    weak = {
                      type = "zfs_fs";
                      options."com.sun:auto-snapshot" = "false";
                      options.mountpoint = "none";
                    };
                    "weak/root" = {
                      type = "zfs_fs";
                      mountpoint = "/";
                      options.mountpoint = "legacy";
                      postCreateHook = "${pkgs.zfs}/bin/zfs list -t snapshot -H -o name | ${pkgs.gnugrep}/bin/grep -E '^weak/root@blank' || ${pkgs.zfs}/bin/zfs snapshot zroot/weak/root@blank";
                    };
                    "weak/nix" = {
                      type = "zfs_fs";
                      mountpoint = "/nix";
                      options.mountpoint = "legacy";
                    };
                    "strong" = {
                      type = "zfs_fs";
                      options."com.sun:auto-snapshot" = "true";
                      options.mountpoint = "none";
                    };
                    "strong/persist" = {
                      type = "zfs_fs";
                      mountpoint = "/persist";
                      options.mountpoint = "legacy";
                    };
                    "strong/keys" = {
                      type = "zfs_fs";
                      mountpoint = "/keys";
                      options.mountpoint = "legacy";
                    };
                    reserved = {
                      type = "zfs_fs";
                      options."com.sun:auto-snapshot" = "true";
                      options.mountpoint = "none";
                      options.refreservation = "2G";
                    };
                  };
                };
              };
            };
            fileSystems = {
              "/".neededForBoot = true;
              "/nix".neededForBoot = true;
              "/keys".neededForBoot = true;
              "/persist".neededForBoot = true;
              "/boot".neededForBoot = true;
            };
          };
      };
    };
  };
}
