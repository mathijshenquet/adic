#import "lib.typ": *

#expo(3, "Cost is a cocycle", "2026-08-10")[

_No Lean in this one — it is design theory ahead of the
mechanization, and it wears the honest badges to prove it. Its
claims are exactly the ones a future track should turn green._

The machine's original cost model had a property so simple it was
easy to mistake for essential: the cost of a run depended only on
the *word* of instructions, not on the configuration it ran from.
Cost was a homomorphism from the free monoid — cost of a
concatenation is the sum, end of story. Two amendments now push
against this: free `up` kept the property, but the proposed
*dirty* pricing (a write-back is paid only when leaving a subtree
that was written) does not: the same word can cost differently
from different configurations. Is that the end of "algebraic"?

It is not, and this exposition says precisely what replaces it.

= The cocycle law is functoriality

Form the *action category* $cal(C)$ of the machine: objects are
configurations, a morphism $c arrow.r c dot w$ is a runnable word
$w$. Let $B NN$ be the one-object category with morphisms
$(NN, +, 0)$. A cost model is a functor

$ "cost" : cal(C) arrow.r B NN, $

and functoriality unpacks to exactly two laws:

$ "cost"("id") = 0, quad
  "cost"(w_1 w_2, c) = "cost"(w_1, c) + "cost"(w_2, c dot w_1). $

The second is the *cocycle law* — the name comes from group
cohomology (for a group action, functions with this law are the
1-cocycles of the translation groupoid) and from ergodic theory,
where "cocycles over a dynamical system" are classical — including,
pleasingly, cocycles over Vershik's adic transformations: the
odometer keeps finding us.

The point of the definition: *state-dependent cost composes
perfectly.* Nothing about the categorical semantics gets harder —
a costed run is a morphism in the Writer-style graded setting
(pairs of state-transform and price, composition adds prices),
which is precisely the cost-graded monoid action the founding
conversation already planned. The finite-presentation story also
survives verbatim: define the cost table on finitely many cases —
generator × *local observation* (the same locality read-branching
already uses; dirtiness is one honest bit per node) — and
functoriality extends it uniquely. The real cleanliness boundary
was never "cost ignores state"; it is "cost reads only the local
observation, from a finite table."

= Coboundaries are potential functions

Inside the cocycles live two distinguished classes. A cocycle is a
*homomorphism* when it factors through the free monoid — cost
blind to state; the base machine and the mount-distance surcharge
both live here. And a cocycle is a *coboundary* when it is
$delta Phi (w, c) = Phi(c dot w) - Phi(c)$ for a potential $Phi$
on configurations. Coboundaries are cohomology's "trivial"
cocycles — and they are exactly the potential functions of
amortized analysis. Two cost models differing by a coboundary
agree on every closed walk and differ only by boundary terms:

#align(center)[*the cohomology class is the amortized cost.*]

Amortization-as-normalization (convo [21]) becomes: choose the
cleanest representative of your class.

#deskthm(title: "Free up is a change of representative")[
  Let $Phi$ = current depth of the head. On movement words,
  $ 2 dot "cost"_"free" = "cost"_"sym" + delta Phi $
  exactly (down: $2 = 1 + 1$; up: $0 = 1 - 1$). The free-`up`
  amendment did not change the cohomology class of movement cost —
  it chose a cleaner representative, and the boundary term
  $Phi lt.eq n$ is the familiar "moves ≤ 2·cost + initial depth"
  safety argument. Elementary; a mechanization would be a short
  induction on words.
]

= Bandwidth is (conjecturally) a nontrivial class

Now the dirty model: `down` fills, a clean `up` discards for free,
a dirty `up` pays its write-back. This cocycle reads one bit of
local state, so it is *not* a homomorphism. The sharp question is
whether it is secretly trivial — cohomologous to some
word-only cost, its state-dependence absorbable into a potential.

#openclaim(title: "The write-back cocycle is not cohomologous to any homomorphism")[
  No potential $Phi$ and word-homomorphism $h$ satisfy
  $"cost"_"dirty" = h + delta Phi$. Witness shape: $m$ isolated
  single-bit writes cost $Theta(m dot n)$ in write-backs, while
  the same multiset of operations arranged as one dense
  $2^k$-block write costs $Theta(2^k)$ — dirtiness *coalesces*.
  Equal word content, unboundedly different cost, comparable
  endpoints: no boundary term can absorb the gap.
]

If this holds — and the witness makes it hard to doubt — it is a
theorem worth framing: *bandwidth cannot be statically priced.*
Latency-like costs (addressing, movement, mount distance) are
homomorphisms; write-back cost is genuinely history-dependent, and
the cohomological language says so exactly. That real machines
struggle to price bandwidth statically (rooflines, write
amplification, "it depends on your access pattern") stops being
folklore and becomes the statement that a certain cohomology class
is nonzero.

#deskthm(title: "Sparse–dense write asymmetry")[
  Under dirty pricing: $m$ isolated writes at pairwise tree-distant
  leaves cost $Theta(m dot n)$ total (each pays its path home),
  while writing a full $2^k$-subtree costs $Theta(2^k)$ — each
  edge of the written region is dirty-crossed once, amortized
  $O(1)$ per written leaf. The write-side twin of the boundary
  spike; desk-level pending the dirty-bit mechanization.
]

= What this buys the programme

Three earlier decisions become one picture. The machine's
semantics was already a (partial) monoid action; its cost was
already meant to be a grading (convo [7], [13]); amortization was
already normalization (convo [21]). The cocycle view identifies
all three: *a cost model is a functor to $B NN$; static prices are
the homomorphisms; potentials are the coboundaries; amortized
equivalence is cohomology; and the interesting resources are the
nontrivial classes.* The mechanization needs none of this
vocabulary — it proves cost equations word by word, as it already
does — but the paper gets to say why those equations have the
shape they have.

]
