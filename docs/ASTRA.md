# Astra configuration and instruction audit

Checked against official OpenAI documentation on 2026-09-08. This is a
quality-to-credit baseline, not a measured optimum.

## Model defaults

| Setting | Choice | Reason |
| --- | --- | --- |
| `model` | `gpt-6-astra` | Preserve the requested model |
| `model_reasoning_effort` | `medium` | Existing live setting and local catalog default |
| `plan_mode_reasoning_effort` | `high` | Retain the existing planning setting |
| `model_verbosity` | `low` | Concise output |
| `features.fast_mode` | `false` | Disable Fast-tier selection in the TUI |
| `service_tier` | unset | Do not request priority processing |

The repo previously installed Sol/high over a live Astra/medium configuration.
The updated defaults resolve that drift. The local model catalog describes
medium as balancing speed and reasoning depth. OpenAI's
[Astra migration guidance](https://developers.openai.com/api/docs/guides/latest-model)
recommends retaining effective effort when migrating from supported levels.

The [Codex pricing page](https://developers.openai.com/codex/pricing) says Astra
Fast mode uses 2.5 times the Standard credits. This is a processing-speed choice,
not a documented quality improvement. API dollar prices are a separate billing
system and do not establish subscription credits saved per task.

The [configuration reference](https://developers.openai.com/codex/config-reference)
distinguishes Fast-tier selection from `service_tier`. An explicit task, profile,
project, or app override can supersede global defaults. Existing tasks may retain
their model settings; start a new task and check its model and effort.

For simple work or difficult debugging, use an explicit per-session override:

```bash
codex -c model_reasoning_effort='"low"'
codex -c model_reasoning_effort='"high"'
```

Keep medium as the starting point. Compare accepted results, rework, elapsed
time, and actual account usage on representative tasks before changing the
default further. No credit-savings benchmark was run during this audit.

## Findings and changes

All 14 repository skill entrypoints, global and root instructions, and the
planning instruction template were inspected. Conditional references were read
where needed to reconcile a finding; bundled upstream manuals were not rewritten.

- Global instructions now resolve skill precedence explicitly, preserve existing
  authorization, scope diagnostic examples, and reuse passing evidence.
- `python-ai` removes an environment dump that could disclose API keys and stops
  requiring speculative feature flags or provider fallbacks.
- `homelab-admin` keeps TLS verification enabled and scopes disruptive testing.
- `linux-sysadmin`, `forgejo-maintainer`, and `podman-operator` distinguish
  diagnosis from mutation, target affected paths, and preserve deployment modes.
  Container inspection must select fields rather than expose credentials.
- `quickshell` and its build reference preserve required features when build
  dependencies are missing.
- `ai-project-manager` scales planning to the request and cannot mark skipped
  required checks complete. Its template reuses prior authorization.
- `pr-readiness` distinguishes local validation from remote merge gates and
  accepts existing independent review evidence when repository policy permits.
- `bash-scripting`, `hugo`, `mdbook`, `rust-cli`, `wayfinder`, and
  `youtube-thumbnail` retain their domain guidance. Planning-only boundaries,
  shell correctness, publication examples, and photographed-person preservation
  remain intact.

OpenAI's [Astra instruction guidance](https://developers.openai.com/api/docs/guides/latest-model#instruction-following)
calls for auditing conflicting skills. Its verification guidance favors relevant
checks over repeated unchanged tests. The changes apply those principles while
retaining required gates.

## Global scope and security

The old standalone CLI 0.149.0 was rejected by the server for Astra requests.
The installed app bundles CLI 0.153.0-alpha.5, which successfully starts Astra
review. The local `~/.local/bin/codex` launcher now links to
`/usr/lib/chatgpt/resources/codex`; its former symlink is backed up under
`~/.codex/backups/astra-cli-20260908-190153/`. This machine-specific repair is
not part of the portable installer. If the app is removed, install a current
standalone CLI before replacing the launcher; restoring the old launcher also
restores its Astra incompatibility.

The installed global `AGENTS.md` and all 14 managed skills are links into this
repository, so their edits apply globally. The live config is a regular file;
update only the intended model settings when applying this audit to an existing
installation. The normal installer renders broader defaults and trust entries,
so inspect its dry run before using it on a customized machine.

This audit preserves the existing `approval_policy = "never"` and
`sandbox_mode = "danger-full-access"`, trust entries, command rules, disabled
memory features, and machine-local integrations. These are existing full-access
preferences, not a sandboxed security baseline. Written authorization rules do
not create OS isolation. No permission or security control was relaxed for cost.

Three additional user-installed skills (`autofix`, `code-review`, `find-skills`)
were inspected. They are not managed by this repository: autofix assumes
publication authorization, code-review broadly selects CodeRabbit, and
find-skills can route ordinary questions into discovery. Global task-scope and
authorization rules take precedence over those guidelines. Their files and
plugin-owned caches remain untouched; future upstream updates need re-auditing.

Credentials, session data, runtime caches, and plugin settings are not copied
into this repository. Required verification remains `./scripts/validate.sh`,
skill frontmatter validation, and `codex review --uncommitted` after local gates.
