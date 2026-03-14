#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get_tmux_option() {
  local value
  value=$(tmux show-option -gqv "$1")
  echo "${value:-$2}"
}

main() {
  # 1. Source colors (defines typhon color palette, resets typhon_modes="")
  tmux source-file "$CURRENT_DIR/typhon-colors.conf"

  # 2. Export help.sh path so user plugins can reference it
  tmux set-environment -g TYPHON_SCRIPTS "$CURRENT_DIR/scripts"

  # 3. Source user typhon plugins from configured directories
  local config_dir data_dir
  config_dir=$(get_tmux_option @typhon-config-dir \
    "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/typhon.d")
  data_dir=$(get_tmux_option @typhon-data-dir \
    "${XDG_DATA_HOME:-$HOME/.local/share}/tmux/typhon.d")

  local dir conf_files
  for dir in "$config_dir" "$data_dir"; do
    if [ -d "$dir" ]; then
      conf_files=("$dir"/*.conf)
      [ -e "${conf_files[0]}" ] && tmux source-file "$dir"/*.conf
    fi
  done

  # 4. Source statusline last (reads accumulated typhon_modes)
  tmux source-file "$CURRENT_DIR/typhon-statusline.conf"
}

main "$@"
