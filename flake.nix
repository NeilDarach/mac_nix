{
  description = "Minimal Mac flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  outputs = inputs@{nixpkgs,home-manager,darwin, nixCats, ...}: 
    let 
      system = "aarch64-darwin";
    in
    {
    darwinConfigurations = {
      Neils-Virtual-Machine = darwin.lib.darwinSystem {
      pkgs = import nixpkgs { 
               system = "aarch64-darwin";
               config = {
                 allowUnfree = true;
                 allowUnfreePredicate = _: true;
                 };
               };
        specialArgs = { inherit inputs ; };
        modules = [ 
          ./modules/darwin 

          home-manager.darwinModules.home-manager {
            users.knownUsers = [ "neil" ];
            users.users.neil.home = "/Users/neil";
            users.users.neil.uid = 501;
            users.users.neil.shell = "/run/current-system/sw/bin/fish";
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.neil.imports = [
                ./modules/home-manager 
                ];
              }; 
            }
          ];
        };
      }; 
    };
  }
