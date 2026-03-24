{
  den,
  ...
}:
{
  # host aspect
  den.aspects.goip = {
    # host NixOS configuration
    includes = with den.aspects; [
      hardware._.alphavps-x86
      server
      nginx-goip
      gff
    ];
    nixos =
      { pkgs, lib, ... }:
      {
        environment.shells = with pkgs; [
          fish
          bash
        ];
        networking.useDHCP = lib.mkForce false;
        networking.nftables.enable = true;
        networking.firewall = {
          enable = true;
          allowedTCPPorts = [
            22
            443
          ];
          allowedUDPPorts = [
            67
            68
          ];
        };
        services.dbus = {
          implementation = "broker";
          enable = true;
        };
      };

  };
}
