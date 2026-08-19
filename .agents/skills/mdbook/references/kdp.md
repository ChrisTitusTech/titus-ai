# KDP manuscript workflow

Use mdBook as the maintained Markdown source, then convert or package the built
content into the requested Kindle or print format.

## Source structure

- Keep manuscript Markdown under `src/`.
- Treat `src/SUMMARY.md` as the canonical table of contents and chapter order.
- Keep title, author, language, source directory, output, and preprocessors in
  `book.toml`.
- Use a simple sequence unless the manuscript requires something different:
  title page, copyright page, optional contents, optional introduction,
  chapters, about the author, and optional additional resources.
- Preserve consistent headings, relative image paths, and intentional chapter
  breaks.

## Outputs

- Prefer EPUB for Kindle ebooks and validate the final EPUB rather than only
  the intermediate HTML book.
- Prefer PDF for print and inspect every rendered page.
- Use print-appropriate image resolution, normally 300 DPI for raster artwork
  at its placed size.
- Embed required print fonts and omit crop marks unless the user or printer
  requires them.
- Keep styling restrained because complex HTML and CSS can convert poorly.

## Validation

- Metadata, title, author, language, and cover dimensions match the requested
  publication.
- The table of contents, internal links, external links, chapter breaks, and
  navigation work in the final format.
- Images are present, correctly placed, and sufficient resolution.
- EPUB validation passes when EPUB is requested.
- Every PDF page renders correctly and required fonts are embedded when PDF is
  requested.
- Final delivery notes identify any remaining KDP preview, bleed, trim, color,
  accessibility, or upload risk.
