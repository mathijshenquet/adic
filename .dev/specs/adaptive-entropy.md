# Track: adaptive-entropy — Shannon move 1: block re-mounting achieves the entropy rate

Worker: gpt-5.6-sol, herdr worktree, branch `track/adaptive-entropy`.
LOG.md at worktree root; first action: add it to `.git/info/exclude`,
verify with `git check-ignore LOG.md`. Append-only, timestamped,
synchronous receipts only. Friction journal as always.

**The out:** problems or ambiguity > ~30 min on any rung →
wall-report that rung honestly, land the rest. An honest wall is a
valued deliverable.

## Context

`aips/draft/shannon-programme.md` §3 (move 1) is the design;
`lean/Adic/Entropy.lean` + `lean/Adic/Gibbs.lean` are the static
theory (touchCost, empiricalDists, entropy bounds both directions);
`lean/Adic/Distance.lean` has Dists/KraftOk. This track is the
flagship next theorem: *static mounting pays the marginal entropy;
block-adaptive re-mounting pays the per-block entropies* — the
machine's entry into the dynamic-optimality world.

## Deliverable: `lean/Adic/Adaptive.lean` (new file; do not edit existing theory files)

Statement design (orchestrator; your lemma ladder may differ, log
deviations):

1. **Re-mount cost.** Define
   `remountCost (d : Dists k) : Nat := finSum (fun i => 1 + d i)`
   — reset + re-select every head at its new distance (justified by
   the canonicalization machinery of RamLift; a comment citing that
   is enough, no dependence on it).
2. **Block-adaptive cost.** For `blocks : List (List (Fin k))`:
   `adaptiveCost blocks := Σ_j (remountCost (empiricalDists b_j) +
   touchCost (empiricalDists b_j) b_j)` — each block priced by its
   own empirical distances. (Handle the all-heads-positive
   hypothesis per block the same way Entropy.lean does; blocks
   where some head has zero touches need the same care the static
   theorem took — reuse its technique, don't invent.)
3. **Upper bound (the theorem):**
   `adaptiveCost blocks ≤ Σ_j (blockFloorLog b_j + 2·|b_j|) +
   Σ_j remountCost (empiricalDists b_j)` — i.e. per-block entropy
   + per-block linear slack + explicit re-mount overhead, by
   applying the static achievability per block. Then the readable
   corollary: for m blocks of total length n,
   adaptive ≤ Σ_j n_j·(1 + H_j)-style bound + m·(re-mount term),
   in whatever exact ℕ-form is honest (floor-log style, as the
   static theorem states it).
4. **Separation witness (the payoff):** the rotating source —
   k heads, m = k equal blocks, block j touches ONLY head j
   (n/k touches each). Prove: (a) adaptiveCost = Θ(n + k·(stuff)):
   per-block entropy is 0 (single head → empiricalDists gives
   distance 0 inside the block; verify what empiricalDists does at
   k=1-support and state exactly); (b) any STATIC Kraft assignment
   costs ≥ the global entropy bound — instantiate the existing
   Gibbs lower bound (`touchCost_entropy_lower`) on the
   concatenated sequence, whose global frequencies are uniform 1/k
   → lower bound ≈ n·(1 + log k) in its exact floor-log form.
   (c) Conclude the strict separation for n ≫ k²: state it as one
   clean theorem `adaptive_beats_static` with explicit constants —
   the exact inequality form is yours, log the design.
5. **Receipts**: add the main theorems (upper bound, witness upper,
   static lower instantiation, separation) to
   `expo/receipts-manifest.txt`, regenerate `receipts.json`
   (`lake exe receipts` exit 0, synchronous).

## Out of scope

Expo prose (a later Claude pass); universal/online mounting (move
2); any edit to Entropy/Gibbs/Distance.lean (import them; if a
private lemma there blocks you, copy it into Adaptive.lean with a
comment rather than editing the file — merge-conflict axis with a
parallel track); the free-up retrofit (runs in parallel — your
touchCost layer is untouched by it; if you notice otherwise, wall
and say so).

## Gate

`lake build` (zero sorry, `#print axioms` on new theorems core
only), `lake exe receipts` exit 0, `lake exe sim` still PASS,
expos still compile. Synchronous receipts in LOG. Commit on the
track branch only.
