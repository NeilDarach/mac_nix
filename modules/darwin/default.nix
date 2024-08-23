{ inputs,pkgs, ...}: 
{
  imports = [
    inputs.nixNvim.nixosModules.default
  ];
  # darwin preferences and config
  environment.etc = {
    "sudoers.d/10-nix-commands".text = ''
      neildarach ALL=(root) NOPASSWD:SETENV: /run/current-system/sw/bin/darwin-rebuild
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
  environment.systemPackages = with pkgs; [ coreutils perl python3 ruby gcc inputs.nixNvim.packages.${pkgs.system}.nvim ];
  system.keyboard.enableKeyMapping = true;
  fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" "Meslo" ]; }) ];
  services.nix-daemon.enable = true;
 # system.activationScripts.setLoginShell.text = ''
 #   sudo /usr/bin/chsh -s /run/current-system/sw/bin/fish neil
 #   '';
  system.activationScripts.postUserActivation.text = ''
    plutil -replace AllSpacesAndDisplays.Desktop.Content.Choices.0.Files.0.relative -string "file:///System/Library/ExtensionKit/Extensions/Wallpaper.appex/Contents/Resources/Transparent.tiff" "/Users/neil/Library/Application Support/com.apple.wallpaper/Store/Index.plist"
    plutil -replace SystemDefault.Desktop.Content.Choices.0.Files.0.relative -string "file:///System/Library/ExtensionKit/Extensions/Wallpaper.appex/Contents/Resources/Transparent.tiff" "/Users/neil/Library/Application Support/com.apple.wallpaper/Store/Index.plist"
    plutil -replace AllSpacesAndDisplays.Desktop.Content.Choices.0.Configuration -data "YnBsaXN0MDDSAQIDDF8QD2JhY2tncm91bmRDb2xvcllwbGFjZW1lbnTSBAUGC1pjb21wb25lbnRzWmNvbG9yU3BhY2WkBwgJCiM/00x2AAAAACM/51NnoAAAACM/7/YZ4AAAACM/8AAAAAAAAE8QQ2JwbGlzdDAwXxAXa0NHQ29sb3JTcGFjZUdlbmVyaWNSR0IIAAAAAAAAAQEAAAAAAAAAAQAAAAAAAAAAAAAAAAAAACIQAQgNHykuOURJUltkbbMAAAAAAAABAQAAAAAAAAANAAAAAAAAAAAAAAAAAAAAtQ==" "/Users/neil/Library/Application Support/com.apple.wallpaper/Store/Index.plist"
    plutil -replace SystemDefault.Desktop.Content.Choices.0.Configuration -data "YnBsaXN0MDDSAQIDDF8QD2JhY2tncm91bmRDb2xvcllwbGFjZW1lbnTSBAUGC1pjb21wb25lbnRzWmNvbG9yU3BhY2WkBwgJCiM/00x2AAAAACM/51NnoAAAACM/7/YZ4AAAACM/8AAAAAAAAE8QQ2JwbGlzdDAwXxAXa0NHQ29sb3JTcGFjZUdlbmVyaWNSR0IIAAAAAAAAAQEAAAAAAAAAAQAAAAAAAAAAAAAAAAAAACIQAQgNHykuOURJUltkbbMAAAAAAAABAQAAAAAAAAANAAAAAAAAAAAAAAAAAAAAtQ==" "/Users/neil/Library/Application Support/com.apple.wallpaper/Store/Index.plist"
    plutil -replace AllSpacesAndDisplays.Desktop.LastSet -date "$(date -u +"%Y-%m-%dT%TZ")" "/Users/neil/Library/Application Support/com.apple.wallpaper/Store/Index.plist"
    plutil -replace SystemDefault.Desktop.LastSet -date "$(date -u +"%Y-%m-%dT%TZ")" "/Users/neil/Library/Application Support/com.apple.wallpaper/Store/Index.plist"
    killall WallpaperAgent
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

  system.defaults = {
    finder._FXShowPosixPathInTitle = true;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.KeyRepeat = 5;
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
    dock.persistent-apps = [ 
      "/Applications/Safari.app" 
      "${pkgs.alacritty}/Applications/Alacritty.app"
      "${pkgs.neovide}/Applications/Neovide.app"
      ];
    };
  }
