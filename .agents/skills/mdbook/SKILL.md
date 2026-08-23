---
name: mdbook
description: Create, edit, validate, and publish mdBook projects or mdBook-based KDP manuscripts. Use for book.toml, SUMMARY.md, themes, preprocessors, CI, and manuscript conversion.
---

# mdBook

Use mdBook as the source workflow for documentation books and KDP manuscripts.

## Workflow

1. Inspect the repository instructions, `book.toml`, `src/SUMMARY.md`, source
   tree, preprocessors, custom theme, and deployment configuration.
2. Determine whether the task concerns ordinary mdBook output, custom tooling,
   deployment, or a KDP manuscript, then read only the matching references.
3. Preserve the existing chapter hierarchy, URLs, output contracts, and pinned
   mdBook version unless the task requires changing them.
4. Make the smallest source or configuration change and use valid TOML and
   mdBook Markdown.
5. Build the requested outputs and inspect representative rendered pages or
   publication artifacts rather than relying only on command success.
6. Report exact validation, skipped checks, and remaining publication or
   deployment risks.

## Reference routing

- For KDP ebook or print work, read [references/kdp.md](references/kdp.md).
- For installation and project creation, read
  [references/installation.md](references/installation.md) and
  [references/creating-a-book.md](references/creating-a-book.md).
- For CLI behavior, read [references/cli.md](references/cli.md).
- For chapter structure, read
  [references/summary-format.md](references/summary-format.md).
- For Markdown, includes, playgrounds, or hidden lines, read
  [references/markdown.md](references/markdown.md) and
  [references/mdbook-specific.md](references/mdbook-specific.md).
- For `book.toml`, preprocessors, renderers, search, or environment variables,
  read [references/configuration.md](references/configuration.md).
- For themes, MathJax, CI, or developer APIs, read only the corresponding file:
  [theme](references/theme.md), [MathJax](references/mathjax.md),
  [CI](references/continuous-integration.md), or
  [developer APIs](references/for-developers.md).

The generated references are snapshots of the official mdBook guide. Check the
version metadata in `references/.wiki-version` against the project or current
official documentation when behavior may have changed.

## Reference maintenance

Run `scripts/generate-references.sh` from this skill directory to refresh the
bundled upstream references. The script rewrites relative documentation links
to versioned official URLs so the flattened reference files remain navigable.

## Validation

- `mdbook build` succeeds for the intended configuration.
- `mdbook test` passes when the book contains testable Rust examples.
- The table of contents, internal links, images, search, and changed theme
  behavior work in representative rendered output.
- CI or hosted output is checked when deployment behavior changed.
- KDP deliverables pass the format-specific checks in `references/kdp.md`.
