{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.local.dock;
  showrecents = if cfg.showrecents then "1" else "0";
    autohide = if cfg.autohide then "1" else "0";
  inherit (pkgs) stdenv dockutil;
in {
  options = {
    local.dock.enable = mkOption {
      description = "Update dock";
      default = stdenv.isDarwin;
      example = false;
    };
    local.dock.autohide = mkOption {
      description = "Set the dock autohide option";
      default = false;
      example = true;
    };
    local.dock.orientation = mkOption {
      description = "Orientation of the dock";
      default = "bottom";
      example = "left";
    };
    local.dock.showrecents = mkOption {
      description = "Include recently started apps on the dock";
      default = false;
      example = false;
    };
    local.dock.entries = mkOption {
      description = "Entries on the dock";
      type = with types;
        listOf (submodule {
          options = {
            path = lib.mkOption { type = str; };
            section = lib.mkOption {
              type = str;
              default = "apps";
            };
            options = lib.mkOption {
              type = str;
              default = "";
            };
          };
        });
    };
  };
  config = mkIf cfg.enable (let
    normalize = path: if hasSuffix ".app" path then path + "/" else path;
    entryURI = path:
      "file://"
      + (builtins.replaceStrings [ " " "!" ''"'' "#" "$" "%" "&" "'" "(" ")" ] [
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
      ] (normalize path));
    wantURIs = lib.concatMapStrings (entry: ''
      ${entryURI entry.path}
    '') cfg.entries;
    createEntries = lib.concatMapStrings (entry: ''
      ${pkgs.dockutil}/bin/dockutil --no-restart --add '${entry.path}' --section '${entry.section}' ${entry.options} $HOME >/dev/null
    '') cfg.entries;
    plist = "/Users/neil/Library/Preferences/com.apple.dock.plist";
  in {
    home.activation.dock = lib.hm.dag.entryAfter [ "writeBoundry" ] ''
      echo >&2 "Setting up the dock..."
      haveURIs="$(${dockutil}/bin/dockutil --list $HOME | ${pkgs.coreutils}/bin/cut -f2)"
      if ! diff -wu <(echo -n "$haveURIs") <(echo -n '${wantURIs}') >/dev/null; then
        ${dockutil}/bin/dockutil --no-restart --remove all $HOME >/dev/null
        ${createEntries}
        /usr/bin/killall Dock
      fi

      /usr/bin/defaults write com.apple.dock orientation -string ${cfg.orientation}
      /usr/bin/defaults write com.apple.dock "show-recents" -int ${showrecents}
      /usr/bin/defaults write com.apple.dock "autohide" -int ${autohide}
    '';
  });
}
