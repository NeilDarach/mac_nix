{
  den,
  ...
}:
{
  # host aspect
  den.aspects.r5s = {
    # host NixOS configuration
    includes = with den.aspects; [
      hardware._.nanopi-r5s
      hardware._.nanopi-r5s-networkr8125
      server
      r5s-firewall
      pi-hole
      etcd
    ];
    nixos =
      { lib, pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          tcpdump
          conntrack-tools
          ethtool
        ];
        environment.shells = with pkgs; [
          fish
          bash
        ];
        boot.kernel.sysctl = {
          "net.ipv4.conf.all.forwarding" = true;
          "net.ipv6.conf.all.forwarding" = true;

          # https://github.com/mdlayher/homelab/blob/master/nixos/routnerr-2/configurtion
          "net.ipv6.conf.all.accept_ra" = 0;
          "net.ipv6.conf.all.autoconf" = 0;
          "net.ipv6.conf.all.use_tempaddr" = 0;

          "net.ipv6.conf.wan0.accept_ra" = 2;
          "net.ipv6.conf.wan0.autoconf" = 1;
        };
        networking.enableIPv6 = lib.mkForce true;
        networking.networkmanager.enable = lib.mkForce false;
        services.avahi = {
          enable = false;
          reflector = true;
          allowInterfaces = [
            "br0"
            "vlan-iot"
          ];

        };
      };
  };
}
