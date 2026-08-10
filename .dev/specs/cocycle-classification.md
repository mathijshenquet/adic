# Track: cocycle-classification — the classification theorem, by actual cohomology

Worker: gpt-5.6-sol, herdr worktree, branch `track/cocycle-classification`.
LOG.md at worktree root; first action: add it to `.git/info/exclude`,
verify with `git check-ignore LOG.md`. Friction journal as always.

**The out:** research track — precise walls are first-class
results. Land partial rungs; never weaken a statement to fake a
rung. Walls > ~30 min per sub-question: record, move on.

## Context

`aips/draft/local-classes.md` proved: fixed-grade triviality is
the finite edge system (E); the class monoid has a computable
presentation; examples split into scheduling classes (dirty,
warmth) and arithmetic/torsion classes (visit mod r — physically:
recycling/flash-erase granularity); the hoped-for "write-back is
the unique generator" is false in the broad language; the tower
(all-grade) uniformity is an open wall. Orchestrator's method
proposal (this track's program): replace witness-per-example with
actual cohomological computation. AIP-5 §1B fixes exchange-form ℕ
discipline; `lean/Adic/Cocycle.lean` fixes the mechanized shapes.

## Deliverable: `aips/draft/cocycle-classification.md` (+ PDF per AGENTS.md recipe)

1. **The SNF method, fixed grade.** The action category is free
   on the reachable configuration graph, so cocycles mod
   coboundaries = holonomy on the cycle space H₁(G;ℤ); the class
   group is coker(ℤ^Σ → H¹(G;ℤ)) (quotient by letter prices =
   pullback along the labeling map). Compute it by Smith normal
   form. Validate on all four local-classes examples at small
   grade: rank and torsion must reproduce sol's verdicts (2-torsion
   for parity, free classes for dirty and warmth, zero for first
   touch) — one computation replacing four witnesses. State the
   ℕ-refinement honestly: SNF classifies up to formal differences;
   the realizable-price cone is a separate Presburger layer —
   define it precisely and compute it for the examples if
   tractable.
2. **The axiom lattice.** Classify under the three restrictions
   and each single omission: (i) divisible (ℚ≥0) coefficients —
   kills torsion (= the write-amplification/averaged regime);
   (ii) idempotent observer updates (set/reset automata — hardware
   state bits, no counters); (iii) radius-zero events (no
   ParentFill). Target theorem: under (i)+(ii)+(iii), the class
   monoid is exactly homomorphisms + ⟨write-back⟩. Do BOTH slices
   (with and without ParentFill) so the taste call "is
   invalidation a priced resource" only picks the headline, not
   the mathematics.
3. **The transgression conjecture.** The observer covering
   C̃ → C has finite monodromy (e.g. ℤ/r for the counter). Make
   precise and attempt: *arithmetic classes are exactly the
   transgressions of finite-monodromy coverings* (five-term
   exact-sequence style, adapted to free categories on graphs).
   Even a clean statement + partial proof is a rung.
4. **The tower attack.** The configuration graphs are built from
   identical local gadgets under tree symmetry. Attempt the
   stabilization theorem via local-to-global: equivariant
   reduction / Mayer–Vietoris / a sheaf-on-the-tree decomposition
   so that the SNF of a fixed finite gadget answers every grade
   n ≥ N. This is the hard rung and the theorem-with-teeth; an
   honest wall with the precise obstruction named is a fine
   outcome.
5. **Lean rung list** for a future mechanization track, in the
   existing Cocycle.lean vocabulary.

## Out of scope

Editing local-classes.md or any AIP; the literature question
(parallel track `cost-cohomology-priorart` handles it — do not
duplicate); dirty pricing details (call 2).

## Gate

PDF renders (pandoc recipe, `\text{}` not `\mathrm{}`); every
claim labeled verified / desk-proved / conjectured / wall; expos
untouched and still compiling. Commit on the track branch only.
