# Roadmap: the berries and their sequencing

## 1. The problem

The project has many individually exciting outputs but no ordering.
This AIP names the target outputs ("berries", session 2026-08-09),
their dependency structure, and a sequence, so tracks can be cut
against it instead of re-derived per session.

## 2. The berries

Landing dyadic-machine-v0 is not a berry but the trunk: every berry
below
consumes its artifacts (the machine definition, the mechanization,
the cost lemmas).

- **B2 — the theorem trio.** dyadic-machine-v0 §3's targets: streaming
  O(1), random access at depth, honest-log simulations, locality
  composition. Cheapest berry, most juice; everything downstream
  consumes it. By-products: paper chapters 1–2, optionally a
  standalone machine-model paper.
- **B4 — Kraft/cursor-weight accounting** (convo [55], [57]). The
  seam between the alloc-less TM-like model and the multi-cursor +
  alloc model that sits pleasingly close to real machines. Statable
  at machine level (weighted heads, fast-state budget) — needs B2's
  machine, not the calculus or an elaborator. Highest novelty per
  unit work; known open-theory risk (write-head weighting, convo
  [72]–[73]).
- **B3 — a checked complexity claim on ordinary-looking code.** "The
  compiler proved my complexity claim": direct-style mergesort or
  transpose with an optional `@ O(n log n)` annotation the checker
  accepts or turns into a precise goal. Longest pole — needs G, the
  capability calculus, a minimal elaborator. Horizon deliverable:
  dated, not dropped; B2 and B4 tell us what the demo should claim.
- **B6 — the strong claim**: the graded hierarchical machine is the
  *right* abstract model for reasoning about computation. Not a
  separate deliverable but the thesis of the monograph; its evidence
  is B2 (robust and honest — the log lives where RAM lies), B4
  (correspondence with real machines: cursor pressure ≈ registers /
  cache lines), and an **empirical berry**: a few discriminating
  cases where the model predicts real performance better than RAM
  does (pointer-chasing vs streaming is the classic). Small and
  cheap once a simulator exists; rhetorically outsized.
- The **live paper** with its claims ledger (desk-proved /
  simulator-checked / mechanized) is the basket, not a berry — per
  the paper AIP.

### Worked-examples ladder (2026-08-09)

The convo's discriminating examples, split by axis: their *cost*
side is cheap now (programs written directly as machine words; the
bounds are corollaries of B2's lemmas) and stress-tests AIP-2 before
the calculus exists; their *correctness* side waits for the calculus
(decode maps are what it is for — raw-machine correctness proofs
would be redone).

1. **zip** (convo [52]–[59]) — first real machine program with a
   proven cost bound; first genuine use of theorem 4 (two input
   heads + write head); feeds B4's write-head question [72].
2. **FVec push/copy** ([14]–[21]) — telescoping doubling copy;
   also a two-stream program.
3. **mergesort** — desk-proved honest cost (Θ(N·w·log N) bit-cost)
   in the ledger first; Lean later.
4. **transpose** — desk-proved layout/boundary-spike study; ledger
   first.

Calculus-tier (deferred, do not start at machine level): splay,
union-find ([22]–[35]), path-copying red-black tree, real-time
queue ([37]).

## 3. Recommendation (sequence)

1. **Land dyadic-machine-v0** — the remaining taste calls (name is
   decided: the dyadic machine, D_n) plus the designed-for-proof
   addendum (§5 there). Everything waits on this.
2. **In parallel after landing:** mechanize the machine definition
   plus theorems 1–2 in Lean (straight structural inductions);
   desk-prove the simulation theorems with ledger status; start the
   paper skeleton and claims ledger (per the paper AIP: chapter 1
   transcribes the machine AIP).
3. **Branch B first, deliberately off the "logical" order:** the
   multi-cursor/alloc layer + Kraft accounting (B4) and the
   empirical berry, *before* the full calculus branch toward B3.
   Rationale: highest novelty per unit work, no elaborator needed,
   and B2 + B4 + empirics already carry the strong claim — a
   publishable story while the calculus grows. Hedge: if B4 stalls
   on open theory, falling back to the calculus branch is loss-free
   because step 2's artifacts are already done.

## 4. Open questions

1. **Lean-first?** RATIFIED (2026-08-09: Mathijs ordered the Lean
   spike as this chunk's deliverable; spike landed green same day —
   see `.dev/specs/lean-spike.md` and `lean/Adic/Dyadic.lean`:
   theorems 1–2 mechanized, core axioms only). The executable Lean
   definition doubles as the simulator (`#eval` at small grades);
   Rust earns its place when the empirical berry needs throughput.
   devenv carries `pkgs.lean4`; `lake build` joined the gate.
2. **Standalone machine-model paper:** cut early, or keep as
   monograph chapters until B2 is done? — rec: decide after theorems
   1–2 are mechanized; no work is lost either way.
