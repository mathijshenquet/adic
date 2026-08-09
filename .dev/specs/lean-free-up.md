# Track: lean-free-up — retrofit the free-`up` cost amendment

Worker: gpt-5.6-sol, same pane. Branch:
`git switch -c track/lean-free-up main`. Same LOG discipline.

**The out:** problems > ~30 min on any layer → wall-report that
layer, land the rest.

## Context

AIP-2 §3 AMENDED (2026-08-10): `up` now costs 0; all other
instructions cost 1. Rationale in the AIP (amortization safety,
clean-eviction reading, cost = address bits acquired). This track
retrofits the whole mechanization. Read the amendment first.

## Deliverable

1. **Cost function**: replace length-based cost with a per-move
   cost (`Move.cost : up ↦ 0, _ ↦ 1`; same at the action level —
   `up` addressed to any head is free, weighted surcharge in
   Weighted.lean applies only to PAID operations: a weighted `up`
   stays free — document this choice in a comment; it preserves
   "surcharge multiplies acquisitions").
   Keep `cost`/`actionCost` names; homomorphism lemmas survive
   (cost of append = sum).
2. **Retrofit every theorem**, tightening constants honestly:
   - streaming: the Euler bound becomes exact-form ≈ 2·2^n
     (derive the true closed form; the odometer sum Σ(1+v₂(i))
     should now appear on the nose — state it as its own lemma if
     it falls out);
   - random access: cost = n unchanged (descents only);
   - metric layer: the lower bound/realizability pair becomes the
     DIRECTED descent distance |b| − |lcp(a,b)| (define it; the
     old symmetric statements are replaced, not weakened — the
     directed pair is the honest statement now);
   - `random_access_optimal`: still n (all-descent);
   - locality/interleaving: statements unchanged, proofs should
     survive mechanically (cost invariance under permutation still
     holds — cost is a sum of per-op costs);
   - zip/copy/doubling: recompute exact closed forms;
   - RAM both directions: rework constants (existential, so
     statements survive; tighten where trivial);
   - entropy layer: touchCost semantics — decide and document:
     touches here are read/write/down acquisitions; free ups drop
     out of touch sequences (they were movement bookkeeping).
3. **Simulator**: update `lake exe sim` expected closed forms —
   the falsifier must agree with the new proofs.
4. **Receipts**: regenerate — ALL hashes change. That is expected
   and is the point: the expos' pins now fail. DO NOT touch the
   expo `.typ` files (re-reading and re-pinning is the
   orchestrator's job per AIP-4 — the human-re-read step is the
   mechanism working). Your gate for this track is: build +
   receipts + sim green, letters compile, and `typst compile` of
   the expos FAILING with pin mismatches — paste that failure as a
   receipt; it proves the assert layer works.
5. Full gate receipts (minus the expected expo failures) in LOG.

## Out of scope

Expo re-pinning (orchestrator), dirtiness/write-back modeling,
cache-v0 phase 3.
