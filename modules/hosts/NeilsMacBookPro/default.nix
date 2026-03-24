{
  den,
  ...
}:
{
  # host aspect
  den.aspects.NeilsMacBookPro = {
    # host NixOS configuration
    darwin =
      { pkgs, ... }:
      {
        users = {
          knownUsers = [
            "neil"
            "marion"
          ];
          users.neil.uid = 502;
          users.marion.uid = 503;
          users.marion.createHome = true;
        };
        programs._1password.enable = true;
        programs._1password-gui.enable = true;
        programs.zsh.enable = true;
        environment.shells = with pkgs; [
          fish
          bash
          zsh
        ];
        system.keyboard.enableKeyMapping = true;
        fonts.packages = [
          pkgs.nerd-fonts.sauce-code-pro
          pkgs.nerd-fonts.meslo-lg
          pkgs.nerd-fonts.symbols-only
        ];
      };
  };
}
