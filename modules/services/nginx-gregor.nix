{
  den.aspects.nginx-gregor = {
    nixos = {
      services.nginx = {
        enable = true;
        defaultHTTPListenPort = 81;
        virtualHosts."gregor.darach.org.uk" = {
          locations."/" = {
            root = "/var/lib/nginx/www";
          };
        };
      };

      networking.firewall.allowedTCPPorts = [ 81 ];

      environment.persistence."/persist".directories = [
        {
          directory = "/var/lib/nginx";
          user = "nginx";
          group = "wheel";
          mode = "u=rwx,g=rwx,o=rx";
        }
      ];
    };
  };
}
