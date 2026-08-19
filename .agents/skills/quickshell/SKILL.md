---
name: quickshell
description: Build, lint, and troubleshoot Quickshell QML configurations or source builds. Use for shell.qml, Quickshell modules, qmllint setup, runtime validation, packaging, and version-matched API guidance.
---

# Quickshell

## Core Workflow

1. Locate the project shape:
   - Config project: has `shell.qml` and QML files.
   - Source checkout: has Quickshell CMake files and usually `BUILD.md`.
   - Packaged config: has a named config intended for `$XDG_CONFIG_HOME/quickshell/<name>` or `$XDG_CONFIG_DIRS/quickshell/<name>`.
2. Read local project instructions first (`AGENTS.md`, `README`, docs, package metadata).
3. For QML edits, resolve this skill's absolute directory, keep the working
   directory at the target project, and run its `scripts/quickshell-qmllint`
   helper before treating `qmllint` import errors as real.
4. For runtime validation, load the managed config with `quickshell --path <dir-or-shell.qml>` or `quickshell --config <name>` in a real or nested compositor/session.
5. For documentation or API work, detect the project's target version from its
   package metadata, lock files, source checkout, or `quickshell --version`.
   Use the matching official versioned docs. If the project has no version
   signal, use the latest stable release and state the version selected.
6. For source builds, use CMake/Ninja and disable optional features whose dependencies are absent.

## Resources

- Read `references/linting.md` when linting QML, configuring `qmllint`/`qmlls`, or diagnosing missing `Quickshell` or `qs.*` type declarations.
- Read `references/build-and-run.md` when installing Quickshell, running a config, packaging a config, or building Quickshell from source.
- Read `references/docs-map.md` when selecting version-matched official docs pages or type references.

## Fast Commands

From the target project root, set the resolved absolute skill directory and lint
all QML under the nearest `shell.qml` root:

```sh
quickshell_skill_dir="/absolute/path/to/quickshell-skill"
"$quickshell_skill_dir/scripts/quickshell-qmllint"
```

Lint a specific config root:

```sh
"$quickshell_skill_dir/scripts/quickshell-qmllint" --root "$PWD/config/quickshell"
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

- Prefer official docs matching the project's Quickshell version. Do not apply
  current APIs to an older pinned configuration without checking compatibility.
- Do not replace runtime `qs.*` imports with relative imports only to satisfy stock `qmllint`; create lint-only module maps instead.
- Treat plain `qmllint` failures about `Quickshell` or `qs.*` imports as setup failures until explicit import roots have been supplied.
- Validate UI/runtime behavior in an actual compositor/X11/Wayland session when windows, panels, focus, IPC, or services are involved.
