which nix || (sh <(curl -L https://nixos.org/nix/install); exit)
nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.Neils-Virtual-Machine.system
./result/sw/bin/darwin-rebuild switch --flake .#
