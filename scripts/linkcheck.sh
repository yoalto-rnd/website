#!/usr/bin/env bash
# Verify every internal link in the build resolves to a real file, and that no
# placeholder hrefs survived from the design comp.
#
# The comp linked several buttons to "#" (whitepaper, audit reports, press kit, careers).
# Those are exactly the links that look fine in a screenshot and are broken in public.
set -uo pipefail

DIST="${1:-dist}"
fail=0

if [[ ! -d "$DIST" ]]; then
  echo "linkcheck: no such directory: $DIST — run a build first" >&2
  exit 2
fi

# 1. Placeholder hrefs
if grep -rn 'href="#"' "$DIST" --include='*.html' >/dev/null 2>&1; then
  echo "✗ placeholder href=\"#\" found:"
  grep -rln 'href="#"' "$DIST" --include='*.html' | sed 's/^/    /'
  fail=1
fi

# 2. Internal links resolve. Astro builds directories, so /protocol/ -> protocol/index.html
while read -r link; do
  [[ -z "$link" ]] && continue
  path="${link%%#*}"                 # drop fragment
  [[ -z "$path" ]] && continue       # same-page anchor
  target="$DIST${path}"
  if [[ "$path" == */ ]]; then
    target="$DIST${path}index.html"
  fi
  if [[ ! -e "$target" ]]; then
    echo "✗ dead internal link: $link  (looked for $target)"
    fail=1
  fi
done < <(grep -rhoE 'href="/[^"]*"' "$DIST" --include='*.html' | sed 's/href="//;s/"$//' | sort -u)

if [[ $fail -eq 0 ]]; then
  echo "✓ linkcheck: all internal links resolve, no placeholders"
  exit 0
fi
exit 1
