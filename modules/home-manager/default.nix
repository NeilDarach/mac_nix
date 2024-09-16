{ config, inputs, pkgs, pkgs-unstable, lib, ... }:
let wallpaper = ./wallpaper.plist;

in {
  # home-manger configs
  #imports = [ inputs.nixNvim.nixosModules.default ];
  local = {
    extensions = {
      enable = true;
      entries = [
        {
          uti = "public.mpeg-4";
          bundle = "org.videolan.vlc";
        }
        {
          uti = "com.apple.quicktime-movie";
          bundle = "org.videolan.vlc";
        }
      ];
    };
    dock = {
      enable = true;
      orientation = "left";
      entries = [
        {
          path = "/System/Applications/System Settings.app";
          section = "apps";
          options = "";
        }
        {
          path = "${pkgs.firefox-bin}/Applications/Firefox.app";
          section = "apps";
          options = "";
        }
        {
          path = "${pkgs.alacritty}/Applications/Alacritty.app";
          section = "apps";
          options = "";
        }
        {
          path = "${pkgs-unstable.neovide}/Applications/Neovide.app";
          section = "apps";
          options = "";
        }
        {
          path = "/Applications";
          section = "others";
          options = "--sort name --view grid --display folder";
        }
        {
          path = "/Users/neil/Downloads";
          section = "others";
          options = "--sort name --view grid --display folder";
        }
      ];
    };
  };
  imports = [ ./dock ./extensions ];
  home.activation.firefoxProfile = lib.hm.dag.entryAfter [ "writeBoundry" ] ''
    run mv /Users/neil/Library/Application\ Support/Firefox/profiles.ini /Users/neil/Library/Application\ Support/Firefox/profiles.hm
    run cp /Users/neil/Library/Application\ Support/Firefox/profiles.hm /Users/neil/Library/Application\ Support/Firefox/profiles.ini
    run rm -f /Users/neil/Library/Application\ Support/Firefox/profiles.ini.bak
    run chmod u+w /Users/neil/Library/Application\ Support/Firefox/profiles.ini
  '';
  home.activation.desktop = lib.hm.dag.entryAfter [ "writeBoundry" ] ''
    /usr/libexec/PlistBuddy -c "Clear dict" -c "Merge ${wallpaper}" -c Save ~/Library/Application\ Support/com.apple.wallpaper/Store/Index.plist
    /usr/bin/killall WallpaperAgent
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  home.packages = with pkgs; [
    ripgrep
    fd
    curl
    less
    plistwatch
    jq
    coreutils
    perl
    python3
    ruby
    gcc
    vlc-bin-universal
    inkscape
    inputs.nixNvim.packages.${pkgs.system}.nvim
    tmux
  ];
  home.stateVersion = "24.05";
  home.username = "neil";
  home.homeDirectory = "/Users/neil";
  home.sessionVariables = {
    PAGER = "less";
    CLICOLOR = 1;
    EDITOR = "vim";
  };
  home.shellAliases = {
    ls = "ls --color=auto -F";
    nr = "darwin-rebuild switch --flake ~/mac_nix/.#";
    hr = "home-manager switch --flake ~/mac_nix/.#$(whoami)";
    rg = "batgrep";
    cat = "bat";
    less = "bat";
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [ batgrep ];
    config.theme = "TwoDark";
  };
  programs.fish = {
    enable = true;
    functions = { flake-update = "nix flake lock --update-input $argv[1]"; };
    loginShellInit = let
      profiles = [
        "/etc/profiles/per-user/$USER"
        "$HOME/.nix-profile"
        "(set -q XDG_STATE_HOME; and echo $XDG_STATE_HOME; or echo $HOME/.local/state)/nix/profile"
        "/run/current-system/sw"
        "/nix/var/nix/profiles/default"
      ];
      makeBinSearchPath = lib.concatMapStringsSep " " (path: "${path}/bin");
    in ''
      fish_add_path --move --prepend --path ${makeBinSearchPath profiles}
      set fish_user_paths $fish_user_paths  
      fish_vi_key_bindings
      eval "$(/opt/homebrew/bin/brew shellenv)"
      for p in /run/current-system/sw/bin
        if not contains $p $fish_user_paths
          set -g fish_user_paths $p $fish_user_paths
        end
      end
    '';
  };
  programs = {
    fzf.enable = true;
    fzf.enableZshIntegration = true;
    git = {
      enable = true;
      ignores = [ "*~" "*.swp" ];
      userEmail = "neil.darach@gmail.com";
      userName = "Neil Darach";
    };
    zsh.enable = true;
    zsh.enableCompletion = true;
    zsh.autosuggestion.enable = true;
    zsh.syntaxHighlighting.enable = true;
    starship.enable = true;
    starship.enableZshIntegration = true;
    starship.settings = {
      format =
        "$username$hostname$localip$shlvl$singularity$kubernetes$nats$directory$vcsh$fossil_branch$fossil_metrics$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package$bun$c$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$gleam$golang$gradle$haskell$haxe$helm$java$julia$kotlin$lua$nim$nodejs$ocaml$odin$opa$perl$php$pulumi$purescript$python$quarto$raku$rlang$red$ruby$rust$scala$solidity$terraform$typst$vlang$vagrant$zig$buf$guix_shell$nix_shell$conda$meson$spack$memory_usage$aws$gcloud$openstack$azure$direnv$env_var$crystal$custom$sudo$cmd_duration$line_break$jobs$battery$time$status$container$os$shell$character";
    };
    alacritty = {
      enable = true;
      settings.font.normal.family = "SauceCodePro Nerd Font Mono";
      settings.font.size = 16;
    };
    firefox = {
      enable = true;
      package = pkgs.firefox-bin;
      profiles.neil = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          onepassword-password-manager
        ];
        settings = {
          "browser.startup.homepage" = "https://theoldreader.com/posts/all";
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.shell.skipDefaultBrowserCheck" = true;
        };
      };
    };
  };
}
