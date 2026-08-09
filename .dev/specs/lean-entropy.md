# Track: lean-entropy — B4 phase 2: the entropy bound

Worker: gpt-5.6-sol, same pane. Branch:
`git switch -c track/lean-entropy main` (contains your merged
Weighted.lean). Same LOG discipline.

**The out:** problems or ambiguity > ~30 min → say so and stop. The
LOWER bound below is genuinely hard over naturals — the fallback
scope (upper bound only) is a complete deliverable.

## Context

cache-v0 rev 2 §3 target 2, from convo [57]: weights chosen against
touch frequencies give expected cost ≤ H(p) + 1 per touch, with a
matching Shannon/Kraft lower bound. Stay all-natural like
Weighted.lean — no reals: work with touch COUNTS, not
probabilities, and log as `Nat.log2`/`Nat.clog 2` (your judgment,
state which and why).

## Deliverable

`lean/Adic/Entropy.lean` (or extend Weighted.lean — your judgment):

1. **Touch cost.** For a touch sequence `touches : List (Fin k)`
   and weights w: `touchCost w touches = Σ_t (1 + w (touches t))`
   (or reuse weightedCost on a word — your judgment; keep it
   consistent with Weighted.lean).
2. **Achievability (the upper bound — the core deliverable).** For
   counts cᵢ = count of head i in a sequence of length n (assume
   all cᵢ > 0, or handle zeros — your judgment, document it), the
   weight choice wᵢ = clog 2 (n / cᵢ) (ceiling log of inverse
   empirical frequency):
   - is Kraft-feasible (KraftOk — the classical Σ 2^(−⌈log 1/pᵢ⌉)
     ≤ Σ pᵢ = 1 argument, done over naturals);
   - gives `touchCost ≤ n + Σᵢ cᵢ · (1 + clog 2 (n / cᵢ))` — state
     the clean closed form you can prove; the target shape is
     "n·(H_emp + O(1))" where H_emp is the empirical entropy in
     count form Σ cᵢ·log(n/cᵢ). Be explicit and honest about
     ceiling slack — an extra +n is fine, a fudged log is not.
3. **Lower bound (attempt; wall-report freely).** Any Kraft-feasible
   w has `touchCost w touches ≥ n + Σᵢ cᵢ · (log2-floor of n/cᵢ
   -ish)` — the counting form of Shannon optimality. If a clean
   natural-number statement doesn't emerge within the box, DESK-arg
   it precisely in the LOG (the paper can badge it desk-proved) and
   land only the upper bound. Do not weaken the statement to force
   a mechanization.
4. **Receipts + gate**: manifest additions, regeneration, full gate
   (build + receipts + sim + typst) synchronously green.

## Out of scope

Real-valued entropy, the k-way cliff witness (phase 3), dynamic
reweighting/Huffman, size-weighted Kraft.
