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
  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish bash zsh ];
  environment.loginShell = pkgs.fish;
  environment.systemPackages = with pkgs; [ home-manager jankyborders ];

  homebrew = {
    enable = true;
    taps = [ ];
    brews = [ "mas" ];
    casks = [
      "nikitabobko/tap/aerospace"
      "1password"
      "autodesk-fusion"
      "mqtt-explorer"
      "dropbox"
      "orcaslicer"
      "quicksilver"
      "steam"
    ];
  };
  system.keyboard.enableKeyMapping = true;
  fonts.packages = [
    (pkgs.nerdfonts.override {
      fonts = [ "SourceCodePro" "Meslo" "NerdFontsSymbolsOnly" ];
    })
  ];
  services.nix-daemon.enable = true;

  system.stateVersion = 5;
  system.defaults = {
    finder._FXShowPosixPathInTitle = true;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.KeyRepeat = 5;
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
  };
}
