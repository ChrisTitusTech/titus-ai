# Project status

Last updated: YYYY-MM-DD

Living operational status for humans and agents. Keep this distinct from
`TASKS.md` (actionable work items). In **public** repositories, use placeholders
only — never real deploy hosts, app IDs, entitlement IDs, or secret values.
Private product repos may hold more concrete ops detail; do not copy that into
public starters.

## Product (locked)

One or two sentences describing the locked product model.

## Shipped

| Area | Status |
| --- | --- |
| YOUR_AREA | Done / In progress / Deferred |

## Blocked / next (operator)

1. **Next release** — Describe the next ship goal without private hostnames.
2. **Keys / dashboards** — List human actions needed (credential *names*, not
   values). Stop agent work that depends on them until provided.
3. **Batch expensive builds** — Do not burn paid CI/build/submit quotas
   mid-feature; run one batched build after keys and code are ready.

## Build gate

| Check | Status |
| --- | --- |
| Production flags safe | Pass / Fail / Pending |
| Required env vars named (not valued) | Pass / Fail / Pending |
| Local smoke | Pass / Fail / Pending |

## Deployed

| Piece | Status |
| --- | --- |
| YOUR_API | Placeholder URL such as `https://example.com/api` |
| YOUR_WEB | Placeholder URL such as `https://example.com` |

## Secrets (never commit values)

| Secret | Where it lives (location only) |
| --- | --- |
| YOUR_API_KEY | Dashboard / secret store / local gitignored file name |
| YOUR_DB_URL | Dashboard / secret store / local gitignored file name |

Local untracked examples (names only): `.env`, `.dev.vars`.
