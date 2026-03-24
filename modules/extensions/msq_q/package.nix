{inputs,...}:
{
  den.aspects.msg_q = {
    nixos =
      {
        nixpkgs.overlays = [
          (final: previous: {
            msg_q = inputs.msg_q.packages.${final.stdenv.hostPlatform.system}.default;
          })
        ];
      };
  };
}
