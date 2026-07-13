# Repository instructions

## Scope

This repository is the source of truth for Titus's portable Codex
configuration, reusable skills, and durable coding-agent instructions. The root
`AGENTS.md` is the project maintenance file and follows the AGENTS.md convention
for tools that load it automatically.

## Operating principles

- Working code only. Plausibility is not correctness; verify before reporting
  done.
- Never fabricate file paths, APIs, commit hashes, command output, or test
  results. Read the file, run the command, or say what is unknown.
- Say when a premise appears wrong before implementing around it.
- Ask before proceeding only when a request has multiple plausible
  interpretations and the choice materially affects the result.
- Touch only what the task requires. Avoid drive-by refactors, formatting, or
  cleanup.
- Keep communication direct and concise. Skip flattery, filler, ceremonial
  openings, and emoji.

## Command execution

- Use `rtk` when command output is likely to be large or repetitive and a
  filtered summary is sufficient. Good candidates include test suites, builds,
  linters, logs, broad searches, dependency listings, and infrastructure
  status commands.
- Use raw commands when output is expected to be short, when exact or complete
  output matters, or when inspecting a specific file or narrowly scoped result.
- In command chains, apply `rtk` only to segments that benefit from filtering.
- If RTK hides needed detail, rejects a command or flag, or complicates
  debugging, rerun the command raw. Do not use `rtk proxy` merely to satisfy an
  RTK convention.
- If a task is primarily Bash or command-line automation, consider RTK for
  noisy validation commands, but keep commands raw when validating exact
  stdout, stderr, exit-status, quoting, or pipeline behavior.
- Prefer running code, tests, linters, and type checks over guessing.
- Read complete errors, logs, and stack traces before fixing them.

## Before editing

- State the plan or success criteria before editing. For non-trivial work,
  include the verification you expect to run.
- Read the files you will touch and the nearby callers, consumers, or docs that
  define their behavior.
- Match existing project patterns, naming, layout, and style even if a different
  approach would be appealing in a new project.
- Resolve ambiguity by reading code or running commands when practical; surface
  assumptions out loud when they affect the result.

## Editing

- Use simple ASCII punctuation unless a file format requires otherwise.
- Keep credentials, tokens, sessions, history, caches, logs, and runtime
  databases out of this repository.
- Put reusable workflows in `.agents/skills/<name>/SKILL.md`.
- Put portable user configuration in `codex-home/`.
- Put project maintenance instructions in this file.
- Do not assume files in `docs/` are loaded automatically.
- Use the minimum code or documentation change that solves the stated problem.
- Do not add speculative features, abstractions, configurability, or hooks.
- Do clean up orphans created by your own change, such as unused imports or
  obsolete helper functions.
- Do not delete pre-existing dead code unless asked; mention it in the summary
  if it matters.

## Documentation routing

Read only the documents needed for the task:

- `docs/CODEX_LAYOUT.md` for Codex discovery and installation boundaries.
- `docs/SKILLS.md` when creating or changing skills.
- `docs/WORKFLOW.md` when changing the repository development workflow.

## Verification

- Run the smallest meaningful verification during iteration and the requested or
  relevant final verification before reporting done.
- If verification fails, fix the cause instead of weakening the check.
- For UI or visual changes, verify visually with screenshots or equivalent
  rendered output.
- Run `./scripts/validate.sh` after changing configuration, skills, install
  scripts, or repository layout.

## Maintenance

- Keep this file short enough to follow. Add rules only when they prevent a real
  repeat mistake or document durable project behavior.
- When the user corrects an approach, tighten the relevant rule instead of
  appending a vague warning.
