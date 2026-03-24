{ den, ... }:
{
  den.aspects.neil = {
    homeManager-darwin =
      { pkgs, ... }:
      {
        dock = {
          enable = true;
          autohide = true;
          orientation = "left";
          entries = [
            {
              path = "/System/Applications/System Settings.app";
              section = "apps";
              options = "";
            }
            {
              path = "${pkgs.firefox-bin}/Applications/Firefox.app";
              section = "apps";
              options = "";
            }
            {
              path = "${pkgs.alacritty}/Applications/Alacritty.app";
              section = "apps";
              options = "";
            }
            {
              path = "~/HomeApplications";
              section = "others";
              options = "--sort name --view grid --display folder";
            }
          ];
        };
      };
  };
}
