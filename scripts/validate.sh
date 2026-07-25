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
  "CLAUDE.md"
  "README.md"
  "ROADMAP.md"
  "SPEC.md"
  "TASKS.md"
  "codex-home/AGENTS.md"
  "codex-home/config.toml"
  "codex-home/ollama.config.toml"
  "codex-home/llamacpp.config.toml"
  "codex-home/rules/default.rules"
  "docs/CODEX_LAYOUT.md"
  "docs/SKILLS.md"
  "docs/WORKFLOW.md"
  ".github/dependabot.yml"
  ".github/pull_request_template.md"
  ".github/workflows/validate.yml"
  "scripts/install.ps1"
  "scripts/install.sh"
  "scripts/test-install.ps1"
  "scripts/test-install.sh"
)

for relative in "${required_files[@]}"; do
  [[ -f "$repo_root/$relative" ]] || fail "missing $relative"
done

if command -v python3 >/dev/null 2>&1; then
  for config_file in "$repo_root"/codex-home/*.toml; do
    python3 -c 'import pathlib, sys, tomllib; tomllib.loads(pathlib.Path(sys.argv[1]).read_text())' "$config_file" ||
      fail "invalid TOML in ${config_file#"$repo_root"/}"
  done

  python3 -c 'import pathlib, sys, tomllib; config = tomllib.loads(pathlib.Path(sys.argv[1]).read_text()); raise SystemExit(config.get("features", {}).get("memories") is not True)' \
    "$repo_root/codex-home/config.toml" || fail "codex-home/config.toml must enable features.memories"
fi

if [[ -d "$repo_root/.codex/skills" ]]; then
  fail "legacy .codex/skills directory still exists"
fi

skill_count=0
actual_skills=""
for skill_dir in "$repo_root"/.agents/skills/*; do
  [[ -d "$skill_dir" ]] || continue
  skill_count=$((skill_count + 1))
  skill_file="$skill_dir/SKILL.md"
  skill_basename="$(basename "$skill_dir")"

  if [[ ! -f "$skill_file" ]]; then
    fail "missing ${skill_file#"$repo_root"/}"
    continue
  fi

  first_line="$(sed -n '1p' "$skill_file")"
  [[ "$first_line" == "---" ]] || fail "${skill_file#"$repo_root"/} has no YAML front matter"
  grep -q '^name: .\+' "$skill_file" || fail "${skill_file#"$repo_root"/} has no name"
  grep -q '^description: .\+' "$skill_file" || fail "${skill_file#"$repo_root"/} has no description"
  skill_name="$(sed -n 's/^name: //p' "$skill_file" | sed -n '1p')"
  [[ "$skill_name" == "$skill_basename" ]] ||
    fail "${skill_file#"$repo_root"/} name does not match its directory"
  ! grep -q '\[TODO:' "$skill_file" || fail "${skill_file#"$repo_root"/} contains TODO placeholders"
  actual_skills+="$skill_basename"$'\n'
done

[[ $skill_count -gt 0 ]] || fail "no skills found under .agents/skills"

# The sed expression is intentionally literal.
# shellcheck disable=SC2016
documented_skills="$(
  sed -n '/^## Repository skills$/,/^## /p' "$repo_root/docs/SKILLS.md" |
    sed -n 's/^- `\([^`]*\)`$/\1/p' |
    sort
)"
actual_skills="$(printf '%s' "$actual_skills" | sort)"
[[ "$documented_skills" == "$actual_skills" ]] ||
  fail "docs/SKILLS.md does not match .agents/skills"

for forbidden in auth.json history.jsonl installation_id state_5.sqlite goals_1.sqlite memories_1.sqlite; do
  [[ ! -e "$repo_root/$forbidden" ]] || fail "runtime file must not be tracked: $forbidden"
done

if command -v git >/dev/null 2>&1 &&
  git -C "$repo_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if git -C "$repo_root" ls-files | grep -Eq '(^|/)(auth\.json|history\.jsonl|installation_id|.*\.sqlite(-shm|-wal)?)$'; then
    fail "tracked Codex runtime or credential files detected"
  fi
fi

if ! bash -n \
  "$repo_root/scripts/install.sh" \
  "$repo_root/scripts/test-install.sh" \
  "$repo_root/scripts/validate.sh"; then
  fail "Bash syntax validation failed"
fi

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck \
    "$repo_root/scripts/install.sh" \
    "$repo_root/scripts/test-install.sh" \
    "$repo_root/scripts/validate.sh" ||
    fail "ShellCheck failed"
fi

if command -v codex >/dev/null 2>&1; then
  policy_result="$(
    codex execpolicy check \
      --rules "$repo_root/codex-home/rules/default.rules" \
      rtk gain
  )" || fail "invalid codex-home/rules/default.rules"

  if [[ -n "${policy_result:-}" ]] && command -v python3 >/dev/null 2>&1; then
    python3 -c 'import json, sys; raise SystemExit(json.loads(sys.argv[1]).get("decision") != "allow")' \
      "$policy_result" || fail "default rules must allow rtk commands"
  fi
fi

if command -v pwsh >/dev/null 2>&1; then
  # The PowerShell variables must not expand in Bash.
  # shellcheck disable=SC2016
  pwsh -NoProfile -Command \
    '$errors = $null; [void][System.Management.Automation.Language.Parser]::ParseFile($args[0], [ref]$null, [ref]$errors); if ($errors.Count) { $errors | ForEach-Object { Write-Error $_ }; exit 1 }' \
    "$repo_root/scripts/install.ps1" ||
    fail "PowerShell syntax validation failed for scripts/install.ps1"
fi

if ! bash "$repo_root/scripts/test-install.sh"; then
  fail "installer integration test failed"
fi

if [[ $errors -gt 0 ]]; then
  printf 'validation failed with %d error(s)\n' "$errors" >&2
  exit 1
fi

printf 'validation passed: %d skills checked\n' "$skill_count"
