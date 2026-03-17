{inputs,...}:{
  den.default.darwin =
    {
      nixpkgs.overlays = [
        inputs.nur.overlays.default
        inputs.firefox-darwin.overlay
      ];
    };
  den.default.homeManager =
    { lib, config, ... }:
    {
      home.activation.firefoxProfile = lib.mkIf config.programs.firefox.enable (
        lib.hm.dag.entryAfter [ "writeBoundry" ] ''
          run mv $HOME/Library/Application\ Support/Firefox/profiles.ini $HOME/Library/Application\ Support/profiles.hm
          run cp $HOME/Library/Application\ Support/Firefox/profiles.hm $HOME/Library/Application\ Support/Firefox/profiles.ini
          run rm -f $HOME/Library/Application\ Support/Firefox/profiles.ini.bak
          run rm -f $HOME/Library/Application\ Support/Firefox/profiles.ini.hm
          run chmod u+w $HOME/Library/Application\ Support/Firefox/profiles.ini
        ''
      );
    };
}
