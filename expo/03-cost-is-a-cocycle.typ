#import "lib.typ": *

#expo(3, "Cost is a cocycle", "2026-08-10")[

_Born as design theory ahead of the mechanization (2026-08-10,
morning); by the same midnight every box had turned green: the
free-up identity, the nontriviality theorem, and the write
asymmetry are all machine-checked. The design-theory-first,
badges-honest workflow did exactly what AIP-4 promised._

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

The machine's semantics is a (partial) action of the word monoid
$M$ on the set of configurations. A monoid is a one-object
category $B M$, and the action is a functor $B M arrow.r "Set"$:
the single object goes to the configuration set, each word to its
(partial) transition function. The *action category* $cal(C)$ is
the Grothendieck construction — the category of elements — of this
functor. Unwinding the definition: objects are configurations, and
a morphism out of $c$ is *not* a bare word but a pair $(w, c)$ — a
word runnable at $c$, welded to the configuration it runs from —
with target $c dot w$ and composition

$ (w_2, c dot w_1) compose (w_1, c) = (w_1 w_2, c). $

The welding is the entire content of the construction: "the same
word from a different configuration" becomes a *different
morphism*, which is exactly the room a state-dependent cost needs
to live in.

Now let $B NN$ be the one-object category with morphisms
$(NN, +, 0)$. A cost model is a functor

$ "cost" : cal(C) arrow.r B NN. $

Because a morphism of $cal(C)$ *is* a pair, a cost model is forced
to be a function of pairs; write $"cost"_c (w)$ for its value on
the morphism $(w, c)$ — subscript the source, nothing ad hoc.
Functoriality over the composition law above unpacks to exactly
two laws:

$ "cost"("id"_c) = 0, quad
  "cost"_c (w_1 w_2) = "cost"_c (w_1) + "cost"_(c dot w_1) (w_2). $

The shifted subscript is not an extra axiom — it only records that
the second arrow of the composite starts where the first one
landed. The second law is the *cocycle law* — the name comes from group
cohomology (for a group action the category of elements *is* the
translation groupoid, and functions with this law are its
1-cocycles) and from ergodic theory,
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

*Static prices are a factorization.* The Grothendieck construction
comes with a projection $pi : cal(C) arrow.r B M$,
$(w, c) arrow.r.bar w$ — forget the state, keep the word. A cost
model is word-only precisely when it factors as
$cal(C) arrow.r B M arrow.r B NN$ through $pi$: functors on $B M$
are monoid homomorphisms into $(NN, +)$, the static prices;
functors on $cal(C)$ are the state-dependent ones. "Cost ignores
state" stops being a property you check equation by equation and
becomes a shape — does the functor factor? — and the desk theorem
below says that write-back cost fails to factor even after
correction by a coboundary.

= Coboundaries are potential functions

Inside the cocycles live two distinguished classes. A cocycle is a
*homomorphism* when it factors through $pi$ — cost blind to state;
the base machine and the mount-distance surcharge both live here.
And a cocycle is a *coboundary* when it is
$(delta Phi)_c (w) = Phi(c dot w) - Phi(c)$ for a potential $Phi$
on configurations. Coboundaries are cohomology's "trivial"
cocycles — and they are exactly the potential functions of
amortized analysis. Two cost models differing by a coboundary
agree on every closed walk and differ only by boundary terms:

#align(center)[*the cohomology class is the amortized cost.*]

Amortization-as-normalization (convo [21]) becomes: choose the
cleanest representative of your class.

#leanthm(
  "Adic.Dyadic.freeUp_exchange",
  pin: "0dc16bd7115b",
  title: "Free up is a change of representative",
)[
  Let $Phi$ = current depth of the head. On movement words,
  $2 dot "cost"_"free" + Phi("initial") =
  "cost"_"sym" + Phi("final")$ exactly (down: $2 = 1 + 1$;
  up: $0 = 1 - 1$). The free-`up` amendment did not change the
  cohomology class of movement cost — it chose a cleaner
  representative, and the boundary term is the familiar
  "moves ≤ 2·cost + initial depth" safety argument. Lean proves
  this by induction on words.
]

= Bandwidth is a nontrivial class (machine-checked)

Now the dirty model: `down` fills, a clean `up` discards for free,
a dirty `up` pays its write-back. This cocycle reads one bit of
local state, so it is *not* a homomorphism. The sharp question is
whether it is secretly trivial — cohomologous to some
word-only cost, its state-dependence absorbable into a potential.

#leanthm(
  "Adic.Dyadic.Dirty.dirty_not_cohomologous",
  pin: "d1f4f594a35b",
  title: "The write-back cocycle is not cohomologous to any homomorphism",
)[
  No word price and no potential satisfy the exchange equation for
  dirty cost — at *every* grade $n gt.eq 1$. The two pillars are
  the desk argument's (AIP-5 §2): $B NN$ is commutative, so a
  homomorphism sees only letter counts; identical endpoints kill
  every potential on closed walks. The mechanized witness is the
  short conjugation pair found by the classification track:
  $"down0"^n "up"^n "down0"^n w_0 w_0$ versus
  $"down0"^n w_0 "up"^n "down0"^n w_0$ — same endpoints, same
  letter counts, dirty-up counts $0$ versus $n$ (costs $2n+2$
  versus $3n+2$); exchange on both forces the contradiction.
]

So it is a theorem, machine-checked:
*bandwidth cannot be statically priced.*
Latency-like costs (addressing, movement, mount distance) are
homomorphisms; write-back cost is genuinely history-dependent, and
the cohomological language says so exactly. That real machines
struggle to price bandwidth statically (rooflines, write
amplification, "it depends on your access pattern") stops being
folklore and becomes the statement that a certain cohomology class
is nonzero.

#leanthm(
  "Adic.Dyadic.Dirty.canonical_sparse_cost",
  pin: "b1537829f734",
  title: "Sparse–dense write asymmetry, exact",
)[
  $m$ isolated depth-$n$ round-trip writes (write pass plus erase
  pass) cost exactly $4 m n + 2 m$ under dirty pricing — each pays
  its path home, twice — while the *count-equalized* dense block
  walk costs $2 m n + 2(n - "blockDepth") + 6 m - 4$
  (`canonical_paddedDense_cost`, same ledger; the padding
  equalization is itself a receipt): equal letter counts, a
  $Theta(m n)$ gap in write-backs. Dirtiness coalesces — the
  write-side twin of the boundary spike, with AIP-5 §2's
  bookkeeping machine-checked including the padding.
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
