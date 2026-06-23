# Repository instructions

## Scope

This repository is the source of truth for Titus's portable Codex
configuration and reusable skills.

## Command execution

- Prefix shell commands with `rtk` when `rtk` is installed.
- If `rtk` is unavailable, state that once and use the raw command.
- In command chains, apply `rtk` to each supported command segment.
- If `rtk` rejects an unsupported command or flag, retry it raw.
- Use raw commands when debugging command filtering.

## Editing

- Use simple ASCII punctuation unless a file format requires otherwise.
- Keep credentials, tokens, sessions, history, caches, logs, and runtime
  databases out of this repository.
- Put reusable workflows in `.agents/skills/<name>/SKILL.md`.
- Put portable user configuration in `codex-home/`.
- Put project maintenance instructions in this file.
- Do not assume files in `docs/` are loaded automatically.

## Documentation routing

Read only the documents needed for the task:

- `docs/CODEX_LAYOUT.md` for Codex discovery and installation boundaries.
- `docs/SKILLS.md` when creating or changing skills.
- `docs/WORKFLOW.md` when changing the repository development workflow.

## Validation

Run `./scripts/validate.sh` after changing configuration, skills, install
scripts, or repository layout.


<!-- headroom:rtk-instructions -->
# RTK (Rust Token Killer) - Token-Optimized Commands

When running shell commands, **always prefix with `rtk`**. This reduces context
usage by 60-90% with zero behavior change. If rtk has no filter for a command,
it passes through unchanged — so it is always safe to use.

## Key Commands
```bash
# Git (59-80% savings)
rtk git status          rtk git diff            rtk git log

# Files & Search (60-75% savings)
rtk ls <path>           rtk read <file>         rtk grep <pattern>
rtk find <pattern>      rtk diff <file>

# Test (90-99% savings) — shows failures only
rtk pytest tests/       rtk cargo test          rtk test <cmd>

# Build & Lint (80-90% savings) — shows errors only
rtk tsc                 rtk lint                rtk cargo build
rtk prettier --check    rtk mypy                rtk ruff check

# Analysis (70-90% savings)
rtk err <cmd>           rtk log <file>          rtk json <file>
rtk summary <cmd>       rtk deps                rtk env

# GitHub (26-87% savings)
rtk gh pr view <n>      rtk gh run list         rtk gh issue list

# Infrastructure (85% savings)
rtk docker ps           rtk kubectl get         rtk docker logs <c>

# Package managers (70-90% savings)
rtk pip list            rtk pnpm install        rtk npm run <script>
```

## Rules
- In command chains, prefix each segment: `rtk git add . && rtk git commit -m "msg"`
- For debugging, use raw command without rtk prefix
- `rtk proxy <cmd>` runs command without filtering but tracks usage
<!-- /headroom:rtk-instructions -->
