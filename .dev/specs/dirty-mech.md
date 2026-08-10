# Track: dirty-mech — the dirty model in Lean (call 2 is discharged)

Worker: gpt-5.6-sol, herdr worktree, branch `track/dirty-mech`.
LOG.md at worktree root; first action: add it to `.git/info/exclude`,
verify with `git check-ignore LOG.md`. Append-only, timestamped,
synchronous receipts only. Friction journal as always.

**The out:** problems or ambiguity > ~30 min on any rung →
wall-report that rung honestly, land the rest.

## Context — the pricing is now DECIDED (cache-v0 §4b, 2026-08-10)

- **Eager**: every dirty `up` pays 1 (at c ≡ 1); a node is dirty
  when written below since its fill; `write` marks every non-root
  node on the root-to-focus path dirty (the root owes no parent);
  a `down` fills its target clean... exact event semantics: use
  `aips/draft/local-classes.md` §2.1's dispatcher (Fill /
  WriteBelow / Leave; ParentFill = identity for this observer)
  with the dirty observer of §2.3 (Q = {C,D}, F = L = C, W = D).
- Gauge: mechanize the eager/operational cost as ground truth;
  flush-inclusive statements are a later prose/statement layer,
  not machine semantics. No `commit` operation.
- Sources: AIP-5 §§2, 7 (the COMPLETE padding witness with exact
  counts, and the dirty ≤ 2× clean observation); Expo 3's deskthm;
  `lean/Adic/Cocycle.lean` (IsCocycle / Exchange — phrase
  everything in this API); local-classes §6 (mechanization-ready
  formulation — follow it or simplify to the single dirty
  observer, your judgment, log it).

## Deliverable: `lean/Adic/Dirty.lean` (new file; import, don't edit, existing modules)

1. **Augmented state + dirty cost.** Configurations extended with
   a dirty mark per node; the event dispatcher for the dirty
   observer; `dirtyCost : Word → DirtyConfig → Nat` (eager
   pricing). Prove `dirtyCost_isCocycle` (the word-split lemma,
   same shape as `cost_isCocycle`).
2. **The cheap receipt**: `dirtyCost ≤ 2 · cost + (slack)` in the
   honest exact form (every write-back is an up whose count is
   bounded by downs — AIP-5 §7). Class changes, magnitude doesn't.
3. **Sparse–dense asymmetry** (Expo 3's second deskthm): define
   the sparse walk (m isolated depth-n round trips, write pass +
   erase pass) and the dense walk (block Euler sweep + erase +
   clean right-half padding) as concrete word families; prove
   their exact dirty costs (sparse write-back total 2mn; dense
   Θ(m+n) with the exact constant you derive). AIP-5 §2 has every
   count — treat it as the blueprint; verify its arithmetic and
   report any discrepancy loudly.
4. **Nontriviality (the flagship).** Both walks are closed at the
   same configuration with equal letter counts (padding solvable —
   AIP-5 §2's bookkeeping; formalize the count-equalization).
   Theorem shape:
   `theorem dirty_not_cohomologous (n : Nat) (hn : N₀ ≤ n) :`
   `¬ ∃ prices Φ, Exchange (dirtyCost) (letterCost prices) Φ`
   — at grade n, instantiated via the two witness walks: Exchange
   on both + equal counts + equal endpoints forces equal dirty
   costs, contradicting the computed gap. Pick the smallest
   honest N₀. This turns Expo 3's desk badge green.
5. **Receipts**: manifest entries (at the end; two parallel sol
   tracks touch aips/draft/ only — you own lean/ + manifest),
   regenerate receipts.json. NO expo edits (Claude flips Expo 3's
   badge at merge, with the pin re-read).

## Out of scope

Level prices × dirty (later, after `Levels.lean` matures); write
entropy / box-counting (AIP-5 §8 — own track later); the general
observer-classification machinery (parallel track); gauge/commit
prose.

## Gate

`lake build` (zero sorry; `#print axioms` on new theorems core
only), `lake exe receipts` exit 0, `lake exe sim` PASS, all
expos/letters compile, cargo gate green. Synchronous receipts in
LOG. Commit on the track branch only.
