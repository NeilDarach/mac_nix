{
  den.aspects.acme-garageofinfiniteplenitude = {
    nixos =
      { config, lib, ... }:
      {
        sops.secrets = {
          "cloudflare/dns_tokens/garageofinfiniteplenitude" = { };
        };
        sops.templates."cloudflare-acme-garageofinfiniteplenitude" = {
          content = ''
            CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder."cloudflare/dns_tokens/garageofinfiniteplenitude"}
          '';
        };
        security.acme = {
          acceptTerms = true;
          defaults.email = "neil.darach@gmail.com";
          certs."garageofinfiniteplenitude.org.uk" = {
            domain = "garageofinfiniteplenitude.org.uk";
            extraDomainNames = [ "*.garageofinfiniteplenitude.org.uk" ];
            webroot = lib.mkForce null;
            dnsProvider = "cloudflare";
            dnsResolver = "1.1.1.1:53";
            environmentFile = "${config.sops.templates."cloudflare-acme-garageofinfiniteplenitude".path}";
          };
        };
      };
  };
}
