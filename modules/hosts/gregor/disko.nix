{ den, inputs, ... }:
{
  den.aspects.gregor = {
        includes = [ den.aspects.disko._.std-zfs ];
    nixos = {
      imports = [ inputs.disko.nixosModules.disko ];
      config =
        let
          main = "/dev/disk/by-id/ata-KINGSTON_SV300S37A240G_50026B7762013410";
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
          };
        };
    };
  };
}
