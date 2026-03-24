{
  den,
  config,
  ...
}:
{
  # user aspect
  den.aspects.neil = {
    includes = [
      den.aspects.mac
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
  };
}
