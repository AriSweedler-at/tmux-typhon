# tmux-typhon

Modal key tables for tmux with auto-sizing help popups, key enactment, and
statusline integration.

## Installation

### With [TPM](https://github.com/tmux-plugins/tpm)

Add to your `tmux.conf`:

```tmux
set -g @typhon-config-dir "$XDG_CONFIG_HOME/tmux/typhon.d"
set -g @typhon-data-dir "$XDG_DATA_HOME/tmux/typhon.d"
set -g @plugin 'arisweedler/tmux-typhon'
```

Then press `prefix + I` to install.

## How it works

Typhon provides a framework for building modal key tables in tmux. The entry
point (`typhon.tmux`) orchestrates loading in a specific order:

1. **Colors** — defines the color palette and resets `typhon_modes=""`
2. **User plugins** — sourced from `@typhon-config-dir` and `@typhon-data-dir`;
   each plugin appends to `typhon_modes` for statusline display
3. **Statusline** — reads the accumulated `typhon_modes` and sets the status
   line format

## Writing a typhon plugin

Place `.conf` files in your `typhon.d/` directory. Each plugin typically:

1. Picks a color: `typhon_gb="${typhon_alt1}"`
2. Binds a prefix key to enter the mode: `bind-key -T prefix J switch-client -T typhon-join`
3. Binds keys within the mode table
4. Binds `?` for help: `bind-key -T typhon-join ? run-shell '"$TYPHON_SCRIPTS/help.sh" typhon-join'`
5. Appends a mode indicator: `typhon_modes="${typhon_modes}#{?#{==:#{client_key_table},typhon-join},#[bg=${typhon_gb}] (J) ,}"`

### Help files

Help files live in `typhon-help/` under your XDG config or data directories.
They are bash scripts that populate a `help` associative array:

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
