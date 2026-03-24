{
  den,
  ...
}:
{
  # host aspect
  den.aspects.gregor = {
    # host NixOS configuration
    includes = with den.aspects; [
      server
      udev._.gregor
    ];
    nixos =
      { pkgs, ... }:
      {
        environment.shells = with pkgs; [
          fish
          bash
        ];
      };
  };
}
