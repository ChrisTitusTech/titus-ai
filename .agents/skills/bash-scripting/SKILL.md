---
name: bash-scripting
description: Design, implement, review, test, and debug Bash and POSIX shell scripts with safe quoting, error handling, portability, ShellCheck, shfmt, and predictable command behavior. Use when Codex is asked to create or modify .sh files, automate command-line workflows, fix shell bugs, improve script safety, remove bashisms, or validate Linux and CI shell scripts.
---

# bash-scripting

## Workflow

1. Inspect repository instructions, the target shell, callers, and supported platforms.
2. Decide whether the script requires Bash or should remain POSIX `sh`.
3. Identify inputs, side effects, privilege needs, failure behavior, and cleanup.
4. Implement the smallest maintainable change using existing project helpers.
5. Validate syntax, static analysis, formatting, and representative success and failure paths.

## Shell selection

- Use `#!/bin/sh` for portable scripts unless Bash features provide a concrete benefit.
- Use `#!/usr/bin/env bash` or the repository's established Bash shebang when arrays, `[[ ]]`, process substitution, `mapfile`, or other Bash-only features are required.
- Do not introduce Bash syntax into a script declared as `sh`.
- Preserve the repository's existing interpreter and compatibility target unless the task requires changing it.

## Implementation rules

- Quote expansions by default: `"$value"` and `"${array[@]}"`.
- Use `printf` for predictable output.
- Prefer `case` for multi-branch string matching and `getopts` for portable option parsing.
- Use functions for meaningful reusable operations, not every individual command.
- Keep normal output on stdout and diagnostics on stderr.
- Return nonzero for failures and preserve useful exit statuses.
- Check external command availability before relying on optional tools.
- Use `mktemp` and `trap` for temporary resources and cleanup.
- Make destructive or privileged operations explicit and narrowly scoped.
- Avoid `eval`, unquoted command construction, predictable temporary paths, and parsing `ls`.
- Avoid piping remote downloads directly into a shell unless the user explicitly requires it and the trust implications are documented.
- Treat `set -e` as a control-flow choice, not complete error handling. Understand its exceptions before adding it.
- Use `set -u` and `pipefail` only when compatible with the script and interpreter.
- Preserve idempotency for installation and configuration scripts where practical.

## Diagnostics

```bash
bash -n path/to/script.sh
sh -n path/to/script.sh
shellcheck path/to/script.sh
shfmt -d path/to/script.sh
checkbashisms path/to/script.sh
```

Run only the interpreter-specific checks that match the declared shell.

## Validation

- Syntax validation passes for the declared interpreter.
- ShellCheck has no unresolved actionable findings.
- Formatting matches the repository or `shfmt`.
- Arguments with spaces, empty values, wildcard characters, and leading dashes are handled safely.
- Failure paths return useful status codes and messages.
- Temporary files and partial state are cleaned up.
- Privileged, destructive, and network operations are tested safely or clearly identified as untested.
