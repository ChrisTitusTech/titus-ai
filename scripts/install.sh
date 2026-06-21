#!/usr/bin/env bash
set -euo pipefail

dry_run=false

if [[ "${1:-}" == "--dry-run" ]]; then
  dry_run=true
elif [[ $# -gt 0 ]]; then
  printf 'usage: %s [--dry-run]\n' "$0" >&2
  exit 2
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_home="${CODEX_HOME:-$HOME/.codex}"
agents_home="${AGENTS_HOME:-$HOME/.agents}"
timestamp="$(date +%Y%m%d-%H%M%S)"
backup_root="$codex_home/backups/titus-ai-$timestamp-$$"

run() {
  if "$dry_run"; then
    printf '+'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

ensure_parent() {
  run mkdir -p "$(dirname "$1")"
}

link_managed_path() {
  local source="$1"
  local target="$2"

  if [[ ! -e "$source" ]]; then
    printf 'error: managed source does not exist: %s\n' "$source" >&2
    exit 1
  fi

  ensure_parent "$target"

  if [[ -L "$target" && "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
    printf 'already linked: %s\n' "$target"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    local relative="${target#"$codex_home"/}"
    local backup="$backup_root/$relative"

    if [[ "$target" != "$codex_home/"* ]]; then
      relative="${target#"$agents_home"/}"
      backup="$backup_root/agents/$relative"
    fi

    ensure_parent "$backup"
    run mv "$target" "$backup"
    printf 'backed up: %s -> %s\n' "$target" "$backup"
  fi

  run ln -s "$source" "$target"
  printf 'linked: %s -> %s\n' "$target" "$source"
}

link_managed_path "$repo_root/codex-home/AGENTS.md" "$codex_home/AGENTS.md"
link_managed_path "$repo_root/codex-home/config.toml" "$codex_home/config.toml"
link_managed_path "$repo_root/codex-home/rules" "$codex_home/rules"

for profile in "$repo_root"/codex-home/*.config.toml; do
  [[ -f "$profile" ]] || continue
  link_managed_path "$profile" "$codex_home/$(basename "$profile")"
done

for skill_dir in "$repo_root"/.agents/skills/*; do
  [[ -d "$skill_dir" ]] || continue
  link_managed_path "$skill_dir" "$agents_home/skills/$(basename "$skill_dir")"
done

if "$dry_run"; then
  printf 'dry run complete\n'
else
  printf 'installation complete. Restart Codex to reload configuration.\n'
fi
