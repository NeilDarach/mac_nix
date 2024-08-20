              {pkgs,lib,...}: {
                 # home-manger configs
                 home.stateVersion = "22.11";
                 home.packages = [ pkgs.ripgrep pkgs.fd pkgs.curl pkgs.less ];
                 home.sessionVariables = {
                   PAGER = "less";
                   CLICOLOR = 1;
                   EDITOR="vim";
                   };
                 home.shellAliases = {
                   ls = "ls --color=auto -F";
                   nr = "darwin-rebuild switch --flake ~/syscfg/.#";
                   };
  programs.fish = {
   enable = true;
   loginShellInit = 
     let
       profiles = [
         "/etc/profiles/per-user/$USER"
         "$HOME/.nix-profile"
         "(set -q XDG_STATE_HOME; and echo $XDG_STATE_HOME; or echo $HOME/.local/state)/nix/profile"
         "/run/current-system/sw"
         "/nix/var/nix/profiles/default"
         ];
       makeBinSearchPath = 
         lib.concatMapStringsSep " " (path: "${path}/bin");
      in
    ''
    fish_add_path --move --prepend --path ${makeBinSearchPath profiles}
    set fish_user_paths $fish_user_paths  
    '';
};
                 programs = {
                   bat.enable = true;
                   bat.config.theme = "TwoDark";
                   fzf.enable = true;
                   fzf.enableZshIntegration = true;
                   git.enable = true;
                   zsh.enable = true;
                   zsh.enableCompletion = true;
                   zsh.autosuggestion.enable = true;
                   zsh.syntaxHighlighting.enable = true;
                   starship.enable = true;
                   starship.enableZshIntegration = true;
                   alacritty = {
                     enable = true;
                     settings.font.normal.family = "SauceCodePro Nerd Font Mono";
                     settings.font.size = 16; 
                     };
                   };
                }
