# Deploying yoalto.com

This directory is this repository's half of the GitOps split: what runs, and how traffic
reaches it. Everything else — the cluster, Flux itself, the Gateway, TLS and DNS — lives in
`yoalto-rnd/infra`, **which this repo does not modify**.

## What is here

| File | What it declares |
|---|---|
| `app/website.yaml` | Namespace, Deployment (2 replicas, read-only rootfs, uid 101), Service |
| `app/site-route.yaml` | HTTPRoute for `yoalto.com`, plus a 301 from `www.yoalto.com` |

Deploying is a push: pin an image tag in `app/website.yaml`, commit, and Flux reconciles it.

```sh
make image-push                       # prints the tag to pin
```

## What is NOT here — the infra handoff

None of the routing above resolves yet. As of writing, `infra` has no `platform/yoalto-*`
Flux root, no Gateway, no ingress-nginx or Envoy Gateway install, no cert-manager, and no
DNS for `yoalto.com`. `yoalto.io` appears in the tree only as a Kubernetes label prefix.

These changes belong to whoever owns `infra`. Listed precisely so they can be applied
without rediscovering them:

1. **Cluster** — decide whether the site lands on one of the existing `yoalto-dev-{1,2,3}`
   single-node clusters or a new one. It is a static file server: 2 × 16Mi.
2. **Flux root** — a `platform/yoalto-<env>` root whose `sync_path` points at this repo's
   `deploy/` and whose `sync_ref` is `main`. GarageMechanic's root is the working model.
3. **Gateway API** — install Envoy Gateway, then a `Gateway` named `yoalto` in
   `envoy-gateway-system` with two listeners, matching the `sectionName`s in
   `app/site-route.yaml`:
   - `https-apex` — hostname `yoalto.com`
   - `https` — hostname `*.yoalto.com`
4. **TLS** — a Cloudflare origin certificate as a `SealedSecret`, referenced by the Gateway
   listeners. Cloudflare set to Full (strict), as for `garagemechanic.com`.
5. **DNS** — `yoalto.com` A/AAAA to the cluster ingress address, Cloudflare-proxied;
   `www.yoalto.com` likewise, so the 301 above can answer it.
6. **Firewall** — `ingress_enabled = true` with `ingress_allowed_ips` set to the Cloudflare
   ranges, applied on a *second* `tofu apply` after `kubectl` is confirmed working, so an
   install failure and a firewall failure cannot be confused.
7. **Image pull** — a `ghcr-pull` `imagePullSecret` in the `yoalto-website` namespace, since
   `ghcr.io/yoalto-rnd/website` is private.

Until 3–5 exist, `app/site-route.yaml` will reconcile but bind to nothing.
