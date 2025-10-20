{ inputs, pkgs, pkgs-unstable, ... }: {
  # darwin preferences and config
  environment.etc = {
    "sudoers.d/10-nix-commands".text = ''
      neil ALL=(root) NOPASSWD:SETENV: /run/current-system/sw/bin/nix-env 
    '';
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 8 * 1024;
        };
        cores = 6;
      };
    };
  };
  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  environment.shells = with pkgs; [ fish bash zsh ];
  environment.systemPackages = with pkgs; [
    nixos-rebuild
    home-manager
    aerospace
    jankyborders
    sshfs
    dua
    mqtt-explorer
  ];

  homebrew = {
    enable = true;
    taps = [ ];
    brews = [ "mas" ];
    casks = [
      "autodesk-fusion"
      "dropbox"
      "orcaslicer"
      "quicksilver"
      "steam"
      "macfuse"
      "handbrake"
    ];
  };
  system.keyboard.enableKeyMapping = true;
  fonts.packages = [
    pkgs.nerd-fonts.sauce-code-pro
    pkgs.nerd-fonts.meslo-lg
    pkgs.nerd-fonts.symbols-only
  ];

  system.stateVersion = 5;
  system.primaryUser = "neil";
  system.defaults = {
    finder._FXShowPosixPathInTitle = true;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.KeyRepeat = 5;
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
  };
}
