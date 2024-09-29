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
          path = "~/HomeApplications";
          section = "others";
          options = "--sort name --view grid --display folder";
        }
        {
          path = "~/Downloads";
          section = "others";
          options = "--sort name --view grid --display folder";
        }
      ];
    };
  };
  imports = [ ./dock ./extensions ];
  home.activation.appSymlinks = lib.hm.dag.entryAfter [ "writeBoundry" ] ''
    run rm -rf ~/HomeApplications
    run mkdir -p ~/HomeApplications
    run ln -s /Applications/OrcaSlicer.app ~/HomeApplications
    run ln -s /Applications/1Password.app ~/HomeApplications
    run ln -s /Applications/Dropbox.app ~/HomeApplications
    run ln -s "/Applications/MQTT Explorer.app" ~/HomeApplications
    run ln -s "$(realpath "$HOME/Applications/Autodesk Fusion.app")" ~/HomeApplications
    run ln -s "${pkgs.vlc-bin-universal}/Applications/VLC.app" ~/HomeApplications
    run ln -s "${pkgs.inkscape}/Applications/Inkscape.app" ~/HomeApplications

  '';
  home.activation.firefoxProfile = lib.hm.dag.entryAfter [ "writeBoundry" ] ''
    run mv $HOME/Library/Application\ Support/Firefox/profiles.ini $HOME/Library/Application\ Support/Firefox/profiles.hm
    run cp $HOME/Library/Application\ Support/Firefox/profiles.hm $HOME/Library/Application\ Support/Firefox/profiles.ini
    run rm -f $HOME/Library/Application\ Support/Firefox/profiles.ini.bak
    run chmod u+w $HOME/Library/Application\ Support/Firefox/profiles.ini
  '';
  home.activation.desktop = lib.hm.dag.entryAfter [ "writeBoundry" ] ''
    /usr/libexec/PlistBuddy -c "Clear dict" -c "Merge ${wallpaper}" -c Save ~/Library/Application\ Support/com.apple.wallpaper/Store/Index.plist
    /usr/bin/killall WallpaperAgent
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  xdg.configFile."aerospace/aerospace.toml".text = ''
    # You can use it to add commands that run after login to macOS user session.
    # 'start-at-login' needs to be 'true' for 'after-login-command' to work
    # Available commands: https://nikitabobko.github.io/AeroSpace/commands
    after-login-command = []

    # You can use it to add commands that run after AeroSpace startup.
    # 'after-startup-command' is run after 'after-login-command'
    # Available commands : https://nikitabobko.github.io/AeroSpace/commands
    after-startup-command = [ 'exec-and-forget borders active_color=0xffd90f23 inactive_color=0xff494d64 width=5.0' ]

    # Start AeroSpace at login
    start-at-login = true

    # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
    enable-normalization-flatten-containers = true
    enable-normalization-opposite-orientation-for-nested-containers = true

    # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
    # The 'accordion-padding' specifies the size of accordion padding
    # You can set 0 to disable the padding feature
    accordion-padding = 30

    # Possible values: tiles|accordion
    default-root-container-layout = 'tiles'

    # Possible values: horizontal|vertical|auto
    # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
    #               tall monitor (anything higher than wide) gets vertical orientation
    default-root-container-orientation = 'auto'

    # Possible values: (qwerty|dvorak)
    key-mapping.preset = 'qwerty'

    # Mouse follows focus when focused monitor changes
    # Drop it from your config, if you don't like this behavior
    on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

    # Gaps between windows (inner-*) and between monitor edges (outer-*).
    # Possible values:
    # - Constant:     gaps.outer.top = 8
    # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
    #                 In this example, 24 is a default value when there is no match.
    #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
    #                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
    [gaps]
    inner.horizontal = 0
    inner.vertical =   0
    outer.left =       5
    outer.bottom =     5
    outer.top =        5
    outer.right =      5

    # 'main' binding mode declaration
    # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
    # 'main' binding mode must be always presented
    [mode.main.binding]

    # All possible keys:
    # - Letters.        a, b, c, ..., z
    # - Numbers.        0, 1, 2, ..., 9
    # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
    # - F-keys.         f1, f2, ..., f20
    # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
    #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
    # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
    #                   keypadMinus, keypadMultiply, keypadPlus
    # - Arrows.         left, down, up, right

    # All possible modifiers: cmd, alt, ctrl, shift

    # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

    # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
    # You can uncomment the following lines to open up terminal with alt + enter shortcut (like in i3)

    # See: https://nikitabobko.github.io/AeroSpace/commands#layout
    alt-slash = 'layout tiles horizontal vertical'
    alt-comma = 'layout accordion horizontal vertical'

    # See: https://nikitabobko.github.io/AeroSpace/commands#focus
    alt-h = 'focus left'
    alt-j = 'focus down'
    alt-k = 'focus up'
    alt-l = 'focus right'

    # See: https://nikitabobko.github.io/AeroSpace/commands#move
    alt-shift-h = 'move left'
    alt-shift-j = 'move down'
    alt-shift-k = 'move up'
    alt-shift-l = 'move right'

    # See: https://nikitabobko.github.io/AeroSpace/commands#resize
    alt-shift-minus = 'resize smart -50'
    alt-shift-equal = 'resize smart +50'

    # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
    alt-1 = 'workspace 1'
    alt-4 = 'workspace 4'
    alt-5 = 'workspace 5'
    alt-6 = 'workspace 6'
    alt-7 = 'workspace 7'
    alt-8 = 'workspace 8'
    alt-9 = 'workspace 9'

    # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
    alt-shift-1 = 'move-node-to-workspace 1'
    alt-shift-4 = 'move-node-to-workspace 4'
    alt-shift-5 = 'move-node-to-workspace 5'
    alt-shift-6 = 'move-node-to-workspace 6'
    alt-shift-7 = 'move-node-to-workspace 7'
    alt-shift-8 = 'move-node-to-workspace 8'
    alt-shift-9 = 'move-node-to-workspace 9'

    # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
    alt-tab = 'workspace-back-and-forth'
    # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
    alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'


    alt-enter = [ ''''exec-and-forget osascript -e '
    tell application "System events" to tell dock preferences
    set autohide to not autohide
    end tell'
    '''' 
    ]
    alt-t = [ 'exec-and-forget ${pkgs.alacritty}/bin/alacritty msg create-window' ]

    # See: https://nikitabobko.github.io/AeroSpace/commands#mode
    alt-shift-semicolon = 'mode service'

    # 'service' binding mode declaration.
    # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
    [mode.service.binding]
    esc = ['reload-config', 'mode main']
    r = ['flatten-workspace-tree', 'mode main'] # reset layout
    #s = ['layout sticky tiling', 'mode main'] # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
    f = ['layout floating tiling', 'mode main'] # Toggle between floating and tiling layout
    backspace = ['close-all-windows-but-current', 'mode main']

    alt-shift-h = ['join-with left', 'mode main']
    alt-shift-j = ['join-with down', 'mode main']
    alt-shift-k = ['join-with up', 'mode main']
    alt-shift-l = ['join-with right', 'mode main']


    #[[on-window-detected]]
    #run = [ ''''exec-and-forget osascript -e '
    #tell application "System events" to tell dock preferences
    #set autohide to true
    #end tell'
    #''''
    #]
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
    hr = "home-manager switch -b bak --flake ~/mac_nix/.#$(whoami)";
    rg = "batgrep";
    cat = "bat";
    less = "bat";
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;

    extraConfig = ''
      # Copy mode
      bind-key -T copy-mode-vi 'v' send -X begin-selection     # Begin selection in copy mode.
      bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle  # Begin selection in copy mode.
      bind-key -T copy-mode-vi 'y' send -X copy-selection      # Yank selection in copy mode.
      # unbind-key -T copy-mode-vi v

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|nvim-dev|fzf)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
      #Pane colors
      set -g window-style fg=colour255,bg=colour239
      set -g window-active-style fg=colour255,bg=colour0
    '';
  };
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    config = builtins.fromTOML ''
      [global]
      hide_env_diff = true
    '';
  };
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [ batgrep ];
    config.theme = "TwoDark";
  };
  programs.fish = {
    enable = true;
    shellAbbrs = { nu = "nix flake lock --update-input"; };
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
      if status is-interactive; and not set -q TMUX
        tmux ls 2>/dev/null | grep -vq attached ; and exec tmux attach-session
        exec tmux
      end
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
        "$username$hostname$localip$shlvl$directory$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package$bun$c$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$gleam$golang$gradle$haskell$haxe$helm$java$julia$kotlin$lua$nim$nodejs$ocaml$odin$opa$perl$php$pulumi$purescript$python$quarto$raku$rlang$red$ruby$rust$scala$solidity$terraform$typst$vlang$vagrant$zig$buf$guix_shell$nix_shell$conda$meson$spack$memory_usage$aws$gcloud$openstack$azure$direnv$env_var$crystal$custom$sudo$cmd_duration$line_break$jobs$battery$time$status$container$os$shell$character";
      status = { disabled = false; };
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
