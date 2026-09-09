# yoalto.com

The public website for [Yoalto](https://github.com/yoalto-rnd/yoalto) — an Astro project
that builds to static HTML with no client JavaScript, served by nginx.

## Quick start

```sh
mise install     # node 22
make install     # npm ci
make dev         # http://localhost:4321
```

## Layout

```
src/pages/       one .astro file per route
src/components/  the design comp's blocks, extracted
src/layouts/     Base.astro — head, nav, footer
src/styles/      site.css, the comp's stylesheet kept near-verbatim
src/config.ts    every off-site link, in one place
scripts/         factcheck.sh, linkcheck.sh
public/          favicon and CNAME
tmp/design/      gitignored copy of the design comp
```

## The one rule

This site was built from a visual design comp whose **copy was invented**. The layout,
typography and CSS were kept; the claims were not — they contradicted the actual protocol
on nearly every point.

Every factual statement here must be traceable to
[`yoalto-rnd/yoalto`](https://github.com/yoalto-rnd/yoalto). `make factcheck` greps the
build output for the fabricated claims and fails on a hit; it runs in CI and inside the
Docker build, so a bad image cannot be produced. See [CLAUDE.md](CLAUDE.md) for the full
list and the reasoning.

```sh
make check       # build + factcheck + linkcheck
```

## Deploying

GitHub Pages, published by `.github/workflows/pages.yml` on every push to `main`. A push
to `main` is a deploy.

`public/CNAME` holds the custom domain (`www.yoalto.com`); GitHub issues the TLS
certificate. www is canonical and the apex redirects to it.
If that file ever goes missing from the build, Pages drops back to a `github.io` address
and every inbound link breaks — `make check` and CI both assert it is there.

DNS: `www` is a CNAME to `yoalto-rnd.github.io`, and the apex keeps A records pointing at
GitHub's Pages addresses so that Pages can redirect it to www.

```
185.199.108.153   185.199.109.153   185.199.110.153   185.199.111.153
```

All records are DNS-only in Cloudflare (grey cloud) — proxying them breaks GitHub's
certificate issuance.
