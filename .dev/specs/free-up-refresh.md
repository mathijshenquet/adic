# Track: free-up-refresh — land the parked free-`up` retrofit on post-rename main

Worker: gpt-5.6-terra, herdr worktree, branch `track/free-up-refresh`.
LOG.md at worktree root; first action: add it to `.git/info/exclude`,
verify with `git check-ignore LOG.md`. Append-only, timestamped,
synchronous receipts only.

**The out:** problems or ambiguity > ~30 min → say so and stop. An
honest wall report is a valued deliverable, never a failure.

## Context

AIP-2 §3 is AMENDED (accepted): `up` costs 0, everything else 1
("cost = address bits acquired"). Sol implemented the full retrofit
on branch `track/lean-free-up` (commit `3c0149f`, 2026-08-09) —
content spec in `.dev/specs/lean-free-up.md`, read it. That branch
predates the weight→distance rename and is now stale: it edits
`lean/Adic/Weighted.lean`, which main renamed to
`lean/Adic/Distance.lean` (with `weightedCost`→`distCost`,
`Weights`→`Dists`, `uniformThreeWeights`→`uniformThreeDists`,
`empiricalWeights`→`empiricalDists`). Your job: bring the retrofit
onto current main and make the gate green.

## Deliverable

1. Rebase/cherry-pick `3c0149f` onto main (or re-apply its diff by
   hand where git can't follow the renames — your judgment, log
   the method). The parked commit is the semantic reference: the
   result must contain its content adjusted to the renames, no
   silent drops. `git diff main...HEAD` reviewed against
   `git show 3c0149f` at the end; note any deviation in the LOG
   with a reason.
2. Regenerate receipts (`lake exe receipts`, synchronous exit 0)
   — statement hashes WILL move for retrofitted theorems.
3. Expos: `expo/01-the-dyadic-machine.typ` and
   `expo/02-heads-at-a-distance.typ` pin receipt hashes; update
   pins to the new hashes AND update any prose that cites now-
   changed constants (e.g. the streaming closed form loses its
   factor 2 — the old `4·2^n` Euler bound becomes the tightened
   form; say what the theorem now says, honestly). For EVERY
   changed pin, record old and new formal statement side by side
   in your LOG — the orchestrator re-reads all pairs at merge
   (AIP-4: your re-pin is provisional).
4. If `lake exe sim` checks costs against closed forms, its
   expectations move too — the parked branch already touched
   `lean/Sim.lean`; carry that over and re-verify.
5. **Gate**, all synchronous, receipts in LOG: `lake build` (zero
   sorry; `#print axioms` core only), `lake exe receipts` exit 0,
   `lake exe sim` PASS, every `expo/*.typ` and `letters/*.typ`
   compiles.

## Out of scope

Any new theorem beyond the parked branch's content; the dirty
model; cocycle machinery (a follow-up track builds on this one);
touching `letters/` prose. Commit on the track branch only.
