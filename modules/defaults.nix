{ den, ... }:
{
  den.default.nixos.system.stateVersion = "25.11";
  den.default.darwin.system.stateVersion = 6;
  den.default.homeManager.config.home.stateVersion = "25.11";
  den.default.os =
    { inputs', ... }:
    {
      _module.args.pkgs-unstable = inputs'.nixpkgs-unstable.legacyPackages;
    };
}
