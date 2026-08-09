# adic work log

## 2026-08-09 (late night) — zip green, merged; fvec launched; Letter 2

- `track/lean-zip` (sol, 14 min, 440 lines): zip as oblivious
  schedule exactly per spec — `interleave` semantics with readable
  `leafBits` lemma, shape-independence via `OperationShape` (write
  bits collapsed, so "oblivious" is a theorem, not a remark), exact
  cost `20·2^n − 12`, correctness over arbitrary initial output with
  heads returned to start. Re-verified independently (clean rebuild,
  five theorems core-axioms-only, zero sorry); merged (`60eff47`).
  Ladder step 1 done.
- Letters are now Typst (Mathijs: "al stukjes formalized proza
  math"); Letter 1 converted + compiles; gate includes letters.
  Paper draft deferred to `aips/deferred/` earlier tonight.
- Launched `track/lean-fvec` (spec `.dev/specs/lean-fvec.md`):
  streaming copy as oblivious schedule + the telescoping doubling
  bound — ladder step 2, the machine half of FVec's amortized push.
- Letter 2 written: "The bilimit, refused" — Smyth–Plotkin
  limit-colimit coincidence + Freyd algebraic compactness +
  Fiore/partial maps as the categorical mechanism of the extensional
  collapse ([0]–[3]); domain theory as adic's image under cost
  erasure; cost-grading as the obstruction keeping Ind and Pro
  apart (theorem-shaped: no cost-bounded cone over the projection
  chain). Sparked by Mathijs's limits question.
- **Open with Mathijs**: roadmap q2; Letters 1–2; veto window 5/7.

## 2026-08-09 (night, cont.) — paper draft deferred into letters

- Mathijs: with AIP-3, the paper draft's calls dissolve/defer — he
  writes the paper himself when it's time. `aips/draft/paper.md` →
  `aips/deferred/paper.md` (annotated); the intended chapter
  structure now lives as the prospective index in
  `letters/README.md`; AIP-3 records the disposition. The three
  paper calls leave Mathijs's queue.
- **Open with Mathijs** (current): roadmap q2 (machine-paper
  timing), Letter 1, veto window 5/7.

## 2026-08-09 (night) — lean-machine green, merged; zip launched

- `track/lean-machine` (sol, 28 min, 1604 lines): full machine
  (action layer as costed monoid action + finite control above it;
  read-branching; no inter-head observation *by construction* — the
  Instruction type can't express it), theorem 4
  (`disjoint_subtree_interleaving`: result+cost invariant under all
  interleavings of region-confined words, shared memory, semantic
  ConfinedOperation — not trivialized), tree metric
  (|a|+|b|−2|LCP|) with lower bound over all runs, realizability,
  and `random_access_optimal`. Orchestrator re-verified: clean
  rebuild exit 0, five theorems core-axioms-only, zero sorry,
  statement fidelity read. Merged (`ca38486`).
- AIP-2's theorem targets 1, 2 (both directions) and 4 are now
  MECHANIZED; target 3 (simulations) deliberately deferred per §5g.
- **AIP-3 accepted**: `letters/` precursor genre; Letter 1 written
  (streaming = odometer). Drive-progress imported with composix
  semantics into CLAUDE.md; worker out-clause standing rule added.
- Model table: sol Lean datapoint recorded + deployed (nh home
  switch).
- Next launched: `track/lean-zip` (spec `.dev/specs/lean-zip.md`) —
  zip as oblivious schedule (data-indexed word, provably
  data-independent shape/cost), correctness vs `interleave`, cost
  closed-form ≤ c·2^n. The uniformity/end-detection seam (convo
  [15]) is explicitly out of scope and journaled for a future AIP.
- **Open with Mathijs**: paper.md (3 calls); roadmap q2; Letter 1
  awaits his read; veto window on 5/7 still open.

## 2026-08-09 (evening) — lean-spike green, merged; Lean-first ratified

- Calibration spike (sol, `track/lean-spike`, spec
  `.dev/specs/lean-spike.md`): Lean 4.30 into devenv, lake project
  `lean/`, D_n movement core (paths, zipper cursors, Option-partial
  moves, words, cost = length) + theorems 1–2 mechanized in **11
  minutes**, zero sorry, core axioms only. Streaming statement is the
  strong form: exact left-to-right leaf-visit list, so "each leaf
  exactly once, in order" is machine-checked; cost closed-form
  `cost(euler n) + 4 = 4·2^n`. Monoid-action lemmas (`run_append`,
  `runTrace_append`) landed per AIP-2 §5a.
- Orchestrator re-verified independently before merge: clean rebuild
  exit 0, axiom check, sorry-grep, statement fidelity read. Merged to
  main (`185ab2a`), main gate green.
- **Calibration verdict**: sol's Lean proficiency confirmed strong
  (fast, faithful statements, honest receipts + friction journal);
  Claude's Lean review loop works (statement-fidelity read + own
  rebuild). Lean-first RATIFIED in roadmap draft (Mathijs ordered the
  spike as chunk deliverable). Gate updated in AGENTS.md: `lake
  build` is in.
- Process friction (minor, recorded): herdr first-prompt swallowed
  (known); `agent start` needs >70s retry window while direnv builds
  a new devenv env; sol read a landing-check literally and stopped —
  re-prompt fixed it.
- Next (running): `track/lean-machine` — full machine (finite
  control, k heads, no inter-head observation, read/write) + theorem
  4 (disjoint-subtree commutation) + tree-metric lower bound, sol in
  the same warm pane.
- **Open with Mathijs**: `aips/draft/paper.md` (3 calls); roadmap q2
  (standalone machine paper timing — its precondition "theorems 1–2
  mechanized" is now met); veto window on taste call 5 (stuck) and
  the leaf-order convention (q7, delegated).

## 2026-08-09 (later) — dyadic machine lands

- **AIP-2 accepted**: the dyadic machine D, D_n per grade
  (`aips/accepted/0002-dyadic-machine-v0.md`). All seven taste calls
  decided (Mathijs; leaf-order delegated to Claude): bits at leaves,
  k heads fixed per program with no inter-head observation,
  internal-node rest allowed, stuck semantics, no swap in v0,
  two-layer leaf-order convention (tree-order numbering for
  metatheory, little-endian data layout). Designed-for-proof
  addendum (§5) added same day: monoid-action presentation,
  recursive memory T(n+1)=T(n)×T(n), cost via tree metric,
  closed-form totals. Odometer insight recorded at theorem 1:
  streaming = adding-machine fact, kinship with Vershik.
- Name scan done (H-machine rejected, adic machine soft-rejected);
  "adic" stays the language/discipline name.
- New draft in inbox: `aips/draft/roadmap.md` — berries + sequencing;
  asks ratification of Lean-first (Lean def doubles as v0 simulator).
- Standing grant recorded in CLAUDE.md: commit+push to main for
  AIP/docs/LOG work without asking. Gitsitter-amend pitfall recorded
  there too.
- **Open with Mathijs**: roadmap draft (ratify Lean-first + machine
  paper timing), `aips/draft/paper.md` (3 calls).
- **Open for agents**: once Lean-first is ratified — Lean toolchain
  into devenv, then mechanize D_n + theorems 1–2 per AIP-2 §5.

## 2026-08-09 — project born

- Founding conversation imported from claude.ai ("Dependently typed
  language over idealized computation models", 56 messages, indices
  sparse to [73]) → `docs/convo.md`; terra wrote `docs/convo-summary.md`.
- Process adopted from composix: AIPs (`aips/README.md`), `.dev/LOG.md`
  journal, `.dev/specs/`, track/worker conventions in `AGENTS.md` +
  `CLAUDE.md`.
- **AIP-1 accepted**: the language is called **adic** (repo moves
  `~/nextlang` → `~/adic`). Prototype language: Rust (Mathijs's call,
  same session).
- Drafts in inbox: `machine-v0` (the dyadic machine — spec,
  prior work, theorem targets, 6 taste calls), `paper` (organizing
  thesis-length artifact, Typst, claims ledger).
- devenv (rust + typst + cargo-watch + jq) built green.
- Rename executed (`~/adic`); founding commit pushed to the public
  repo `github.com/mathijshenquet/adic` (Mathijs's call, same
  session). `docs/convo.json` checked before publishing: first name +
  uuids only, no e-mail.
- Session restarts in `~/adic` after this entry; next session starts
  at the CLAUDE.md session ritual (this LOG's top entry).
- **Open with Mathijs**: read `aips/draft/machine-v0.md` (6 taste
  calls) and `aips/draft/paper.md` (3); standing commit/push/merge
  grants for this repo (this push was a one-off instruction).
- **Open for agents**: nothing until machine-v0 lands (then: simulator
  track).
