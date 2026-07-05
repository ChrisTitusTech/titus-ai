# Build, Run, and Package Quickshell

Use this reference for Quickshell installs, config validation, packaged configs, and source builds.

Official docs:
- Installation and setup: https://quickshell.org/docs/v0.2.1/guide/install-setup/
- Distributing configurations: https://quickshell.org/docs/v0.2.1/guide/distribution/
- Source build instructions: https://git.outfoxxed.me/quickshell/quickshell/src/branch/master/BUILD.md

## Install Tooling

Package names vary by distro:

```sh
# Arch
pacman -S quickshell qt6-declarative

# Fedora/RHEL family
dnf install quickshell qt6-qtdeclarative-devel

# Debian family
apt install quickshell qt6-declarative-dev-tools
```

Optional runtime modules depend on the project, commonly SVG/image formats, multimedia, PipeWire, status notifier, MPRIS, PAM, Polkit, Wayland, X11, and compositor-specific integrations.

## Run Configs

Run a config directory or a specific `shell.qml`:

```sh
quickshell --path ./config/quickshell --no-duplicate
quickshell --path ./shell.qml --no-duplicate
```

Run a named config installed under an XDG config root:

```sh
quickshell --config <name> --no-duplicate
```

Quickshell discovers named configs at `$XDG_CONFIG_HOME/quickshell/<name>/shell.qml` or `$XDG_CONFIG_DIRS/quickshell/<name>/shell.qml`. For dotfiles intended for broad use, prefer named config directories over the bare `$XDG_CONFIG_HOME/quickshell` directory.

## Runtime Validation

- Use a real or nested compositor/session for `PanelWindow`, focus, layer shell, tray, services, IPC, and screen-dependent code.
- Headless/offscreen starts can catch some syntax issues but may fail with messages like "No PanelWindow backend loaded"; do not treat that as proof the config is broken.
- Check `quickshell list`, `quickshell log`, and `quickshell ipc` when a project defines IPC.

## Source Builds

Quickshell source builds use CMake and Ninja:

```sh
cmake -GNinja -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
cmake --install build
```

Important source-build rules from upstream:
- Quickshell depends on private Qt APIs and must be rebuilt against each Qt release to avoid ABI mismatches.
- At least Qt 6.6 is required.
- Features are enabled by default; disable optional features when dependencies are missing.
- Packaging should set a useful `DISTRIBUTOR` CMake flag.
- QML tooling metadata install paths can be controlled with `INSTALL_QML_PREFIX` or `INSTALL_QMLDIR`.

Common feature flags:

```sh
-DCRASH_HANDLER=OFF
-DUSE_JEMALLOC=OFF
-DWAYLAND=OFF
-DX11=OFF
-DSERVICE_PIPEWIRE=OFF
-DSERVICE_STATUS_NOTIFIER=OFF
-DSERVICE_MPRIS=OFF
-DSERVICE_PAM=OFF
-DSERVICE_POLKIT=OFF
-DHYPRLAND=OFF
-DI3=OFF
```

Use only the flags that match the target environment and missing dependencies.
