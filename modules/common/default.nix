{ den, inputs, ... }:
{
  den.aspects.common = {
    includes = with den.aspects; [
      disableGnome
      git
      msg_q
      openssh
      registration
      strongStateDir
      wrappedNvim
      zfs-backup
    ];
    homeManager-nixos =
      { config, lib, ... }:
      {
        systemd.user.startServices = lib.mkIf config.programs.home-manager.enable "sd-switch";
      };
    os = {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate = _: true;
    };
    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        environment.etc = {
          "systemd/journald.conf.d/99-storage.conf".text = ''
            [Journal]
            Storage=volatile
          '';
        };
        #// (lib.mapAttrs' (name: value: {
        #name = "nix/path/${name}";
        #value.soure = value.flake;
        #}) config.nix.registry);
        #nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) (
        #(lib.filterAttrs (_: lib.isType "flake")) inputs
        #);
        nix.nixPath = [ "/etc/nix/path" ];
        environment.systemPackages = with pkgs; [
          bat
          curl
          dig
          dnsutils
          ethtool
          file
          git
          gnutar
          iputils
          jq
          lsof
          mc
          mtr
          netcat
          neovim
          nvd
          openssl
          psmisc
          ripgrep
          sysstat
          tree
          unzip
          usbutils
          wget
          xxd
        ];
        time.timeZone = "Europe/London";
        security.sudo = {
          wheelNeedsPassword = false;
          extraConfig = ''
            Defaults lecture = never
          '';
        };
        nix.settings.trusted-users = [
          "root"
          "@wheel"
        ];
        i18n.defaultLocale = "en_GB.UTF-8";
        documentation.man.generateCaches = false;
        networking.networkmanager.enable = lib.mkDefault true;
        networking.enableIPv6 = false;
        networking.hostId = lib.mkDefault (
          builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName)
        );
      };
  };
}
