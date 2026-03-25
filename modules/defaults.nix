{ den, ... }:
{
  den.aspects.hm-darwin =
    { user, ... }:
    den._.forward {
      each = [ "homeManager-darwin" ];
      fromClass = _: "homeManager-darwin";
      intoClass = _: "darwin";
      intoPath = _: [
        "home-manager"
        "users"
        user.userName
      ];
      fromAspect = _: den.aspects.${user.aspect};
    };
  den.aspects.hm-nixos =
    { user, ... }:
    den._.forward {
      each = [ "homeManager-nixos" ];
      fromClass = _: "homeManager-nixos";
      intoClass = _: "nixos";
      intoPath = _: [
        "home-manager"
        "users"
        user.userName
      ];
      fromAspect = _: den.aspects.${user.aspect};
    };
  den.default.nixos = {
    system.stateVersion = "25.11";
  };
  den.default.darwin.system.stateVersion = 6;
  den.default.homeManager.config = {
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
    xdg.enable = true;
  };
  den.default.includes = [
    den._.mutual-provider
    den._.hostname
    den._.inputs'
    den._.self'
  ];
  den.default.os =
    {
      inputs',
      ...
    }:
    {
      _module.args.pkgs-unstable = inputs'.nixpkgs-unstable.legacyPackages;
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
}
