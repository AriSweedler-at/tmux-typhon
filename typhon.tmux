#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 1. Source colors (defines typhon color palette, resets typhon_modes="")
tmux source-file "$CURRENT_DIR/typhon-colors.conf"

# 2. Export help.sh path so user plugins can reference it
tmux set-environment -g TYPHON_SCRIPTS "$CURRENT_DIR/scripts"

# 3. Source user typhon plugins from configured directories
for dir_option in @typhon-config-dir @typhon-data-dir; do
  dir=$(tmux show-option -gqv "$dir_option")
  if [ -n "$dir" ] && [ -d "$dir" ]; then
    conf_files=("$dir"/*.conf)
    [ -e "${conf_files[0]}" ] && tmux source-file "$dir"/*.conf
  fi
done

# 4. Source statusline last (reads accumulated typhon_modes)
tmux source-file "$CURRENT_DIR/typhon-statusline.conf"
