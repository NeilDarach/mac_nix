{ den, ... }:
{
  den.aspects.zfs = {
    nixos =
      { config, ... }:
      {
        boot.supportedFilesystems = [ "zfs" ];
        boot.initrd.kernelModules = [ "zfs" ];
        boot.kernelModules = [ "zfs" ];
        environment.systemPackages = [ pkgs.zfs ];
      };
  };
}
