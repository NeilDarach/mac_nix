{
  den.aspects.hardware = {
    provides = {
      alphavps-x86 = {
        nixos =
          {
            pkgs,
            ...
          }:
          {
            hardware.firmware = [ pkgs.linux-firmware ];
            boot = {
              zfs.devNodes = "/dev/disk/by-path";
              initrd.systemd.emergencyAccess = true;
              supportedFilesystems = [ "vfat" ];
              kernelParams = [
                "console=tty0"
                "earlycon=uart8250,mmio32,0xfe660000"
              ];
              initrd.availableKernelModules = [
                "ata_piix"
                "uhci_hcd"
                "virtio_pci"
                "sr_mod"
                "virtio_blk"
              ];
              initrd.kernelModules = [
              ];
              initrd.systemd.enable = true;

              loader = {
                systemd-boot.enable = false;
                grub.enable = true;
                grub.useOSProber = false;
                grub.efiSupport = false;
                efi.canTouchEfiVariables = false;
                timeout = 3;

                generic-extlinux-compatible = {
                  enable = true;
                  useGenerationDeviceTree = true;
                };
              };
            };
          };
      };
    };
  };
}
