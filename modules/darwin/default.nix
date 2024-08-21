{ inputs,pkgs, ...}: 
let
  nixCats = builtins.getFlake github:NeilDarach/nixNvim?rev=ac75b1c0d405e61e9cb8e1b7b2a5be003c542f53;
in
{
  imports = [
    nixCats.nixosModules.default
  ];
  # darwin preferences and config
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
  environment.systemPackages = [ pkgs.coreutils nixCats.packages.${pkgs.system}.nvim ];
  system.keyboard.enableKeyMapping = true;
  fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" "Meslo" ]; }) ];
  services.nix-daemon.enable = true;
 # system.activationScripts.setLoginShell.text = ''
 #   sudo /usr/bin/chsh -s /run/current-system/sw/bin/fish neil
 #   '';
  system.defaults = {
    finder._FXShowPosixPathInTitle = true;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.KeyRepeat = 5;
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
    dock.persistent-apps = [ 
      "/Applications/Safari.app" 
      "${pkgs.alacritty}/Applications/Alacritty.app"
      ];
    };
  }
