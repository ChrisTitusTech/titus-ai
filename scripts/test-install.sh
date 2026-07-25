#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
task_test_root="$(mktemp -d "${TMPDIR:-/tmp}/titus-ai-install-test.XXXXXX")"
test_codex_home="$task_test_root/codex home"
test_agents_home="$task_test_root/agents home"

cleanup() {
  if [[ -d "$task_test_root" && "$(basename "$task_test_root")" == titus-ai-install-test.* ]]; then
    rm -rf -- "$task_test_root"
  fi
}
trap cleanup EXIT

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

assert_link() {
  local target="$1"
  local source="$2"

  [[ -L "$target" ]] || fail "expected symbolic link: $target"
  [[ "$(readlink "$target")" == "$source" ]] ||
    fail "unexpected link target: $target"
}

mkdir -p "$test_codex_home"
printf 'original global instructions\n' >"$test_codex_home/AGENTS.md"

CODEX_HOME="$test_codex_home" AGENTS_HOME="$test_agents_home" \
  "$repo_root/scripts/install.sh" >/dev/null

assert_link "$test_codex_home/AGENTS.md" "$repo_root/codex-home/AGENTS.md"
assert_link "$test_codex_home/config.toml" "$repo_root/codex-home/config.toml"
assert_link "$test_codex_home/rules" "$repo_root/codex-home/rules"
assert_link "$test_codex_home/ollama.config.toml" "$repo_root/codex-home/ollama.config.toml"
assert_link "$test_codex_home/llamacpp.config.toml" "$repo_root/codex-home/llamacpp.config.toml"

for skill_dir in "$repo_root"/.agents/skills/*; do
  [[ -d "$skill_dir" ]] || continue
  assert_link "$test_agents_home/skills/$(basename "$skill_dir")" "$skill_dir"
done

shopt -s nullglob
instruction_backups=("$test_codex_home"/backups/titus-ai-*/AGENTS.md)
shopt -u nullglob
[[ ${#instruction_backups[@]} -eq 1 ]] ||
  fail "expected one AGENTS.md backup, found ${#instruction_backups[@]}"
[[ "$(sed -n '1p' "${instruction_backups[0]}")" == "original global instructions" ]] ||
  fail "AGENTS.md backup content changed"

link_fixture_dir="$task_test_root/link fixtures"
mkdir -p "$link_fixture_dir"
ln -s "$repo_root/codex-home/AGENTS.md" "$link_fixture_dir/managed instructions"
rm -- "$test_codex_home/AGENTS.md"
ln -s "../link fixtures/managed instructions" "$test_codex_home/AGENTS.md"
raw_instruction_target="$(readlink "$test_codex_home/AGENTS.md")"

CODEX_HOME="$test_codex_home" AGENTS_HOME="$test_agents_home" \
  "$repo_root/scripts/install.sh" >/dev/null
[[ "$(readlink "$test_codex_home/AGENTS.md")" == "$raw_instruction_target" ]] ||
  fail "idempotent install replaced an equivalent relative link"

shopt -s nullglob
instruction_backups=("$test_codex_home"/backups/titus-ai-*/AGENTS.md)
shopt -u nullglob
[[ ${#instruction_backups[@]} -eq 1 ]] ||
  fail "idempotent install created another AGENTS.md backup"

rm -- "$test_codex_home/rules"
ln -s "$repo_root/codex-home/rules/." "$test_codex_home/rules"
raw_rules_target="$(readlink "$test_codex_home/rules")"
CODEX_HOME="$test_codex_home" AGENTS_HOME="$test_agents_home" \
  "$repo_root/scripts/install.sh" >/dev/null
[[ "$(readlink "$test_codex_home/rules")" == "$raw_rules_target" ]] ||
  fail "idempotent install replaced an equivalent normalized link"

cycle_fixture_dir="$task_test_root/cycle fixtures"
mkdir -p "$cycle_fixture_dir"
ln -s "cycle-b" "$cycle_fixture_dir/cycle-a"
ln -s "cycle-a" "$cycle_fixture_dir/cycle-b"
rm -- "$test_codex_home/config.toml"
ln -s "../cycle fixtures/cycle-a" "$test_codex_home/config.toml"
cycle_error_log="$task_test_root/cycle-error.log"

CODEX_HOME="$test_codex_home" AGENTS_HOME="$test_agents_home" \
  "$repo_root/scripts/install.sh" >/dev/null 2>"$cycle_error_log"
grep -q '^error: too many symbolic-link hops:' "$cycle_error_log" ||
  fail "cyclic link did not report a bounded-resolution error"
assert_link "$test_codex_home/config.toml" "$repo_root/codex-home/config.toml"

dry_run_codex_home="$task_test_root/dry run codex"
dry_run_agents_home="$task_test_root/dry run agents"
CODEX_HOME="$dry_run_codex_home" AGENTS_HOME="$dry_run_agents_home" \
  "$repo_root/scripts/install.sh" --dry-run >/dev/null
[[ ! -e "$dry_run_codex_home" && ! -L "$dry_run_codex_home" ]] ||
  fail "dry-run created CODEX_HOME"
[[ ! -e "$dry_run_agents_home" && ! -L "$dry_run_agents_home" ]] ||
  fail "dry-run created AGENTS_HOME"

printf 'installer integration test passed\n'
