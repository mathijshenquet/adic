# adic work log

## 2026-08-10 (day 2, close) — classification round 2 MERGED: the local-to-global cocycle theory

- **`track/cocycle-classification` round 2 MERGED** (sol,
  Mathijs-driven, `88d9db6`): the left-subtree embedding yields a
  genuine local-to-global theory. Results: (1) W=P=id observers:
  the ENTIRE tower reduces exactly to two finite one-leaf graphs —
  grade 1 decides all grades. (2) Strongly connected augmented
  graphs: relation lattices form a descending chain; over ℚ always
  stabilizes. (3) **Dirty is strongly connected → its
  nontriviality is uniform over the whole tower** (harvest steer
  landed; agrees with the independently mechanized
  dirty_not_cohomologous n≥1). (4) Warmth is NOT strongly
  connected (hot root-children can never be re-invalidated — the
  root is never re-filled) but stays uniformly nontrivial from
  grade 2 via the direct witness. (5) Permutation observers
  stabilize integrally; torsion index divides the exponent of the
  observer group — the candidate lemma confirmed for that slice.
  (6) ONE remaining wall, precisely named: a uniform
  exponent/saturation theorem for the reachable signed-cycle
  event ledger of general irreversible reset observers; naive
  Noetherian reasoning insufficient.
- Scorecard of the day's steers: left-subtree embedding (Claude)
  → core of the theory; dirty/warmth connectivity harvest → dirty
  yes, warmth no-with-sharp-reason; index-divides-exponent →
  confirmed for permutation observers. Both wall-repairs came
  from the joint conversation loop.
- The cohomology chapter is now paper-shaped: SES + verified SNF
  + local-to-global tower theorems (per slice) + mechanized
  flagship (Expo 3 fully green) + honest priorart positioning.
  Remaining open: the saturation lemma (exotic irreversible
  observers only — no current claim depends on it).

## 2026-08-10 (day 2, cont. 6) — dirty-mech MERGED: Expo 3 is fully green

- **`track/dirty-mech` MERGED** (sol, ~70 min): `lean/Adic/Dirty.lean`
  — augmented dirty configurations + eager pricing per discharged
  call 2; `dirtyCost_isCocycle`; dirty ≤ 2·clean + slack;
  sparse/dense walks as concrete word families with EXACT costs
  (sparse 4mn+2m — AIP-5 §2's arithmetic reproduced on the nose;
  padded dense 2mn+2(n−blockDepth)+6m−4; count-equalization its
  own theorem, not a hypothesis); and the flagship
  `dirty_not_cohomologous (n ≥ 1)` via the classification track's
  short conjugation witness (mid-flight steer paid off — costs
  2n+2 vs 3n+2). 61 receipts. Gate independently re-run green.
- **Expo 3 is now FULLY GREEN**: both remaining desk badges
  flipped to leanthm (pins d1f4f594a35b, b1537829f734 re-read at
  merge). Born as design theory in the morning, every box
  machine-checked by midnight — AIP-4's workflow demonstrated
  end-to-end. *Bandwidth cannot be statically priced* is a
  machine-checked theorem.
- Tower interim (Mathijs relayed from classification r2): the
  left-subtree embedding WORKS — divisible strongly-connected
  slice has an all-grade stabilization theorem; two named missing
  lemmas remain (boundary-fiber reachability/saturation; uniform
  arithmetic index bound). Follow-up steers sent: harvest the
  dirty/warmth tower corollary via strong connectivity; candidate
  lemma "index divides exponent of observer monoid group-part".
- In flight: cocycle-classification round 2 (Mathijs-driven,
  watcher armed).

## 2026-08-10 (day 2, cont. 5) — priorart + classification MERGED; call 2 discharged; dirty-mech in flight

- **cache-v0 call 2 DISCHARGED** (Mathijs + principled analysis):
  eager dirty pricing (forced by up=evict + write-back-cache
  semantics, not a new choice); commit-at-boundaries = gauge
  (same class); `commit`-as-operation → future persistence layer;
  [72] RESOLVED via dirty (Mathijs: "erg elegant"); size-aware
  parked deeper (motivator gone); level scope: both.
  `track/dirty-mech` LAUNCHED (sol): dirty observer in Lean,
  dirty ≤ 2·clean, sparse-dense exact, dirty_not_cohomologous.
  Mid-flight soft-steer sent: use classification's short witness
  pair (eq 20) for nontriviality instead of the padding.
- **`track/euclidean-levels` MERGED** (terra, honest partial):
  macro-Kraft arithmetic, integer roots, k=2 sweep bound, (2,1,1)
  test vectors green — 53 receipts; walls on escort achievability
  + Hölder converse (two missing finite-sum lemmas, named).
- **`track/cost-cohomology-priorart` MERGED** (sol, 17pp):
  verdict — the slogan is NOT new (graph cohomology, weight
  pushing, symbolic dynamics incl. ordered cohomology, gauge
  freedom in thermodynamics, Baues–Wirsching); the potential
  equation is standard amortized analysis; the credible
  contribution is the 5-point bundle (action-category functor
  semantics; priceability-as-factorization; ℕ-positive exchange
  quotient; observer/tower computation; hardware
  identifications). Paper must position accordingly; tower
  theorem is load-bearing.
- **`track/cocycle-classification` MERGED** (sol, 13pp — Mathijs
  restarted the agent for a round 2, worktree kept):
  (1) THE fixed-grade theorem: short exact sequence
  0 → Ext¹(ℤ^Σ/B,ℤ) → Q_G → Hom(K,ℤ) → 0 — scheduling free part
  vs arithmetic torsion part, canonical; every arithmetic
  obstruction is torsion (proved). (2) SNF computation verified
  grades 1–2, all four verdicts reproduced witness-free; found
  rank-5 relation downs−ups = δdepth. (3) **Claude's axiom
  lattice REFUTED with witnesses**: even under all three axioms
  the dirty bit alone has rank THREE (dirty-up, dirty-read,
  redundant-write independent; relation u_D+z_D+o_D = writes);
  idempotence too weak (non-commuting idempotents compose to
  counters, order-2 witness); repair needs a *pricing surface*
  (constrain which events may be priced). (4) Transgression:
  five-term sequence proved for graph covers; visit counter IS
  the H²(ℤ/r) generator; full conjecture needs two
  qualifications (reset observers aren't covers; base H¹ ≫
  letter prices) — replacement: arithmetic classes = count-
  monodromy characters. (5) Tower: named examples stabilize by
  grade 2 (NEW short uniform dirty witness eq 20); ambient H¹
  provably does NOT stabilize (84→6828); equivariant + MV
  attacks fail at a named missing finite-boundary transfer
  object; refined conjecture under commuting-band + pricing-
  surface hypotheses; 12-rung Lean ladder.
- In flight: dirty-mech (sol), cocycle-classification round 2
  (Mathijs-initiated, watcher armed).

## 2026-08-10 (day 2, cont. 4) — Letter 2 RESOLVED: Expo 6 live; euclidean-levels launched

- **Letter 2 closing question RESOLVED by Mathijs**: the
  no-cost-bounded-cone claim becomes a formal theorem target
  ("mooie no-go voor die classical domain theorem"), link to be
  clarified. Claude wrote **Expo 6 "The bilimit, refused"**
  (Letter 2 reformulated per AIP-4 — first letters→expo item
  done): cone asymmetry desk-proved at MACHINE level (free-up
  makes it one line: colimit elements cost finitely many acquired
  bits, limit points infinitely many; pigeonhole for
  no-finite-stage-universality); the ENRICHED no-go (no bilimit,
  algebraic compactness fails in the cost-graded enrichment)
  stays the open calculus-tier target, now sanctioned. Link
  clarified as a triangle: Scott/Smyth–Plotkin/Freyd = cost-erased
  shadow; America–Rutten ultrametric = the limit side kept apart
  (2-adic metric = our tree geometry); adic = diagram + price.
  Parts (i)+(ii) flagged as near-verbatim Lean candidates.
- `track/euclidean-levels` launched (terra): campbell report §9
  ladder rungs 1–5 + streaming-boundary lemma, macro-level
  all-natural route. Watcher + heartbeat armed.
- Roadmap overview given to Mathijs incl. the strategic fork: B4
  branch is essentially harvested; per the roadmap's own logic
  the calculus branch (toward B3) is the next major branch —
  decision put on his stack next to q2.
- **Open with Mathijs** (updated): cache-v0 call 2 (3 real
  decisions: dirty details, [72]-route, phase-3 go); Expo 1+2
  corrections (+C=1); roadmap q2 + calculus-branch fork; s≈2.41
  call; veto 5/7; warmth headline call; operadic product-vs-
  envelope. Letter 2 ✓ resolved.

## 2026-08-10 (day 2, cont. 3) — the breakthrough-candidate framing; two tracks launched

- Design conversation (Mathijs excited, Claude calibrating): the
  candidate claim is *"cost models of a machine form a computable
  cohomology; resources are classes; amortization is gauge;
  hardware phenomena are its structure (bandwidth = free rank,
  invalidation = 2nd free class, recycling granularity =
  torsion)"*. Between us and that claim: (1) the tower/
  stabilization theorem, (2) the ℕ-cone (monoid) refinement,
  (3) honest prior-art positioning — Claude pre-flagged weight
  pushing (Mohri) as adjacent art, plus Parry–Tuncel/Livšic/
  entropy-production cocycles.
- Physical reading found for the "unphysical" mod-r class: flash
  block-erase / nursery GC / log compaction — recycling costs;
  torsion = "amortizable only fractionally"; the ℚ-quotient is
  the industry's write-amplification average. Axiom (1) of the
  lattice re-read as currency-granularity choice, not
  pathology-exclusion.
- Grothendieck framing confirmed for all observer classes:
  augmented configurations = coverings C̃ → C; classification =
  H¹ of coverings; fixed grade = graph cohomology + SNF; counters
  = transgressions of finite monodromy (conjecture); tower =
  local-to-global/sheaf attack.
- LAUNCHED (sol ×2, prompts verified working, watchers +
  heartbeat armed): `track/cost-cohomology-priorart` (honest
  positioning sweep, hallucination-guarded citations) and
  `track/cocycle-classification` (SNF method validating all four
  example verdicts in one computation; axiom lattice both slices;
  transgression conjecture; tower stabilization attack).

## 2026-08-10 (day 2, cont. 2) — local-classes MERGED: the machine's cohomology has torsion

- `track/local-classes` MERGED (sol, ~40 min, 10-page report,
  gate green): the broad-observer classification. General
  machinery: exact edge-feasibility (exchange) system for
  fixed-grade triviality; signed underlying-cycle criterion;
  closed-directed-walk criterion under strong connectivity
  (with the honest catch that irreversible observer state breaks
  the naive shortcut); kernel-vs-integral-extension split.
  Example verdicts, all algebraically checked: first-touch
  TRIVIAL (potential = untouched count, the calibration case);
  dirty write-back NONTRIVIAL (AIP-5 padding argument reused);
  warmth NONTRIVIAL (witness pair: equal counts+endpoints, costs
  3 vs 5); **visit-parity NONTRIVIAL with TRIVIAL double — the
  local H¹ has 2-torsion**, and modulo-r pricing gives exact
  period-r torsion-like classes generally. So write-back is NOT
  the lone generator: the class monoid contains potentials
  (trivial), holonomy classes (dirty, warmth), and integral
  torsion. Honest walls: all-grade stabilization; the narrow
  dirty-bit-only classification. Answers AIP-5 §4's question
  richer than conjectured.
- **Open for Mathijs** (from the report): is the broad-observer
  theorem the wanted form, or cut a follow-up narrow track for
  the single dirty-bit observer?

## 2026-08-10 (day 2, cont.) — operadic-canonicity MERGED: classification pinned

- `track/operadic-canonicity` MERGED (sol, ~50 min, 18-page
  report, full gate green incl. cargo): mountings DO form an
  operad under grafting (depths add, masses multiply — exactly
  the proposed law). Honest wall: the mounting-mass image is NOT
  the dyadic-rational suboperad (one cylinder mass per head;
  density fails), so the direct Bradley import breaks — repaired
  via the product operad Δ × Mounting. The graft-local object is
  the partition functional Z_α = Σp^α (not M_t itself), with the
  exact multiplicative grafting law; conditional converse: two
  character branches — additive ⇒ linear cost ⇒ Shannon,
  multiplicative ⇒ exponential schedules ⇒ Campbell/Rényi — then
  Furuichi + Baez–Fritz–Leinster imported for uniqueness (import
  beat reprove, as hoped). Labelled dyadic envelope documented as
  optional non-literal extension. campbell-renyi §8's qualified
  KN claim is superseded by this route. AIP-5 §8b splay/credits
  addendum landed same window.
- **Review for Mathijs**: aips/draft/operadic-canonicity.pdf.

## 2026-08-10 (day 2) — operadic-canonicity launched; coefficient-ring design direction

- `track/operadic-canonicity` launched (sol): pin the schedule
  classification via the mounting operad — mountings compose by
  grafting (dyadic-rational suboperad of the simplex operad);
  forward direction: M_t satisfies the exact (deformed) Leibniz
  grafting law, strict derivation at α=1 (Bradley's
  characterization as template for the converse); literature
  check included (import beats reprove). Proposed by Mathijs
  after scanning campbell-renyi (§7–8 not pinned).
- **Coefficient-ring direction (Claude, chat, Mathijs's
  suggestion sharpened)**: for the Euclidean mechanization,
  generalize the cocycle framework's coefficients from ℕ to an
  ordered cancellative commutative monoid; concrete costs live
  exactly in ℕ[2^(1/k)] = ℕ[x]/(x^k = 2) — exact, decidable
  order (k=2,3 decide-able), executable (coefficient vectors,
  sim keeps running); all k at once via ℕ[2^ℚ] = colim_k (a
  graded tower of coefficient objects — work with the diagram).
  Entropy-side bounds stay in floor/escort-root ℕ-form (macro
  levels) — the optima (Z_α) escape every fixed number field,
  exactly as H(p) already did in the Shannon layer. Goes into
  the euclidean-mechanization spec when cut, after the operadic
  report lands.

## 2026-08-10 (night, close) — ALL SEVEN tracks landed; fleet drained; expo definitions convention

- **`track/adaptive-entropy` MERGED** (sol, wall→repair→green):
  `lean/Adic/Adaptive.lean` — blockwise entropy upper bound
  (zero-safe), skewed four-head witness exact adaptive cost 664,
  Gibbs lower 512 + exact four-code Kraft lower 768, and
  `adaptive_beats_static` (664 < 768) with a structural Kraft
  lemma (no native_decide). 42 receipts after manifest-union
  merge. Shannon move 1 is mechanized.
- **`track/empirical-berry` MERGED** (sol): Rust enters — Cargo
  workspace + `bench/` (pointer-chase, streaming, write
  asymmetry; 19-point sweeps, CSVs committed), report
  `aips/draft/empirical-berry.md` + PDF. Headline: measured
  hierarchy envelope **s ≈ 2.41** — inside the predicted (2, 3)
  band. Full cargo gate (fmt/clippy/test) joined the project gate
  and is green. **Open with Mathijs**: quote workstation s≈2.41
  or wait for quiet-laptop replication (report recommends
  host-labeled + sensitivity range).
- **`track/campbell-renyi` MERGED** (sol): 16-page desk report
  `aips/draft/campbell-renyi.md`. Verdict: Rényi order
  α = 1/(1+t) SURVIVES; corrections owed to shannon-programme §2:
  optimal distances need the escort offset log₂ Z_α; the optimal
  value is affine in 2^(t·H_α), not H_α itself; the "s=1 = tape"
  slogan holds for random access but NOT streaming (dyadic sweep
  at c(ℓ)=2^ℓ is Θ(N log N)); streaming-iff criterion; qualified
  KN/additivity canonicity; honest NEGATIVE on the WBE rhyme
  (shallow); six-rung Lean ladder with the hard rung named
  (denominator-cleared natural Hölder). Claude to amend
  shannon-programme accordingly (queued).
- **Expo definitions convention** (Mathijs): AIP-4 §4.5 amended —
  definitions as plain math prose are first-class expo content, no
  badge needed; `#defn` in lib.typ; Expo 2 retrofitted as
  exemplar. Retrofit of Expo 1/3/4 + all future expos follow.
- **Queued for Claude (next window)**: Expo 5 (adaptive entropy,
  with definitions per new convention); shannon-programme
  amendments per campbell report; definitions retrofit expo 1/3/4;
  nice expos of berry + campbell results per Mathijs's ask.
- **Open with Mathijs**: s≈2.41 quote-or-replicate; cache-v0 call
  2; Expo 1+2 corrections (+C=1 paragraph); roadmap q2; Letter 2;
  veto 5/7.
- Fleet drained: no workers in flight; all worktrees/workspaces
  cleaned; 7 tracks launched today, 7 landed (2 exemplary honest
  walls: adaptive round 1, both repaired same-day).

## 2026-08-10 (night) — free-up MERGED; adaptive wall repaired; cocycle-framework launched; padding proof completed

- **`track/free-up-refresh` MERGED** (terra, ~15 min): the parked
  retrofit `3c0149f` ported onto post-rename main. All 7 changed
  pins re-read at merge (streaming 4·2^n→2·2^n; metric layer →
  directed descent distance; copy 20→12, RAM sim 10→6 constants;
  dist-zip explicit closed form; reverse sim bound now counts
  freeUpCount honestly). Gate independently re-run green in
  worktree AND on main post-merge. Up is now free in the
  mechanization; AIP-2 amendment fully implemented. Stale
  worktrees/branches cleaned (lean-spike, eval-harness,
  lean-free-up).
- **AIP-5 §2 completed by Claude**: padding bookkeeping written
  out in full (m=2^k=Θ(n), balanced sparse addresses, leftmost
  block, right-half clean excursions; totals 4mn+2m vs
  2mn+2m+Θ(m+n)) — the nontriviality theorem is desk-proved with
  NO remaining caveats; the gap is exactly dirty ups vs clean ups
  on equal letter counts. Expo 3 updated.
- **adaptive-entropy: exemplary sol wall + orchestrator repair.**
  Wall: spec demanded remounting all heads with block
  empiricalDists on single-support blocks — Kraft-infeasible
  (zero-count heads get distance 1; mass 1+3/2>1; the positivity
  hypothesis is load-bearing). Decision (Claude, spec-bug fix):
  option (c) — skewed-positive witness blocks (dominant head
  q−(k−1), all others 1); empiricalDists untouched, global counts
  exactly uniform, separation ≈2n vs ≥n(1+log k). Sol continuing
  (round 2, watcher re-armed).
- **`track/cocycle-framework` launched** (terra, fresh pane):
  exchange-form cocycle predicate, homomorphism examples, the
  free-up identity 2·cost+Φ = symCost+Φ∘run with Φ=depth by word
  induction, receipts + Expo 3's first badge flip desk→lean.
- Heartbeat protocol explicitly requested by Mathijs mid-turn:
  fallback re-armed on every wake since (currently armed).
- In flight: adaptive-entropy (sol, round 2), cocycle-framework
  (terra), mergesort-expo (sol), empirical-berry (sol),
  campbell-renyi (sol).

## 2026-08-10 (late) — slots 1–3 decided; roadmap rev 2; dirty direction endorsed; Euclidean variants decided

- **AIP-5 ACCEPTED** (dirty-cocycle → `aips/accepted/0005-…`):
  Mathijs ratified all recommendations. Classification (§4):
  first activated as contained sol track, then same-turn put
  DORMANT by Mathijs (wait for theory to crystallize) — spec
  `.dev/specs/local-classes.md` stays ready.
- **Fan-out authorized** (Mathijs: up to ~8 parallel, sol freely).
  FIVE tracks launched (all prompts verified `working`; watchers
  + 10-min fallback armed): terra on `track/free-up-refresh`
  (land the parked free-up retrofit `3c0149f` on post-rename
  main — accepted-AIP open end, prerequisite for the cocycle
  framework); sol ×4 on `track/adaptive-entropy` (Shannon move 1:
  block re-mounting = entropy rate + rotating-source separation
  witness, statement design in spec), `track/mergesort-expo`
  (Expo 4, desk-proved ladder item 3), `track/empirical-berry`
  (Rust enters: pointer-chase/streaming/write-asymmetry bench +
  dimension-slope measurement + report), `track/campbell-renyi`
  (desk verification of level-prices↦Rényi; also answers
  Mathijs's two new questions: Expo-2-at-k-dimensions — Kraft
  stays, entropy turns Rényi — and which price schedules are
  well-behaved: streaming-summability boundary = tape at s=1,
  doubling condition, Rényi/Kolmogorov–Nagumo axiomatics for why
  exponential schedules are canonical).
- **Expo 3 upgraded (Claude)**: the nontriviality claim is now
  DESK-PROVED — erase-pass construction makes both witness walks
  loops at one configuration (δΦ dies exactly), commutativity
  argument kills h; only down0/down1/up padding counts remain
  (elementary). Section retitled; AIP-5 §2 updated. Queued next:
  cocycle-framework Lean track (after free-up lands), move-2
  universal mounting, C=1 paragraph (bundled with Expo 2
  corrections).
- dirty-cocycle rev 2 (Mathijs asked for full AIP form with
  pros/cons): two NEW results while writing — (a) commutativity of
  Bℕ forces homomorphisms to see only letter counts, giving a
  padding/holonomy argument that upgrades the nontriviality
  conjecture to near-desk-proved (padding bookkeeping remains);
  (b) write cost of a set = its box-counting profile (Σ_ℓ N_ℓ),
  fractal dimension on the data side — write-side twin of the
  entropy theorem. Also: dirty ≤ 2× clean (class changes, not
  magnitude); ℕ-coefficients resolved by exchange form (= Tarjan's
  amortized identity); gauge rec: lazy as ground truth,
  flush-inclusive for interface statements.

- Mathijs slotted the three proposed steps onto the todo list:
  **(1) Shannon move 1** (block-adaptive re-mounting = entropy
  rate; Claude spec → sol), **(2) mergesort ledger entry**
  (desk-first; terra after spec), **(3) empirical berry** (Rust
  bench pointer-chasing vs streaming + the dimension measurement:
  hierarchy latency/capacity slope estimates the machine's ambient
  dimension). Not yet launched — specs to be cut next work window.
- **Euclidean variants decided** (Mathijs): after the C = 1
  paragraph, immediately do c(ℓ) = 2^(ℓ/2) and 2^(ℓ/3) (k = 2, 3)
  as first-class variants. Campbell/Rényi is their entropy story.
- **Dirty model: direction endorsed** (Mathijs — cocycles stay
  categorically clean, cohomology links a plus). Open questions
  collected in `aips/draft/dirty-cocycle.md` (ℕ-coefficients,
  local-class classification, two-trees unification, gauge choice,
  c(ℓ) interaction incl. write-amplification anchor, RAM
  correspondence, write entropy). Pricing details stay with
  Mathijs at cache-v0 call 2.
- Docs landed: `roadmap.md` rev 2 (B2 done, B4 phases 1–2 done,
  ladder zip ✓ FVec ✓, B4′ Shannon programme folded in, slots
  recorded, q2 flagged ripe); shannon-programme §2 folklore
  anchors (SRAM √area, hierarchy slope 0.3–0.5 → dimension 2–3,
  Rent's rule p = 1 − 1/d, holographic area law, Kleiber/WBE
  rhyme incl. the d/(d+1) = k/(k+1) coincidence, fractal dial,
  write amplification); cache-v0 §4b status + §5 sequencing
  updated. cache-v0 keeps its handle (content already renamed by
  the sweep).
- **Open with Mathijs**: cache-v0 call 2; roadmap q2 (now ripe);
  Expo 1+2 corrections; Letter 2 closing question; veto 5/7.

## 2026-08-10 (eve) — Kraft "weight" → "distance" decided (recovered from session tail); Expo 3 corrections applied

- **Terminology decision (Mathijs, previous session tail — was
  recorded nowhere durable until now): rename the Kraft parameter
  $w_i$ from *weight* to *distance* $d_i$.** Rationale: "weight"
  collides with the literature we cite (Huffman coding, biased
  search trees / Bent–Sleator–Tarjan) where weight = *frequency* —
  heavy = hot = cheap — while our $w$ is mount-path depth, the
  opposite polarity. "Distance" reads correctly: far = expensive;
  the entropy theorem becomes "frequent heads get small distance";
  the $1+d$ surcharge is travel time, not a fee; Kraft
  $sum 2^{-d_i} <= 1$ becomes geometry — "only so much fits
  nearby", hot is near. Unifier: with free-up (cost = acquired
  address bits) every cost in the system is a distance in a dyadic
  tree — data tree for memory, fast-state tree for heads; one cost
  notion, two trees. Mathijs: "zeker rewriten naar distance — het
  is ook mijn intuïtie, dat ding op afstand d."
- Execution: `track/distance-rename` (sol, ~7 min) MERGED —
  context-aware sweep (Lean `Weighted.lean`→`Distance.lean`,
  `weightedCost`→`distCost`; expo 2 → "Heads at a distance";
  cache-v0/roadmap/paper docs; false friends like typst font
  weight left alone). All 8 pins re-read at merge (pure
  α-renames), gate independently re-run green (build + 32
  receipts + sim + all typst, core axioms only).
- `aips/draft/shannon-programme.md` landed: expo 2's entropy pair
  identified as the source coding theorem; four programme moves
  (entropy rate via re-mounting; universal mounting; machine as
  unit-capacity channel, C=1 by free-up normalization;
  rate–distortion for bounded near-space) + the geometry answer
  to Mathijs's distance objection (unit prices = hyperbolic;
  c(ℓ)=2^(ℓ/k) = k-dim Euclidean, √N = 2D/VLSI; Campbell/Rényi
  under exponential prices — desk, verify). Sharpened after
  discussion: noisy-channel analogue DEMOTED (rhyme, not target);
  honest thesis = mechanize the combinatorial/individual-sequence
  half of information theory (draft §7).
- Expo 3 corrections from the same tail applied + pushed this
  session: Grothendieck construction explicit (morphisms are pairs
  $(w,c)$; cocycle law = functoriality), $"cost"_c (w)$ component
  notation, factorization picture "static ⇔ factors through
  $pi : cal(C) -> B M$".

## 2026-08-10 (close) — target 3 CLOSED both directions; Expo 1 fully green; Expo 2 live

- `track/lean-gibbs` merged: discrete log-sum + entropy lower bound
  — B4 phase 2 complete both directions (sol, 5m08s, counting/
  prefix-code route, zero-count heads handled).
- **Expo 2 published** (`expo/02-weighted-heads.typ`): the weighted
  model — 8 green pinned claims (Kraft=mounting, weighted zip +
  [59], entropy achievability + optimality + Gibbs), cliff-gap
  desk-badged, [72] open-badged.
- `track/lean-ram-lift` merged (sol, 4m26s): canonicalization
  between fragments (reset + re-select), terra's per-action theorem
  reused unchanged, program-level reverse simulation cost ≤ 5·T.
  **AIP-2 target 3 is CLOSED in both directions.** All of AIP-2's
  theorem targets (1, 2, 3↔, 4) are now mechanized. Ledger: 32
  receipts. Expo 1 updated — every claim in it is now lean-backed.
- Sol+terra collaboration note: terra built the foundation and
  named the crux honestly; sol designed the invariant and reused
  terra's theorem unchanged — the seam worked exactly as the table
  intends.
- State: sol idle, terra idle. Remaining open ends need either
  Mathijs (cache-v0 call 2 → phase 3 spec design; Expo/letter
  corrections; roadmap q2; Letter 2 question; veto 5/7) or fresh
  design (k-way merge machinery for the cliff witness; letters→expo
  reformulation queued for Claude). Per drive-progress idle rule:
  prospecting has effectively run today (cache-v0, expositions
  drafts landed and adopted); correct action is to wait on Mathijs.
- **Open with Mathijs**: Expo 1+2 corrections; cache-v0 rev 2 read;
  roadmap q2; Letter 2 closing question; veto 5/7.

## 2026-08-10 (cont.) — kraft, entropy-upper, reverse-per-action all merged

- Merged, each independently gate-verified: `track/lean-kraft` (B4
  phase 1: weighted cost, kraft_iff_mounting both directions with
  constructive mounting, weighted zip + [59] example);
  `track/lean-ram-reverse` (terra: fixed-register word RAM,
  three-rung lemma ladder, ram_action_simulation — ≤3 instructions
  per D action; program lift honestly deferred on a transient-
  register compositional relation); `track/lean-entropy` (B4 phase
  2 upper bound: inverse-frequency weights Kraft-feasible, exact
  empirical cost, floor-log bound; lower bound honestly walled on
  the discrete Gibbs/log-sum inequality — not weakened). Ledger at
  27 receipts; ledger merge conflicts resolved by manifest union +
  deterministic regeneration.
- Expo 1 updated: reverse-per-action now a green pinned claim;
  program lift stays desk-badged. The ledger-as-exposition
  mechanism did its job visibly.
- Terra calibration (Mathijs asked): capable Lean executor for
  decomposed ladders, does not self-structure, zero false greens
  under receipts discipline — model table updated + deployed.
- In flight: sol on `track/lean-gibbs` (discrete log-sum via the
  counting/prefix-code route + the entropy lower bound). Terra
  idle — no remaining well-scoped independent item; per
  drive-progress idle rule, correct action is nothing.
- Queue: Expo 2 (weighted heads/Kraft — Claude), letters→expo
  reformulation (Claude), phase 3 k-way witness (needs k-way merge
  machinery — spec design first), program-level reverse lift.
- **Open with Mathijs**: Expo 1 corrections; cache-v0 rev 2 (call
  2); roadmap q2; Letter 2 closing question; veto 5/7.

## 2026-08-10 — receipts + sim merged; Expo 1 live; two tracks in flight

- Drive-progress activated by Mathijs. Two workers parallel since:
  sol (lean-spike pane), terra (eval-harness pane, first terra-Lean
  epsilon — verdict: clean, fast, zero false greens on `lake exe
  sim`, independently re-run PASS exit 0).
- Merged: `track/lean-receipts` (sol: `lake exe receipts` → 13-entry
  ledger, FNV-1a 12-hex pins, forge-guard fails nonzero,
  deterministic regen) and `track/eval-harness` (terra: `lake exe
  sim`, costs vs closed forms to grade 12, real runs to grade 10).
  One lakefile conflict, resolved; full gate green on main (build +
  receipts + sim).
- cache-v0 rev 2 (earlier): rebuilt on convo [55]–[59] after
  Mathijs's corrections — 1+w surcharge, Kraft shares, down-fills/
  up-evicts, no head overlap; k-way cancellation as target; [72]
  deferred to size-weighted v1.
- **Expo 1 published** (`expo/01-the-dyadic-machine.typ`): the
  machine + 10 lean-backed pinned claims + 1 desk badge (reverse
  simulation). First real use of the receipt boxes.
- In flight: sol on `track/lean-kraft` (B4 phase 1: weighted cost,
  Kraft↔antichain, weighted zip); terra on `track/lean-ram-reverse`
  (RAM simulates D: extend RAM with shifts, per-move constant
  lemma; wall genuinely possible, out-clause emphasized).
- Process friction: compound `&`+`wait` background watchers hit
  sandbox PermissionDenied — use one simple `herdr agent wait` per
  background task instead. Sandbox leaves 0-byte dotfile
  mount-residue in repo root after unsandboxed runs — verified
  empty, removed. direnv first-build window now observed up to
  ~2.5 min (retry accordingly).
- **Open with Mathijs**: Expo 1 corrections; cache-v0 rev 2 read
  (call 2: c≡1 first?); roadmap q2; Letter 2 closing question;
  veto 5/7.

## 2026-08-10 (early) — ram merged (target 3 one-way); expositions accepted (AIP-4)

- `track/lean-fvec` merged earlier tonight (copy + telescoping,
  ladder step 2, 4m38s). `track/lean-ram` merged (`74fa9cf`): minimal
  word RAM, address→path layout, and the FULL program-level
  honest-log simulation `cost ≤ 10·T·(s+2^v)` — sol landed beyond
  the per-instruction fallback, 17m46s, re-verified green. AIP-2
  scoreboard: targets 1, 2, 4 fully mechanized; target 3 honest-log
  direction done, reverse direction (RAM simulates D) still open.
- **AIP-4 accepted** (Mathijs): expositions — readable math with
  Lean receipts, tour-style. All four calls decided: name expo/;
  hash-pin (claim→backing path CI-checkable); Typst first with
  reusable lib (`expo/lib.typ` built: leanthm green / deskthm amber
  / openclaim grey, receipt boxes from receipts.json, pin assert);
  Claude's own hand, Mathijs corrects not pre-approves. Expositions
  largely supersede letters (AIP-3 §3b); Letters 1–2 to be
  reformulated as expos once the harness lands; an expo without
  receipts is fine but must badge honestly.
- `expo/style-demo.typ` compiles (hand-pasted mock receipt, clearly
  labeled; forbidden once the harness exists). Launched
  `track/lean-receipts` (spec `.dev/specs/lean-receipts.md`): lake
  exe receipts → receipts.json from a manifest, fail-on-missing.
- Also tonight: cache-v0 draft (Kraft sketch, 4 calls) in Mathijs's
  inbox — gates the B4 mechanization track.
- **Open with Mathijs**: cache-v0 (4 calls), roadmap q2, Letter 2's
  closing question (no-cost-bounded-cone: theorem target or thesis
  sentence?), veto 5/7.
- **Queue for agents**: after lean-receipts → Expo 1 (Claude),
  letters→expo reformulation (Claude), then B4 mechanization once
  cache-v0 lands; reverse simulation direction; #eval harness.

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
