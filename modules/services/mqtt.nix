{
  den.aspects.mqtt = {
    nixos =
      { config, ... }:
      {
        services.mosquitto = {
          enable = true;
          listeners = [
            {
              address = "0.0.0.0";
              port = 1883;
              settings.allow_anonymous = true;
              users."mqtt-tasmota" = {
                passwordFile = "${config.sops.templates."mqtt-tasmota.pw".path}";
                acl = [ "readwrite #" ];
              };
            }
          ];
          logType = [ "debug" ];
        };
        sops.secrets."mqtt/password" = { };
        sops.templates."mqtt-tasmota.pw" = {
          content = ''
            ${config.sops.placeholder."mqtt/password"}
          '';
        };
        networking.firewall.allowedTCPPorts = [ 1883 ];
      };
  };
}
