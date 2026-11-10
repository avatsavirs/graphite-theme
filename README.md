# graphite-theme

The **graphite** dark theme from [Herdr](https://github.com/herdrdev/herdr), shipped for
opencode, Neovim, kitty and tmux. All three are generated from one palette (`palette.json`), so they
stay identical.

| Tool | Generated file | Installed via |
|------|----------------|---------------|
| opencode | `dist/opencode/graphite.json` | `scripts/install-opencode.sh` |
| Neovim | `dist/nvim/palette.lua` + `colors/` + `lua/graphite/` | plugin manager |
| kitty | `dist/kitty/graphite.conf` | `include` in `kitty.conf` |
| tmux | `dist/tmux/graphite.conf` | `source-file` in `tmux.conf` |

`dist/` is committed so a plain clone works with no build step.

## Install

### opencode

```sh
./scripts/install-opencode.sh          # symlink into ~/.config/opencode/themes/
./scripts/install-opencode.sh --copy   # standalone copy instead
```

Then pick **graphite** in opencode (`Ctrl+P` > Settings > Theme), or set it in `cli.json`:

```json
{ "theme": { "name": "graphite", "mode": "dark" } }
```

A symlink picks up rebuilds automatically; it breaks if you move or delete this repo.
opencode 2.2.6 plugins can't register themes, so this is a file install, not a plugin.

### Neovim

lazy.nvim:

```lua
{
  "OWNER/graphite-theme",   -- or dir = "~/Dev/playground/graphite-theme"
  lazy = false,
  priority = 1000,
  opts = { transparent = false, italic_comments = true },
  config = function(_, opts)
    require("graphite").setup(opts)
    vim.cmd.colorscheme("graphite")
  end,
}
```

lualine: the plugin ships a matching theme, `require("lualine").setup({ options = { theme = "graphite" } })`.
lualine reads its theme once at startup, so set this in your lualine config; running `:colorscheme`
later won't change it.

Without a plugin manager: add this folder to `runtimepath`, then `:colorscheme graphite`.
`transparent = true` keeps the terminal's background (handy inside Herdr or kitty).

### kitty

```conf
# kitty.conf
include /path/to/graphite-theme/dist/kitty/graphite.conf
```

### tmux

Needs tmux >= 3.0 and a Nerd/Powerline font (the status bar uses arrow glyphs).

```conf
# ~/.tmux.conf  (replace any existing theme block)
source-file ~/Dev/playground/graphite-theme/dist/tmux/graphite.conf
```

Reload with `tmux source-file ~/.tmux.conf`. The theme only sets colors and the status bar;
keybindings, `status-interval` and other options stay in your own config.

## Development

```sh
bun run build   # regenerate dist/ from palette.json
bun run check   # fail if dist/ is stale
```

Edit `palette.json` or `scripts/build.ts` (and `opencode/base.json` for the opencode token tree),
never the files in `dist/`. Neovim highlight groups are hand-written in
`lua/graphite/highlights.lua`.

## Palette

`palette.json` was dumped from Herdr's `themes()` API (graphite preset). Background `#17191d`,
accent `#96b2d7`. Herdr is Apache-2.0; palette values are credited to it.

## License

MIT, see `LICENSE`.
