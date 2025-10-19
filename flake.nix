{
  # comment
  description = "Minimal Mac flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixNvim.url = "github:NeilDarach/nixNvim";
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    inputs@{ nixpkgs, nixpkgs-unstable, home-manager, darwin, nixNvim, ... }:
    let
      standardMac = {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          overlays = [ inputs.nur.overlays.default ];
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        };
        specialArgs = {
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./modules/darwin
          home-manager.darwinModules.home-manager
          {
            users = {
              knownUsers = [ "neil" ];
              users = {
                neil = {
                  home = "/Users/neil";
                  uid = 502;
                  shell = "/run/current-system/sw/bin/fish";
                };
              };
            };
            home-manager = {
              backupFileExtension = "bak";
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
                pkgs-unstable = import nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
              };
              users.neil.imports = [ ./modules/home-manager ];
            };
          }
        ];
      };
      darwin = let
        src = nixpkgs.legacyPackages."aarch64-darwin".applyPatches {
          name = "nix-darwin";
          src = inputs.darwin;
          patches = [ ];
        };
      in nixpkgs.lib.fix
      (self: (import "${src}/flake.nix").outputs { inherit self nixpkgs; });
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};

    in {
      darwinConfigurations = {

        Neils-Virtual-Machine = darwin.lib.darwinSystem standardMac;
        Neils-MacBook-Pro = darwin.lib.darwinSystem standardMac;

      };
      homeConfigurations."neil" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          overlays = [ inputs.firefox-darwin.overlay inputs.nur.overlays.default ];
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        };
        extraSpecialArgs = {
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          inherit system;
        };
        modules = [ ./modules/home-manager ];
      };
    };
}
