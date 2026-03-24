{
  den,
  ...
}:
{
  den.aspects.r5s-firewall = {
    includes = [ den.aspects.router-firewall ];
    nixos =
      { lib, ... }:
      {

        local.firewall.internalInterfaces = [
          "br0"
          "vlan-iot"
          "wg0"
        ];
        local.firewall.externalInterfaces = [ "wan0" ];
        local.firewall.allowedInternalTCPPorts = [
          22
          80
          443
          1883
        ];
        local.firewall.allowedExternalTCPPorts = [
          22
          80
          443
          3020
        ];
        local.firewall.allowedExternalUDPPorts = [ ];
        local.firewall.allowedInternalUDPPorts = [ ];
        networking = {
          enableIPv6 = lib.mkForce true;
          nftables = {
            enable = true;
            ruleset = ''
              define IOT = 192.168.5.0/24
              define LAN = 192.168.4.0/24
              define WG = 192.168.9.0/24
              define HA = 192.168.4.5/32

              table inet filter {
                chain output {
                  type filter hook output priority 100; policy accept;
                  }

                chain input {
                  type filter hook input priority 0; policy drop;

                  # Established/related connections
                  ct state established,related accept

                  # Loopback interface
                  iifname lo accept
                  ip saddr { $IOT, $LAN, $WG } accept
                  accept
                  }

                chain forward {
                  type filter hook forward priority filter; policy drop; 
                  ct state established, related accept
                  #Allow all forwarded packets through
                  iif "wan0" oif { $LAN, $WG } ct status dnat accept
                  ip saddr { $IOT } ip daddr { $HA, 192.168.5.2/32 } accept
                  ip saddr { $LAN, $WG } accept
                }
                }

                table ip nat {
                  chain prerouting { 
                    type nat hook prerouting priority filter; policy accept;
                    # Transmission port forward to gregor
                    udp dport 51413 dnat to 192.168.4.5:51413
                    tcp dport 51413 dnat to 192.168.4.5:51413
                    }

                  chain postrouting {
                    type nat hook postrouting priority filter; policy accept;
                    oifname "wan0" masquerade
                    }
                  }
            '';
          };

          nat = {
            enable = false;
            enableIPv6 = true;
            externalInterface = "wan0";
            internalInterfaces = [
              "br0"
              "wg0"
              "vlan-iot"
            ];
            forwardPorts = [
              {
                destination = "192.168.4.5:32400";
                proto = "tcp";
                sourcePort = 32400;
              }
              {
                destination = "192.168.4.5:1883";
                proto = "tcp";
                sourcePort = 1883;
              }
              {
                destination = "192.168.4.5:8123";
                proto = "tcp";
                sourcePort = 8123;
              }
            ];
          };
        };
      };
  };
}
