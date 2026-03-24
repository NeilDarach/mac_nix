{ den, inputs, ... }:
{
  den.aspects.goip = {
    includes = [ den.aspects.disko._.std-zfs ];
    nixos = {
      imports = [ inputs.disko.nixosModules.disko ];
      config =
        let
          main = "/dev/disk/by-path/pci-0000:00:04.0";
        in
        {
          disko.devices = {
            disk = {
              main = {
                type = "disk";
                device = main;
                content = {
                  type = "gpt";
                  partitions = {
                    boot = {
                      size = "1M";
                      type = "EF02"; # for the grub MBR
                    };
                    ESP = {
                      size = "512M";
                      type = "EF00";
                      content = {
                        type = "filesystem";
                        format = "vfat";
                        mountpoint = "/boot";
                        mountOptions = [ "umask=0077" ];
                      };
                    };
                    swap = {
                      size = "8G";
                      content = {
                        type = "swap";
                      };
                    };
                    zfs = {
                      size = "100%";
                      content = {
                        type = "zfs";
                        pool = "zroot";
                      };
                    };
                  };
                };
              };
            };
            zpool = {
              zroot = {
                datasets = {
                  "strong/home" = {
                    type = "zfs_fs";
                    mountpoint = "/home";
                    options.mountpoint = "legacy";
                  };
                };
              };
            };
          };
          fileSystems = {
            "/home".neededForBoot = true;
          };
        };
    };
  };
}
