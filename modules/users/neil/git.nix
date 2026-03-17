{ den, ... }:
{
  den.aspects.neil = {
    homeManager =
      { config, ... }:
      {
        programs.git = {
          enable = true;
          ignores = [
            "*~"
            "*.swp"
          ];
          settings = {
            user = {
              email = config.local.user.email;
              name = config.local.user.fullName;
            };
          };
        };
      };
  };
}
