#!/usr/bin/env bash
# Installs the graphite theme into opencode's global themes directory.
#   ./scripts/install-opencode.sh           symlink (updates automatically on rebuild)
#   ./scripts/install-opencode.sh --copy    copy a standalone file instead
#   ./scripts/install-opencode.sh --force   replace an existing graphite.json
# Override the target with OPENCODE_THEMES_DIR (default ~/.config/opencode/themes).
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src="$root/extras/opencode/graphite.json"
dir="${OPENCODE_THEMES_DIR:-$HOME/.config/opencode/themes}"
dest="$dir/graphite.json"
mode=link force=0

for arg in "$@"; do
  case "$arg" in
    --copy) mode=copy ;;
    --force) force=1 ;;
    -h|--help) sed -n '2,7p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

# extras/ is committed, but rebuild when bun is around so a fresh palette edit is picked up.
if command -v bun >/dev/null 2>&1; then
  (cd "$root" && bun scripts/build.ts >/dev/null)
fi
[ -f "$src" ] || { echo "missing $src (run: bun run build)" >&2; exit 1; }

mkdir -p "$dir"
if [ -e "$dest" ] || [ -L "$dest" ]; then
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ] && [ "$mode" = link ]; then
    echo "already installed: $dest -> $src"; exit 0
  fi
  [ "$force" = 1 ] || { echo "$dest already exists; re-run with --force to replace it" >&2; exit 1; }
  rm -f "$dest"
fi

if [ "$mode" = copy ]; then cp "$src" "$dest"; else ln -s "$src" "$dest"; fi
echo "installed ($mode): $dest"
echo 'Select it in opencode (Ctrl+P > Settings > Theme) or set {"theme":{"name":"graphite"}} in cli.json.'
