---
name: pr-readiness
description: Validate changes and pull requests through merge readiness, including local gates, Codex review, CI, independent review, manual evidence, and unresolved review threads.
---

# PR readiness

Match the requested milestone: local validation, PR publication, or merge
readiness. For local work, remote gates are not applicable. Reuse a completed
review for the same unchanged diff; do not start another review merely because
this skill was loaded after the repository's review gate already passed.

## Workflow

1. Read the applicable repository instructions, requirements, accepted plan,
   and current task status.
2. Inspect the branch, worktree, untracked files, and complete diff. Separate
   unrelated pre-existing changes from the requested change.
3. Run focused checks, then the repository's complete required local gate.
   Record exact commands, results, skipped checks, and residual risk.
4. Run the built-in local Codex review after the complete local gate passes.
   Select the scope that contains the requested change:

   ```bash
   codex review --uncommitted
   codex review --base <target-branch>
   codex review --commit <sha>
   ```

   Use `--uncommitted` for staged, unstaged, and untracked changes, `--base`
   for a committed branch or PR, and `--commit` for one commit. Resolve the
   actual PR target branch rather than assuming `main`. If both committed and
   uncommitted work belong to the request, ensure both are covered; a clean
   worktree does not establish that committed changes were reviewed.

   Let the review finish. Verify every finding against the current diff, fix
   only actionable defects, add regression coverage when practical, rerun
   affected validation, and repeat review of the affected scope until no
   actionable findings remain. Explain verified false positives without
   changing correct code. A review-mode Codex instance must report findings
   directly and never launch a nested review. If Codex review is unavailable or
   fails, report it as a readiness blocker instead of substituting a third-party
   review CLI.
5. Honor standing local-commit authorization in the applicable instructions
   and commit validated, task-owned batches as requested. Local commits do not
   authorize pushes or pull requests; require authorization for those actions.
   Open a ready-for-review pull request by default. Create or
   leave it as a draft only when the user explicitly requests a draft. If known
   gates or required manual tests remain, stop before opening the pull request
   and report the blockers instead of using draft state as a holding area.
6. For a published PR, verify checks and reviews against the latest commit.
   Inspect thread-level resolution state rather than relying only on flat
   comments. For a contributor-fork PR, read
   [references/contributor-forks.md](references/contributor-forks.md).
7. For merge readiness, require an independent review of the current change.
   A completed independent Codex review can supply that evidence unless the
   repository requires an additional reviewer or human approval. The builder's
   self-review and green CI do not replace an independent review.
8. Complete and document the repository's manual-test checklist on the real
   target environment when practical.
9. Recheck the final diff, required checks, reviews, and unresolved threads
   after every push.

## CodeRabbit rate-limit fallback

When CodeRabbit explicitly reports rate limiting or exhausted review quota,
switch to built-in Codex review for the current change without waiting for the
quota reset or repeatedly retrying CodeRabbit. Record the limit as the reason
for the fallback. An ordinary pending review, authentication error, or failed
request is not proof of rate limiting, and missing output is not a clean review.

1. Inspect existing CodeRabbit feedback and retain all unresolved actionable
   findings. Switching reviewers does not dismiss them.
2. Review the complete requested change with the scope from step 4 above.
   For a PR, fetch its actual target and head, confirm the checkout matches the
   intended head, and use `codex review --base <target-branch>`. Review any
   uncommitted fixes as well. Do not use an empty `--uncommitted` review as
   evidence for a committed PR. Reuse an already completed independent Codex
   review only when it covers the same full, unchanged diff.
3. For an authorized fix loop, verify findings, fix actionable defects, rerun
   affected validation, and repeat Codex review until a completed review finds
   no actionable issues. Preserve the existing commit, push, and thread-action
   authorization. A review-only request reports findings without applying fixes.
   A failed, interrupted, or unavailable Codex review remains a blocker.
4. Before announcing merge readiness, confirm the reviewed content is the
   latest remote PR head, required checks and approvals pass, prior actionable
   feedback is addressed, required conversations are resolved, and all other
   hard gates below pass. Unpushed fixes are local readiness only.

A clean independent Codex review satisfies the reviewer fallback; do not wait
for another optional CodeRabbit run. It cannot satisfy a CodeRabbit-specific
required check or approval enforced by branch protection or repository policy.
Report that remaining gate rather than bypassing it or claiming merge readiness.
Otherwise, announce "merge ready" to the user with the verified PR head SHA and
state that Codex review replaced rate-limited CodeRabbit. This does not authorize
posting a remote comment or performing the merge.

## Hard gates

Do not report a pull request as ready to merge while any of these remain:

- required CI is failed, pending, missing, or attached to an older commit
- actionable review feedback is unresolved
- the Codex review loop or a required independent review is incomplete
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
