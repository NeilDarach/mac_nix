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
      cfg = config.local.desktop;
    in
    {
      options = with lib; {
        local.desktop = {
          wallpaper = mkOption {
            description = "plist containing a wallpaper definition";
            default = null;
            example = "../../files/wallpaper.plist";
            type = types.nullOr types.path;
          };
        };
      };
      config =
        lib.mkIf (cfg.wallpaper != null) {
          home.activation.wallpaper = hm.dag.entryAfter [ "writeBoundary" ] ''
             echo >&2 "Setting up the wallpaper"
             /usr/libexec/PlistBuddy -c "Clear dict" -c "Merge ${cfg.wallpaper}" -c Save ~/Library/Application\ Support/com.apple.wallpaper/Store/Index.plist
             /usr/bin/killall WallpaperAgent
            /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
          '';
        };
    };
}
