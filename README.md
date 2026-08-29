# narehood-ai

Public portable coding-agent configuration, reusable skills, and project
planning templates. **T3 Code** is the control surface. **Codex**, **Claude
Code**, and **Cursor** are first-class providers it can run. Shared skills
follow the Agent Skills standard so all three load the same files, in T3 Code
or in each provider's own CLI.

This repository is public. Tracked files must stay free of credentials, personal
absolute paths, pairing tokens, and private product operations.

## Use with T3 Code

Open this checkout as a T3 Code project at the repository root. Choose Codex,
Claude, or Cursor as the provider. Root `AGENTS.md` is loaded by the provider.
Skills under `.agents/skills/` appear in the composer `$` picker when the
thread cwd is the repo root.

```text
$linux-sysadmin diagnose this service failure
$python-ai add an Ollama-backed model provider
$rust-cli add a new subcommand
```

See [docs/T3CODE_LAYOUT.md](docs/T3CODE_LAYOUT.md). Provider-specific discovery:

- Codex: [docs/CODEX_LAYOUT.md](docs/CODEX_LAYOUT.md)
- Claude Code: [docs/CLAUDE_LAYOUT.md](docs/CLAUDE_LAYOUT.md)
- Cursor: [docs/CURSOR_LAYOUT.md](docs/CURSOR_LAYOUT.md)

Project planning templates live under
`.agents/skills/ai-project-manager/assets/project-docs/` (`AGENTS.md`,
`SPEC.md`, `ROADMAP.md`, `TASKS.md`, and optional `STATUS.md`). Adapt them to
each project; keep placeholders out of production docs.

## Install skills (and optional Codex home)

The installer links `.agents/skills/` into `~/.agents/skills/` so the same
skills are available in other T3 Code projects. It can also install portable
Codex home files when you use the Codex provider.

Preview and install on Linux or macOS:

```bash
./scripts/install.sh --dry-run
./scripts/install.sh
```

On Windows:

```powershell
.\scripts\install.ps1 -DryRun
.\scripts\install.ps1
```

Restart Codex after installation. Existing managed files are backed up under
`~/.codex/backups/`. Credentials, sessions, history, caches, and plugins are
not changed by default.

The installer manages:

- `codex-home/` configuration and rules in `~/.codex/`
- `.agents/skills/` into `~/.agents/skills/`

### Trust GitHub projects

Every Codex installation renders `~/.codex/config.toml` with trusted-project
entries for that user's `~/github` directory and every Git worktree found
recursively beneath it. The committed sample `codex-home/config.toml` does not
contain personal absolute paths; the installer adds machine-local trusts at
install time.

Rerun the installer after creating or cloning repositories so new worktrees are
added. Common dependency and build directories are skipped during discovery.

### Install recommended plugins

[Codex plugin](https://learn.chatgpt.com/docs/plugins) installation is opt-in
because plugins can add instructions, hooks, and connections to external
services. Preview or install the repository's selected plugins on Linux or
macOS with:

```bash
./scripts/install.sh --dry-run --plugins
./scripts/install.sh --plugins
```

On Windows:

```powershell
.\scripts\install.ps1 -DryRun -Plugins
.\scripts\install.ps1 -Plugins
```

The selected plugin IDs live in `codex-plugins.txt`. The initial selection is
`superpowers@openai-curated`. Start a new Codex session after installation so
its skills become available. The managed global instructions tell Codex to
skip the full Superpowers methodology for trivial, low-risk edits.

For GitHub-heavy projects, the broader priority order is:

1. **Superpowers plugin** for planning, TDD, debugging, and delivery workflows.
2. **GitHub plugin** for pull requests, issues, reviews, and repository
   operations.
3. **Context7 MCP server** for current framework and dependency documentation.
4. **Playwright or Chrome DevTools MCP server** for frontend testing and
   browser debugging.
5. **Codex Security plugin** for vulnerability analysis and remediation.
6. **Sentry plugin** for production debugging.

Only the entries in `codex-plugins.txt` are installed by `--plugins`. Context7,
Playwright, and Chrome DevTools are
[MCP servers](https://learn.chatgpt.com/docs/extend/mcp) rather than plugins and
require separate configuration. GitHub, Codex Security, and Sentry remain
opt-in until they are added to the manifest because they can require service
authorization or project-specific setup.

## Use skills

In T3 Code, type `$` in the composer to pick a skill. Providers may also
auto-select from skill descriptions.

```text
$linux-sysadmin diagnose this service failure
$python-ai add an Ollama-backed model provider
$rust-cli add a new subcommand
```

## AI development workflow

The reusable workflow separates planning from pull-request readiness:

- `$ai-project-manager` reads or creates `AGENTS.md`, `SPEC.md`, `ROADMAP.md`,
  `TASKS.md`, and optional `STATUS.md`, pauses at plan-approval boundaries, and
  executes one reviewable phase at a time.
- `$pr-readiness` validates the final diff, runs `codex review --uncommitted`
  until no actionable findings remain, records manual testing, and verifies CI
  and review state before merge.

See [docs/WORKFLOW.md](docs/WORKFLOW.md) for the complete lifecycle.

## Local models (Codex)

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

The validation includes an isolated Linux or macOS installer integration test.
GitHub Actions also exercises the PowerShell installer on Windows and runs
dependency review for pull requests.

## Repository layout

- `AGENTS.md`: instructions for maintaining this repository
- `SPEC.md`, `ROADMAP.md`, and `TASKS.md`: requirements, phase order, and
  validated task status
- `.agents/skills/`: reusable Agent Skills for Codex, Claude, and Cursor
- `CLAUDE.md`: Claude Code router to `AGENTS.md`
- `codex-plugins.txt`: opt-in Codex plugin selections
- `codex-home/`: portable Codex global instructions, configuration, profiles,
  and rules
- `docs/`: reference documentation loaded only when explicitly requested
- `scripts/`: installation and validation

See [docs/T3CODE_LAYOUT.md](docs/T3CODE_LAYOUT.md),
[docs/CODEX_LAYOUT.md](docs/CODEX_LAYOUT.md),
[docs/CLAUDE_LAYOUT.md](docs/CLAUDE_LAYOUT.md), and
[docs/CURSOR_LAYOUT.md](docs/CURSOR_LAYOUT.md).
