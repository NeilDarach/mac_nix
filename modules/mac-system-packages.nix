{ den, ... }:
{
  den.aspects.NeilsMacBookPro = {
includes = [ den._.inputs' ];
    darwin =
      {
        pkgs,
        pkgs-unstable,
        inputs',
        ...
      }:
      {
        environment.systemPackages = with pkgs; [
          dua
          google-chrome
          home-manager
          mqtt-explorer
          sshfs
        ];
      };
  };
}
