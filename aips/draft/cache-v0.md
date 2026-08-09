# The cached dyadic machine (v0): weighted cursors under Kraft

## 1. The problem

B4 (roadmap): bridge the multi-head dyadic machine to a machine
with caches — Mathijs's framing, 2026-08-09 — making fast state a
priced, structural resource rather than a bolted-on table. Convo
[55]/[57] fixed the shape (weighted cursors under a Kraft/antichain
capacity constraint, not a recursively accessed cursor tree); [72]–
[73] left the write-head weight question open. The v0 goal: the
smallest model in which cached streaming, Kraft feasibility, and
optimal weight allocation are theorems.

## 2. Prior work

- **AACS hierarchical memory** — our §2 neighbor in AIP-2; here the
  hierarchy becomes per-cursor and programmable.
- **External-memory (I/O) model, cache-oblivious model** — scan
  N/B, the M/B capacity cliff. The cached machine *derives* the
  scan bound (target 1) and honestly does not capture the cliff
  (recorded gap, convo [17]/[57]: Kraft pricing vs cliff pricing).
- **Register allocation** — k heads ≈ registers was the first
  analogy ([55]); weights generalize it to registers-plus-cachelines.
- **Kraft inequality / prefix codes** — antichains of dyadic
  subtrees are exactly prefix codes; the fast-state budget is a
  Kraft constraint, connecting allocation to source coding (the
  road to the entropy chapter).

## 3. Recommendation

**No new machine: a weighted cost semantics on D.** Each head i
carries a weight w_i (its *fringe*: the cached window of height w_i
around its focus). Moves inside the fringe cost 0; a move crossing
a height-j boundary above the fringe costs (j − w_i)-ish — v0
charges fringe *refill* at boundary crossing, which implicitly
prices maintenance. Cost remains a homomorphism on action words —
the plain machine is the special case w = 0, and every existing
theorem survives as the w = 0 fiber.

**Capacity**: a weight assignment is admissible iff
Σ_i 2^{w_i} ≤ 2^m — fast memory of grade m; normalized,
Σ 2^{w_i − m} ≤ 1: Kraft.

**Theorem targets** (each falsifiable against `#eval`):

1. *Cached scan*: fringe w makes a full scan cost Θ(2^{n−w}) — the
   external-memory scan bound N/B with B = 2^w, derived not
   assumed. (The odometer sum with the first w levels zeroed.)
2. *Kraft feasibility*: admissible weight assignments correspond
   exactly to antichain/prefix-code realizations of fast state.
3. *Optimal allocation*: for concurrent streams with rates r_i,
   total cost Σ r_i·2^{−w_i} under Kraft is minimized by weights
   proportional to log-rates; corollary: zip's write head gets
   exactly one extra fringe level (resolves [72]–[73]).
4. *Bridge*: plain D simulates weighted D with overhead equal to
   fringe maintenance; positioning against the I/O model follows.

## 4. Open questions (taste calls for Mathijs)

1. **Fringe shape.** Subtree window below/around the focus, or a
   path window along the root-to-focus spine? — rec: the height-w
   window around the focus (subtree fringe): it makes target 1 the
   clean telescoping sum and matches cache lines (spatial
   neighborhoods), while a spine window re-prices random access
   instead of streaming — less aligned with what caches do.
2. **Two-axis tower.** Is fast memory m a second grade — machines
   M_{n,m}, a two-parameter tower — or a per-program constant? —
   rec: second grade axis. It matches "the hierarchy made
   programmable" (AIP-2 §2 on AACS), scales to multi-level caches
   as iterated grading, and keeps uniformity: one program, all
   (n, m).
3. **Eviction stays out.** Confirm the M/B cliff (capacity misses,
   thrashing) remains a documented non-goal for v0. — rec: yes;
   the Kraft-vs-cliff seam is the honest boundary of the model.
4. **Refill pricing.** Charge (j − w) at a height-j crossing (pure
   refill), or j (full walk, fringe only saves the low levels)? —
   rec: (j − w): it is what block transfer does, and it makes the
   w = 0 fiber exactly the old cost.

## 5. Sequencing

Design calls above gate only the mechanization track
(weighted-cost + cached-scan in Lean, next sol slot after fvec).
The Kraft letter (prospective index no. 6) follows the calls. The
empirical `#eval` harness is independent and can run any time.
