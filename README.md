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

lualine: a matching theme ships with the plugin. Set `options = { theme = "graphite" }` in your
lualine setup; lualine reads it once at startup, so `:colorscheme` won't change it later.

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

Running the build before pushing is optional. CI runs the smoke test on every PR; on every push to
`main` it rebuilds the generated files and commits any changes as
`chore(build): auto-generated build files`, so `git pull` before your next push. Run
`bun run build` locally to preview a palette change.

## Releases

Versions follow [semver](https://semver.org) and are cut by
[release-please](https://github.com/googleapis/release-please) from
[Conventional Commits](https://www.conventionalcommits.org). Use `feat:` for new features and
`fix:` for fixes (`feat!:` or a `BREAKING CHANGE:` footer for breaking changes); `docs:`, `chore:`
and the like don't trigger a release. Merging the release PR that release-please keeps open on
`main` tags `vX.Y.Z` and updates `CHANGELOG.md`. Until 1.0, breaking changes bump the minor version.

## Palette

`palette.json` was dumped from Herdr's `themes()` API (graphite preset). Background `#17191d`,
accent `#96b2d7`. Herdr is Apache-2.0; the palette values are credited to it, and the generated
kitty header carries that notice.

## License

MIT, see `LICENSE`.
