// Verifies that docs/ is a complete mirror of the source tree.
//
//   node tools/check_docs_mirror.mjs
//
// Every  lib/**/*.dart  and  test/**/*.dart  must have a matching
// docs/<same path>.md — and every doc must have a matching source file.
// Exits 1 and lists the problems when the mirror drifts.

import { readdirSync, statSync, existsSync } from 'node:fs';
import { join } from 'node:path';

const SOURCE_DIRS = ['lib', 'test'];
const DOCS_DIR = 'docs';

function walk(dir, ext, out = []) {
  if (!existsSync(dir)) return out;
  for (const name of readdirSync(dir)) {
    const p = join(dir, name).split('\\').join('/');
    if (statSync(p).isDirectory()) walk(p, ext, out);
    else if (name.endsWith(ext)) out.push(p);
  }
  return out;
}

const sources = SOURCE_DIRS.flatMap((d) => walk(d, '.dart'));
const docs = walk(DOCS_DIR, '.md').filter((p) => p !== `${DOCS_DIR}/README.md`);

const missingDocs = sources.filter(
  (src) => !existsSync(`${DOCS_DIR}/${src.replace(/\.dart$/, '.md')}`),
);
const orphanDocs = docs.filter((doc) => {
  const src = doc.slice(DOCS_DIR.length + 1).replace(/\.md$/, '.dart');
  return !existsSync(src);
});

if (missingDocs.length === 0 && orphanDocs.length === 0) {
  console.log(`OK — ${sources.length} source files, ${docs.length} docs, mirror is complete.`);
  process.exit(0);
}

if (missingDocs.length) {
  console.error(`\nMissing docs (${missingDocs.length}) — create these:`);
  for (const s of missingDocs) {
    console.error(`  ${DOCS_DIR}/${s.replace(/\.dart$/, '.md')}   (for ${s})`);
  }
}
if (orphanDocs.length) {
  console.error(`\nOrphan docs (${orphanDocs.length}) — source is gone, delete or move these:`);
  for (const d of orphanDocs) console.error(`  ${d}`);
}
process.exit(1);
