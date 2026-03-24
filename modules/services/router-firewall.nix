{
  config,
  lib,
  ...
}:
{
  den.aspects.router-firewall = {
    nixos =
      let
        cannonicalizePortList = ports: lib.unique (builtins.sort builtins.lessThan ports);
        cannonicalizeInterfaceList = interfaces: lib.lists.uniqueStrings interfaces;
      in
      {
        options = {
          local.firewall.allowedInternalTCPPorts = lib.mkOption {
            type = lib.types.listOf lib.types.port;
            default = [ ];
            apply = cannonicalizePortList;
            example = [
              88
              1883
            ];
            description = "TCP ports to be opened for internal interfaces";
          };
          local.firewall.allowedInternalUDPPorts = lib.mkOption {
            type = lib.types.listOf lib.types.port;
            default = [ ];
            apply = cannonicalizePortList;
            example = [ 53 ];
            description = "UDP ports to be opened for internal interfaces";
          };
          local.firewall.allowedExternalTCPPorts = lib.mkOption {
            type = lib.types.listOf lib.types.port;
            default = [ ];
            apply = cannonicalizePortList;
            example = [ 22 ];
            description = "TCP ports to be opened for external interfaces";
          };
          local.firewall.allowedExternalUDPPorts = lib.mkOption {
            type = lib.types.listOf lib.types.port;
            default = [ ];
            apply = cannonicalizePortList;
            example = [ ];
            description = "UDP ports to be opened for external interfaces";
          };
          local.firewall.internalInterfaces = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            apply = cannonicalizeInterfaceList;
            example = [ "br0" ];
            description = "Interfaces to be treated as local for NFT port opening";
          };
          local.firewall.externalInterfaces = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            apply = cannonicalizeInterfaceList;
            example = [ "wan0" ];
            description = "Interfaces to be treated as external for NFT port opening";
          };
        };
        config = {

          networking = {
            firewall.interfaces = lib.lists.fold (a: b: lib.recursiveUpdate a b) { } [
              (builtins.listToAttrs (
                map (n: {
                  name = n;
                  value = {
                    allowedTCPPorts = config.local.firewall.allowedInternalTCPPorts;
                  };
                }) config.local.firewall.internalInterfaces
              ))
              (builtins.listToAttrs (
                map (n: {
                  name = n;
                  value = {
                    allowedUDPPorts = config.local.firewall.allowedInternalUDPPorts;
                  };
                }) config.local.firewall.internalInterfaces
              ))
              (builtins.listToAttrs (
                map (n: {
                  name = n;
                  value = {
                    allowedTCPPorts = config.local.firewall.allowedExternalTCPPorts;
                  };
                }) config.local.firewall.externalInterfaces
              ))
              (builtins.listToAttrs (
                map (n: {
                  name = n;
                  value = {
                    allowedUDPPorts = config.local.firewall.allowedExternalUDPPorts;
                  };
                }) config.local.firewall.externalInterfaces
              ))
            ];
          };
        };
      };
  };
}
