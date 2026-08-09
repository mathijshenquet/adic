# Track: campbell-renyi — desk verification: level prices ↦ Rényi order

Worker: gpt-5.6-sol, herdr worktree, branch `track/campbell-renyi`.
LOG.md at worktree root; first action: add it to `.git/info/exclude`,
verify with `git check-ignore LOG.md`. Friction journal as always.

**The out:** this is desk mathematics — if the claimed
correspondence is WRONG or needs repair, that is the most valuable
possible outcome; report exactly what breaks. Walls > ~30 min on a
sub-question: record and move on.

## Context

`aips/draft/shannon-programme.md` §2 makes a desk-level claim
flagged "to verify": under exponential level prices
c(ℓ) = 2^(tℓ), the optimal distance assignment shifts to
d_i ≈ (1/(1+t))·log(1/p_i) and the optimal amortized cost is
governed by the Rényi entropy of order α = 1/(1+t) — Campbell's
exponential-cost coding theorem (1965). The Euclidean variants
c(ℓ) = 2^(ℓ/2), 2^(ℓ/3) are decided as first-class model variants
(cache-v0 §5), so this correspondence will underpin real theorems.
Your job: verify it, adapt it to our discrete/ℕ setting, and
design the mechanization statements.

## Deliverable: `aips/draft/campbell-renyi.md` (+ PDF per AGENTS.md recipe)

1. **The continuous check**: derive, from scratch (Lagrange on
   Σ p_i·C(d_i) under Σ 2^(−d_i) ≤ 1 with C(d) = Σ_{ℓ≤d} 2^(tℓ)),
   the optimal d_i and the value; state precisely how it relates
   to Rényi H_α and for which α. Compare against Campbell's actual
   theorem statement (which optimizes a different but related
   functional — the exponential mean (1/t)log Σ p·2^(t·ℓ_i));
   say exactly where our travel-cost functional and Campbell's
   coincide, where they differ, and whether the α = 1/(1+t) claim
   survives. If it needs correction, correct it — shannon-programme
   gets amended after merge, not by you.
2. **The discrete/ℕ version**, in the style of Entropy.lean's
   statements (floor-logs, exact inequalities with linear slack,
   no real numbers): propose achievability
   (d_i = ⌈(1/(1+t))·log(1/p_i)⌉-style, Kraft-feasibility check)
   and the converse direction (what replaces Gibbs — Campbell's
   converse, discretized). Desk-prove both as far as honest;
   flag every gap.
3. **Instantiation table**: t = 1/2 and t = 1/3 (the k = 2, 3
   Euclidean machines): exact α, the optimal-cost expression, and
   one worked numeric example (three heads, simple p) computed by
   hand both ways as a sanity check.
4. **Mechanization design**: the list of Lean statements a future
   track would prove (names, hypotheses, exact ℕ-forms), ordered
   as a ladder, with the hard rung identified.
5. **"Expo 2 at k dimensions"** (Mathijs asks to see this written
   out): a section sketching what the Heads-at-a-distance story
   becomes under Euclidean pricing. Key structural point to make
   precise: the Kraft constraint itself does NOT change — mounting
   is combinatorial (antichain packing), geometry-free; what
   changes is the *objective* (travel cost), so the optimal
   assignment flattens (d_i ≈ (1/(1+t))·log(1/p_i) — rare heads
   are pushed less deep because depth is superlinearly priced) and
   Shannon entropy in the value is replaced by Rényi. "Kraft
   becomes Rényi" is thus half-right: Kraft stays, the *entropy*
   turns Rényi. Write the corrected slogan and the before/after
   table (assignment, optimal value, the [59]-style worked
   example).
6. **Which price schedules are well-behaved?** (Mathijs asks.)
   Beyond c(ℓ) = 2^(ℓ/k), map the design space of monotone
   schedules with cumulative C(d) = Σ_{ℓ≤d} c(ℓ):
   - *the streaming boundary*: amortized O(1)-per-leaf streaming
     survives iff Σ_ℓ c(ℓ)·2^(−ℓ) converges (each level-ℓ edge is
     crossed 2^(n−ℓ) times in a sweep — check this claim, state
     it exactly). Locate the boundary case c(ℓ) = 2^ℓ (s = 1):
     random access Θ(N) — *the Turing tape*. The dial should read:
     s = 1 tape, s = 2, 3 chips, s → ∞ the information machine;
     verify and state.
   - *growth trichotomy*: polynomial C (Euclidean-like dimension),
     bounded c (hyperbolic), and the intermediate/super-exponential
     regimes — what each does to random access and to streaming;
     which of our existing theorems need which condition
     (a doubling-type condition C(d+1) ≤ K·C(d) is probably the
     honest "well-behaved" axiom — confirm or correct).
   - *why exponential schedules are canonical*: Rényi's own
     axiomatic classification (via Kolmogorov–Nagumo
     quasi-arithmetic means: the only additive information
     measures are Shannon + the Rényi family) suggests the
     exponential family c(ℓ) = 2^(tℓ) is exactly the class whose
     optimal-cost functional is additive over independent head
     groups. Make this precise as far as honest — it would answer
     "why 2^(ℓ/k) and not something else" with an axiom instead
     of a shrug.
7. **Stretch (optional, clearly labeled)**: the WBE rhyme —
   shannon-programme §2 notes West–Brown–Enquist's d/(d+1)
   metabolic exponent coincides with our α = k/(k+1). One honest
   page: is their optimization a Campbell-type problem after a
   change of variables, or is the coincidence shallow? Either
   answer is a fine result; do not force it.

## Gate

The PDF renders (pandoc recipe, `\text{}` not `\mathrm{}`); every
claim badge-labeled in prose (verified / desk-proved / conjectured
/ wall); expos untouched and still compiling. No edits outside
your report + LOG. Commit on the track branch only.
