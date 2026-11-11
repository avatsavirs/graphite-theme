# graphite-theme

The **graphite** dark theme from [Herdr](https://github.com/herdrdev/herdr), shipped for
opencode, Neovim, kitty, tmux and lazygit. All are generated from one palette (`palette.json`), so they
stay identical. Generated files are committed, so a plain clone works with no build step.

| Tool | Generated file | Installed via |
|------|----------------|---------------|
| opencode | `extras/opencode/graphite.json` | symlink into `~/.config/opencode/themes/` |
| Neovim | `colors/` + `lua/graphite/` | plugin manager |
| kitty | `extras/kitty/graphite.conf` | `include` in `kitty.conf` |
| tmux | `extras/tmux/graphite.conf` | `source-file` in `tmux.conf` |
| lazygit | `extras/lazygit/graphite.yml` | merge `gui.theme` into `config.yml` |

## Install

### opencode

```sh
mkdir -p ~/.config/opencode/themes
ln -s /path/to/graphite-theme/extras/opencode/graphite.json ~/.config/opencode/themes/graphite.json
```

Use `cp` instead of `ln -s` for a standalone copy.

Then pick **graphite** in opencode (`Ctrl+P` > Settings > Theme), or set it in `cli.json`:

```json
{ "theme": { "name": "graphite", "mode": "dark" } }
```

A symlink picks up rebuilds automatically; it breaks if you move or delete this repo.
opencode plugins can't register themes, so this is a file install, not a plugin.

### Neovim

lazy.nvim:

```lua
{
  dir = "/path/to/graphite-theme",
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
include /path/to/graphite-theme/extras/kitty/graphite.conf
```

### tmux

Needs tmux >= 3.0 and a Nerd/Powerline font (the status bar uses arrow glyphs).

```conf
# ~/.tmux.conf  (replace any existing theme block)
source-file /path/to/graphite-theme/extras/tmux/graphite.conf
```

Reload with `tmux source-file ~/.tmux.conf`. The theme only sets colors and the status bar;
keybindings, `status-interval` and other options stay in your own config.

### lazygit

lazygit has no include mechanism, so copy the `gui.theme` block from `extras/lazygit/graphite.yml`
into your lazygit `config.yml` (`lazygit --print-config-dir` shows where it lives), replacing any
existing `gui.theme`.

If you use lazygit.nvim with `vim.g.lazygit_config_file_path`, lazygit inside Neovim reads only that
file, so the block has to go there too.

## Development

Requires [bun](https://bun.sh).

```sh
bun run build   # regenerate extras/ and lua/graphite/palette.lua from palette.json
bun run check   # fail if the generated files are stale
./scripts/test  # headless Neovim smoke test (needs nvim >= 0.10)
```

Edit `palette.json` or `scripts/build.ts` (and `opencode/base.json` for the opencode token tree),
never the generated files: `extras/` and `lua/graphite/palette.lua`. Neovim highlight groups are
hand-written in `lua/graphite/highlights.lua`.

You don't have to run the build before pushing. CI runs the smoke test on every PR, and on every
push to `main` it rebuilds the generated files and commits any changes as
`chore(build): auto-generated build files` (the same approach as folke/tokyonight.nvim). Run
`git pull` before your next push so you pick up that commit. Run `bun run build` locally when you
want to preview a palette change in kitty, tmux or Neovim.

## Palette

`palette.json` was dumped from Herdr's `themes()` API (graphite preset). Background `#17191d`,
accent `#96b2d7`. Herdr is Apache-2.0; palette values are credited to it (the generated kitty header carries its Apache-2.0 notice).

## License

MIT, see `LICENSE`.
