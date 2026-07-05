---
name: quickshell
description: Build, lint, validate, and troubleshoot Quickshell desktop shell projects and QML configurations. Use when working with Quickshell `shell.qml`, `qs.*` imports, Quickshell QML modules, `qmllint`/`qmlls` import failures, Quickshell source builds, packaged Quickshell configs, or docs/API questions based on https://quickshell.org/docs/v0.2.1/.
---

# Quickshell

## Core Workflow

1. Locate the project shape:
   - Config project: has `shell.qml` and QML files.
   - Source checkout: has Quickshell CMake files and usually `BUILD.md`.
   - Packaged config: has a named config intended for `$XDG_CONFIG_HOME/quickshell/<name>` or `$XDG_CONFIG_DIRS/quickshell/<name>`.
2. Read local project instructions first (`AGENTS.md`, `README`, docs, package metadata).
3. For QML edits, run `scripts/quickshell-qmllint` from this skill before treating `qmllint` import errors as real.
4. For runtime validation, load the managed config with `quickshell --path <dir-or-shell.qml>` or `quickshell --config <name>` in a real or nested compositor/session.
5. For source builds, use CMake/Ninja and disable optional features whose dependencies are absent.

## Resources

- Read `references/linting.md` when linting QML, configuring `qmllint`/`qmlls`, or diagnosing missing `Quickshell` or `qs.*` type declarations.
- Read `references/build-and-run.md` when installing Quickshell, running a config, packaging a config, or building Quickshell from source.
- Read `references/docs-map.md` when selecting official Quickshell v0.2.1 docs pages or type references.

## Fast Commands

Lint all QML under the nearest `shell.qml` root:

```sh
/home/titus/github/titus-ai/.agents/skills/quickshell/scripts/quickshell-qmllint
```

Lint a specific config root:

```sh
/home/titus/github/titus-ai/.agents/skills/quickshell/scripts/quickshell-qmllint --root config/quickshell
```

Run a config for validation:

```sh
quickshell --path config/quickshell --no-duplicate
```

Build Quickshell source:

```sh
cmake -GNinja -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
cmake --install build
```

## Guardrails

- Prefer official Quickshell v0.2.1 docs for API and behavior references unless the project pins another version.
- Do not replace runtime `qs.*` imports with relative imports only to satisfy stock `qmllint`; create lint-only module maps instead.
- Treat plain `qmllint` failures about `Quickshell` or `qs.*` imports as setup failures until explicit import roots have been supplied.
- Validate UI/runtime behavior in an actual compositor/X11/Wayland session when windows, panels, focus, IPC, or services are involved.
