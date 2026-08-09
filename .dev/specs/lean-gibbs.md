# Track: lean-gibbs — the discrete log-sum inequality + entropy lower bound

Worker: gpt-5.6-sol, same pane. Branch:
`git switch -c track/lean-gibbs main` (contains your merged
Entropy.lean). Same LOG discipline.

**The out:** problems > ~30 min on any sub-lemma → wall-report that
sub-lemma precisely and land the rest. Your own LOG's wall analysis
(pointwise substitution is false; the aggregate inequality is
needed) is the starting point — read it back first.

## Deliverable

1. **The discrete Gibbs/log-sum lemma**, all-natural, in the form
   your wall analysis identified as missing — roughly: for counts
   cᵢ summing to n and any Kraft-feasible weights w,
   `Σᵢ cᵢ·(floor-log₂(n/cᵢ)) ≤ Σᵢ cᵢ·wᵢ + n·O(1)` — state the
   sharpest natural-number form you can actually prove, with the
   slack explicit and honest. Classical route: convexity/Jensen is
   real-valued, but the counting proof (Kraft ⇒ the weight
   assignment is a prefix code ⇒ Σ cᵢ wᵢ is a code length for the
   touch sequence ⇒ compare against the type-class/counting bound)
   stays in ℕ. Use your kraft_iff_mounting to move between weights
   and antichains if that helps.
2. **The entropy lower bound** for touchCost, completing phase 2:
   any Kraft-feasible w has touchCost ≥ (the empirical-entropy
   count form minus explicit slack). Statement shape from your LOG;
   do not weaken.
3. **Receipts + full gate** as always (manifest, regeneration,
   build + receipts + sim + typst, zero sorry, synchronous).

## Out of scope

Real-valued entropy, phase 3 (k-way witness), size-weighted Kraft.
