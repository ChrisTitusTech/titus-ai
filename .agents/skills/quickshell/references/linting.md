# Quickshell QML Linting

Use this reference for `qmllint`, `qmlls`, `qml-language-server`, and missing QML type declarations.

## Why Plain qmllint Fails

Stock `qmllint` often does not discover Quickshell modules automatically. It needs explicit QML import roots that contain Qt's modules, Quickshell's `qmldir` files, and generated `.qmltypes` files. Quickshell `qs.<path>` imports are rooted at the directory containing `shell.qml`; stock Qt tooling may also need a lint-only `qmldir` map for each local `qs.*` module.

Official docs:
- Quickshell v0.2.1 QML imports: https://quickshell.org/docs/v0.2.1/guide/qml-language/
- Installation and editor setup: https://quickshell.org/docs/v0.2.1/guide/install-setup/

## Preferred Command

Run the bundled helper from a Quickshell config project:

```sh
/home/titus/github/titus-ai/.agents/skills/quickshell/scripts/quickshell-qmllint
```

It:
- finds `qmllint-qt6`, `qmllint`, or `/usr/lib*/qt6/bin/qmllint`;
- adds common Qt/Quickshell QML roots such as `/usr/lib64/qt6/qml`, `/usr/lib/qt6/qml`, and `/usr/lib/qt6/qml`;
- discovers `qs.*` imports in the target files;
- creates temporary `qmldir` files and symlinks for local QML types;
- sets `QMLLS_BUILD_DIRS` and `QML_IMPORT_PATH` for the lint process.

## Manual Pattern

Use this if the helper needs adaptation:

```sh
QMLLS_BUILD_DIRS="/usr/lib64/qt6/qml:/usr/lib/qt6/qml" \
QML_IMPORT_PATH="$PWD/config/quickshell" \
qmllint-qt6 \
  -I /usr/lib64/qt6/qml \
  -I /usr/lib/qt6/qml \
  -I "$tmp_module_root" \
  -I config/quickshell \
  config/quickshell/shell.qml
```

For Nix, use the store paths for `qtdeclarative` and `quickshell`:

```sh
export QMLLS_BUILD_DIRS="${qtdeclarative}/lib/qt-6/qml:${quickshell}/lib/qt-6/qml"
export QML_IMPORT_PATH="$PWD"
```

## Local qs.* Module Maps

For a file that imports `qs.core`, create a temporary tree like:

```text
$tmp/qs/core/qmldir
$tmp/qs/core/Theme.qml -> $project/core/Theme.qml
$tmp/qs/core/ShellButton.qml -> $project/core/ShellButton.qml
```

The `qmldir` entries should mark files with `pragma Singleton` as singletons:

```text
module qs.core
singleton Theme 1.0 Theme.qml
ShellButton 1.0 ShellButton.qml
```

Do not commit this lint-only tree unless the project intentionally wants persistent Qt module metadata.

## LSP Notes

Quickshell v0.2.1 docs recommend `qmlls`, but note it has caveats and cannot provide all Quickshell type documentation. In Codex projects, prefer `qml-language-server` from `cushycush/qml-language-server` when the repo already standardizes on it, and still keep `QMLLS_BUILD_DIRS`/`QML_IMPORT_PATH` aligned with the lint import roots.
