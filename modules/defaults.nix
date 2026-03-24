{ den, ... }:
let
  hm-darwin =
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
  hm-nixos =
    { user,... }:
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
in
{
  den.default.nixos = {
    system.stateVersion = "25.11";
    registration.etcdHost = "etcd.darach.org.uk:2379";
  };
  den.default.darwin.system.stateVersion = 6;
  den.default.homeManager.config = {
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
  };
  den.default.includes = [
    den._.mutual-provider
    den._.hostname
    den._.define-user
    den._.inputs'
    hm-darwin
    hm-nixos
  ];
  den.default.os =
    { inputs', ... }:
    {
      _module.args.pkgs-unstable = inputs'.nixpkgs-unstable.legacyPackages;
      nix.extraOptions = ''
        experimental-features = nix-command flakes
      '';
      home-manager = {
        backupFileExtension = "bak";
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
}
