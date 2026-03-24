{
  den.aspects.acme-goip = {
    nixos =
      { config, lib, ... }:
      {
        sops.secrets = {
          "cloudflare/dns_tokens/goip" = { };
        };
        sops.templates."cloudflare-acme-goip" = {
          content = ''
            CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder."cloudflare/dns_tokens/goip"}
          '';
        };
        security.acme = {
          acceptTerms = true;
          defaults.email = "neil.darach@gmail.com";
          certs."goip.org.uk" = {
            domain = "goip.org.uk";
            extraDomainNames = [ "*.goip.org.uk" ];
            webroot = lib.mkForce null;
            dnsProvider = "cloudflare";
            dnsResolver = "1.1.1.1:53";
            environmentFile = "${config.sops.templates."cloudflare-acme-goip".path}";
          };
        };
      };
  };
}
