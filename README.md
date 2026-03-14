# tmux-typhon

Create custom submodes and help menus for tmux.

## Installation

### With [TPM](https://github.com/tmux-plugins/tpm)

Add to your `tmux.conf`:

```tmux
set -g @plugin 'arisweedler/tmux-typhon'
```

Then press `prefix + I` to install.

## How it works

Typhon orchestrates loading in a specific order to solve the variable
accumulation problem — user plugins append to `typhon_modes`, and the
statusline must read the final value:

1. **Colors** — defines the color palette and resets `typhon_modes=""`
2. **User plugins** — sourced from `typhon.d/` directories; each plugin
   appends to `typhon_modes`
3. **Statusline** — reads accumulated state and interpolates placeholders

## Options

| Option | Default | Description |
|---|---|---|
| `@typhon-config-dir` | `$XDG_CONFIG_HOME/tmux/typhon.d` | Directory for user typhon plugins |
| `@typhon-data-dir` | `$XDG_DATA_HOME/tmux/typhon.d` | Directory for machine-local typhon plugins |
| `@typhon-status-left` | *(built-in template)* | Custom status-left template with placeholders |
| `@typhon-status-right` | *(built-in template)* | Custom status-right template with placeholders |

## Statusline placeholders

Use these in `@typhon-status-left` / `@typhon-status-right` to embed
typhon content into your own statusline:

| Placeholder | Description |
|---|---|
| `#{typhon_style}` | Prefix-aware fg/bg style (normal vs prefix coloring) |
| `#{typhon_indicators}` | All state badges — sync, zoom, custom modes, OFF, copy, selection |

Example:

```tmux
set -g @typhon-status-left "#{typhon_style} #S #{typhon_indicators}"
set -g @typhon-status-right "#{typhon_style}#{typhon_indicators} #h | %R "
```

## Writing a typhon plugin

Place `.conf` files in your `typhon.d/` directory. Each plugin typically:

1. Picks a color: `typhon_gb="${typhon_alt1}"`
2. Binds a prefix key to enter the mode:
   `bind-key -T prefix J switch-client -T typhon-join`
3. Binds keys within the mode table
4. Binds `?` for help:
   `bind-key -T typhon-join ? run-shell '"$TYPHON_SCRIPTS/help.sh" typhon-join'`
5. Appends a mode indicator:
   `typhon_modes="${typhon_modes}#{?#{==:#{client_key_table},typhon-join},#[bg=${typhon_gb}] (J) ,}"`

### Help files

Help files live in `typhon-help/` under your XDG config or data
directories. They are bash scripts that populate a `help` associative
array:

```bash
help[v]="join vertical (side-by-side)"
help[h]="join horizontal (top/bottom)"
```

## Available colors

| Variable | Color |
|---|---|
| `typhon_alt1` | blue |
| `typhon_alt2` | green |
| `typhon_alt3` | purple |
| `typhon_alt4` | orange |
| `typhon_alt5` | red |
| `typhon_alt6` | teal |
| `typhon_alt7` | brown |
| `typhon_alt8` | lavender |
