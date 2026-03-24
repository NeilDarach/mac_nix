{ inputs, ... }:
{
  den.aspects.sops = {
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
            age.generateKey = false;
            defaultSopsFormat = "yaml";
            defaultSopsFile = "${toString inputs.secrets}/secrets.yaml";
          };
          systemd.tmpfiles.rules = [
            "f ${config.sops.age.keyFile} 0640 root root"
            "d ${dirOf config.sops.age.keyFile} 0750 root root"
          ];
        };
      };
  };
}
