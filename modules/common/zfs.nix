{ den, ... }:
{
  den.aspects.zfs = {
    nixos =
      { pkgs,... }:
      {
        boot.supportedFilesystems = [ "zfs" ];
        boot.initrd.kernelModules = [ "zfs" ];
        boot.kernelModules = [ "zfs" ];
        environment.systemPackages = [ pkgs.zfs ];
      };
  };
}
