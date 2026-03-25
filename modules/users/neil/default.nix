{
  den,
  config,
  ...
}:
{
  # user aspect
  den.aspects.neil = {
    includes = [
      den._.primary-user
      (den._.user-shell "fish")
      den.aspects.hm-darwin
      den.aspects.hm-nixos
    ];

    homeManager =
      { pkgs, ... }:
      {
        home.sessionVariables = {
          PAGER = "less";
          CLICOLOR = 1;
          EDITOR = "vim";
        };
        programs = {
          firefox.enable = true;
          tmux.enable = true;
          direnv.enable = true;
          git.enable = true;

        };
        home.shellAliases = {
          ls = "ls --color=auto -F";
          nr = "darwin-rebuild switch --flake ~/mac_nix/.#";
          hr = "home-manager switch -b bak --flake ~/mac_nix/.#";
          rg = "batgrep";
          cat = "bat";
          less = "bat";
        };
        home.packages = with pkgs; [
          coreutils
          curl
          fd
          htop
          jq
          less
          plistwatch
          ripgrep
          vlc-bin-universal
          wrappedNvim
          wrappedNvimLocal
        ];
        local.user.email = "neil.darach@gmail.com";
        local.user.fullName = "Neil Darach";
      };

    # user can provide NixOS configurations
    # to any host it is included on
    os = {
      users.users.neil.description = "Neil Darach";
      home-manager = {
        backupFileExtension = "bak";
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };

  };
}
