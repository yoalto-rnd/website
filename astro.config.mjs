// @ts-check
import { defineConfig } from 'astro/config';

// Static output: this is a content site served by GitHub Pages. Nothing here needs a
// server, and the design needs no client JavaScript either — see CLAUDE.md.
//
// www is CANONICAL; the apex redirects to it. GitHub Pages does that redirect itself so
// long as the apex A records stay pointed at Pages alongside the www CNAME — so those
// records are load-bearing even though nothing is served from the apex directly.
//
// `site` must match the canonical host exactly: it is what canonical link tags and og:url
// are built from, and a mismatch there quietly splits search-engine attribution between
// two hostnames.
export default defineConfig({
  site: 'https://www.yoalto.com',
  output: 'static',
  build: { format: 'directory' },
});
