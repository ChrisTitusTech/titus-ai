---
name: mdbook
description: Use this skill when creating, editing, validating, or converting KDP-ready book manuscripts with mdBook as the source workflow, or when working with mdBook documentation projects, including book.toml, SUMMARY.md, mdbook init/build/serve/watch/test/clean, Markdown formatting, mdBook configuration, themes, preprocessors, renderers/backends, MathJax, search, custom themes, CI deployment, GitHub Pages, GitLab Pages, or Rust mdBook developer APIs.
---

# mdBook

Use this skill to create KDP-ready manuscripts with mdBook as the source format and to create, configure, build, theme, validate, and deploy mdBook projects.

## Workflow

1. Identify the mdBook topic from the user's request.
2. Read the matching reference file before giving detailed guidance or editing files.
3. Use correct TOML for `book.toml` and correct Markdown structure for `SUMMARY.md`.
4. Prefer the local reference files because they mirror the official mdBook guide.
5. Use `scripts/generate-references.sh` only when the bundled references need to be refreshed from upstream mdBook docs.
6. When the references are insufficient and current docs are required, fetch the matching file from `https://raw.githubusercontent.com/rust-lang/mdBook/master/guide/src/<path>.md`.

## KDP Manuscript Workflow

Use mdBook as the manuscript source when creating Kindle or print-ready books:

1. Keep manuscript source in Markdown under `src/`.
2. Use `src/SUMMARY.md` as the canonical table of contents and chapter order.
3. Use `book.toml` for title, author, language, source directory, HTML output, and any preprocessing.
4. Build with `mdbook build` and inspect the generated `book/` output before conversion.
5. Convert or package the generated content into the requested KDP target, usually EPUB for Kindle and PDF for print.
6. Validate links, images, chapter breaks, metadata, fonts, and table of contents before delivery.

### KDP Structure

Use a simple, review-friendly book structure unless the user provides a manuscript-specific structure:

1. Title page
2. Copyright page
3. Table of contents, optional for print
4. Preface or introduction, optional
5. Chapters
6. About the author
7. Additional resources, optional

### KDP Output Guidance

- Prefer EPUB for Kindle eBooks.
- Prefer PDF for print books.
- Keep heading hierarchy consistent.
- Use one clear book title and chapter-level headings.
- Use relative image paths.
- Use high-resolution images for print, preferably 300 DPI.
- Avoid excessive styling that may fail KDP review or convert poorly.
- Embed fonts for print PDFs when required.
- Do not include crop marks unless specifically requested.

### KDP Validation Checklist

- Metadata is complete.
- Cover dimensions match the target format.
- Table of contents links work.
- Internal and external links are not broken.
- Images are present and appropriate resolution.
- EPUB passes validation when EPUB is requested.
- PDF pages render correctly when PDF is requested.
- Fonts are embedded where required.
- Chapter breaks are correct.
- Final upload notes call out any remaining KDP risks.

## References

- [Overview](references/overview.md): mdBook purpose and general introduction.
- [Installation](references/installation.md): installing mdBook with Cargo, prebuilt binaries, or source builds.
- [Creating a Book](references/creating-a-book.md): `mdbook init`, project layout, and first-book workflow.
- [Reading Books](references/reading-books.md): navigating generated mdBook output.
- [CLI](references/cli.md): `init`, `build`, `watch`, `serve`, `test`, `clean`, and completions.
- [SUMMARY Format](references/summary-format.md): `src/SUMMARY.md` syntax and nesting.
- [Markdown](references/markdown.md): supported Markdown syntax and extensions.
- [mdBook Specific](references/mdbook-specific.md): hiding code lines, including files, playgrounds, and mdBook-only features.
- [MathJax](references/mathjax.md): math rendering support.
- [Configuration](references/configuration.md): `book.toml`, preprocessors, renderers, environment variables, and output options.
- [Theme](references/theme.md): custom themes, `index.hbs`, syntax highlighting, editor support, and theme files.
- [Continuous Integration](references/continuous-integration.md): GitHub Actions, GitLab CI, and deployment patterns.
- [For Developers](references/for-developers.md): custom preprocessors, renderers/backends, and Rust API details.

## Scripts

- [generate-references.sh](scripts/generate-references.sh): refresh the `references/` files from the upstream mdBook guide. Run it from the skill directory.

## Quick Commands

Create and preview a book:

```bash
mdbook init my-book
cd my-book
mdbook serve --open
```

Build and validate:

```bash
mdbook build
mdbook serve
mdbook watch
mdbook test
mdbook clean
```

## Project Layout

```text
my-book/
├── book.toml
├── src/
│   ├── SUMMARY.md
│   ├── chapter_1.md
│   └── chapter_2/
│       ├── section_1.md
│       └── section_2.md
└── book/
```

## SUMMARY.md Basics

```markdown
# Summary

[Introduction](README.md)

- [Chapter 1](chapter_1.md)
  - [Section 1.1](chapter_1/section_1.md)
- [Chapter 2](chapter_2.md)

---

[Appendix](appendix.md)
```

## book.toml Basics

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

## Topic Guidance

- For setup or install questions, read [Installation](references/installation.md) and [Creating a Book](references/creating-a-book.md).
- For command behavior, flags, or troubleshooting build commands, read [CLI](references/cli.md).
- For table of contents or chapter structure issues, read [SUMMARY Format](references/summary-format.md).
- For Markdown rendering, includes, hidden lines, playgrounds, or code blocks, read [Markdown](references/markdown.md) and [mdBook Specific](references/mdbook-specific.md).
- For `book.toml`, preprocessors, renderers, search, output options, or environment variables, read [Configuration](references/configuration.md).
- For custom CSS, JavaScript, templates, highlighting, or editor integration, read [Theme](references/theme.md).
- For MathJax or equation rendering, read [MathJax](references/mathjax.md).
- For GitHub Pages, GitLab Pages, or automated builds, read [Continuous Integration](references/continuous-integration.md).
- For custom preprocessors or renderers/backends, read [For Developers](references/for-developers.md).
