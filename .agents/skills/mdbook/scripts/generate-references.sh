#!/usr/bin/env bash
set -euo pipefail

# Generate mdBook skill reference files from the official guide
# Source: https://github.com/rust-lang/mdBook (guide/ directory)
#
# Usage: ./scripts/generate-references.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REFS_DIR="$SKILL_DIR/references"
MDBOOK_REPO="https://github.com/rust-lang/mdBook.git"
WORK_DIR=$(mktemp -d)
PYTHON_CMD=""

for candidate in python3 python; do
    if command -v "$candidate" >/dev/null 2>&1 &&
        "$candidate" -c 'import sys; raise SystemExit(sys.version_info < (3, 9))' >/dev/null 2>&1; then
        PYTHON_CMD="$candidate"
        break
    fi
done

if [[ -z "$PYTHON_CMD" ]]; then
    printf '%s\n' "error: Python 3.9 or newer is required to rewrite reference links" >&2
    exit 1
fi

cleanup() { rm -rf "$WORK_DIR"; }
trap cleanup EXIT

echo "==> Cloning mdBook (sparse, guide/ only)..."
git clone --depth 1 --filter=blob:none --sparse --quiet "$MDBOOK_REPO" "$WORK_DIR/mdbook"
git -C "$WORK_DIR/mdbook" sparse-checkout set guide/src

GUIDE="$WORK_DIR/mdbook/guide/src"

MDBOOK_COMMIT=$(git -C "$WORK_DIR/mdbook" rev-parse --short HEAD)
MDBOOK_DATE=$(git -C "$WORK_DIR/mdbook" log -1 --format=%ci)
MDBOOK_VERSION=$(
    git -C "$WORK_DIR/mdbook" show HEAD:Cargo.toml |
        awk '
            $0 == "[package]" { in_package = 1; next }
            in_package && /^\[/ { exit }
            in_package && /^version[[:space:]]*=/ {
                value = $0
                sub(/^[^=]*=[[:space:]]*"/, "", value)
                sub(/".*$/, "", value)
                print value
                exit
            }
        '
)
if [[ -z "$MDBOOK_VERSION" ]]; then
    printf '%s\n' "error: unable to read mdBook version from Cargo.toml" >&2
    exit 1
fi
IFS=. read -r MDBOOK_MAJOR MDBOOK_MINOR _ <<<"$MDBOOK_VERSION"
if [[ "$MDBOOK_MAJOR" -eq 0 ]]; then
    MDBOOK_SEMVER="$MDBOOK_MAJOR.$MDBOOK_MINOR"
    MDBOOK_SEMVER_BREAK="$MDBOOK_MAJOR.$((MDBOOK_MINOR + 1)).0"
else
    MDBOOK_SEMVER="$MDBOOK_MAJOR"
    MDBOOK_SEMVER_BREAK="$((MDBOOK_MAJOR + 1)).0.0"
fi

echo "==> mdBook commit: $MDBOOK_COMMIT ($MDBOOK_DATE)"

mkdir -p "$REFS_DIR"

# Helpers

source_url_for() {
    local src="$1" relative
    relative=${src#"$GUIDE/"}

    PYTHONUTF8=1 "$PYTHON_CMD" - "$relative" <<'PY'
import pathlib
import sys

sys.stdout.reconfigure(encoding="utf-8", newline="\n")
relative = pathlib.PurePosixPath(sys.argv[1])
if relative.name == "SUMMARY.md" and len(relative.parts) == 1:
    route = ""
elif relative.name == "README.md":
    route = "" if len(relative.parts) == 1 else f"{relative.parent}/"
else:
    route = f"{relative.with_suffix('.html')}"

print(f"https://rust-lang.github.io/mdBook/{route}")
PY
}

render_page() {
    local src="$1" source_url="${2:-}"
    if [[ -z "$source_url" ]]; then
        source_url=$(source_url_for "$src")
    fi

    PYTHONUTF8=1 "$PYTHON_CMD" - \
        "$src" "$source_url" "$MDBOOK_VERSION" "$MDBOOK_SEMVER" "$MDBOOK_SEMVER_BREAK" <<'PY'
import re
import sys
from urllib.parse import urljoin

sys.stdout.reconfigure(encoding="utf-8", newline="\n")
source_path, source_url, mdbook_version, mdbook_semver, mdbook_semver_break = sys.argv[1:]
inline_link = re.compile(
    r'(?P<prefix>!?\[[^\]]*\]\()(?P<open><)?'
    r'(?P<target>[^\s)>]+)(?P<close>>)?'
    r'(?P<suffix>(?:\s+["\'][^"\']*["\'])?\))'
)
reference_link = re.compile(
    r'(?P<prefix>^\s*\[(?!\^)[^\]]+\]:\s*)(?P<open><)?'
    r'(?P<target>[^\s>]+)(?P<close>>)?(?P<suffix>.*$)',
    re.MULTILINE,
)


def absolute_target(target: str) -> str:
    lowered = target.lower()
    if lowered.startswith(("http://", "https://", "mailto:", "data:")):
        return target
    if target.startswith("#"):
        return target

    path, marker, fragment = target.partition("#")
    if path.endswith("README.md"):
        path = f"{path[:-len('README.md')]}index.html"
    elif path.endswith(".md"):
        path = f"{path[:-3]}.html"

    resolved = urljoin(source_url, path)
    return f"{resolved}{marker}{fragment}" if marker else resolved


def rewrite(match: re.Match[str]) -> str:
    parts = match.groupdict()
    return "".join(
        (
            parts["prefix"],
            parts.get("open") or "",
            absolute_target(parts["target"]),
            parts.get("close") or "",
            parts.get("suffix") or "",
        )
    )


def rewrite_text(text: str) -> str:
    text = inline_link.sub(rewrite, text)
    return reference_link.sub(rewrite, text)


in_fence = False
buffer: list[str] = []
with open(source_path, encoding="utf-8") as source:
    for line in source:
        line = line.replace("{{ mdbook-version }}", mdbook_version)
        line = line.replace("{{ mdbook-semver }}", mdbook_semver)
        line = line.replace("{{ mdbook-semver-break }}", mdbook_semver_break)
        stripped = line.lstrip()
        if stripped.startswith(("```", "~~~")):
            if not in_fence:
                print(rewrite_text("".join(buffer)), end="")
                buffer.clear()
            in_fence = not in_fence
            print(line, end="")
            continue
        if in_fence:
            print(line, end="")
            continue

        buffer.append(line)

print(rewrite_text("".join(buffer)), end="")
PY
}

copy_page() {
    local src="$1" dst="$REFS_DIR/$2" url="$3"
    if [[ ! -f "$src" ]]; then
        echo "  WARN: $(basename "$src") not found, skipping"
        return
    fi
    {
        echo "<!-- source: $url -->"
        echo "<!-- repo: rust-lang/mdBook commit $MDBOOK_COMMIT ($MDBOOK_DATE) -->"
        echo "<!-- auto-generated by scripts/generate-references.sh - DO NOT EDIT MANUALLY -->"
        echo ""
        render_page "$src" "$url"
    } > "$dst"
    echo "  OK: $2"
}

merge_pages() {
    local output_name="$1" header="$2" url="$3" section_url
    local dst="$REFS_DIR/$output_name"
    shift 3
    {
        echo "<!-- source: $url -->"
        echo "<!-- repo: rust-lang/mdBook commit $MDBOOK_COMMIT ($MDBOOK_DATE) -->"
        echo "<!-- auto-generated by scripts/generate-references.sh - DO NOT EDIT MANUALLY -->"
        echo ""
        echo "# $header"
        echo ""
        for src in "$@"; do
            if [[ -f "$src" ]]; then
                section_url=$(source_url_for "$src")
                echo "<!-- section source: $section_url -->"
                echo ""
                render_page "$src" "$section_url"
                echo ""
                echo "---"
                echo ""
            else
                echo "  WARN: $(basename "$src") not found, skipping from merge" >&2
            fi
        done
    } > "$dst"
    echo "  OK: $output_name (merged)"
}

echo ""
echo "==> Generating reference files..."

# Guide overview

copy_page "$GUIDE/README.md" \
    "overview.md" \
    "https://rust-lang.github.io/mdBook/"

copy_page "$GUIDE/SUMMARY.md" \
    "summary.md" \
    "https://rust-lang.github.io/mdBook/"

# Getting started

copy_page "$GUIDE/guide/installation.md" \
    "installation.md" \
    "https://rust-lang.github.io/mdBook/guide/installation.html"

copy_page "$GUIDE/guide/creating.md" \
    "creating-a-book.md" \
    "https://rust-lang.github.io/mdBook/guide/creating.html"

copy_page "$GUIDE/guide/reading.md" \
    "reading-books.md" \
    "https://rust-lang.github.io/mdBook/guide/reading.html"

# CLI

merge_pages "cli.md" "mdBook CLI Reference" \
    "https://rust-lang.github.io/mdBook/cli/" \
    "$GUIDE/cli/README.md" \
    "$GUIDE/cli/init.md" \
    "$GUIDE/cli/build.md" \
    "$GUIDE/cli/watch.md" \
    "$GUIDE/cli/serve.md" \
    "$GUIDE/cli/test.md" \
    "$GUIDE/cli/clean.md" \
    "$GUIDE/cli/completions.md" \
    "$GUIDE/cli/arg-watcher.md"

# Format and configuration

copy_page "$GUIDE/format/summary.md" \
    "summary-format.md" \
    "https://rust-lang.github.io/mdBook/format/summary.html"

merge_pages "configuration.md" "mdBook Configuration (book.toml)" \
    "https://rust-lang.github.io/mdBook/format/configuration/" \
    "$GUIDE/format/configuration/README.md" \
    "$GUIDE/format/configuration/general.md" \
    "$GUIDE/format/configuration/preprocessors.md" \
    "$GUIDE/format/configuration/renderers.md" \
    "$GUIDE/format/configuration/environment-variables.md"

copy_page "$GUIDE/format/markdown.md" \
    "markdown.md" \
    "https://rust-lang.github.io/mdBook/format/markdown.html"

copy_page "$GUIDE/format/mathjax.md" \
    "mathjax.md" \
    "https://rust-lang.github.io/mdBook/format/mathjax.html"

copy_page "$GUIDE/format/mdbook.md" \
    "mdbook-specific.md" \
    "https://rust-lang.github.io/mdBook/format/mdbook.html"

# Theme

merge_pages "theme.md" "mdBook Theme Customization" \
    "https://rust-lang.github.io/mdBook/format/theme/" \
    "$GUIDE/format/theme/README.md" \
    "$GUIDE/format/theme/index-hbs.md" \
    "$GUIDE/format/theme/syntax-highlighting.md" \
    "$GUIDE/format/theme/editor.md"

# For developers

merge_pages "for-developers.md" "mdBook for Developers (Preprocessors & Backends)" \
    "https://rust-lang.github.io/mdBook/for_developers/" \
    "$GUIDE/for_developers/README.md" \
    "$GUIDE/for_developers/preprocessors.md" \
    "$GUIDE/for_developers/backends.md"

# Continuous integration

copy_page "$GUIDE/continuous-integration.md" \
    "continuous-integration.md" \
    "https://rust-lang.github.io/mdBook/continuous-integration.html"

# Write version metadata

echo ""
echo "==> Writing metadata..."

cat > "$REFS_DIR/.wiki-version" <<EOF
commit='$MDBOOK_COMMIT'
date='$MDBOOK_DATE'
EOF

TOTAL=$(find "$REFS_DIR" -name '*.md' | wc -l)
echo "==> Done! Generated $TOTAL reference files from mdBook commit $MDBOOK_COMMIT"
echo "    Output: $REFS_DIR/"
