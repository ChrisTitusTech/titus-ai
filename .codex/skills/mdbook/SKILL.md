---
name: mdbook
description: >-
  This skill should be used when the user asks about "mdBook", "mdbook",
  "book.toml", "SUMMARY.md", "mdbook build", "mdbook serve", "mdbook init",
  "mdbook watch", "mdbook test", "mdbook clean", "mdBook configuration",
  "mdBook preprocessor", "mdBook renderer", "mdBook backend", "mdBook theme",
  "mdBook syntax highlighting", "mdBook MathJax", "mdBook search",
  "mdBook CI deployment", "mdBook GitHub Pages", "mdBook GitLab Pages",
  "mdBook custom theme", "index.hbs", "mdBook editor", "mdBook markdown",
  "mdBook include files", "mdBook hiding code lines",
  or any topic related to creating, configuring, theming, building, or deploying
  documentation books with mdBook.
version: 0.1.0
---

# mdBook Documentation

Complete reference for [mdBook](https://rust-lang.github.io/mdBook/), the Rust-based tool for creating books from Markdown. Auto-generated from the official guide at https://github.com/rust-lang/mdBook.

The `references/` directory contains the full, unmodified guide markdown, updated daily.

## Directives

- Base all answers on the official mdBook documentation in the reference files below.
- Use correct `book.toml` (TOML) syntax for configuration examples.
- Use correct `SUMMARY.md` format for table of contents structure.
- Distinguish between **built-in preprocessors** (links, index) and **custom preprocessors**.
- Distinguish between **built-in renderers** (HTML) and **alternative backends** (pdf, epub, etc.).

## Reference Files

Identify the topic from the user's question, then read the matching reference file:

### Getting Started

| Topic | File |
|-------|------|
| Overview and introduction | **`references/overview.md`** |
| Installation (cargo, binaries) | **`references/installation.md`** |
| Creating a new book | **`references/creating-a-book.md`** |
| Reading / navigating books | **`references/reading-books.md`** |

### CLI

| Topic | File |
|-------|------|
| All CLI commands (init, build, watch, serve, test, clean, completions) | **`references/cli.md`** |

### Book Format

| Topic | File |
|-------|------|
| SUMMARY.md structure and syntax | **`references/summary-format.md`** |
| Markdown features and extensions | **`references/markdown.md`** |
| mdBook-specific features (hiding code, include, playground) | **`references/mdbook-specific.md`** |
| MathJax support | **`references/mathjax.md`** |

### Configuration

| Topic | File |
|-------|------|
| book.toml (general, preprocessors, renderers, environment variables) | **`references/configuration.md`** |

### Theme

| Topic | File |
|-------|------|
| Theme customization (index.hbs, syntax highlighting, editor) | **`references/theme.md`** |

### For Developers

| Topic | File |
|-------|------|
| Writing preprocessors and backends (Rust API) | **`references/for-developers.md`** |

### Deployment

| Topic | File |
|-------|------|
| CI/CD (GitHub Actions, GitLab CI) | **`references/continuous-integration.md`** |

## Live Fetching

When reference files are insufficient, fetch the latest docs from raw GitHub:

```
https://raw.githubusercontent.com/rust-lang/mdBook/master/guide/src/<path>.md
```

Examples:
- `https://raw.githubusercontent.com/rust-lang/mdBook/master/guide/src/format/configuration/general.md`
- `https://raw.githubusercontent.com/rust-lang/mdBook/master/guide/src/cli/build.md`
- `https://raw.githubusercontent.com/rust-lang/mdBook/master/guide/src/format/theme/syntax-highlighting.md`

## Strategy

1. Identify the topic from the user's question.
2. Read the matching reference file from the tables above.
3. Answer with correct TOML syntax for `book.toml` and Markdown for `SUMMARY.md`.
4. If more detail is needed, fetch from the corresponding raw GitHub URL.
5. For custom preprocessors/backends, reference `references/for-developers.md`.
6. For CI deployment, check `references/continuous-integration.md`.

## Quick Reference

### Create a new book
```bash
mdbook init my-book
cd my-book
mdbook serve --open    # preview at http://localhost:3000
```

### Project structure
```
my-book/
├── book.toml          # Configuration
├── src/
│   ├── SUMMARY.md     # Table of contents
│   ├── chapter_1.md
│   └── chapter_2/
│       ├── section_1.md
│       └── section_2.md
└── book/              # Generated output (after build)
```

### SUMMARY.md syntax
```markdown
# Summary

[Introduction](README.md)

- [Chapter 1](chapter_1.md)
  - [Section 1.1](chapter_1/section_1.md)
- [Chapter 2](chapter_2.md)

---

[Appendix](appendix.md)
```

### book.toml basics
```toml
[book]
title = "My Book"
authors = ["Author Name"]
language = "en"
src = "src"

[build]
build-dir = "book"

[output.html]
default-theme = "light"
preferred-dark-theme = "ayu"
git-repository-url = "https://github.com/user/repo"
```

### Build commands
```bash
mdbook build              # build to book/
mdbook serve              # live preview server
mdbook watch              # rebuild on changes
mdbook test               # test Rust code samples
mdbook clean              # remove build artifacts
```
