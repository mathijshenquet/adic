# The cached dyadic machine (v0): heads at a distance under Kraft — rev 2

Rev 2 (2026-08-09, after Mathijs's corrections): rebuilt on the
convo's actual model ([55]–[59]), which is sharper than rev 1's
fringe sketch. Rev 1's "moves inside the fringe are free" mechanism
is dropped — the convo prices differently and better.

## 1. The problem

B4: bridge the multi-head machine to a machine with caches, making
fast state a priced structural resource. The convo already built
most of this ([56]: Mathijs's distance-indexed cursor proposal; [57]: the
Kraft analysis); this AIP freezes the v0 slice to mechanize.

## 2. The model (from the convo, with indices)

- **Down fills, up evicts.** A `down` at level ℓ morally fills the
  level-ℓ cache; `up` evicts it (Mathijs 2026-08-09; the
  amortization-as-normalization view of [21] — rewrite down·up → ε
  — is the same fact equationally). Eviction is therefore *in* the
  base model already; D's walk IS the cache traffic.
- **Per-level price c(ℓ).** The base machine prices every level 1
  (c ≡ 1 — the honest-information price, our current D). The
  physical variant scales per level: c(ℓ) = 2^(αℓ) with α = 1/2
  gives random access Θ(√N) — the "memory latency goes as the
  square root of capacity" lore as a stated model variant, not a
  patch.
- **Heads at a distance, Kraft budget** ([56]/[57]): every head has
  a distance d; the constraint Σᵢ 2^(−dᵢ) ≤ 1 (Kraft) says only so
  much fits nearby. The heads' fast-state shares — head i gets
  fraction 2^(−dᵢ) of the caches — form a prefix-free code, i.e. an
  antichain of mount slots in the fast-state block. The physical
  picture: a head's share is an
  aligned window, cache-line-style (power-of-2 floor boundaries,
  not centered — Mathijs). The formal mechanics: every move of a
  head at distance d pays a surcharge, cost 1 + d — its address depth
  in the implicit fast-state tree ([57]; no tree is walked, the
  distance *is* the address). Within-stream amortization survives
  with the multiplicative (1 + d).
- **No overlapping heads** (Mathijs 2026-08-09): shares are
  disjoint (the antichain condition); no dynamic cache-sharing
  optimization — that would make everything non-local, and [57]
  records why half-measures there are treacherous (adversarial
  sharing breaks classic bounds). Static disjoint shares keep every
  bound provable and sound.
- **Size-aware distance refinement** ([57] correction 1, noted for v1):
  a depth-d head's state costs ~d, so the honest constraint is
  Σ sᵢ·2^(−dᵢ) ≤ S_fast — the (grade, distance) antichain. v0
  mechanizes pure Kraft; the size refinement falls out when heads
  are literally mounted in a fast-state block.

## 3. Theorem targets

1. *Streaming at a distance*: the scan/zip/copy bounds survive
   with factor (1 + d) — e.g. zip at d = 2 per head
   (Kraft: 3·2^(−2) = 3/4 ≤ 1, the convo's own worked example
   [59]).
2. *Entropy bound* ([57]): touch frequencies p, distances
   dᵢ = ⌈log 1/pᵢ⌉ → cost ≤ n·(H(p) + 1); matching Shannon/Kraft
   lower bound: no distance assignment beats the empirical entropy
   per touch. (Precedent: biased search trees, Bent–Sleator–Tarjan;
   adaptive distance assignment via dynamic Huffman reweighting is v3.)
3. *The Kraft-vs-cliff witness* ([57]'s honest retraction, upgraded
   to a theorem): k-way merge under Kraft distances costs n log n for
   every k — the tradeoff cancels exactly, so the model provably
   does NOT award the external-memory multi-way win. This is the
   sharpest statement of the missing eviction/capacity axis, and
   proving it keeps us honest: Kraft pricing never under-charges
   ([938]: pessimism is the right failure mode for a verifier).
4. *√-latency variant*: under c(ℓ) = 2^(ℓ/2), random access costs
   Θ(√N) and streaming stays amortized O(1)-per-leaf up to the
   level-price sum — the physical-lore pricing as theorems.

## 4. Remaining taste calls

1. (was rev 1's q1/q3/q4 — all resolved by Mathijs: aligned
   window picture; eviction = up, in-model; down fills, no separate
   refill charge.)
2. **Level-price scope**: mechanize the c ≡ 1 distance model first and
   state the √-variant (target 4) desk-level, or mechanize the
   general c(ℓ) machinery at once? — rec: c ≡ 1 first; general
   c(ℓ) is a re-parameterization of one lemma layer, cheap to add
   after the distance layer exists. (This replaces rev 1's
   "two-axis tower" question, which dissolves: the Kraft budget is
   normalized to 1, no separate fast-memory grade in v0.)
3. **[72] stays open, now precisely**: zip's write head — equal
   *touch* frequency says d = 2 like the readers ([59]); double
   *data* rate says a bigger share. The tension is exactly
  touch-frequency distances vs size-aware distances (§2 last bullet),
  so the answer belongs to the size-aware refinement, not to v0 guesswork.
   — rec: record, defer to the size-aware distance refinement in v1.

## 4b. The dirty-up refinement (Mathijs musing, 2026-08-10 — open)

With free `up` (AIP-2 amendment), `down` = fill and `up` = commit:
a *clean* up is a free discard, a *dirty* up (writes below since
the descent) would pay a write-back and propagate dirtiness to the
parent. Machinery: a dirty marking on nodes; total write-back cost
of a written region ≈ its size — sound. Payoff worth weighing:
under dirty-up pricing, zip's write head pays its ups while the
read heads don't — the read/write asymmetry of real hierarchies
falls out of the base machine, and **[72] may resolve here rather
than in the distance layer** ("writes twice the data" becomes "pays
write-backs"), no Kraft choice needed. Pricing principle behind
the whole family: free is admissible exactly for
potential-consuming operations (up consumes depth); read/write/
down can repeat in place and must stay paid. Status: Mathijs
thinking it over; the unconditional-free-up retrofit lands first
(it is the read-only fiber of this model, nothing is thrown away).

## 5. Sequencing

Mechanization track (after Mathijs reads this rev): the 1 + d cost
on action words + Kraft feasibility + distance-aware
streaming (target 1), then entropy bound (target 2), then the
cliff witness (target 3). Independent of the expositions/receipts
line.
