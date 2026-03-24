{ den, lib, ... }:
#let
#hm-darwin =
#{ user, aspect-chain }:
#den._.forward {
#each = [ "homeManager-darwin" ];
#fromClass = _: "homeManager-darwin";
#intoClass = "darwin";
#intoPath = [
#"home-manager"
#"users"
#user.userName
#];
#fromAspect = _: lib.head aspect-chain;
  #};
#in
{
  den.default.nixos.system.stateVersion = "25.11";
  den.default.darwin.system.stateVersion = 6;
  den.default.homeManager.config = {
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
  };
  den.default.includes = [
    den._.mutual-provider
    den._.hostname
    den._.define-user
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
