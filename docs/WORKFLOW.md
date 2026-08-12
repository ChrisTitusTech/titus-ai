# AI development workflow

## Project file roles

| File | Purpose |
| --- | --- |
| `AGENTS.md` | Durable instructions the coding agent loads automatically |
| `SPEC.md` | Product and technical requirements and acceptance criteria |
| `ROADMAP.md` | Ordered outcomes, dependencies, risks, and exit criteria |
| `TASKS.md` | Current actionable work and validated status |
| `.agents/skills/` | Reusable workflows Codex can invoke |
| `docs/` | Reference material loaded only when requested or linked |

## Complete lifecycle

1. Install this repository's global instructions, configuration, rules, and
   reusable skills.
2. Inspect the real repository, branch, worktree, architecture, runtime paths,
   and existing validation.
3. Put durable project conventions and boundaries in `AGENTS.md`.
4. Define observable requirements, non-goals, and acceptance criteria in
   `SPEC.md`.
5. Order outcomes, risks, exit criteria, and validation in `ROADMAP.md`.
6. Break the current phase into reviewable work in `TASKS.md`.
7. Use `$ai-project-manager` to produce a requirement-linked plan with automated
   and manual validation.
8. Stop for plan approval when the user reserved that checkpoint.
9. Implement one approved phase, run focused checks, and inspect the diff.
10. Run the complete local gate and update task status only after it passes.
11. Use `$pr-readiness` to run the built-in Codex review:

    ```bash
    codex review --uncommitted
    ```

12. Verify every finding against the current diff. Fix only actionable defects,
    rerun affected validation, and repeat `codex review --uncommitted` until no
    actionable findings remain. Document verified false positives without
    changing correct code. A review-mode Codex instance reports findings
    directly and must not launch another nested review.
13. Commit the focused change, push it, and open a ready-for-review pull request
    only when authorized. Create or leave a draft only when the user explicitly
    requests one. If known gates remain, stop before opening the pull request
    and report the blockers.
14. Require a completed Codex review loop, CI validation, applicable security
    checks, and a fresh independent review on the latest commit.
15. Fix or explain every review item, resolve completed threads, and repeat the
    checks after every push.
16. Complete and document required manual testing on the real target
    environment.
17. Merge only after the final diff, planning documents, CI, security checks,
    reviews, threads, and manual tests are clean.

## Security baseline

Establish the security checks that apply to the repository instead of adding
irrelevant gates:

- Enable secret scanning and push protection where available.
- Configure Dependabot for every package ecosystem and GitHub Actions.
- Run dependency review when dependency manifests can change.
- Configure CodeQL for every language in the repository that CodeQL supports.
- Document accepted exceptions with a reason, owner, and review date.

## Required pull request evidence

Record the problem, approach, important decisions, exact automated checks,
manual tests, screenshots for visible changes, limitations, skipped validation,
and follow-up work.

## Documentation rule

Do not rely on a coding agent discovering arbitrary documents by filename.
Reference supporting documents from `AGENTS.md`, a selected skill, or the task
prompt. Keep the specification, roadmap, tasks, and implementation synchronized
when requirements or architecture change.
