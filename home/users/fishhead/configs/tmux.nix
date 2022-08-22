{ pkgs, ... }:

{
    programs.tmux = {
        enable = true;
        aggressiveResize = true;
        clock24 = true;
        escapeTime = 0;
        historyLimit = 10000;
        # breaks tmate
        newSession = false;
        secureSocket = false;
        shortcut = "space";
        terminal = "tmux-256color";

        baseIndex = 1;

        plugins = with pkgs; [
            tmuxPlugins.cpu
            {
                plugin = tmuxPlugins.resurrect;
                extraConfig = "set -g @resurrect-strategy-nvim 'session'";
            }
            {
                plugin = tmuxPlugins.continuum;
                extraConfig = ''
                set -g @continuum-restore 'on'
                set -g @continuum-save-interval '60' # minutes
                '';
            }
            {
                plugin = tmuxPlugins.tmux-colors-solarized;
                extraConfig = ''
                set -g @colors-solarized 'dark'
                '';
            }
        ];

        extraConfig = ''
        # Mouse works as expected
        set-option -g mouse on
        
        # easy-to-remember split pane commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        # Vi copypaste mode
        set-window-option -g mode-keys vi
        if-shell "test '\( #{$TMUX_VERSION_MAJOR} -eq 2 -a #{$TMUX_VERSION_MINOR} -ge 4 \)'" 'bind-key -Tcopy-mode-vi v send -X begin-selection; bind-key -Tcopy-mode-vi y send -X copy-selection-and-cancel'
        if-shell '\( #{$TMUX_VERSION_MAJOR} -eq 2 -a #{$TMUX_VERSION_MINOR} -lt 4\) -o #{$TMUX_VERSION_MAJOR} -le 1' 'bind-key -t vi-copy v begin-selection; bind-key -t vi-copy y copy-selection'
        
        # auto window rename
        set-window-option -g automatic-rename

        bind -n S-M-Up {
          copy-mode
          send -X clear-selection
          send -X start-of-line
          send -X start-of-line
          send -X cursor-up
          send -X start-of-line
          send -X start-of-line

          if -F "#{m:*➜\u00A0*,#{copy_cursor_line}}" {
            send -X search-forward-text "➜\u00A0"
            send -X stop-selection
            send -X -N 2 cursor-right
            send -X begin-selection
            send -X end-of-line
            send -X end-of-line
            if "#{m:*➜\u00A0?*,#{copy_cursor_line}}" {
            send -X cursor-left
            }
          } {
            send -X end-of-line
            send -X end-of-line
            send -X begin-selection
            send -X search-backward-text "➜\u00A0"
            send -X end-of-line
            send -X end-of-line
            send -X cursor-right
            send -X stop-selection
          }
        }
        '';
    };
}