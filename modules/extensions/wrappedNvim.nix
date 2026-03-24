{inputs,...}:
{
  den.aspects.wrappedNvim = {
    os = {
      nixpkgs.overlays = [
        (final: previous: {
          wrappedNvim = inputs.nixNvim.packages.${final.system}.neovim;
          wrappedNvimLocal = inputs.nixNvim.packages.${final.system}.neovimlocal;
        })
      ];
    };
  };
}
