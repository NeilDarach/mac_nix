{ inputs, ... }:
{
  den.aspects.sops = {
    os = {
      imports = [ inputs.sops-nix.darwinModules.sops ];
      sops = {
        age.generateKey = false;
        defaultSopsFormat = "yaml";
        defaultSopsFile = "${toString inputs.secrets}/secrets.yaml";
      };
    };

    darwin = {
      sops = {
        age.keyFile = "/Users/neil/.config/sops/age/keys.txt";
      };
    };

    nixos =
      {
        config,
        ...
      }:
      {
        imports = [ inputs.sops-nix.nixosModules.sops ];
        config = {
          sops = {
            age.keyFile = "/keys/key.txt";
          };
          systemd.tmpfiles.rules = [
            "f ${config.sops.age.keyFile} 0640 root root"
            "d ${dirOf config.sops.age.keyFile} 0750 root root"
          ];
        };
      };
  };
}
