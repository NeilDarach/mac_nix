{ den,inputs, ... }:
{
  den.aspects.r5s = {
    includes = [ den.aspects.disko._._std-zfs ];
    nixos = {
      imports = [ inputs.disko.nixosModules.disko ];
      config =
        let
          emmc = "/dev/disk/by-id/mmc-AJTD4R-0xd9bdb60e";
          nvme = "/dev/disk/by-id/nvme-KINGSTON_SNV2S250G_50026B7785183EEF";
        in
        {
          disko.devices = {
            disk = {
              emmc = {
                type = "disk";
                device = emmc;
                content = {
                  type = "gpt";
                  partitions = {
                    ESP = {
                      size = "100%";
                      type = "EF00";
                      start = "32M";
                      content = {
                        type = "filesystem";
                        format = "vfat";
                        mountpoint = "/boot";
                        mountOptions = [ "umask=0077" ];
                      };
                    };
                  };
                };
              };
              nvme = {
                type = "disk";
                device = nvme;
                content = {
                  type = "gpt";
                  partitions = {
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
