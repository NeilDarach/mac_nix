{
  den,
  ...
}:
{
  includes = with den.aspects; [
    acme-goip
    acme-garaageofinfiniteplenitude
  ];
  den.aspects.nginx-goip = {
    nixos = {
      services.nginx = {
        enable = true;
        defaultHTTPListenPort = 80;
        virtualHosts = {
          "goip.org.uk" = {
            enableACME = true;
            forceSSL = true;
            extraConfig = ''
              autoindex on;
            '';
            locations = {
              "/" = {
                root = "/strongStateDir/nginx";
              };
              "/charlie" = {
                root = "/strongStateDir/nginx";
                basicAuthFile = "/strongStateDir/nginx/charlie/.htpasswd";
                extraConfig = ''
                  autoindex on;
                '';
              };
              "/gff/" = {
                proxyPass = "http://darach.org.uk:3020/";
              };
            };
          };
          "garageofinfiniteplenitude.org.uk" = {
            enableACME = true;
            forceSSL = true;
            locations = {
              "/" = {
                root = "/strongStateDir/nginx";
              };
              "/charlie" = {
                basicAuthFile = "/strongStateDir/nginx/charlie/.htpasswd";
                tryFiles = "$uri $uri/ $uri/index.html =404";
                extraConfig = ''
                  autoindex on;
                '';
              };
              "/gff" = {
                proxyPass = "http://darach.org.uk:3020/";
              };
            };
          };
        };
      };

      networking.firewall.allowedTCPPorts = [ 443 ];
      strongStateDir.service.nginx.enable = true;

    };
  };
}
