{
  den.aspects.plex = {
    nixos =
      { pkgs, ... }:
      let
        version = "1.43.0.10492-121068a07";
        sha256 =
          {
            x86_64-linux = "sha256-HA779rkjy8QBlW2+IsRmgu4t5PT2Gy0oaqcJm+9zCYE=";
            aarch64-linux = "sha256-YrIH51MyyL6gPWneAaV4sMUDygau5ytZnOBgQ1YCcLo=";
          }
          ."${pkgs.stdenv.hostPlatform.system}";
        arch =
          {
            x86_64-linux = "amd64";
            aarch64-linux = "arm64";
          }
          ."${pkgs.stdenv.hostPlatform.system}";
      in
      {
        nixpkgs.overlays = [
          (final: previous: {
            plex = previous.plex.override {
              plexRaw = previous.plexRaw.overrideAttrs (o: {
                src = final.fetchurl {
                  inherit version sha256;
                  url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_${arch}.deb";
                };
              });

            };
          })
        ];
      };
  };
}
