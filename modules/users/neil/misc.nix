{ den, ... }:
{
  den.aspects.neil = {
    homeManager =
      {
        pkgs,
        lib,
        ...
      }:
      {

        programs.bat = {
          enable = true;
          extraPackages = with pkgs.bat-extras; [ batgrep ];
          config.theme = "TwoDark";
        };
        programs.fish = {
          enable = true;
          shellAbbrs = {
            nu = "nix flake lock --update-input";
          };
          loginShellInit =
            let
              profiles = [
                "/etc/profiles/per-user/$USER"
                "$HOME/.nix-profile"
                "(set -q XDG_STATE_HOME; and echo $XDG_STATE_HOME; or echo $HOME/.local/state)/nix/profile"
                "/run/current-system/sw"
                "/nix/var/nix/profiles/default"
              ];
              makeBinSearchPath = lib.concatMapStringsSep " " (path: "${path}/bin");
            in
            ''
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
          zsh.enable = true;
          zsh.enableCompletion = true;
          zsh.autosuggestion.enable = true;
          zsh.syntaxHighlighting.enable = true;
          starship.enable = true;
          starship.enableZshIntegration = true;
          starship.settings = {
            format = "$username$hostname$localip$shlvl$directory$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package$bun$c$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$gleam$golang$gradle$haskell$haxe$helm$java$julia$kotlin$lua$nim$nodejs$ocaml$odin$opa$perl$php$pulumi$purescript$python$quarto$raku$rlang$red$ruby$rust$scala$solidity$terraform$typst$vlang$vagrant$zig$buf$guix_shell$nix_shell$conda$meson$spack$memory_usage$aws$gcloud$openstack$azure$direnv$env_var$crystal$custom$sudo$cmd_duration$line_break$jobs$battery$time$status$container$os$shell$character";
            status = {
              disabled = false;
            };
          };
          alacritty = {
            enable = true;
            settings.font.normal.family = "SauceCodePro Nerd Font Mono";
            settings.font.size = 14;
          };
          firefox = {
            enable = true;
            profiles.neil = {
              extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
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
      };
  };
}
