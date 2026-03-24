{
  den,
  ...
}:
{
  # host aspect
  den.aspects.server = {
    # host NixOS configuration
    includes = with den.aspects; [
      common
      impermanence
      sops
      distributedBuilds
      zfs
    ];
  };
}
