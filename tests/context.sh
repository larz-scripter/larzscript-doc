#!/bin/sh
# A header that imports another package for context must not have that
# package's calls read as its own documentation. Three of the four
# "documented but missing" findings on the published corpus were this
# mistake before documentation was scoped to the package's own alias.
cd "$(dirname "$0")/.."
LARZDOC="${LARZDOC:-larzscript bin/larzdoc.lz}"
$LARZDOC check tests/fixtures/contextpkg.lz
echo "exit=$?"
