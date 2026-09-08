#!/usr/bin/env bash
# Fail the build if a claim from the design comp has crept back into the output.
#
# The site was built from a visual comp whose copy was invented (see CLAUDE.md). The
# layout was kept; the claims were not. This grep is what keeps that decision from
# quietly eroding — a future edit that pastes a paragraph back in fails here rather
# than on a live site.
#
# Each pattern is a string that cannot legitimately appear. Where a word has an honest
# use ("post-quantum" in "Yoalto is not post-quantum"), the pattern is narrowed to the
# fabricated form rather than banned outright.
set -uo pipefail

DIST="${1:-dist}"

if [[ ! -d "$DIST" ]]; then
  echo "factcheck: no such directory: $DIST — run a build first" >&2
  exit 2
fi

# pattern <TAB> why it is banned
PATTERNS=$(cat <<'PAT'
SLH-DSA	post-quantum signature scheme Yoalto does not use — it is Ed25519 + BLS
FIPS 205	as above
quantum-safe	Yoalto is not quantum-safe today; say crypto-agile instead
\bYLT\b	wrong ticker — the native token is YOA
\btps\b	no throughput figure has been measured for Yoalto
1,412,803	invented throughput number from the comp
0\.0421	invented token price from the comp
512 validators	invented validator count
MAINNET LIVE	there is no mainnet
mainnet block	there is no mainnet and no block height to quote
\bwasm\b	the execution layer is a native action registry, not a VM
ywasm	invented artifact extension
two-phase commit	payments are SEND/RECEIVE; there is no cross-partition 2PC
\b2PC\b	as above
atomically composable	cross-partition atomicity does not exist, by design
get\.yoalto\.dev	there is no installer
curl -sSf	there is no install script to pipe
AGPL	the licence is Apache-2.0 only
Zug	no jurisdiction has been established
Swiss foundation	no foundation exists
flinkcoin\.org	legacy domain, unconfirmed as a current channel
Elena Roth	invented person
Kenji Mori	invented person
Adaeze Okafor	invented person
Söderberg	invented person
Priya Nair	invented person
Marc Berger	invented person
PAT
)

fail=0
while IFS=$'\t' read -r pattern why; do
  [[ -z "$pattern" ]] && continue
  if hits=$(grep -rniE "$pattern" "$DIST" --include='*.html' -l 2>/dev/null); then
    echo "✗ $pattern"
    echo "    $why"
    while read -r f; do [[ -n "$f" ]] && echo "    in: $f"; done <<< "$hits"
    fail=1
  fi
done <<< "$PATTERNS"

if [[ $fail -eq 0 ]]; then
  echo "✓ factcheck: no fabricated claims in $DIST"
  exit 0
fi

echo
echo "factcheck failed. These claims contradict ../yoalto — see CLAUDE.md." >&2
exit 1
