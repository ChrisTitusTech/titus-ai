# Narehood AI roadmap

## Phase 1: Portable Codex foundation

Status: Complete

### Outcome

Portable global instructions, configuration, rules, local-model profiles, and
skills install without replacing private Codex runtime state.

### Exit criteria

- Linux, macOS, and Windows installers support preview and timestamped backups.
- Repository validation rejects private runtime state and malformed portable
  configuration.

## Phase 2: Workflow alignment

Status: Complete

### Outcome

The repository and reusable skills encode the complete planning, implementation,
review, manual-testing, and merge workflow.

### Included work

- Add repository planning documents and reusable project templates.
- Separate project planning from pull-request readiness.
- Add cross-platform installer integration tests and pull-request CI.
- Add Dependabot coverage, dependency review, and PR evidence prompts.
- Align Claude routing and workflow documentation.
- Use the built-in Codex review loop for local pull-request readiness checks.
- Add explicit, cross-platform installation for selected Codex plugins without
  making ordinary installs mutate plugin state.
- Render exact trusted-project entries for every Git worktree beneath the
  current user's `~/github` directory.

### Risks

- Windows symbolic-link behavior can differ by permissions and host policy.
- Required GitHub checks cannot be configured until their final names exist on
  the default branch.

### Exit criteria

- Local validation and skill validation pass.
- Linux installer integration tests pass locally.
- Windows installer integration tests pass in CI.
- The final diff contains only workflow-alignment changes.

## Phase 3: Enforced repository governance

Status: Planned

### Outcome

GitHub settings enforce the review and validation gates documented by the
repository.

### Included work

- Require pull requests and successful validation checks.
- Require conversation resolution.
- Require an independent approval when repository ownership makes that
  practical.
- Confirm secret scanning, push protection, Dependabot, and dependency review.

### Exit criteria

- The repository ruleset protects the default branch.
- Required checks run against the latest pull-request commit.
- The documented merge gate matches GitHub settings.

## Phase 4: Cursor-first + Narehood rebrand

Status: Complete

### Outcome

The public repository is branded Narehood AI, shared skills and planning
templates encode evolved policy patterns, personal absolute paths are stripped
from sample configuration, and Codex install remains available without private
product leakage.

### Included work

- Complete Narehood AI / narehood-ai rebrand across docs and installers.
- Remove personal absolute paths from committed sample configuration.
- Strengthen project-doc templates and add an optional STATUS.md template.
- Document Cursor discovery in `docs/CURSOR_LAYOUT.md`.
- Soften Codex-only skill trigger wording; align global PR and key-block rules.

### Risks

- Installer tests must stay in sync with renamed backup and temp prefixes.
- Public visibility requires continuous vigilance against identity or product
  leaks in examples.

### Exit criteria

- Local validation passes with the new brand prefixes.
- Grep finds no legacy brand strings or personal home paths in tracked files.
- Templates use placeholders only.

## Phase 5: T3 Code control surface

Status: Complete

### Outcome

T3 Code is the documented control surface. Codex, Claude Code, and Cursor are
first-class providers. Canonical skills live in `.agents/skills/` so the `$`
picker and each provider can load them.

### Included work

- Document T3 Code project-root, skill picker, and public-repo boundaries.
- Treat Codex, Claude Code, and Cursor as first-class providers with shared
  `.agents/skills/` and provider layout docs.
- Keep `.agents/skills/` as the only skill tree; do not duplicate into
  `.claude/skills` or `.cursor/skills`.
- Ignore local `.t3/` userdata.

### Risks

- T3 Code skill discovery is cwd-scoped; opening a parent directory hides
  repo-local skills.
- Claude pickers in some T3 Code builds omit `.agents/skills` even when the
  skill is still invocable by name.

### Exit criteria

- Docs name T3 Code as the control surface, Codex/Claude/Cursor as first-class
  providers, and `.agents/skills/` as canonical.
- Validation requires `docs/T3CODE_LAYOUT.md` and `docs/CLAUDE_LAYOUT.md`.
- Public-repo leak checks still pass.

