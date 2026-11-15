#!/bin/sh
# The generated reference.
cd "$(dirname "$0")/.."
LARZDOC="${LARZDOC:-larzscript bin/larzdoc.lz}"
mkdir -p tests/data
$LARZDOC gen tests/fixtures --out tests/data/ref.md
echo "--- index"
sed -n '/^## Index/,/^$/p' tests/data/ref.md
echo "--- the drifting package"
sed -n '/^## driftpkg$/,/^<details>/p' tests/data/ref.md
