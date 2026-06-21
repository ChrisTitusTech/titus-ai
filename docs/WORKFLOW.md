# AI development workflow

## Project file roles

| File | Purpose |
| --- | --- |
| `AGENTS.md` | Durable instructions Codex loads automatically |
| `SPEC.md` | Product and technical requirements |
| `ROADMAP.md` | Milestones and longer-term direction |
| `TASKS.md` | Current actionable work and status |
| `.agents/skills/` | Reusable workflows Codex can invoke |
| `docs/` | Reference material loaded only when requested or linked |

## Recommended workflow

1. Put stable working conventions in `AGENTS.md`.
2. Capture requirements in `SPEC.md`.
3. Derive milestones in `ROADMAP.md`.
4. Break the next milestone into testable items in `TASKS.md`.
5. Invoke the relevant skill or ask Codex to select one.
6. Implement one reviewable phase.
7. Run the validation defined before implementation.
8. Update task status only after validation.

## Documentation rule

Do not rely on Codex discovering arbitrary documents by filename. Reference
supporting documents from `AGENTS.md`, a skill, or the task prompt.
