# titus-ai

Portable Codex configuration, rules, and reusable skills.

## Install

Preview and install:

```bash
./scripts/install.sh --dry-run
./scripts/install.sh
```

Restart Codex after installation. Existing managed files are backed up under
`~/.codex/backups/`. Credentials, sessions, history, caches, and plugins are
not changed.

The installer links:

- `codex-home/` configuration and rules into `~/.codex/`
- `.agents/skills/` into `~/.agents/skills/`

### Install RTK

[RTK](https://github.com/rtk-ai/rtk) is an optional Rust CLI proxy that
compresses verbose command output before it reaches Codex's context window.
Install it directly from GitHub:

```bash
cargo install --git https://github.com/rtk-ai/rtk
```

Do not use `cargo install rtk`. The `rtk` package name on crates.io belongs to
a different project.

Ensure Cargo's binary directory is on `PATH`:

```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

Then verify both the binary and its output-savings command:

```bash
rtk --version
rtk gain
```

The managed `codex-home/AGENTS.md` already instructs Codex to prefix supported
commands with `rtk`, so no separate `rtk init` step is required after running
this repository's installer. Codex falls back to the raw command when RTK is
missing or rejects an unsupported command or flag.

## Use

Start Codex normally to use the default configuration:

```bash
codex
```

Invoke a skill explicitly when needed:

```text
$linux-sysadmin diagnose this service failure
$python-ai add an Ollama-backed model provider
$rust-cli add a new subcommand
```

Codex can also select skills automatically based on their descriptions.

## Local models

Local model profiles are optional and do not change the default provider.

Ollama:

```bash
ollama pull qwen3-coder
codex --profile ollama
```

llama.cpp:

```bash
llama-server --model /path/to/model.gguf --jinja --port 8080
codex --profile llamacpp
```

Override either profile's model with `--model`:

```bash
codex --profile ollama --model another-model
codex --profile llamacpp --model another-model
```

Local models need reliable structured tool calling for effective Codex use.
The llama.cpp profile expects a Responses-compatible endpoint at
`http://127.0.0.1:8080/v1`.

## Validate

```bash
./scripts/validate.sh
```

## Repository layout

- `AGENTS.md`: instructions for maintaining this repository
- `.agents/skills/`: reusable skills
- `codex-home/`: portable global instructions, configuration, profiles, and rules
- `docs/`: reference documentation loaded only when explicitly requested
- `scripts/`: installation and validation

See [docs/CODEX_LAYOUT.md](docs/CODEX_LAYOUT.md) for detailed discovery and
configuration behavior.
