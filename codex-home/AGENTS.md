# Global Codex instructions

## Command execution

- Prefix shell commands with `rtk` when `rtk` is installed.
- If `rtk` is unavailable, state that once and use the raw command.
- In command chains, apply `rtk` to each supported command segment.
- Use raw commands when debugging command filtering.

## Working style

- Use simple ASCII punctuation unless a file format requires otherwise.
- Inspect repository instructions and existing changes before editing.
- Preserve unrelated user changes.
- Prefer small, reviewable changes with relevant validation.
- Do not expose credentials, tokens, private keys, or secret file contents.
- Do not perform destructive operations without explicit authorization.

## Scope selection

- Use `AGENTS.md` for durable repository conventions.
- Use `.codex/config.toml` for trusted project-specific Codex settings.
- Use skills for reusable task workflows.
- Treat files under `docs/` as references, not automatic instructions.
