{
  den,
  inputs,
  ...
}:
{
  # host aspect
  den.aspects.gregor = {
    # host NixOS configuration
    includes = with den.aspects; [
      server
      udev._.gregor
      hardware._.intel
      acme-darach
      appdaemon
      esphome
      gitea
      grafana
      haproxy
      home-assistant
      influxdb
      mqtt
      nginx-gregor
      plex
      transmission
      ups
      zigbee2mqtt
    ];
    nixos =
      { pkgs, ... }:
      {
        #imports = [ inputs.msg_q.nixosModules.msg_q ];
        environment.shells = with pkgs; [
          fish
          bash
        ];
        environment.systemPackages = [ pkgs.bluez ];
        hardware.bluetooth.enable = true;
        #services.msg_q = {
        #enable = true;
        #port = 9000;
        #openFirewall = true;
        #};
        services.dbus = {
          implementation = "broker";
          enable = true;
        };
        hardware.firmware = [ pkgs.linux-firmware ];

        nix.settings.extra-platforms = [ "aarch64-linux" ];
        boot = {
          loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
            efi.efiSysMountPoint = "/boot";
          };
          initrd.systemd.emergencyAccess = true;
          binfmt.emulatedSystems = [ "aarch64-linux" ];
          zfs.extraPools = [
            "linstore"
            "silent"
          ];
        };
        fileSystems."/home" = {
          device = "silent/home";
          fsType = "zfs";
          neededForBoot = true;
        };
        services.nfs.server = {
          exports = ''
            /var/lib/nfs/yellow 192.168.4.89(rw,sync,no_subtree_check,no_root_squash)
          '';
        };
        networking.hostId = "abcdef01";
      };
  };
}
