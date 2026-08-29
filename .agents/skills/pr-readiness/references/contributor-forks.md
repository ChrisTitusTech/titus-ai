# Contributor-fork pull requests

Use this reference when a pull request's head branch belongs to a fork rather
than the base repository.

## Synchronize safely

1. Record the base repository and branch, head repository and branch, and
   current pull-request commit.
2. Fetch the current base branch and the actual head branch before evaluating
   mergeability or changing the branch.
3. Check out the real head branch and update it using the repository's accepted
   merge or rebase policy. Do not manufacture a similarly named branch in the
   base repository.
4. Compare the resulting branch with the fetched base branch and confirm that
   unrelated base changes are not presented as pull-request changes.
5. After pushing, verify the pull request now points at the expected commit and
   rerun required checks against that commit.

## Review threads

Query thread-level review state against the base repository, because the pull
request belongs to the base repository even when its head branch belongs to a
fork. When using GitHub GraphQL, pass the base owner, base repository, and pull
request number explicitly when reading `reviewThreads`.

After addressing feedback, push the authorized changes, re-query the base
repository, and resolve only the threads whose actionable request is fully
satisfied. Flat comments alone do not prove that a thread is resolved.
