{ inputs,pkgs, ...}: 
let
  wallpaper = ./wallpaper.plist;
in
{
  imports = [
    inputs.nixNvim.nixosModules.default
  ];
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
  programs.fish.shellInit = ''
    for p in /run/current-system/sw/bin
      if not contains $p $fish_user_paths
        set -g fish_user_paths $p $fish_user_paths
      end
    end
    '';
  environment.shells = with pkgs; [ fish bash zsh ];
  environment.loginShell = pkgs.fish;
  environment.systemPackages = with pkgs; [ plistwatch jq coreutils perl python3 ruby gcc
 inputs.nixNvim.packages.${pkgs.system}.nvim
];
  system.keyboard.enableKeyMapping = true;
  fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" "Meslo" ]; }) ];
  services.nix-daemon.enable = true;
 # system.activationScripts.setLoginShell.text = ''
 #   sudo /usr/bin/chsh -s /run/current-system/sw/bin/fish neil
 #   '';
  system.activationScripts.postUserActivation.text = ''
    /usr/libexec/PlistBuddy -c "Clear dict" -c "Merge ${wallpaper}" -c Save ~/Library/Application\ Support/com.apple.wallpaper/Store/Index.plist
    killall WallpaperAgent
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

  system.defaults = {
    finder._FXShowPosixPathInTitle = true;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.KeyRepeat = 5;
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
    dock = {
      persistent-apps = [ 
        "/Applications/Safari.app" 
        "${pkgs.alacritty}/Applications/Alacritty.app"
        "${pkgs.neovide}/Applications/Neovide.app"
        ];
      persistent-others = [ "/Users/neil/Downloads" "/Applications" ];
      show-recents = false;
      orientation = "left";
      };
    };
  }
