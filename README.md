# larzdoc

Read a [Larzscript](https://github.com/larz-scripter/larzscript) package's
public surface, compare it with what its header actually documents, and
generate a reference.

The reference is the deliverable. The comparison is the point.

## The finding

Run over the 66 packages in
[larzscript-packages](https://github.com/larz-scripter/larzscript-packages):

| | |
|---|---|
| packages | 66 |
| public functions | **476** |
| packages documenting an API in their header | 65 |
| **packages whose header covers their whole public surface** | **19** |
| public functions never mentioned in their own header | **184** |
| **functions documented but absent** | **0** |

That last row is the good news and it is worth stating first: **nothing in
this ecosystem's documentation is wrong.** Every function a header shows
being called exists. The headers are accurate; they are just incomplete,
and 184 public functions have never been written down anywhere.

`REFERENCE.md` in this repo is the generated reference for all 67 installed
packages — 476 functions, each marked documented or not. It is a snapshot,
because it is generated from a local package library that CI does not have.

## What counts as documented

The package headers follow a consistent convention:

```
# heap - a readable, array-backed binary heap. Min-heap by default; pass
# a key function for max-heap or custom ordering.
#
#   import "heap" as heap
#   heap.push(h, 5)
```

So a function is documented if the header shows it being **called on this
package's own alias**.

That scoping is load-bearing, and getting it wrong is what the corpus
caught. `genetic.lz`'s header imports `random as rng` for context and
writes `rng.seed(1)`. Counting every `x.name(` in the header made
`seed` and `randint` look like functions genetic documented but had not
implemented. **Three of the four original "documented but missing" findings
were that mistake**; after scoping to the package's own alias, the count is
zero and stays zero.

Exports are read from the token stream rather than grepped, because a
`fn` inside a comment or a string is not a definition — and package
headers are full of usage examples.

## Usage

```
larzscript bin/larzdoc.lz check <path>...           report drift
larzscript bin/larzdoc.lz check --summary <path>... counts only
larzscript bin/larzdoc.lz gen <path>... --out FILE  write a markdown reference
```

A function **documented but absent** is an error — the header is lying.
A public function the header never mentions is a **warning** — the header is
incomplete, which is the ordinary state of things. Exit 1 only on errors, so
`check` is usable in CI without demanding that every project document
everything today.

Paths containing `/vendor/` are skipped.

## Demo

Real output of `sh examples/demo.sh`:

```
== 1. drift across four packages
tests/fixtures/driftpkg.lz  warning  gamma() is public and undocumented
tests/fixtures/liarpkg.lz  error    documents liar.vanished() which does not exist
scanned 4 package(s); 4 document an API; 2 fully in sync
1 documented-but-missing, 1 undocumented

== 2. a header that imports another package for context
   (rng.seed() belongs to random, not to this package)
scanned 1 package(s); 1 document an API; 1 fully in sync
0 documented-but-missing, 0 undocumented

== 3. the generated reference
wrote examples/out/ref.md: 4 package(s), 7 public function(s)
## Index

## driftpkg

documents two of its three public functions.

```
import "driftpkg" as drift
```

| function | documented |
|---|---|
| `alpha()` | yes |
| `beta()` | yes |
| `gamma(n=nil)` | — |

<details><summary>header</summary>
== 4. larzdoc on its own source
scanned 3 package(s); 3 document an API; 3 fully in sync
0 documented-but-missing, 0 undocumented
```

## It passes its own check

```
scanned 3 package(s); 3 document an API; 3 fully in sync
0 documented-but-missing, 0 undocumented
```

It did not at first — `api.lz` exported four functions its own header never
mentioned, and `lex.lz` exported `render`. A tool that reports
undocumented exports should not have any.

## Design

`lib/lex.lz` is copied unchanged from
[larzscript-fmt](https://github.com/larz-scripter/larzscript-fmt), via
[larzscript-lint](https://github.com/larz-scripter/larzscript-lint). It is
duplicated rather than shared because there is no mechanism to depend on
another flagship repo; the file records that, so a fix to one is known to
need applying to the others.

## Install

```
git clone https://github.com/larz-scripter/larzscript-doc
cd larzscript-doc
sh tests/run_tests.sh
sh examples/demo.sh
```

## Licence

MIT.
