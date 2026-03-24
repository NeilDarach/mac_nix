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
            ".direnv"
          ];
          settings = {
            user = {
              email = "neil.darach@gmail.com";
              name = "Neil Darach";
            };
          };
        };
      };
  };
}
