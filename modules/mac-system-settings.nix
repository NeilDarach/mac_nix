{ den, inputs, ... }:
{
  den.default.darwin = {
    system.defaults = {
      finder._FXShowPosixPathInTitle = true;
      NSGlobalDomain.InitialKeyRepeat = 14;
      NSGlobalDomain.KeyRepeat = 5;
      NSGlobalDomain."com.apple.swipescrolldirection" = false;
    };
  };
}
