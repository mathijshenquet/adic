# Track: lean-machine — the full dyadic machine + theorem 4 + metric lemmas

Worker: gpt-5.6-sol via codex, continuing in the lean-spike pane
(warm context). Branch: create `track/lean-machine` off local `main`
(`git switch -c track/lean-machine main`) — main now contains your
merged spike. Same LOG.md discipline as before (it is already
excluded); append, don't restart.

## Context

- `aips/accepted/0002-dyadic-machine-v0.md` §3 (definition), §4
  (all decisions, incl. §4.7 leaf-order) and §5 (proof-design). Your
  `lean/Adic/Dyadic.lean` movement core is the substrate — extend,
  reuse, refactor where it helps; don't fork a parallel hierarchy.

## Deliverable

Extend the mechanization to the full machine and two more theorem
groups, in the same lake project.

1. **The machine** (AIP-2 §3): memory `Tree n` with bits at leaves;
   a program P = finite control: state type (finite), k heads (k
   fixed by P), transition table over the instruction set `up |
   down0 | down1 | read | write0 | write1 | halt`, each instruction
   addressing exactly one head. `read` branches the control on the
   bit under the addressed head (must be at a leaf). The transition
   function observes ONLY (control state, addressed head's local
   observation) — no inter-head observation (§5c). Step is partial
   (Option): boundary moves and read/write off-leaf are stuck.
   Config = control state × head positions × memory. Cost = step
   count. Keep the word/monoid-action presentation for the
   head+memory action (§5a); control flow sits above it.
2. **Theorem group C — locality composition (AIP-2 §3 target 4).**
   At the action level (straight-line words of head-addressed
   operations, control aside): operations addressing different heads
   whose focus stays confined to disjoint (prefix-incomparable)
   subtrees commute — the diamond/trace-monoid lemma — and
   consequently result and cost of such a word are invariant under
   any interleaving that preserves per-head order. State it so the
   disjointness hypothesis is explicit and checkable; don't smuggle
   in "the heads never interact" as an assumption that trivializes
   the theorem.
3. **Theorem group D — tree-metric cost (AIP-2 §5d).** Define tree
   distance between positions (via the longest common prefix). Prove
   both halves for single-head movement words:
   - lower bound: any word moving a head from position a to b has
     cost ≥ dist(a, b);
   - realizability: there is a word of cost exactly dist(a, b)
     (up to the LCA, down the other side) that does it.
   This retroactively completes theorem target 2 (the depth cost of
   random access is optimal).
4. **Quality gate** — as before, synchronous receipts in LOG.md:
   fresh-shell clean `lake build` exit 0; zero sorry; `#print
   axioms` for the main theorems (core axioms only); statements
   readable stand-alone.

## Process

Same as lean-spike: commit small on the track branch, never touch
main; LOG.md current with timestamps, receipts, and the friction
journal (AIP ambiguities you hit while formalizing the full machine
are especially valuable — they feed the AIP/paper).

If the full-control layer (1) turns out to fight the action-level
theorems (2–3), prioritize: machine definition correct and building,
theorem group D complete, theorem group C at least for the two-head
case. An honest wall report on C beats a weakened statement.

## Out of scope

Simulation theorems, Kraft/weighted cursors, `#eval` simulator
ergonomics, paper text, mathlib.
