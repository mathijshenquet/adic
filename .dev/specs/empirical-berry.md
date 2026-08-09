# Track: empirical-berry — the model vs real hardware (Rust enters)

Worker: gpt-5.6-sol, herdr worktree, branch `track/empirical-berry`.
LOG.md at worktree root; first action: add it to `.git/info/exclude`,
verify with `git check-ignore LOG.md`. Friction journal as always.

**The out:** problems or ambiguity > ~30 min → say so and stop.
Measurement noise you cannot tame is a finding, not a failure —
report it honestly.

## Context

Roadmap B6's empirical berry: a few discriminating cases where the
dyadic machine's cost model predicts real performance *shape*
better than the flat-RAM model does. Plus the new dimension
measurement (shannon-programme §2, folklore anchors): the log-log
latency-vs-capacity slope of a real hierarchy estimates the
machine's ambient dimension s in the c(ℓ) = 2^(ℓ/s) dial
(expected 2–3). This track introduces Rust to the repo.

## Deliverable

1. **Cargo workspace**: top-level `Cargo.toml` (workspace) +
   `bench/` crate. Keep it minimal: std only if you can (a
   hand-rolled timer around `std::time::Instant` beats a criterion
   dependency for our purpose; your judgment, log it). Note in
   the LOG which gate commands now apply (AGENTS.md: fmt, clippy
   warning-denied, test).
2. **Benchmarks** (each: working-set sizes swept 2^12..2^30 bytes,
   multiple reps, median-of-runs, results to `bench/results/*.csv`,
   committed):
   - *pointer-chase*: dependent random walk over a
     permutation-cycle array (the classic latency probe);
   - *streaming*: sequential sum over the same footprints
     (throughput per element);
   - *write asymmetry*: sequential fill vs random single-cache-line
     writes over the same footprint (the dirty-coalescing shadow).
   Document CPU model, frequency-scaling caveats, and what you
   could not control (this is a laptop measurement, not a lab —
   honesty over polish).
3. **Analysis + report** `aips/draft/empirical-berry.md` (+ PDF
   per the AGENTS.md pandoc recipe):
   - fit the latency-capacity slope on the log-log pointer-chase
     curve (piecewise: within-cache plateaus + the envelope);
     report the envelope exponent → the empirical dimension
     s = 1/slope, with the fit's honesty caveats;
   - streaming vs pointer-chase divergence: show the flat-RAM
     model predicts a constant ratio, the dyadic model predicts
     the observed divergence shape (O(1)/leaf vs depth-priced);
     keep claims qualitative where the data is qualitative;
   - write asymmetry: report the measured seq/random gap next to
     the sparse–dense prediction (aips/accepted/0005 §8);
   - a closing "what would falsify the model" paragraph — say
     what shape would have contradicted us.
4. **Gate**: `cargo fmt --check`, `cargo clippy -- -D warnings`,
   `cargo test` (add at least a smoke test that the bench
   harness runs a tiny sweep), all synchronous, receipts in LOG;
   `lake build` and expos untouched but verify they still pass
   before commit.

## Out of scope

Any Lean; any model changes; tuning benchmarks to flatter the
model (report what you measure). Commit on the track branch only.
