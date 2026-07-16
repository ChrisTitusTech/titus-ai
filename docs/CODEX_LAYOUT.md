# Codex configuration layout

## What Codex loads automatically

Codex automatically discovers a limited set of files:

| Purpose | User scope | Repository scope |
| --- | --- | --- |
| Instructions | `~/.codex/AGENTS.md` | `AGENTS.md` from the repository root to the working directory |
| Configuration | `~/.codex/config.toml` | `.codex/config.toml` in trusted projects |
| Skills | `~/.agents/skills/` | `.agents/skills/` from the working directory to the repository root |
| Rules | `~/.codex/rules/` | Project rules next to an active trusted `.codex/config.toml` layer |

Codex does not recursively read arbitrary files under `docs/`. A loaded
`AGENTS.md`, selected skill, or user prompt must point Codex to the relevant
document.

## Why this repository is not a full home-directory mirror

The active `~/.codex` directory mixes portable configuration with private and
ephemeral runtime state. Examples include:

- `auth.json`
- installation identifiers
- session transcripts and history
- SQLite state and write-ahead logs
- model and application caches
- downloaded plugins
- shell snapshots

Tracking or replacing those files would expose credentials, create noisy
changes, and make the setup less portable.

This repository manages only:

- global instructions
- user configuration defaults
- optional local model profiles
- command rules
- reusable skills

The installer links those files into their documented locations while
preserving runtime state.

## Local model profiles

Codex profile files live directly under `CODEX_HOME` and use the name
`<profile>.config.toml`.

This repository includes:

- `ollama.config.toml` for Codex's built-in Ollama provider.
- `llamacpp.config.toml` for a local llama.cpp Responses API endpoint.

Profiles layer over `config.toml` only when selected with `--profile`, so local
model settings do not affect ordinary Codex sessions.

## Skill location migration

Older local layouts may place skills under `.codex/skills`. Current Codex
documentation uses `.agents/skills` for user and repository skills. This
repository uses `.agents/skills` as its canonical location.

## Direct `CODEX_HOME` use

Do not point `CODEX_HOME` at this repository. Codex writes runtime state into
`CODEX_HOME`, while this repository intentionally separates managed files from
runtime data. Use `scripts/install.sh` on Linux or macOS and
`scripts/install.ps1` on Windows instead.

## Verification

After installation, restart Codex and ask:

```text
List the instruction sources and relevant skills active for this repository.
```

The expected instruction order is:

1. `~/.codex/AGENTS.md`
2. the repository root `AGENTS.md`
3. any closer nested `AGENTS.md` or `AGENTS.override.md`
