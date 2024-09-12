{
  # comment
  description = "Minimal Mac flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixNvim.url = "github:NeilDarach/nixNvim/lze";
    firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    firefox-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, nixNvim, ... }:
    let
      darwin = let
        src = nixpkgs.legacyPackages."aarch64-darwin".applyPatches {
          name = "nix-darwin";
          src = inputs.darwin;
          patches = [ ./patches/dock.nix.patch ];
        };
      in nixpkgs.lib.fix
      (self: (import "${src}/flake.nix").outputs { inherit self nixpkgs; });
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};

    in {
      darwinConfigurations = {
        Neils-Virtual-Machine = darwin.lib.darwinSystem {
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            overlays = [ inputs.firefox-darwin.overlay inputs.nur.overlay ];
            config = {
              allowUnfree = true;
              allowUnfreePredicate = _: true;
            };
          };
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/darwin
            home-manager.darwinModules.home-manager
            {
              users = {
                knownUsers = [ "neil" ];
                users = {
                  neil = {
                    home = "/Users/neil";
                    uid = 501;
                    shell = "/run/current-system/sw/bin/fish";
                  };
                };
              };
              home-manager = {
                backupFileExtension = "bak";
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.neil.imports = [ ./modules/home-manager ];
              };
            }
          ];
        };
      };
      homeConfigurations."neil" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          overlays = [ inputs.firefox-darwin.overlay inputs.nur.overlay ];
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        };
        modules = [ ./modules/home-manager ];
      };
    };
}
