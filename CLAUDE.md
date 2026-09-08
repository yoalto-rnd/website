# Working in this repo

This repo is the public website for Yoalto, served at **yoalto.com**. It is an Astro
project that builds to static HTML — no client JavaScript, no server-side rendering.

## Never write outside this repo

**Stay inside `yoalto-rnd/website`.** Do not create, edit, delete, stage, commit, push, or
`git checkout` anything in a sibling repository — specifically:

- `../yoalto/` — the protocol implementation
- `../garagemechanic/` — a separate product
- `../infra/` — Talos clusters and the Flux bootstrap

**Reading them is expected and necessary.** This site has no content of its own: every
technical claim on it comes from `../yoalto`, and the Astro conventions here follow
`../garagemechanic/apps/webpage/`. Read freely — `cat`, `grep`, `ls`,
`git -C ../yoalto show`, `ls-tree`. Avoid even `git fetch` in them; it writes refs.

**Why.** Those repos are worked on by separate sessions, often concurrently. Editing files
under someone else's working tree corrupts their in-flight state in ways neither of you can
see: a `git checkout` moves a branch out from under them, a stray file turns up in their
`git add -A`, and a commit interleaves with work they had not finished.

**What to do instead.** Make the change on this side, then say plainly what the other repo
needs and let its owner apply it. A precise handoff — file, line, old value, new value — is
the deliverable.

This site needs nothing from `../infra`: GitHub Pages serves it, and the DNS records are
set at the registrar. There is deliberately no cluster, ingress or Flux wiring here.

## Source of truth

**`https://github.com/yoalto-rnd/yoalto`** — local clone at `../yoalto`.

Every factual claim on this site must be traceable to that repo. When writing or editing
copy, verify against the code and `../yoalto/docs/*.md` rather than against an earlier
version of this site. Cite the file you checked in the commit message when the claim is
load-bearing.

## The no-fabrication rule

The site was built from a visual design comp whose copy was invented. The comp's layout,
typography and CSS were kept; its claims were not. Do not let them creep back in.

Nothing on this site may assert:

1. **Post-quantum signatures.** It is Ed25519 for user transactions and BLS
   (`supranational/blst`) for consensus. No SLH-DSA, no FIPS 205. The honest story is
   *crypto-agility*: two-layer identity with `claim_hash` frozen at account open, so a
   Falcon migration is one `KeyRotateTx`.
2. **Any throughput number.** None exists for Yoalto. The "4000 tps / 3 s" in
   `../yoalto/media/whitepaper/` belongs to the old Flink block-lattice design — a
   different architecture — and must never be presented as Yoalto's.
3. **A live network.** No mainnet, no public testnet, no faucet, no block explorer. Three
   private Talos dev clusters exist.
4. **A VM.** The EVM on chain 0 is designed, not built. What ships is a native action
   registry. Never say "wasm".
5. **`YLT`, or any tokenomics.** The ticker is `YOA`. No tokenomics document exists — no
   supply, distribution, emission schedule, or price.
6. **An external audit.** `../yoalto/docs/security-audit-2026-07.md` is an internal pass
   and explicitly declines to claim "certified clean". `libs/smt` has no external audit.
7. **A working order-book DEX.** It is schema-only. (The NFT marketplace *is* real and
   end-to-end.)
8. **People, a foundation, funding, bounties, or open roles.** None of it is verified.
9. **Live figures** — block heights, epoch numbers, validator counts, "updated 2s ago".
10. **Cross-partition atomicity.** Payments are Nano-style SEND/RECEIVE; the absence of
    cross-partition atomicity is a deliberate design property, not an omission.

Also: `flinkcoin.org`, `blog.flinkcoin.org`, `x.com/flinkcoin` and the Discord invite in
`../yoalto/README.md` are all Flink-era. Do not put them on the site without confirming
they are still the intended channels.

`make factcheck` greps the build output for these strings and fails on a hit. Run it
before any deploy; it runs in CI too.

## Build

```sh
make dev        # astro dev on :4321
make build      # astro build -> dist/
make check      # build + factcheck + linkcheck — what CI runs
```

## Deploying is a push

The site is served by **GitHub Pages** at `yoalto.com`, published by
`.github/workflows/pages.yml` on every push to `main`. There is no image, no cluster and
no ingress — treat a push to `main` as a deploy.

`public/CNAME` carries the custom domain. If it goes missing from the build output, Pages
silently drops back to a `github.io` address and every inbound link breaks, so `make check`
and CI both assert it is present.

## Conventions

- **Static output, no client JS.** The design needs none, and Pages serves files only.
  If a change would add a `<script>` tag, that is a design decision to raise, not a
  detail to slip in.
- **This repository is public.** It holds the marketing site and nothing else. Do not
  add infrastructure topology, cluster details, internal hostnames or anything else
  from `../infra` — that was the reason the container deployment was removed from here.
- `src/styles/site.css` is the design comp's stylesheet, kept near-verbatim as the single
  source of visual truth. Prefer adding a class there over inventing a parallel system.
- The comp used heavy inline `style=""`. Repeated patterns have been lifted into classes;
  genuine one-offs stay inline. Don't mass-refactor the remainder for its own sake.
- Content maturity is stated inline with `StatusTag` (Shipped / In progress / Designed)
  rather than in a site-wide disclaimer banner.
