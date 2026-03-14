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

  # 4. Source statusline (computes format strings, stores as @_ options)
  tmux source-file "$CURRENT_DIR/typhon-statusline.conf"

  # 5. Interpolate placeholders into status-left/right
  interpolate_statusline
}

# Replace #{typhon_*} placeholders with computed format strings.
# Reads templates from @typhon-status-left / @typhon-status-right,
# falling back to built-in defaults.
interpolate_statusline() {
  local style indicators
  style=$(tmux show-option -gqv @_typhon-style)
  indicators=$(tmux show-option -gqv @_typhon-indicators)

  local default_left default_right
  default_left=$(tmux show-option -gqv @_typhon-default-status-left)
  default_right=$(tmux show-option -gqv @_typhon-default-status-right)

  local left right
  left=$(get_tmux_option @typhon-status-left "$default_left")
  right=$(get_tmux_option @typhon-status-right "$default_right")

  left="${left//\#\{typhon_style\}/$style}"
  left="${left//\#\{typhon_indicators\}/$indicators}"

  right="${right//\#\{typhon_style\}/$style}"
  right="${right//\#\{typhon_indicators\}/$indicators}"

  tmux set-option -g status-left "$left"
  tmux set-option -g status-right "$right"

  # Clean up internal options
  tmux set-option -gu @_typhon-style
  tmux set-option -gu @_typhon-indicators
  tmux set-option -gu @_typhon-default-status-left
  tmux set-option -gu @_typhon-default-status-right
}

main "$@"
