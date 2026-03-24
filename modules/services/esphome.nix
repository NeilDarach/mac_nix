{
  den.aspects.esphome = {
    nixos =
      { lib, ... }:
      {
        services.esphome = {
          enable = true;
          openFirewall = true;
          usePing = true;
          address = "0.0.0.0";
        };

        systemd.services.esphome = {
          serviceConfig = {
            ProtectSystem = lib.mkForce "off";
            DynamicUser = lib.mkForce "false";
            User = "esphome";
            Group = "esphome";
          };
        };

        users.users.esphome = {
          isSystemUser = true;
          home = "/var/lib/esphome";
          group = "esphome";
        };
        users.groups.esphome = { };

        registration.service.esphome = {
          port = 6052;
          description = "esphome";
        };
      };
  };
}
