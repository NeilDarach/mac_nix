{
  inputs,
  den,
  local,
  ...
}:
{
  # host aspect
  den.aspects.r5s = {
    # host NixOS configuration
    includes = [
      den.provides.hostname
      local.hardware
    ];
    nixos =
      { pkgs, ... }:
      {
        nanopi-r5s.network.r8125 = true;
        nixpkgs.config.allowUnfree = true;
        local = {
          sops = true;
          impermanence = true;
        };
        nix.extraOptions = ''
          experimental-features = nix-command flakes
        '';
        environment.shells = with pkgs; [
          fish
          bash
        ];
      };
  };
}
