{ den, ... }:
{
  den.aspects.mac = {
    includes = with den.aspects; [
      mac-dock
      mac-extensions
      mac-desktop
    ];
  };
}
