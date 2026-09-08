# The Yoalto website: Astro built to static HTML, served by nginx.
#
# Build context is the repo root:
#   docker build -t ghcr.io/yoalto-rnd/website:<tag> .
#
# nginx-unprivileged rather than the stock image: it listens on 8080 as a non-root user
# out of the box, which is what lets the pod keep runAsNonRoot with a read-only root
# filesystem.

FROM node:22-bookworm-slim AS site
WORKDIR /src
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY . ./
RUN npm run build

# The build output must not contain any claim the comp invented. Running this here means
# a bad image cannot be produced at all, rather than being caught later in CI.
RUN ./scripts/factcheck.sh dist

FROM nginxinc/nginx-unprivileged:1.27-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=site /src/dist /site
EXPOSE 8080
