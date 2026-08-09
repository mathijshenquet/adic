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

## 3. Recommendation

**The dyadic machine D.** A program P is a finite control: a finite set
of states with a transition table over the instruction set below, fixed
independently of grade. For each grade n, the machine M_n = (P, n) has
as configuration:

- **memory** — a complete binary tree of depth n with one bit at each
  leaf (`block_0 = bit`, convo [13]); internal nodes carry no data;
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
   ≤ 4·2^n — amortized O(1) per leaf (convo [17]).
2. *Random access*: reaching leaf i costs its depth; adjacent leaves
   across a dyadic boundary cost 2n — a boundary spike that is
   fidelity, not artifact (pages and cache lines do the same).
3. *Simulation*: RAM simulates M_n with constant-factor overhead; M_n
   simulates a space-2^n TM at O(n) worst case per step and O(1)
   amortized on one-way scans; M simulates a RAM of S words at
   O(log S) per access — the honest log.
4. *Locality composition*: cost of a program using heads confined to
   disjoint subtrees is invariant under interleaving.

## 4. Open questions

1. **Name and letter.** "Dyadic machine", D_n? — rec: yes; short,
   descriptive, pairs with the language name.
2. **Bits or words at leaves?** — rec: bits. Words (`uint_k` as a
   grade-k subtree) are calculus-level derived structure; putting them
   in the machine would smuggle in a preferred word size, the exact u64
   move adic exists to refuse.
3. **How many heads in v0?** — rec: k fixed per program. k = 1 gives
   the cleanest theorems, but zip/merge need 2 (convo [52]); making k
   part of P costs nothing in the metatheory.
4. **May a head rest at internal nodes?** — rec: yes (zipper-style);
   movement is the only interaction there, data lives at leaves only.
5. **Stuck vs total.** Make moves total with self-loops, or leave them
   stuck/undefined? — rec: stuck. Keeps the machine's equational
   presentation small; totality is the calculus' job (convo [13]: the
   v1 concrete core is total).
6. **A `swap` instruction** (exchange focused subtree with held
   subtree)? Convo [31]'s `swap_cap` suggests it eventually — rec: not
   in v0; it belongs to the capability layer.
