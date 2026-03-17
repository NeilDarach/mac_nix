{
  den.default.homeManager =
    {
      lib,
      ...
    }:
    {
      options = with lib; {
        local.user = {
          email = lib.mkOption {
            description = "Primary email address";
            type = lib.types.str;
            default = "";
            example = "neil.darach@gmail.com";
          };
          fullName = lib.mkOption {
            description = "Full name of the user";
            type = lib.types.str;
            default = "";
            example = "Neil Darach";
          };
        };
      };
    };
}
