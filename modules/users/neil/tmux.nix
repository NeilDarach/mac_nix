{ den, ... }:
{
  den.aspects.neil = {
    homeManager =
      { lib, config, ... }:
      {
        programs.tmux = lib.mkIf config.programs.tmux.enable {
          keyMode = "vi";
          mouse = true;
          extraConfig = ''
            # Copy mode
            bind-key -T copy-mode-vi 'v' send -X begin-selection     # Begin selection in copy mode.
            bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle  # Begin selection in copy mode.
            bind-key -T copy-mode-vi 'y' send -X copy-selection \; run "tmux show-buffer | pbcopy"      # Yank selection in copy mode.
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
      };

  };
}
