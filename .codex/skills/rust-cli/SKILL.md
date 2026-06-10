---
name: rust-cli
description: Design, implement, test, document, and release Rust command line applications using Cargo, clap, integration tests, error handling, and CLI UX conventions. Use when Codex is asked to build or review a Rust CLI, add commands or flags, improve tests, package releases, or debug Cargo workflows.
---

# rust-cli

## Workflow

1. Gather Cargo workspace, command, flag, and test context.
2. Determine user-facing CLI behavior and compatibility impact.
3. Create rollback by keeping changes scoped and tests focused.
4. Implement the smallest parser, command, or library change.
5. Validate formatting, linting, tests, help text, and exit codes.

## Diagnostics

```bash
cargo metadata --no-deps
cargo fmt --check
cargo clippy -- -D warnings
cargo test
cargo run -- --help
cargo run -- <command> --help
```

## Safety Rules

- Keep parsing, command execution, and reusable logic separated.
- Print normal output to stdout and diagnostics to stderr.
- Never change CLI output formats casually if scripts may depend on them.
- Return non-zero exit codes for failed operations.
- Follow existing crate and workspace conventions before adding abstractions.

## Validation

- `cargo fmt --check` passes.
- `cargo clippy -- -D warnings` passes when feasible.
- Unit and integration tests pass.
- `--help` and command help are accurate.
- Success and failure paths return expected exit codes.
