#import "lib.typ": *

#expo(1, "The dyadic machine", "2026-08-09")[

adic's model of computation is a machine whose memory is a complete
binary tree: at grade $n$, the machine $D_n$ owns a tree of depth
$n$ with one bit at each of its $2^n$ leaves, and nothing else. A
fixed finite program drives $k$ cursors ("heads") over this tree;
the only motions are `up`, `down0`, `down1`, and the only data
operations are reading or writing the bit under a head resting at a
leaf. Every instruction costs 1. Space is not measured — the grade
$n$ *is* the space, by construction. One program runs uniformly at
every grade; the tower ${D_n}$, never any single machine, is the
object of the theory (AIP-2).

This exposition presents the machine and its first mechanized
results: the cost model is *structural* — streaming cheapness and
logarithmic random access are theorems about the tree's geometry,
not assumptions about a memory controller.

= Movement and cost

A run is a word of instructions; its cost is its length. Movement
composes as a monoid action, and every cost statement below is a
closed-form total over a concrete word (no potentials, no credits).
Positions are bit-paths; the metric is the tree distance
$d(a,b) = |a| + |b| - 2|"lcp"(a,b)|$.

#leanthm(
  "Adic.Dyadic.random_access",
  pin: "90d693624072",
  title: "Random access costs the depth",
)[
  Descending the path $p$ from the root reaches the leaf addressed
  by $p$ at cost exactly $n$ — the depth. Access cost is the
  path length, definitionally.
]

#leanthm(
  "Adic.Dyadic.random_access_optimal",
  pin: "384959b54737",
  title: "…and the depth is optimal",
)[
  No word reaching a leaf at depth $n$ from the root costs less
  than $n$: the descent is not merely one way to get there, it is
  the cheapest.
]

#leanthm(
  "Adic.Dyadic.movement_cost_lower_bound",
  pin: "a9dd1cc5c5b7",
  title: "Cost dominates the metric",
)[
  Any successful run moving a head from position $a$ to position
  $b$ costs at least $d(a, b)$ —
]

#leanthm(
  "Adic.Dyadic.movement_cost_realizable",
  pin: "441789e92c57",
  title: "…and the metric is realizable",
)[
  — and some word achieves exactly $d(a,b)$: up to the least common
  ancestor, down the other side. Cost, restricted to movement, *is*
  the tree metric.
]

= Streaming, or the odometer

Number the leaves left to right. Stepping from leaf $i$ to leaf
$i+1$ costs $2(1 + v_2(i+1))$ — the walk to the least common
ancestor and back, governed by how far the binary carry propagates
when incrementing $i$. A full scan telescopes:
$sum_(i<2^n)(1 + v_2(i)) approx 2 dot 2^n$. Streaming is cheap on
$D_n$ for the same reason the odometer performs amortized $O(1)$
carries; the 2-adic valuation is the cost model seen from the
address side.

#leanthm(
  "Adic.Dyadic.streaming",
  pin: "da2cf6d93911",
  title: "Streaming is amortized O(1) per leaf",
)[
  The Euler word of grade $n$ succeeds from the root, returns to
  the root, costs at most $4 dot 2^n$, and its trace of visited
  leaves is *exactly* the $2^n$ leaves in left-to-right order —
  each leaf once, in order. (The exact cost is $4 dot 2^n - 4$.)
]

= Locality is compositional

Heads cannot observe one another — an instruction reads only the
control state and the addressed head's local view. That makes
disjointness *syntactic*: operations of heads confined to disjoint
(prefix-incomparable) subtrees commute, and whole schedules can be
interleaved freely without changing result or cost. This is the
frame rule of the machine, and the ground the capability calculus
will stand on.

#leanthm(
  "Adic.Dyadic.disjoint_subtree_interleaving",
  pin: "c0fe61356058",
  title: "Interleaving invariance (theorem 4)",
)[
  For words confined to disjoint subtrees (shared memory, real
  writes), every interleaving that preserves per-head order yields
  the same final configuration at the same cost.
]

= Two programs

Zip is the first real program: two input heads stream two grade-$n$
trees, a write head streams the grade-$(n+1)$ interleaving. Its
itinerary is *oblivious* — data-independent — which is itself a
theorem: the schedule's shape (moves, read/write skeleton, hence
cost) does not depend on the inputs; only the choice between
`write0` and `write1` does.

#leanthm(
  "Adic.Dyadic.zipWord_correct",
  pin: "14348ba5db73",
  title: "Zip is correct",
)[
  Running the zip schedule on inputs $a, b$ (arbitrary initial
  output) succeeds and leaves memory holding $a$, $b$ unchanged and
  the output subtree equal to their leaf-interleaving, heads back
  at start.
]

#leanthm(
  "Adic.Dyadic.zipWord_cost",
  pin: "197f534c6425",
  title: "Zip is linear",
)[
  The schedule costs exactly $20 dot 2^n - 12$, independent of the
  data — amortized $O(1)$ per element, with the constant in plain
  sight.
]

Copy is the second: a two-head streaming copy at exact cost
$10 dot 2^n - 8$, whose doubling chain telescopes —

#leanthm(
  "Adic.Dyadic.doublingCopyTotal_linear_bound",
  pin: "7bf1eddaf4cc",
  title: "Doubling telescopes",
)[
  The total cost of copying at every grade $0, dots, c$ (the
  doubling vector's copy chain) is at most $20 dot 2^c$: linear in
  the final size. This is the machine half of FVec's amortized
  $O(1)$ push.
]

= The honest logarithm

The RAM's $O(1)$ random access is the standard fiction; $D$ prices
what it hides. A word RAM of $2^s$ words of $2^v$ bits embeds in a
grade-$(s+v)$ tree — a word is an aligned grade-$v$ subtree,
address arithmetic is path navigation — and:

#leanthm(
  "Adic.Dyadic.ram_program_simulation",
  pin: "ae500d06e278",
  title: "The honest log",
)[
  Every RAM program of cost $T$ runs on $D$ at cost
  $lt.eq 10 dot T dot (s + 2^v)$ — $O(log S + w)$ per RAM step.
  The logarithm was always there; the RAM model merely declines to
  charge for it.
]

#leanthm(
  "Adic.Dyadic.ram_action_simulation",
  pin: "faf9a8c8b649",
  title: "The reverse direction, per action",
)[
  Conversely, a fixed-register word RAM simulates each $D$ action
  in at most a constant number of instructions (three suffice):
  addresses as padded words, moves as shifts. So the two models
  differ by exactly the logarithm — in one direction only.
]

#deskthm(title: "The reverse direction, whole programs")[
  Lifting the per-action simulation to whole action words needs a
  compositional invariant on transient register state; desk-level
  until that lands.
]

= What is deliberately absent

No caches (weighted heads under a Kraft budget are the next layer —
cache-v0 draft), no eviction or capacity cliffs (recorded gap:
Kraft pricing is not cliff pricing), no allocation, no capabilities
(they arrive as the calculus above, the machine stays algebra-free),
and no completion of the tower: $NN$ and $ZZ_2$ are its two limits,
and adic works with the diagram, never the limit (Letter 2).

]
