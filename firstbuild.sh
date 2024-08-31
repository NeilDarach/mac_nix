which nix || (sh <(curl -L https://nixos.org/nix/install); exit)
which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
softwareupdate --install-rosetta --agree-to-license
nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.Neils-Virtual-Machine.system
./result/sw/bin/darwin-rebuild switch --flake .#
