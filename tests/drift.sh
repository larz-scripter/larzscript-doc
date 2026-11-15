#!/bin/sh
# Each fixture reports exactly its own kind of drift.
cd "$(dirname "$0")/.."
LARZDOC="${LARZDOC:-larzscript bin/larzdoc.lz}"
$LARZDOC check tests/fixtures
echo "exit=$?"
