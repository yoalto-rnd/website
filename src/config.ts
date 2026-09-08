// Every off-site destination, in one place.
//
// `github.com/yoalto-rnd/yoalto` is currently a PRIVATE repository, so any link to it
// 404s for a visitor. Until that changes, `sourceIsPublic` gates the source and design-doc
// links across the site: pages render an honest "not yet public" state instead of a dead
// link. Flip it to true when the repo opens.
//
// The Discord / X / blog handles in ../yoalto/README.md are all Flink-era and unconfirmed,
// so they are deliberately absent. Add them here once confirmed — not inline in a page.
export const site = {
  sourceIsPublic: false,
  repo: 'https://github.com/yoalto-rnd/yoalto',
  org: 'https://github.com/yoalto-rnd',
  /** Path within the repo, appended to `repo`/blob/main/ for design-doc links. */
  docsPath: 'docs',
} as const;

/** A link to a file in the core repo, or null when the repo is not public yet. */
export function repoFile(path: string): string | null {
  return site.sourceIsPublic ? `${site.repo}/blob/main/${path}` : null;
}
