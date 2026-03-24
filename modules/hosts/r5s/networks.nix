{
  den.aspects.r5s = {
    nixos = {
      systemd.network = {
        enable = true;
        netdevs = {
          "10-br0" = {
            netdevConfig = {
              Kind = "bridge";
              Name = "br0";
            };
          };
          "20-vlan-iot" = {
            netdevConfig = {
              Kind = "vlan";
              Name = "vlan-iot";
            };
            vlanConfig.Id = 5;
          };
        };
        networks = {
          "30-wan" = {
            matchConfig.Name = "wan0";
            networkConfig = {
              DHCP = "yes";
              #LinkLocalAddressing = "no";
              IPv6AcceptRA = true;
            };
            linkConfig.RequiredForOnline = "routable";
          };
          "30-lan1" = {
            matchConfig.Name = "lan1";
            networkConfig.Bridge = "br0";
            DHCP = "no";
            linkConfig.RequiredForOnline = "enslaved";
          };
          "30-lan2" = {
            matchConfig.Name = "lan2";
            networkConfig.Bridge = "br0";
            DHCP = "no";
            linkConfig.RequiredForOnline = "enslaved";
          };
          "40-br0" = {
            matchConfig.Name = "br0";
            bridgeConfig = { };
            vlan = [ "vlan-iot" ];
            address = [ "192.168.4.2/24" ];
            DHCP = "no";
            networkConfig = {
              IPv4Forwarding = true;
              DHCPServer = "no";
              IPv6AcceptRA = false;
            };
            linkConfig.RequiredForOnline = "routable";
          };
          "40-vlan-iot" = {
            matchConfig.Name = "vlan-iot";
            DHCP = "no";
            address = [ "192.168.5.2/24" ];
            networkConfig = {
              IPv4Forwarding = true;
              DHCPServer = "no";
              IPv6AcceptRA = false;
            };
            linkConfig.RequiredForOnline = "routable";
          };
        };
      };
    };
  };
}
