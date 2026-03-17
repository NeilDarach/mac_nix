{
  den,
  nd,
  ...
}:
{
  # user aspect
  den.aspects.marion = {
    includes = [
      den.provides.define-user
      (den.provides.user-shell "fish")
    ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.htop ];
        local.extensions.enable = true;
        local.user.email = "marionnow@yahoo.co.uk";
        local.user.fullName = "Marion Darach";
      };
  };
}
