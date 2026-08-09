# Track: lean-ram-reverse — RAM simulates D (the other direction)

Worker: gpt-5.6-terra via codex, reuse the eval-harness pane/
worktree: `git switch -c track/lean-ram-reverse main`. LOG.md
discipline as before (append to your existing worktree LOG).

**The out:** problems or ambiguity > ~30 min → say so and stop.
This is the hardest track cut so far; a precise wall report on any
sub-step is a fully valued deliverable. Receipts stay SYNCHRONOUS
exit statuses — paste command + exit code.

## Context

AIP-2 §3 target 3, remaining direction: "RAM simulates M_n with
constant-factor overhead". `lean/Adic/Ram.lean` has the minimal
word RAM (setAddress/load/store + successor/comparison) used for
the other direction. Simulating D's moves needs address doubling/
halving (child = 2a+b, parent = a/2), which that instruction set
lacks.

## Deliverable

1. **Extend the RAM minimally**: add double/halve (or shift)
   instructions to `RamInstruction` — justify in a comment why
   these are standard word-RAM operations (shifts), keep the set
   minimal. Re-verify the existing forward-direction theorems still
   build unchanged (they should — new constructors, untouched
   cases... if the extension breaks existing proofs, fix them
   mechanically, and record the friction).
2. **Representation**: a D-configuration (grade n, k heads, memory)
   as RAM state: memory tree as 2^n-word... your judgment — the
   natural choice is leaves as words (or bits packed; simpler is
   fine, constant factors are existential), head positions as
   address words with a depth marker.
3. **Per-move simulation lemma**: each D action-step (up/down/read/
   write on the addressed head) is simulated by a CONSTANT number
   of RAM instructions — state the constant existentially
   (`∃ c, ∀ …, ramCost … ≤ c`), prove per instruction case.
4. **Program-level lift** (only if the per-move lemma lands with
   time to spare): a D action word of cost T simulates in RAM cost
   ≤ c·T. The per-move lemma is the real content; land it alone if
   the lift threatens the box.
5. **Quality gate** — as always: fresh clean build + `lake exe
   receipts` + `lake exe sim` all exit 0 synchronously; zero sorry;
   core axioms only; letters + demo compile; add landed theorems to
   the receipts manifest and regenerate.

## Out of scope

Finite-control (machine-step) simulation — action words suffice for
v0; optimal constants; TM simulations; weighted costs.
