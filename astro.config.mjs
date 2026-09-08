// @ts-check
import { defineConfig } from 'astro/config';

// Static output: this is a content site served by nginx. Nothing here needs a server, and
// the design needs no client JavaScript either — see CLAUDE.md.
//
// Apex is canonical. GarageMechanic put its site on www because its audience reads the URL
// off a printed certificate, where a bare domain could be mistaken for a company name. This
// site's audience is developers arriving from a link, so the shorter form wins.
export default defineConfig({
  site: 'https://yoalto.com',
  output: 'static',
  build: { format: 'directory' },
});
