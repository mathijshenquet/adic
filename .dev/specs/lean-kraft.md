# Track: lean-kraft — weighted heads under Kraft, phase 1 (B4)

Worker: gpt-5.6-sol, same pane. Branch:
`git switch -c track/lean-kraft main`. Same LOG discipline.

**The out:** problems or ambiguity > ~30 min → say so and stop.

## Context

`aips/draft/cache-v0.md` rev 2 — read §2 (the model, from convo
[55]–[59]) and §3 carefully; this track mechanizes phase 1 of §5:
level price c ≡ 1, weighted heads, Kraft feasibility, weighted
streaming. Entropy bound and the k-way cliff witness are LATER
phases — not this track.

## Deliverable

`lean/Adic/Weighted.lean` (or your judgment), same project:

1. **Weight assignments.** `Weights k := Fin k → Nat`; Kraft
   feasibility `KraftOk w : Prop` := Σᵢ 2^(−wᵢ) ≤ 1, stated over
   naturals (Σᵢ 2^(W−wᵢ) ≤ 2^W for W = max wᵢ, or your cleaner
   formulation — avoid rationals if you can do it honestly).
2. **Weighted cost**: `weightedCost w (word : ActionWord k) : Nat`
   — each operation addressed to head i costs 1 + wᵢ ([57]: the
   surcharge is the head's address depth in the implicit fast-state
   tree). Still a homomorphism: `weightedCost_append`. Plain cost
   is the w ≡ 0 fiber: `weightedCost_zero : weightedCost 0 word =
   actionCost word`.
3. **Kraft ↔ antichain**: a Kraft-feasible weight assignment
   corresponds to an antichain of mount slots — connect to the
   existing `PrefixIncomparable` machinery: there EXISTS an
   injective assignment of heads to pairwise prefix-incomparable
   paths with |path i| = wᵢ iff Kraft holds. (This is
   Kraft's classical construction; both directions.)
4. **Weighted streaming**: the zip bound survives weighting —
   `weightedCost w (zipWord n a b) = Z_w n` closed form with
   `Z_w n ≤ (1 + max w) · 20 · 2^n`, and instantiate the convo's
   own example [59]: uniform w = 2 on three heads, Kraft check
   3·2^(−2) ≤ 1 by `decide`/`native_decide`-free proof.
5. **Quality gate** — as always, plus: add the main new theorems to
   `expo/receipts-manifest.txt` and regenerate `receipts.json`
   (commit the regenerated file; `lake exe receipts` exit 0).

## Out of scope

Entropy bound, k-way merge witness, level prices c(ℓ) ≠ 1,
size-weighted Kraft, reweighting generators, fast-state mounting
semantics (v0 prices statically).
