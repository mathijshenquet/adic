# Track: mergesort-expo — worked example 3, desk-proved (Expo 4)

Worker: gpt-5.6-sol, herdr worktree, branch `track/mergesort-expo`.
LOG.md at worktree root; first action: add it to `.git/info/exclude`,
verify with `git check-ignore LOG.md`. Friction journal as always.

**The out:** problems or ambiguity > ~30 min → say so and stop.
An honest wall report is a valued deliverable.

## Context

Roadmap worked-examples ladder item 3: mergesort with desk-proved
honest cost, ledger-first (Lean later). Read
`expo/01-the-dyadic-machine.typ` and `expo/02-heads-at-a-distance.typ`
for house style and `expo/lib.typ` for the badge machinery
(deskthm/openclaim — you will use NO leanthm: this expo is honest
amber). Study `lean/Adic/Zip.lean` and `lean/Adic/Copy.lean`
enough to cite their *mechanized* bounds as the building blocks
your desk argument stands on (name the receipts in prose, e.g.
"zipWord_cost, mechanized").

Machine facts you rely on: AIP-2 §3 (instructions; `up` is free —
cost = address bits acquired), streaming = odometer sum, the zip
pattern (two read heads + write head).

## Deliverable: `expo/04-mergesort.typ` (+ compiled PDF, committed)

An expo in the house voice (measured, precise, no hype):

1. **The program**: direct-style bottom-up mergesort of N = 2^n
   records of w bits each, laid out contiguously; merge pass =
   the zip pattern (two read heads, one write head) at stride
   2^j·w; log N passes. State the layout choices explicitly
   (where the output of pass j lives — ping-pong between two
   buffers is fine; say so).
2. **Desk cost accounting**, one deskthm per level:
   - a single merge pass over the whole array is a streaming
     word: desk-derive its cost Θ(N·w) from the zip/copy
     mechanized bounds (adapted to stride — say exactly what
     changes vs the mechanized statement);
   - total over log N passes: Θ(N·w·log N) bit-cost, constants
     stated honestly (with free-up, track the odometer sums);
   - the comparison itself: w-bit compare during the merge —
     account for it (read both, branch; it rides the same pass).
3. **One openclaim**: the matching lower bound question (is
   N·w·log N tight on this machine for comparison sorting? state
   what is known — the classical comparison bound gives N log N
   *comparisons*; the bit-cost claim needs its own argument —
   phrase the open question precisely, do not overclaim).
4. **A closing paragraph** placing it on the ladder: first
   multi-pass worked example; what a Lean track would mechanize
   (the pass word, its cost closed form, composition over passes).

## Gate

`typst compile expo/04-mergesort.typ` exit 0 (synchronous), all
other expos still compile, PDF committed. Every quantitative claim
carries a badge; no leanthm. Update `expo/README.md` if it lists
the expos. Commit on the track branch only.
