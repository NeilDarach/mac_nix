{
  den,
  config,
  ...
}:
{
  # user aspect
  den.aspects.neil = {
    includes = [
      den.provides.primary-user
      den.aspects.wallpaper
      den.aspects.extensions
    ];
    homeManager-darwin =
      { lib, pkgs, ... }:
      {
        desktop.wallpaper = ../../../files/wallpaper.plist;
        extensions = [
          {
            uti = "public.mpeg-4";
            bundle = "org.videolan.vlc";
          }
          {
            uti = "com.apple.quicktime-movie";
            bundle = "org.videolan.vlc";
          }
        ];
        home.activation.appSymlinks = (
          lib.hm.dag.entryAfter [ "writeBoundry" ] ''
            run rm -rf ~/HomeApplications
            run mkdir ~/HomeApplications
            run ln -s /Applications/Steam.app ~/HomeApplications
            run ln -s /Applications/OrcaSlicer.app ~/HomeApplications
            run ln -s /Applications/1Password.app ~/HomeApplications
            run ln -s /Applications/Dropbox.app ~/HomeApplications
            run ln -s "${pkgs.mqtt-explorer}/Applications/MQTT Explorer.app" ~/HomeApplications
            run ln -s "${pkgs.google-chrome}/Applications/Google Chrome.app" ~/HomeApplications
            run ln -s "$(realpath "$HOME/Applications/Autodesk Fusion.app")" ~/HomeApplications
            run ln -s "${pkgs.vlc-bin-universal}/Applications/VLC.app" ~/HomeApplications
            run ln -s "${pkgs.inkscape}/Applications/Inkscape.app" ~/HomeApplications
          ''
        );
      };

    darwin = {
      environment.etc = {
        "sudoers.d/10-nix-commands".text = ''
          neil ALL=(root) NOPASSWD:SETENV: /run/current-system/sw/bin/nix-env
          neil ALL=(root) NOPASSWD:SETENV: /run/current-system/sw/bin/darwin-rebuild
        '';
      };
    };

    homeManager =
      { pkgs, ... }:
      {
        home.sessionVariables = {
          PAGER = "less";
          CLICOLOR = 1;
          EDITOR = "vim";
        };
        programs = {
          firefox.enable = true;
          tmux.enable = true;
        };
        home.shellAliases = {
          ls = "ls --color=auto -F";
          nr = "darwin-rebuild switch --flake ~/mac_nix/.#";
          hr = "home-manager switch -b bak --flake ~/mac_nix/.#";
          rg = "batgrep";
          cat = "bat";
          less = "bat";
        };
        home.packages = with pkgs; [
          coreutils
          curl
          fd
          htop
          jq
          less
          plistwatch
          ripgrep
          vlc-bin-universal
        ];
        local.user.email = "neil.darach@gmail.com";
        local.user.fullName = "Neil Darach";
      };

    # user can provide NixOS configurations
    # to any host it is included on
    nixos = {
      users.users.neil.description = "Neil Darach";
    };

  };
}
