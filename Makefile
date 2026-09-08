# Yoalto website — dev tasks.
#
# The image build needs no local Node: its first stage is node:22, so `make image` works
# on a machine that has only Docker. `make dev` does need Node, for the live-reloading
# Astro server — `mise install` provides it.
#
# Mirrors garagemechanic/apps/webpage/Makefile, including the refusal to push a -dirty
# tag: a deployed image tag must name a commit someone can check out.

IMAGE   ?= ghcr.io/yoalto-rnd/website
TAG     ?= $(shell git rev-parse --short=12 HEAD 2>/dev/null || echo nogit)$(shell git diff --quiet 2>/dev/null || echo -dirty)

.PHONY: help install dev build preview factcheck check image image-push clean

help:
	@echo "install     npm ci (needs Node — mise install)"
	@echo "dev         astro dev on :4321"
	@echo "build       astro build -> dist/"
	@echo "preview     serve dist/ locally"
	@echo "factcheck   fail on any claim the design comp invented"
	@echo "check       build + factcheck + link check"
	@echo "image       build $(IMAGE):$(TAG) (Docker only — Node runs inside)"
	@echo "image-push  build and push"

install:
	npm ci

dev:
	npm run dev

build:
	npm run build

preview: build
	npm run preview

# Guards the one thing that is easy to get wrong here: the site was built from a comp
# whose copy was fabricated, and a careless edit can paste it back. See CLAUDE.md.
factcheck:
	./scripts/factcheck.sh dist

check: build factcheck
	./scripts/linkcheck.sh dist

image:
	@echo "building $(IMAGE):$(TAG)"
	docker build -t $(IMAGE):$(TAG) .

image-push: image
	@case "$(TAG)" in *-dirty) \
	  echo "refusing to push $(TAG): commit the working tree first"; exit 1 ;; esac
	docker push $(IMAGE):$(TAG)
	@echo "pushed $(IMAGE):$(TAG)  — pin this tag in deploy/app/website.yaml"

clean:
	rm -rf dist .astro
