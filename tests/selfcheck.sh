#!/bin/sh
# larzdoc on its own source.
cd "$(dirname "$0")/.."
LARZDOC="${LARZDOC:-larzscript bin/larzdoc.lz}"
$LARZDOC check --summary lib
echo "exit=$?"
