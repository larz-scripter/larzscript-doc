#!/bin/sh
# Runs each tests/*.sh scenario and diffs its real output against
# tests/<name>.expected. Real captured output, nothing fabricated.
#
# Nothing needs normalizing here: the formatter is deterministic and no
# test prints a path, a time or a hash.
set -e
cd "$(dirname "$0")/.."
LARZDOC="${LARZDOC:-larzscript bin/larzdoc.lz}"
export LARZDOC
mkdir -p tests/data
fail=0
for t in tests/*.sh; do
  name=$(basename "$t" .sh)
  [ "$name" = "run_tests" ] && continue
  exp="tests/$name.expected"
  # `|| true`: a scenario that ends on a non-zero exit is normal here -
  # larzlint exits 1 when it finds an error, which several tests do on
  # purpose. Without this, `set -e` aborts the whole runner on the first
  # such test and the remaining ones silently never run.
  got=$(sh "$t" 2>&1 || true)
  if [ ! -f "$exp" ]; then
    echo "MISSING EXPECTED  $name"; printf '%s\n' "$got"; fail=1; continue
  fi
  if printf '%s\n' "$got" | diff -u "$exp" - > /tmp/ld_diff_$$ 2>&1; then
    echo "ok    $name"
  else
    echo "FAIL  $name"; cat /tmp/ld_diff_$$; fail=1
  fi
  rm -f /tmp/ld_diff_$$
done
rm -rf tests/data
exit $fail
