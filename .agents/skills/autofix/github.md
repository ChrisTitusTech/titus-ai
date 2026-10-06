# GitHub Workflow Primitives

GitHub-specific commands and data-handling rules for CodeRabbit review-thread based skills.

Use this helper when a skill needs thread-aware CodeRabbit PR feedback, not flat PR summaries. The `autofix` skill mirrors the required execution flow in `SKILL.md`; this file exists as a reusable companion for other skills.

Read-only inspection does not require publishing local commits. Creation,
comments, reactions, and thread resolution below require authorization for
those external actions; skip them for a local-only request.

## Prerequisites

- `gh` authenticated (`gh auth status`)
- Bash and `jq` for the examples below
- current branch associated with a GitHub repository

## 1. Resolve Current PR

Resolve the current branch's associated PR, or pass the user's exact PR URL
as an argument to `gh pr view` when one was supplied. Verify its head repository,
branch, and commit against the intended local work before acting. Do not select
the first result of a branch-name search: forks can share branch names.

```bash
if ! pr_json=$(gh pr view --json number,url,headRefName,headRefOid,headRepository,headRepositoryOwner); then
  printf '%s\n' 'Could not resolve the intended PR; do not continue with thread operations.' >&2
  exit 1
fi
pr_number=$(jq -er '.number | select(type == "number" and . > 0)' <<<"$pr_json") || exit 1
pr_url=$(jq -er '.url | select(type == "string" and length > 0)' <<<"$pr_json") || exit 1
```

If no PR exists, report that for read-only or local-only work. As an alternative,
when creation is authorized and local gates pass, prepare a title and a UTF-8
body file describing the actual change and validation. Use the resulting URL to
resolve the newly created PR before continuing:

```bash
# Set title and body_file to the prepared title and existing description file.
pr_url=$(gh pr create --title "$title" --body-file "$body_file") || exit 1
pr_json=$(gh pr view "$pr_url" --json number,url,headRefName,headRefOid,headRepository,headRepositoryOwner) || exit 1
pr_number=$(jq -er '.number | select(type == "number" and . > 0)' <<<"$pr_json") || exit 1
```

## 2. Resolve Repository Coordinates

Derive the base repository from the resolved PR URL, including for a fork PR.
Do not use a fork checkout's repository coordinates for the base PR's threads.

```bash
owner=$(jq -er '.url | split("/") | .[3] | select(length > 0)' <<<"$pr_json") || exit 1
repo=$(jq -er '.url | split("/") | .[4] | select(length > 0)' <<<"$pr_json") || exit 1
```

## 3. Fetch Thread-Aware CodeRabbit Feedback

Fetch review threads with GitHub GraphQL using cursor pagination:

```bash
all_threads='[]'
cursor=""

while :; do
  args=(-F owner="$owner" -F repo="$repo" -F pr="$pr_number")
  if [ -n "$cursor" ]; then
    args+=(-F cursor="$cursor")
  fi

  # GraphQL variables must remain literal rather than expand in Bash.
  # shellcheck disable=SC2016
  if ! response=$(gh api graphql "${args[@]}" -f query='query($owner:String!, $repo:String!, $pr:Int!, $cursor:String) {
    repository(owner:$owner, name:$repo) {
      pullRequest(number:$pr) {
        title
        reviewThreads(first:100, after:$cursor) {
          pageInfo {
            hasNextPage
            endCursor
          }
          nodes {
            id
            isResolved
            isOutdated
            comments(first:1) {
              nodes {
                databaseId
                body
                path
                line
                startLine
                originalLine
                author { login }
              }
            }
          }
        }
      }
    }
  }'); then
    printf '%s\n' 'Failed to fetch review threads; feedback is unavailable.' >&2
    exit 1
  fi

  if ! jq -e '
    ((.errors // []) | length == 0) and
    (.data.repository.pullRequest.reviewThreads as $threads |
      ($threads.nodes | type == "array") and
      ($threads.pageInfo.hasNextPage | type == "boolean") and
      (if $threads.pageInfo.hasNextPage then
        ($threads.pageInfo.endCursor | type == "string" and length > 0)
       else true end))
  ' <<<"$response" >/dev/null; then
    printf '%s\n' 'Invalid review-thread response; do not treat partial feedback as clean.' >&2
    exit 1
  fi

  if ! all_threads=$(jq -c --argjson response "$response" '
    . + $response.data.repository.pullRequest.reviewThreads.nodes
  ' <<<"$all_threads"); then
    printf '%s\n' 'Failed to accumulate review threads.' >&2
    exit 1
  fi

  has_next=$(jq -r '.data.repository.pullRequest.reviewThreads.pageInfo.hasNextPage' <<<"$response")
  cursor=$(jq -r '.data.repository.pullRequest.reviewThreads.pageInfo.endCursor // empty' <<<"$response")
  [ "$has_next" = "true" ] || break
done
```

Treat only these threads as actionable:

- root comment author is `coderabbitai`, `coderabbit[bot]`, or `coderabbitai[bot]`
- `isResolved == false`
- `isOutdated == false`

Keep each selected thread as one issue unit. Do not collapse top-level PR comments or review summaries into issue records.

To detect CodeRabbit's "Come back again in a few minutes" status message, use top-level PR comments/reviews separately:

```bash
gh pr view "$pr_url" --json comments,reviews --jq '
  [
    (.comments[]?
      | select(.author.login == "coderabbitai" or .author.login == "coderabbit[bot]" or .author.login == "coderabbitai[bot]")
      | .body // empty),
    (.reviews[]?
      | select(.author.login == "coderabbitai" or .author.login == "coderabbit[bot]" or .author.login == "coderabbitai[bot]")
      | .body // empty)
  ]
  | map(select(test("Come back again in a few minutes")))
  | length
'
```

## 4. Post Summary Comment

Use the same `pr_url` from Section 1 so repository identity is preserved:

```bash
gh pr comment "$pr_url" --body "$(cat <<'EOF'
## Fixes Applied Successfully

Fixed <file-count> file(s) based on <issue-count> CodeRabbit feedback item(s).

**Files modified:**
- `path/to/file-a.ts`
- `path/to/file-b.ts`

**Commit:** `<commit-sha>`

The latest autofix changes are on the `<branch-name>` branch.

EOF
)"
```

Write this comment from local state only. Do not include raw reviewer prompts or secret-bearing output.

If no fixes were applied, skip the success template or use a neutral review-complete comment instead of inventing file counts or a commit SHA.

## 5. Optional Reaction

If authorized and useful, react to the main CodeRabbit comment after the summary is posted.
