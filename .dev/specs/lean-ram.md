# Track: lean-ram — minimal word RAM + the honest-log simulation (one direction)

Worker: gpt-5.6-sol, same pane. Branch: `git switch -c track/lean-ram
main`. Same LOG discipline.

**The out:** problems or ambiguity > ~30 min → say so and stop.
Honest wall = valued deliverable. This track is the first one where
a wall is genuinely plausible — the spec deliberately cuts scope to
keep it landable, and if even the cut scope fights back, stopping
with a precise report is success.

## Context

AIP-2 §3 target 3, §5g (minimal RAM counterpart; existential
constants; the O(log S) direction is "nearly free": a word is a
grade-w subtree, address arithmetic is path navigation — theorem 2
plus composition). Roadmap B2's honest-log berry. The *other*
direction (D simulated by RAM, constant factor) is OUT OF SCOPE —
it needs cost accounting on a RAM execution model and deserves its
own track.

## Deliverable

1. **Minimal word RAM** (`lean/Adic/Ram.lean`): the smallest
   adequate model — S words of w bits, programs as finite
   instruction lists (load/store by address in a register,
   arithmetic your judgment but minimal — successor + comparison
   may suffice), unit cost per instruction. Resist features; §5g's
   whole point is that the counterpart stays small.
2. **Layout**: a RAM memory of S = 2^s words of w = 2^v bits lives
   in a grade-(s+v) dyadic tree: word i is the grade-v subtree at
   the depth-s path of i. Give the address→path map and its
   correctness lemma (word i's leaves = the tree's leaves under
   that path).
3. **Simulation theorem (one direction)**: every RAM program of
   cost T is simulated on D by a (data-indexed, oblivious-schedule
   where possible — reuse your Zip/Copy machinery judgment) run of
   cost ≤ c·T·(s + 2^v) — i.e. O(log S + w) per RAM step, the
   honest log. Existential constant c. State it per-instruction
   first (one RAM step = one D excursion of bounded cost), then
   lift to programs by induction; the per-instruction lemma is the
   real content, the lift should be routine.
4. **Quality gate** — as always: fresh clean `lake build` exit 0,
   zero sorry, `#print axioms` core-only, letters compile, receipts
   in LOG.md, friction journal.

If step 3's full lift threatens the time box, land steps 1–2 plus
the per-instruction excursion lemma and stop honestly — that is a
complete deliverable for this track.

## Out of scope

RAM simulates D (reverse direction), TM simulations, cost-optimal
constants, uniform-program end-detection, Kraft/cache work.
