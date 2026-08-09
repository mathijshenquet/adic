# The dyadic machine (v0): adic's model of computation

## 1. The problem

adic needs its ground floor: the idealized machine that the graded
calculus will be proven sound against (convo [5]: verify a toy machine
first; real compilation arrives later as a lax, big-O-preserving
interpretation). The machine must satisfy the same discipline as the
types above it:

- **No infinite objects.** A Turing machine owns an infinite tape; a
  RAM owns an infinite (or undef-edged, u64-style) address space. Here
  the machine itself must be a graded tower: M_n has exactly 2^n bits
  of memory, and one fixed program runs uniformly at every grade. The
  only infinity is uniformity across the tower — the same move that
  gives `uint` instead of `u64`.
- **Structural cost.** Access cost must follow from the geometry of the
  configuration, not from a bolted-on table: random access Θ(log n),
  streaming amortized O(1) — the two empirically dominant facts about
  real memory systems — should be *theorems*.
- **Small and first-order**, so initiality/adequacy against it is
  finite work (convo [5], [13]).
- **Honestly partial locality.** Spatial locality and streaming are
  modeled; capacity/eviction cliffs are a known, recorded gap (convo
  [17], [57]: Kraft pricing vs cliff pricing), out of scope for v0.

## 2. Prior work

- **Turing machine** — right spirit (locality is primitive, movement is
  the only way to reach data), wrong memory shape: flat, sequential,
  actually infinite.
- **RAM / von Neumann** — O(1) random access is the standard fiction;
  it hides the word-size and addressing log factors precisely where
  adic wants honesty.
- **Tree Turing machines** (classical complexity literature: TMs with
  tree-structured tapes) — the closest classical relative; known
  simulation theorems to inherit. adic differs in grading (finite at
  every level) and in the region/capability algebra to be layered
  above.
- **Pointer machines** (Kolmogorov–Uspensky; Schönhage's storage
  modification machine) — memory as mutable graph; no cost hierarchy,
  no bounded-space grading.
- **Hierarchical memory models** (Aggarwal–Alpern–Chandra–Snir: cost
  f(a) to touch address a; block-transfer variant) — our cost model is
  their f = log, with the hierarchy made programmable (a cursor you
  move) instead of address-indexed (convo [17]).
- **Cache-oblivious model, van Emde Boas layouts** — the M/B capacity
  cliff is exactly what gradual dyadic pricing does not capture; the
  sharpest statement of the gap is convo [57]'s Kraft-vs-cliff
  analysis. Recorded as a scope boundary, not a surprise.
- **Capability machines** (CHERI; convo [9]) — unforgeable authority.
  Deliberately absent from the v0 machine: capabilities arrive as the
  calculus above, and the machine stays algebra-free.
- **Circuit families** — graded machines resemble them; the classical
  trap is non-uniformity (convo [3]). One fixed program across all
  grades is the uniformity condition, obtained for free.
- **p-adic / profinite structure** (convo [3], docs/convo.md:48–50) —
  the grade-n address space is ℤ/2ⁿ, and the tower with its
  projections is the defining pro-diagram of the 2-adic integers ℤ₂;
  the boundary of the infinite tree is Cantor space. Inductive data
  takes the *direct* limit of this tower (Ind, zero-padding
  inclusions; colimit ℕ — every element at a finite grade),
  coinductive data the *inverse* limit (Pro, streams, profinite
  topology). adic works with the diagrams and never takes either
  limit. The cost model is genuinely 2-adic — see the odometer note
  at theorem 1.

## 3. Recommendation

**The dyadic machine D.** A program P is a finite control: a finite set
of states with a transition table over the instruction set below, fixed
independently of grade. For each grade n, the machine M_n = (P, n) has
as configuration:

- **memory** — a complete binary tree of depth n with one bit at each
  leaf (`block_0 = bit`, convo [13]); internal nodes carry no data.
  Canonical definition is recursive — `T(0) = bit`, `T(n+1) = T(n) ×
  T(n)` — with positions as bit-paths and heads as zippers, not an
  array with index arithmetic (addendum §5b);
- **heads** — k cursors (k fixed by P), each resting at a node of the
  tree;
- **control** — the current state of P.

Instructions, each costing 1, each addressing one head:

- `up`, `down0`, `down1` — move the head along an edge. Partial: `up`
  at the root and `down` at a leaf are stuck. Stuckness is to be
  excluded statically by the calculus, not handled by the machine.
- `read` — branch on the bit under a head at a leaf; `write0`,
  `write1` — set it.
- `halt`.

The transition function reads only (control state, the addressed
head's local observation): heads cannot observe each other — no
same-node predicate, no cross-head reads (addendum §5c).

Conventions: input is the initial leaf contents, output the final leaf
contents (function-shaped I/O with designated input/output subtrees is
deferred to the calculus). Time is instruction count; space is the
grade n, all of it by construction — sub-space refinement arrives with
regions.

Head disjointness is *not* machine-enforced (the machine is sequential;
races cannot occur). The calculus' linear capabilities will make
disjointness a type-level invariant; the machine-level payoff to prove
is that operations of heads on disjoint subtrees commute in cost.

**Theorem targets for the paper** (each falsifiable against the
simulator):

1. *Streaming*: a full left-to-right leaf scan via the Euler tour costs
   ≤ 4·2^n — amortized O(1) per leaf (convo [17]). In the MSB-first
   leaf order, stepping from leaf i to i+1 costs 2·(1 + v₂(i+1)) —
   carry propagation, i.e. the odometer — and the bound is
   Σᵢ v₂(i) telescoping: theorem 1 is an adding-machine fact
   (kinship with Vershik's adic transformations, §4.1).
2. *Random access*: reaching leaf i costs its depth; adjacent leaves
   across a dyadic boundary cost 2n — a boundary spike that is
   fidelity, not artifact (pages and cache lines do the same).
3. *Simulation*: RAM simulates M_n with constant-factor overhead; M_n
   simulates a space-2^n TM at O(n) worst case per step and O(1)
   amortized on one-way scans; M simulates a RAM of S words at
   O(log S) per access — the honest log.
4. *Locality composition*: cost of a program using heads confined to
   disjoint subtrees is invariant under interleaving.

## 4. Taste calls (all decided 2026-08-09)

1. **Name and letter.** DECIDED (Mathijs, 2026-08-09): **the dyadic
   machine**, written D, D_n per grade. Prior-work scan: "dyadic
   machine" is unclaimed as a model of computation. "H-machine"
   rejected — crowded letter-machine namespace, search-drowned by
   hierarchical-memory work (whose classical model, AACS's HMM,
   is already our §2 neighbor). "adic machine" rejected softly: in
   ergodic theory "adic transformation" (Vershik) names the
   odometer/adding-machine family, and the abbreviation a-machine is
   Turing's own 1936 term for the TM. The Vershik collision is
   kinship, not accident (streaming = odometer, theorem 1) — which is
   exactly why the connection belongs in theorems, not in the name.
   p = 2 stays pinned: the bit is the only non-arbitrary atom; any
   p > 2 smuggles a preferred radix (the u64 move again, cf. §4.2);
   p-ary generalization is a related-work remark. "adic" remains the
   name of the language/discipline, which honestly covers both limits
   of the tower (§2).
2. **Bits or words at leaves?** DECIDED (Mathijs, 2026-08-09): bits —
   invariant and clean. Words (`uint_k` as a
   grade-k subtree) are calculus-level derived structure; putting them
   in the machine would smuggle in a preferred word size, the exact u64
   move adic exists to refuse.
3. **How many heads in v0?** DECIDED (Mathijs, 2026-08-09): k fixed
   per program, with no inter-head observation (§5c). k = 1 gives the cleanest theorems,
   but zip/merge need 2 (convo [52]) and theorem 4 is *about*
   multiple heads (with k = 1 it is vacuous); making k part of P
   costs nothing in the metatheory. Single-head would also punish
   two-stream operations real machines do cheaply — the multi-tape-TM
   precedent: the single-tape quadratic overhead is universally read
   as artifact, not fidelity.
4. **May a head rest at internal nodes?** DECIDED (Mathijs,
   2026-08-09): yes (zipper-style); movement is the only interaction
   there, data lives at leaves only.
5. **Stuck vs total.** Make moves total with self-loops, or leave them
   stuck/undefined? DECIDED (2026-08-09, rec adopted after in-session
   explanation): stuck. Keeps the machine's equational presentation
   small — no laws about what `up`-at-root "does" — and the calculus
   statically excludes these programs anyway, so theorems take a "run
   succeeds" hypothesis (§5e); totality is the calculus' job (convo
   [13]: the v1 concrete core is total).
6. **A `swap` instruction** (exchange focused subtree with held
   subtree)? DECIDED (Mathijs, 2026-08-09): not in v0 — YAGNI until
   needed; convo [31]'s `swap_cap` suggests it eventually, in the
   capability layer.
7. **Leaf-order convention (endianness).** DECIDED (2026-08-09,
   delegated to Claude): the apparent tension between convo [3]'s
   little-endian choice (docs/convo.md:48) and theorem 1's MSB-first
   odometer analysis dissolves by separating two layers. (i)
   *Metatheory*: leaves are numbered in left-to-right tree order —
   paths read MSB-first — which is where the streaming/odometer/
   boundary-spike theorems quantify; growth embeds the old tree as
   child 0 of a new root, preserving leaf addresses. (ii) *Data
   layout*: stored numerals, including addresses-as-data, are
   little-endian in that order (LSB at the leftmost leaf, per convo
   [3]), keeping successor uniform across grades. The layers do not
   conflict: theorems quantify over tree order; the uniformity
   requirement constrains data layout only. The `join`-adjacency
   question (convo [13]) stays open at the calculus level.

## 5. Addendum: designed for proof (2026-08-09)

v0 has no legacy, so the machine gets shaped to make the theorem
targets fall out as structural inductions (Mathijs's framing, session
2026-08-09). Seven principles; (a)–(c) amend §3 above, the rest
constrain how the theorems are stated and proved.

a. **Monoid-action presentation.** An instruction denotes a partial
   function Config ⇀ Config at unit cost; a run is a word of
   instructions, semantics is composition, cost is word length (the
   length homomorphism from the free monoid). Small-step is derived;
   proofs are inductions on words, and theorem 4 becomes a statement
   in a trace (partially commutative) monoid — standard, equational,
   Lean-friendly. Convo [7] said this conceptually; here it is the
   canonical presentation, not an afterthought.

b. **Recursive memory.** `T(0) = bit`, `T(n+1) = T(n) × T(n)`;
   positions are bit-paths, heads are zippers. Streaming becomes the
   induction C(n+1) = 2·C(n) + O(1); random access is induction on
   the path; subtree disjointness is prefix incomparability — list
   combinatorics, no div/mod. Never define memory as an array.

c. **No inter-head observation.** Each instruction addresses exactly
   one head; the transition function reads only (state, that head's
   observation). Then instructions on heads in disjoint subtrees
   commute *syntactically* and theorem 4 is a diamond lemma over the
   trace monoid; a single cross-head predicate would demote it to a
   semantic proof.

d. **Cost factors through the tree metric.** Two base lemmas carry
   theorems 1–2: cost ≥ sum of head displacements (lower bound), and
   any itinerary is realizable at exactly its length (upper bound).
   The theorems then reduce to geometry: Euler-tour length, path
   depth, the 2n boundary spike. Movement is the only channel through
   which geometry enters cost — which is why unit-cost `read`/`write`
   are harmless.

e. **Stuck = Option.** Confirms §4.5: partial steps compose in the
   option monad, and theorems carry a "run succeeds" hypothesis —
   exactly the obligation the calculus later discharges statically.
   Self-loop totalization would pollute every cost statement with
   edge cases.

f. **Closed-form totals, not amortized statements.** State bounds as
   totals over grades ("full scan ≤ 4·2^n, for all n"); amortized
   O(1) per leaf is a corollary phrasing. No potentials or credits in
   the v0 metatheory — those arrive with the calculus (convo [23]).

g. **Minimal RAM counterpart, simulations last.** Theorem 3's
   formalization cost is dominated by defining the *other* machine:
   pick the smallest adequate word RAM, use existential constants,
   and mechanize only after the definition freezes (desk-proved in
   the claims ledger until then). The O(log S) direction is then
   nearly free: a word is a grade-w subtree, address arithmetic is
   path navigation — theorem 2 plus composition.

Mechanization note: the machine is small, first-order, finite —
Lean-sized from day one, and Lean 4 is executable, so the Lean
definition itself can serve as the v0 simulator (`#eval` at small
grades). A Rust simulator earns its place when empirical throughput
demands it. Sequencing lives in the roadmap draft, not here.
