{ den, inputs, ... }:
{
  den.aspects.NeilsMacBookPro = {
    darwin = {
      homebrew = {
        enable = true;
        taps = [ ];
        brews = [ ];
        casks = [
          "autodesk-fusion"
          "dropbox"
          "orcaslicer"
          "quicksilver"
          "steam"
          "macfuse"
          "handbrake-app"
          "inkscape"
        ];
      };
    };
  };
}
