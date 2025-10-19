{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.local.extensions;
  inherit (pkgs) stdenv;
in {
  # See https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
  # for a list of uti options.
  options = {
    local.extensions.enable = mkOption {
      description = "Modify application associaions";
      default = stdenv.isDarwin;
      example = false;
    };
    local.extensions.entries = mkOption {
      description = "App types to update";
      type = with types;
        listOf (submodule {
          options = {
            uti = lib.mkOption { type = str; };
            bundle = lib.mkOption { type = str; };
            role = lib.mkOption {
              type = str;
              default = "all";
            };
          };
        });
    };
  };
  config = mkIf cfg.enable (let
    createEntries = lib.concatMapStrings (entry: ''
      ${pkgs.duti}/bin/duti -s ${entry.bundle} ${entry.uti} ${entry.role} >/dev/null
    '') cfg.entries;
  in {
    home.activation.extensions = lib.hm.dag.entryAfter [ "writeBoundry" ] ''
      echo >&2 "Setting up the extensions..."
      ${createEntries}
    '';
  });
}
