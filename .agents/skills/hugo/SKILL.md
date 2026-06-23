---
name: hugo
description: Build, edit, validate, and troubleshoot Hugo static sites. Use when working with Hugo repositories, including config.toml/config.yaml/hugo.toml, content front matter, archetypes, layouts, partials, shortcodes, taxonomies, menus, assets, image processing, RSS/search outputs, redirects, or static-site deployment.
---

# Hugo

Use this skill for Hugo static-site work: content changes, template/layout edits, taxonomy and menu updates, asset pipeline changes, data files, shortcodes, render hooks, redirects, and deployment validation.

## First Pass

Before editing, inspect the project shape:

- Read repository instructions such as `AGENTS.md`, `.codex/config.toml`, and relevant README files.
- Identify the Hugo config file: `hugo.toml`, `config.toml`, `hugo.yaml`, `config.yaml`, `hugo.json`, or a `config/` directory.
- Check for a theme, module, or local layouts: `themes/`, `layouts/`, `assets/`, `static/`, `data/`, `content/`, `archetypes/`, `i18n/`.
- Check the build/deploy path: `package.json`, `go.mod`, `.github/workflows/`, `netlify.toml`, `vercel.json`, `wrangler.*`, Cloudflare Pages docs, Makefile, or project scripts.
- Run or inspect `hugo version` when validation depends on version-specific behavior.
- Inspect `git status --short` and preserve unrelated user changes.

## Common Commands

Use the repository's existing scripts when present. Otherwise prefer:

```bash
hugo server
hugo server --buildDrafts --buildFuture
hugo --gc --minify
hugo --printPathWarnings --printUnusedTemplates
```

Use `--source`, `--config`, `--environment`, or `--destination` only when the repository structure requires them.

## Content Work

- Use existing archetypes and nearby content as the model for new pages or posts.
- Preserve explicit `url`, `slug`, `aliases`, and redirect behavior unless the task is specifically about URL changes.
- Keep front matter format consistent with the file or project: TOML, YAML, or JSON.
- Preserve taxonomy spelling and casing used by existing content.
- For posts, verify required fields such as `title`, `date`, `draft`, `description`, `summary`, `image`, `categories`, `tags`, `author`, or custom params by checking templates and archetypes.
- Use `<!--more-->` only when existing list templates or content conventions rely on manual summaries.
- Avoid broad rewrites of historical content unless requested.

## Template Work

- Prefer existing partials, base templates, render hooks, shortcodes, and CSS patterns over one-off markup.
- Identify template lookup rules before moving or renaming files. Section/type-specific templates can be intentional.
- Treat these as high-impact files because they often affect many pages: `baseof.html`, head/meta partials, navigation/header/footer partials, list/single templates, RSS templates, sitemap templates, search index templates, and structured-data partials.
- Preserve SEO and sharing behavior: canonical URLs, Open Graph, Twitter cards, JSON-LD, RSS, sitemap, and robots output.
- Preserve accessibility affordances such as semantic headings, skip links, focus states, useful alt text, labels, and keyboard-accessible controls.
- For shortcodes, keep positional/named parameter compatibility unless a breaking change is requested.

## Assets And Data

- Understand the asset boundary:
  - `assets/` is processed by Hugo Pipes.
  - `static/` is copied directly to the published site.
  - `public/` is generated output and is usually not source.
- For SCSS, JS, fonts, and images, follow the existing pipeline rather than adding a new package manager or bundler.
- For image processing, check config and template use of `.Resources`, `resources.Get`, `Fit`, `Fill`, `Resize`, WebP, and fingerprinting before changing paths.
- For `data/` files, keep JSON/YAML/TOML valid and preserve the shape consumed by templates.
- Do not commit secrets, API keys, private tokens, or generated credentials in data files, templates, scripts, or build logs.

## Hugo Modules And Themes

- If the site uses Hugo Modules, inspect `go.mod`, `go.sum`, and module imports in config before editing theme files.
- If the site uses a theme under `themes/`, prefer overriding templates in the project `layouts/` directory unless the task requires changing the theme source.
- If the site vendors a theme or has no external theme, treat local templates and assets as first-party source.

## Multilingual Sites

When `languages`, `defaultContentLanguage`, `i18n/`, or language-specific content directories are present:

- Preserve translation keys and language-specific URL rules.
- Check whether menus, params, taxonomies, and permalinks are language-specific.
- Validate at least one representative page per affected language when practical.

## Deployment

Match validation to the deployment target:

- Cloudflare Pages commonly runs `hugo` or a project script and publishes `public/`.
- Netlify may use `netlify.toml`, environment variables, and a pinned Hugo version.
- GitHub Pages may deploy through Actions and may require base URL or artifact settings.
- Vercel or custom hosts may wrap Hugo in package scripts.

Do not change deployment commands, publish directories, Hugo versions, or environment assumptions without checking the existing deployment config.

## Validation

For most changes, run:

```bash
hugo --gc --minify
```

For content scheduled in the future or drafts:

```bash
hugo server --buildDrafts --buildFuture
```

For high-impact template or URL changes, also inspect representative generated pages or run a local server and check:

- Home page.
- A single content page.
- A list page.
- A taxonomy page.
- Search or JSON output if present.
- RSS or sitemap if touched.
- A page using any changed shortcode/render hook.

Report validation commands run, failures, skipped checks, and residual risks.
