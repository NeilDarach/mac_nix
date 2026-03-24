{
  den,
  ...
}:
{
  # host aspect
  den.aspects.goip = {
    # host NixOS configuration
    includes = with den.aspects; [
      hardware._.alphavps-x86
      server
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
