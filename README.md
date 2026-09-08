# yoalto.com

The public website for [Yoalto](https://github.com/yoalto-rnd/yoalto) — an Astro project
that builds to static HTML with no client JavaScript, served by nginx.

## Quick start

```sh
mise install     # node 22
make install     # npm ci
make dev         # http://localhost:4321
```

`make image` needs only Docker — Node runs inside the build stage.

## Layout

```
src/pages/       one .astro file per route
src/components/  the design comp's blocks, extracted
src/layouts/     Base.astro — head, nav, footer
src/styles/      site.css, the comp's stylesheet kept near-verbatim
src/config.ts    every off-site link, in one place
scripts/         factcheck.sh, linkcheck.sh
deploy/app/      this repo's half of the GitOps manifests
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

## Verifying the container

```sh
make image
docker run --rm -p 8080:8080 --read-only --tmpfs /tmp ghcr.io/yoalto-rnd/website:$(git rev-parse --short=12 HEAD)
curl -f localhost:8080/healthz
curl -o /dev/null -w '%{http_code}\n' localhost:8080/nope/   # must be 404, not 200
```

## Deploying

`deploy/app/` holds the Deployment, Service and HTTPRoutes. The Gateway, TLS certificate,
DNS and Flux root are **not** in this repo — see [deploy/README.md](deploy/README.md).
