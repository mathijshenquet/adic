# Roadmap: the berries and their sequencing — rev 2

Rev 2 (2026-08-10): refreshed after B2 completed and B4 phases 1–2
landed; folds in the Shannon programme
(`aips/draft/shannon-programme.md`) and the decisions of 2026-08-10
(slots 1–3, Euclidean variants, dirty-model direction).

## 1. The problem

The project has many individually exciting outputs but no ordering.
This AIP names the target outputs ("berries", session 2026-08-09),
their dependency structure, and a sequence, so tracks can be cut
against it instead of re-derived per session.

## 2. The berries — status

Landing dyadic-machine-v0 was the trunk; it is landed and
mechanized.

- **B2 — the theorem trio. DONE** (2026-08-10): streaming,
  random access + optimality, locality composition, RAM
  simulations in *both* directions (target 3 closed). 32 receipts;
  Expo 1 carries it fully lean-backed. By-product decision still
  open: standalone machine-model paper (q2 below, now ripe).
- **B4 — Kraft/distance accounting. Phases 1–2 DONE**
  (kraft_iff_mounting both directions, distance zip, entropy
  achievability + Gibbs converse; Expo 2 "Heads at a distance").
  Remaining: phase 3 cliff witness (needs k-way merge machinery +
  cache-v0 call 2), size-aware distances (v1), [72] — which may
  resolve in the dirty layer instead (cache-v0 §4b).
- **B4′ — the Shannon programme** (new, successor line to B4):
  the entropy pair is the source coding theorem; the programme is
  the *combinatorial half of information theory, mechanized*
  (shannon-programme §7). Concrete berries: move 1 (block-adaptive
  re-mounting = entropy rate — SLOTTED), move 2 (universal
  mounting), the C = 1 paragraph (free), Campbell/Rényi under
  level prices (with the Euclidean variants below).
- **Geometry variants** (decided 2026-08-10): after the C = 1
  identity, do the Euclidean variants *immediately* — c(ℓ) =
  2^(ℓ/2) and 2^(ℓ/3) (k = 2, 3) as first-class model variants
  next to c ≡ 1, not a distant v1 nicety. The level-price dial is
  a choice of ambient dimension (hyperbolic at c ≡ 1, k-Euclidean
  at 2^(ℓ/k), fractal at non-integer exponent); folklore anchors
  in shannon-programme §2.
- **Dirty model** (direction endorsed by Mathijs 2026-08-10 — the
  cocycle reading stays categorically clean and buys cohomology):
  design questions collected in `aips/draft/dirty-cocycle.md`;
  mechanization targets are Expo 3's three badge claims. Pricing
  details stay a Mathijs call (cache-v0 call 2).
- **B3 — a checked complexity claim on ordinary-looking code.**
  Unchanged horizon deliverable — needs the calculus and a minimal
  elaborator; B2 and B4 now tell us what the demo should claim.
- **B6 — the strong claim.** Thesis of the monograph; its evidence
  is B2 (done), B4 (largely done), and the **empirical berry —
  SLOTTED**: Rust microbench of discriminating cases
  (pointer-chasing vs streaming) against model predictions, plus
  the dimension measurement: the log-log latency/capacity slope of
  a real memory hierarchy estimates the machine's ambient
  dimension (expected between 2 and 3; shannon-programme §2).
- The **live paper** with its claims ledger remains the basket;
  the expo series is its front-porch and already carries the
  receipt mechanism.

### Worked-examples ladder

1. **zip** — DONE (mechanized, incl. distance zip + [59]).
2. **FVec push/copy** — DONE (copyWord, doubling copy closed form).
3. **mergesort** — SLOTTED: desk-proved honest cost
   (Θ(N·w·log N) bit-cost) as a badged expo/ledger entry first;
   Lean later.
4. **transpose** — queued (desk-level layout/boundary-spike study).

Calculus-tier (deferred): splay, union-find, path-copying RB tree,
real-time queue.

## 3. Sequence (current slots, decided 2026-08-10)

1. **Shannon move 1** — block-adaptive re-mounting achieves the
   entropy rate. Claude designs the statement + lemma ladder, sol
   executes. Flagship next theorem.
2. **Mergesort ledger entry** — desk-first per the ladder;
   terra-shaped after a short spec. Independent axis, runs
   parallel to 1.
3. **Empirical berry** — Rust bench + dimension measurement;
   sol-shaped after design. Rust earns its place here.
4. Then: C = 1 paragraph bundled into the Expo 2 correction round;
   Euclidean variants k = 2, 3 (+ Campbell/Rényi as their entropy
   story); dirty-model design → mechanization track (Expo 3's
   badges).

Blocked on Mathijs: cache-v0 call 2 (unlocks phase 3 cliff +
dirty pricing details); Expo 1+2 corrections; Letter 2 closing
question; veto 5/7.

## 4. Open questions

1. **Lean-first?** RATIFIED (2026-08-09; spike landed same day).
   The executable Lean definition doubles as the simulator; Rust
   enters with the empirical berry (slot 3).
2. **Standalone machine-model paper:** cut early, or keep as
   monograph chapters? The stated decision point ("after theorems
   1–2 are mechanized") is passed — **ripe for Mathijs**.
