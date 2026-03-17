{ den, ... }:
{
  den.aspects.NeilsMacBookPro = {
    darwin =
      { pkgs,... }:
      {
        nix.linux-builder = {
          enable = true;
          ephemeral = true;
          maxJobs = 5;
          config = {
            virtualisation = {
              darwin-builder = {
                diskSize = 40 * 1024;
                memorySize = 8 * 1024;
              };
              cores = 6;
            };
          };
        };
      };
  };
}
