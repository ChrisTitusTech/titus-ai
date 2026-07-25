---
name: pr-readiness
description: Validate local or published changes from final diff through pull-request merge readiness, including project gates, local CodeRabbit review, CI, independent review, thread resolution, and manual-test evidence. Use when Codex is asked to review uncommitted work, prepare or open a pull request, check whether a PR is ready, address final review feedback, or verify merge readiness.
---

# PR readiness

## Workflow

1. Read the applicable repository instructions, requirements, accepted plan,
   and current task status.
2. Inspect the branch, worktree, untracked files, and complete diff. Separate
   unrelated pre-existing changes from the requested change.
3. Run focused checks, then the repository's complete required local gate.
   Record exact commands, results, skipped checks, and residual risk.
4. Run the local CodeRabbit review when the CLI is available:

   ```bash
   coderabbit review --agent --uncommitted --include-untracked
   ```

   Let the review finish. Fix actionable defects, add regression coverage when
   practical, rerun affected validation, and repeat the review. Explain verified
   false positives without changing correct code.
5. Commit, push, or open a pull request only when the user authorized those
   state changes. Keep the PR draft while known gates or manual tests remain.
6. For a published PR, verify checks and reviews against the latest commit.
   Inspect thread-level resolution state rather than relying only on flat
   comments.
7. Require a fresh independent review. The builder's self-review and a green CI
   run do not replace it.
8. Complete and document the repository's manual-test checklist on the real
   target environment when practical.
9. Recheck the final diff, required checks, reviews, and unresolved threads
   after every push.

## Hard gates

Do not report a pull request as ready to merge while any of these remain:

- required CI is failed, pending, missing, or attached to an older commit
- actionable review feedback is unresolved
- a required independent or CodeRabbit review is incomplete
- required manual testing is incomplete or undocumented
- the branch contains unrelated changes, secrets, debug code, or generated junk
- planning documents no longer match the implementation

Do not perform the merge unless the user explicitly requests it.
Never fabricate commit hashes, review state, commands, or test results. For
uncommitted work, report `HEAD` together with worktree and untracked-file state.
When no pull request exists, report remote checks, reviews, threads, and PR
status as not applicable.

## Pull request evidence

Ensure the PR records:

- the problem and implemented approach
- important decisions and deviations from the plan
- exact automated checks that passed
- manual tests and their environment
- screenshots or recordings for visible changes
- known limitations, skipped validation, and follow-up work

## Final report

Report `HEAD`, worktree and untracked-file state, changed-file scope, local
checks, manual-test state, and remaining blockers. For a published pull request,
also report its latest commit, remote checks, review state, unresolved threads,
and whether it is draft, review-ready, or merge-ready.
