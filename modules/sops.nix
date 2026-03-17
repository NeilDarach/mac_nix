{ inputs, ... }:
{
  den.default.nixos =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      options = {
        local.sops = lib.mkEnableOption "System level sops";
      };
      config = lib.mkIf config.local.sops {
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
}
