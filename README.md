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
