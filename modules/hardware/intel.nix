{
  den.aspects.hardware = {
    provides = {
      intel = {

        nixos =
          { config, lib, ... }:
          {
            boot = {
              initrd = {
                availableKernelModules = [
                  "xhci_pci"
                  "ehci_pci"
                  "ata_piix"
                  "usbhid"
                  "usb_storage"
                  "uas"
                  "sd_mod"
                ];
                systemd.enable = true;
              };
              kernelModules = [ "kvm-intel" ];
              zfs = {
                allowHibernation = false;
              };
            };
            hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
          };
      };
    };
  };
}
