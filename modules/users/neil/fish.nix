{ den, ... }:
{
  den.aspects.neil = {
    homeManager = {
      # home-manger configs
      programs.fish = {
        enable = true;
        shellInit = ''
          fish_vi_key_bindings
        '';
      };
    };
  };
}
