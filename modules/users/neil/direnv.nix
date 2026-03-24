{ den, ... }:
{
  den.aspects.neil = {
    homeManager = {
      # home-manger configs
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
        config = {
          global = {
            hide_env_diff = true;
          };
        };
      };
    };
  };
}
