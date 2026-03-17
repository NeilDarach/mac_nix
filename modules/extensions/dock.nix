{
  den.default.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;
    let
      cfg = config.local.dock;
      showrecents = if cfg.showrecents then "1" else "0";
      autohide = if cfg.autohide then "1" else "0";
    in
    {
      options = with lib; {
        local.dock = {
          enable = mkOption {
            description = "Update dock";
            default = pkgs.stdenv.isDarwin;
            example = false;
            type = types.bool;
          };
          autohide = mkOption {
            description = "Set the dock autohide option";
            default = false;
            example = true;
            type = types.bool;
          };
          orientation = mkOption {
            description = "Orientation of the dock";
            default = "bottom";
            example = "left";
            type = types.str;
          };
          showrecents = mkOption {
            description = "Include recently started apps on the dock";
            default = false;
            example = true;
            type = types.bool;
          };
          entries = mkOption {
            description = "Entries on the dock";
            default = [];
            type =
              with types;
              listOf (submodule {
                options = {
                  path = mkOption { type = str; };
                  section = mkOption {
                    type = str;
                    default = "apps";
                  };
                  options = mkOption {
                    type = str;
                    default = "";
                  };
                };
              });
          };
        };
      };
      config = lib.mkIf cfg.enable (
        let
          normalize = path: if hasSuffix ".app" path then path + "/" else path;
          entryURI =
            path:
            "file://"
            + (builtins.replaceStrings
              [
                " "
                "!"
                ''"''
                "#"
                "$"
                "%"
                "&"
                "'"
                "("
                ")"
              ]
              [
                "%20"
                "%21"
                "%22"
                "%23"
                "%24"
                "%25"
                "%26"
                "%27"
                "%28"
                "%29"
              ]
              (normalize path)
            );
          wantURIs = lib.concatMapStrings (entry: ''
            ${entryURI entry.path}
          '') cfg.entries;
          createEntries = concatMapStrings (entry: ''
            ${pkgs.dockutil}/bin/dockutil --no-restart --add '${entry.path}' --section '${entry.section}' ${entry.options} $HOME > /dev/null
          '') cfg.entries;
        in
        {
          home.activation.dock = hm.dag.entryAfter [ "writeBoundary" ] ''
            echo >&2 "Setting up the dock"
            if [[ -f $HOME/Library/Preferences/com.apple.dock.plist ]] ; then 
            haveURIs="$(${pkgs.dockutil}/bin/dockutil --list $HOME | ${pkgs.coreutils}/bin/cut -f2)"
            if ! diff -wu <(echo -n "$haveURIs") <(echo -n "${wantURIs}") > /dev/null; then 
              ${pkgs.dockutil}/bin/dockutil --no-restart --remove all $HOME >/dev/null
              ${createEntries}
              /usr/bin/killall Dock
            fi

            /usr/bin/defaults write com.apple.dock "orientation" -string ${cfg.orientation}
            /usr/bin/defaults write com.apple.dock "show-recents" -int ${showrecents}
            /usr/bin/defaults write com.apple.dock "autohide" -int ${autohide}
            fi
          '';
        }
      );
    };
}
