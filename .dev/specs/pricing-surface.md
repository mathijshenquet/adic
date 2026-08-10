# Track: pricing-surface — bandwidth as THE unique eviction-priced resource

Worker: gpt-5.6-sol, herdr worktree, branch `track/pricing-surface`.
LOG.md at worktree root; first action: add to `.git/info/exclude`,
verify with `git check-ignore LOG.md`. Friction journal as always.
**The out:** > ~30 min stuck on a sub-question: record, move on.

## Context

The classification report (`aips/draft/cocycle-classification.md`)
§3.2 refuted "divisible + idempotent + radius-zero ⇒ write-back
only": the dirty bit alone carries rank three (dirty-up,
dirty-read, redundant-write), and the report names the repair —
"a theorem with one generator would need an additional restriction
on WHICH EVENTS MAY BE PRICED, such as 'only up may inspect the
dirty bit'". The physical principle backing that surface is the
discharged cache-v0 call 2: state-dependent charges live on
EVICTIONS (write-back caches pay on dirty eviction; up = evict).
This track proves the repaired theorem.

## Deliverable: `aips/draft/pricing-surface.md` (+ PDF per AGENTS.md recipe)

1. **Define pricing surface precisely.** A surface S ⊆ Σ × Q of
   (generator, observation) pairs on which the table may be
   state-sensitive; off S the table must be observation-blind
   (T(a,q) = T(a,q′)). Give the general definition, then the
   *eviction surface*: state-sensitivity only on `up`.
2. **The uniqueness theorem (the headline).** For the dirty
   observer (Q = {C,D}, F = L = C, W = D, P = id) under the
   eviction surface: the local-table class monoid is exactly
   ℕ·[write-back] (plus word prices) — rank one, torsion-free.
   Method: restrict the columns of the report's table-to-edge map
   ρ to the surface and redo the SNF/§2.5 analysis at grades 1–2
   (finite, exact); then lift over the tower via the round-2
   local-to-global theory (dirty is strongly connected — the
   descending-chain theorem applies; check what the surface
   restriction does to the chain argument, it should only shrink
   the lattice).
3. **Scope of the surface principle.** Same question for: warmth
   under the eviction surface (does invalidation survive as a
   class when only `up` may be priced? — its witness is
   `down`-priced, so plausibly NOT: state it either way); the
   mod-r counter under the eviction surface. The emerging picture:
   which resources are *eviction-visible*. State it as a table.
4. **The physical reading, one paragraph**: the surface is not an
   ad-hoc axiom but cache-v0's pricing principle (charges at
   potential-consuming boundary events) — the same principle that
   fixed free-up and the dirty pricing. Cite, don't re-derive.
5. **Lean statements** for the uniqueness theorem in the
   Cocycle/Dirty vocabulary (Dirty.lean exists on main — reuse its
   dirtyCost and configuration machinery in your proposed
   statements).

## Out of scope
The ℕ-comparison (parallel track); the saturation wall (parallel
track). Only your report + LOG.

## Gate
PDF renders (pandoc recipe); claims labeled; expos untouched and
still compiling. Commit on the track branch only.
