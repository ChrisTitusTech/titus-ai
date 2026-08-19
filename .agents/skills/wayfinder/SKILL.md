---
name: wayfinder
description: Build and maintain a local three-file planning set consisting of SPEC.md, MAP.md, and ANSWERS.md for large, unclear, or multi-session work. Use only when explicitly invoked with /wayfinder or $wayfinder to chart an idea, resolve planning questions, or refresh an existing wayfinder plan; do not invoke automatically for ordinary planning or implementation requests.
---

# Wayfinder

Turn a foggy destination into three durable local planning files. Stay in
planning mode: investigate and decide, but do not implement the destination
unless the user separately authorizes implementation.

## Files

Create or maintain these files in the repository root unless the user names a
different planning directory:

- `SPEC.md` is the current agreed destination: goals, scope, requirements,
  constraints, and success criteria.
- `MAP.md` is the live route: unresolved questions, dependencies, the current
  frontier, fog that is not precise enough to ask yet, and completed decisions.
- `ANSWERS.md` is the decision record: the answer, rationale, evidence, and
  consequences for each resolved question.

Use the templates under `assets/templates/` as structural starting points.
Adapt them to the project, replace all example content, and remove all
instructional comments from the created planning files.

Keep each fact in one canonical place:

- Put settled requirements and boundaries in `SPEC.md`.
- Put unresolved questions and their status in `MAP.md`.
- Put decision history and supporting detail in `ANSWERS.md`.
- Let `MAP.md` link to completed entries in `ANSWERS.md` instead of repeating
  their detail.

## Workflow

1. Read applicable `AGENTS.md` files, inspect existing changes, and locate any
   existing `SPEC.md`, `MAP.md`, and `ANSWERS.md`. Preserve useful content and
   unrelated user edits; never blindly replace an existing planning file.
2. Identify the invocation mode:
   - **Chart** when the user brings a new idea or the three files do not exist.
   - **Advance** when the files exist and the user wants to continue planning.
   - **Refresh** when new evidence changes the destination, scope, or route.
3. Name the destination before mapping the route. Ask focused questions until
   the intended outcome and stopping point are clear. Do not invent missing
   requirements.
4. Explore breadth-first. Capture precise unanswered decisions as named
   questions in `MAP.md`; capture hazy but in-scope areas under `Fog` until they
   can be phrased as questions. Put work beyond the destination in the
   `Out of scope` section of `SPEC.md`.
5. Give each question a stable `Q-###` identifier, a descriptive name, and any
   dependency on another question. Use names in narration; identifiers exist
   only for stable links and editing.
6. Resolve one coherent question at a time unless the user has already supplied
   a set of inseparable answers. Use repository evidence or current primary
   sources when the answer depends on facts. Record uncertainty explicitly.
7. When a question is resolved:
   - Add its full decision record to `ANSWERS.md`.
   - Update `SPEC.md` with any newly settled requirement or boundary.
   - Move the question from `Frontier` or `Blocked` to `Completed` in `MAP.md`
     and link its name to the answer entry.
   - Add newly exposed questions, update dependencies, and promote any fog that
     has become precise.
8. Stop when the requested planning pass is complete. Summarize the destination,
   decisions recorded, remaining frontier, and any user input needed next.

## Mapping Rules

- A question belongs in `Frontier` when it is precise, unresolved, and has no
  unresolved dependency.
- A question belongs in `Blocked` when another named question must be answered
  first.
- An area belongs in `Fog` when it is in scope but cannot yet be stated as a
  precise question.
- A resolved question belongs in `Completed` and has exactly one detailed entry
  in `ANSWERS.md`.
- Phrase questions as decisions or investigations, not implementation tasks.
  The route is complete when nothing material remains to decide before work can
  be planned or implemented.
- If the whole route is already clear and fits in one session, say that a
  wayfinder map adds little value, still create or update the requested files,
  and keep `MAP.md` concise.

## Validation

Before finishing a planning pass, verify that:

- all three files exist in the same planning directory;
- `SPEC.md` describes a bounded destination with testable success criteria;
- every unresolved precise question appears once in `MAP.md` with a valid
  status and dependency;
- every completed map item links to one unique answer entry;
- settled facts do not remain in the frontier or fog;
- no required decision was silently guessed; and
- no implementation work was performed under planning-only authorization.

This workflow is a simplified local-file adaptation of Matt Pocock's
[Wayfinder](https://github.com/mattpocock/skills/tree/main/skills/engineering/wayfinder)
concept.
