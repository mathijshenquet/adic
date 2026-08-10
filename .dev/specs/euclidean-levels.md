# Track: euclidean-levels — level prices in Lean (macro-level route, k = 2, 3)

Worker: gpt-5.6-terra, herdr worktree, branch `track/euclidean-levels`.
LOG.md at worktree root; first action: add it to `.git/info/exclude`,
verify with `git check-ignore LOG.md`. Append-only, timestamped,
synchronous receipts only. Friction journal as always.

**The out:** problems or ambiguity > ~30 min on any rung →
wall-report that rung honestly, land the rest. The converse rung
is EXPECTED to be hard; an honest wall there is a fine outcome.

## Context

Decided (cache-v0 §5): the Euclidean variants c(ℓ) = 2^(ℓ/2),
2^(ℓ/3) are first-class model variants. The design is COMPLETE in
`aips/draft/campbell-renyi.md`: §4.2 gives the exact all-natural
macro-level formulation (rational t = a/b: group b binary levels,
macro-distance e, Kraft mass Σ 2^(−b·e_i), moment Σ m_i·2^(a·e_i),
integer floor/ceiling escort roots, denominator-cleared Hölder
converse), §9 gives the six-rung Lean ladder — follow that ladder;
this spec only fixes housekeeping. Read §4.2 and §9 carefully
before writing code. Everything stays in ℕ — no reals, no Int in
statements (exchange-form house style, AIP-5 §1B).

## Deliverable: `lean/Adic/Levels.lean` (new file; import, don't edit, existing modules)

1. Rungs 1–4 of the report's §9 ladder (macro Kraft arithmetic;
   integer roots; escort weights and distances; achievability),
   for general rational t = a/b, instantiated at t = 1/2 and
   t = 1/3 (the k = 2, 3 machines) with one concrete worked
   example each (three heads, simple counts — the report's §5
   numbers are your test vectors; verify against them and log
   any discrepancy loudly).
2. Rung 5 (denominator-cleared natural Hölder converse): attempt;
   the report names it the hard rung. Land whatever sub-lemmas
   are honestly green; wall the rest precisely.
3. **Streaming boundary lemma** (campbell report §7.1's criterion,
   the part that is pure ℕ): for the macro model at t = a/b < 1,
   prove the sweep bound that makes streaming amortized O(1) per
   leaf (the geometric sum against 2^(−ℓ) converges — state the
   exact ℕ inequality for the concrete t = 1/2 case at minimum).
4. **Receipts**: add main theorems to `expo/receipts-manifest.txt`
   (at the end, minimal conflict surface), regenerate
   `receipts.json` (`lake exe receipts` exit 0, synchronous).
   No expo prose edits (a later Claude pass writes the expo).

## Out of scope

Real-number formulations; the ℕ[2^(1/k)] coefficient ring (design
direction recorded in LOG, activates in a later track — the macro
route needs no new coefficients); dirty model; expo prose; any
edit to existing lean modules (imports only; NOTE two parallel
sol tracks also touch aips/draft/ — you touch only lean/ and the
manifest, so no conflict axis).

## Gate

`lake build` (zero sorry; `#print axioms` on new theorems core
only), `lake exe receipts` exit 0, `lake exe sim` still PASS,
every expo/letter still compiles, cargo gate still green
(`cargo fmt --check`, clippy -D warnings, `cargo test`).
Synchronous receipts in LOG. Commit on the track branch only.
