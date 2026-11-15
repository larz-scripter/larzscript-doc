#!/bin/sh
# Runs against fixtures committed to this repo.
set -e
cd "$(dirname "$0")/.."
LARZDOC="${LARZDOC:-larzscript bin/larzdoc.lz}"
mkdir -p examples/out

echo "== 1. drift across four packages"
$LARZDOC check tests/fixtures || true

echo
echo "== 2. a header that imports another package for context"
echo "   (rng.seed() belongs to random, not to this package)"
$LARZDOC check tests/fixtures/contextpkg.lz

echo
echo "== 3. the generated reference"
$LARZDOC gen tests/fixtures --out examples/out/ref.md
sed -n '/^## Index/,/^$/p' examples/out/ref.md
sed -n '/^## driftpkg$/,/^<details>/p' examples/out/ref.md

echo "== 4. larzdoc on its own source"
$LARZDOC check --summary lib

rm -rf examples/out
