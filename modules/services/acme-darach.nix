{
  den.aspects.acme-darach = {
    nixos =
      { config, lib, ... }:
      {
        sops.secrets = {
          "cloudflare/dns_tokens/darach" = { };
        };
        sops.templates."cloudflare-acme-darach" = {
          content = ''
            CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder."cloudflare/dns_tokens/darach"}
          '';
        };
        security.acme = {
          acceptTerms = true;
          defaults.email = "neil.darach@gmail.com";
          certs."darach.org.uk" = {
            domain = "darach.org.uk";
            extraDomainNames = [ "*.darach.org.uk" ];
            webroot = lib.mkForce null;
            dnsProvider = "cloudflare";
            dnsResolver = "1.1.1.1:53";
            environmentFile = "${config.sops.templates."cloudflare-acme-darach".path}";
          };
        };
      };
  };
}
