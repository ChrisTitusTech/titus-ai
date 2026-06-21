#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
errors=0

fail() {
  printf 'error: %s\n' "$1" >&2
  errors=$((errors + 1))
}

required_files=(
  "AGENTS.md"
  "codex-home/AGENTS.md"
  "codex-home/config.toml"
  "codex-home/ollama.config.toml"
  "codex-home/llamacpp.config.toml"
  "codex-home/rules/default.rules"
  "docs/CODEX_LAYOUT.md"
  "scripts/install.sh"
)

for relative in "${required_files[@]}"; do
  [[ -f "$repo_root/$relative" ]] || fail "missing $relative"
done

if command -v python3 >/dev/null 2>&1; then
  for config_file in "$repo_root"/codex-home/*.toml; do
    python3 -c 'import pathlib, sys, tomllib; tomllib.loads(pathlib.Path(sys.argv[1]).read_text())' "$config_file" ||
      fail "invalid TOML in ${config_file#"$repo_root"/}"
  done
fi

if [[ -d "$repo_root/.codex/skills" ]]; then
  fail "legacy .codex/skills directory still exists"
fi

skill_count=0
for skill_dir in "$repo_root"/.agents/skills/*; do
  [[ -d "$skill_dir" ]] || continue
  skill_count=$((skill_count + 1))
  skill_file="$skill_dir/SKILL.md"

  if [[ ! -f "$skill_file" ]]; then
    fail "missing ${skill_file#"$repo_root"/}"
    continue
  fi

  first_line="$(sed -n '1p' "$skill_file")"
  [[ "$first_line" == "---" ]] || fail "${skill_file#"$repo_root"/} has no YAML front matter"
  grep -q '^name: .\+' "$skill_file" || fail "${skill_file#"$repo_root"/} has no name"
  grep -q '^description: .\+' "$skill_file" || fail "${skill_file#"$repo_root"/} has no description"
done

[[ $skill_count -gt 0 ]] || fail "no skills found under .agents/skills"

for forbidden in auth.json history.jsonl installation_id state_5.sqlite goals_1.sqlite memories_1.sqlite; do
  [[ ! -e "$repo_root/$forbidden" ]] || fail "runtime file must not be tracked: $forbidden"
done

if command -v git >/dev/null 2>&1; then
  if git -C "$repo_root" ls-files | grep -Eq '(^|/)(auth\.json|history\.jsonl|installation_id|.*\.sqlite(-shm|-wal)?)$'; then
    fail "tracked Codex runtime or credential files detected"
  fi
fi

if [[ $errors -gt 0 ]]; then
  printf 'validation failed with %d error(s)\n' "$errors" >&2
  exit 1
fi

printf 'validation passed: %d skills checked\n' "$skill_count"
