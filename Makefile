# Yoalto website — dev tasks.
#
# The site is static and deploys to GitHub Pages from .github/workflows/pages.yml, so
# there is no image to build and nothing to push by hand. Deploying is a push to main.

.PHONY: help install dev build preview factcheck linkcheck check clean

help:
	@echo "install     npm ci (needs Node — mise install)"
	@echo "dev         astro dev on :4321"
	@echo "build       astro build -> dist/"
	@echo "preview     serve dist/ locally"
	@echo "factcheck   fail on any claim the design comp invented"
	@echo "linkcheck   fail on dead internal links or href=\"#\" placeholders"
	@echo "check       build + factcheck + linkcheck  (what CI runs)"

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

linkcheck:
	./scripts/linkcheck.sh dist

check: build factcheck linkcheck
	@test -f dist/CNAME || { echo "dist/CNAME missing — Pages would drop the custom domain"; exit 1; }
	@grep -rl '<script' dist --include='*.html' && { echo "unexpected client JavaScript"; exit 1; } || echo "✓ no client JavaScript"
	@echo "✓ ready to deploy"

clean:
	rm -rf dist .astro
