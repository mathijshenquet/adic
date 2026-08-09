#import "lib.typ": *

#expo(3, "Cost is a cocycle", "2026-08-10")[

_Born as design theory ahead of the mechanization; the first box
has since turned green (the free-up identity, mechanized
2026-08-10). The remaining badges are honest — amber is
desk-proved, and each is a worklist item for a future track._

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

= Bandwidth is a nontrivial class (desk-proved)

Now the dirty model: `down` fills, a clean `up` discards for free,
a dirty `up` pays its write-back. This cocycle reads one bit of
local state, so it is *not* a homomorphism. The sharp question is
whether it is secretly trivial — cohomologous to some
word-only cost, its state-dependence absorbable into a potential.

#deskthm(title: "The write-back cocycle is not cohomologous to any homomorphism")[
  No word-homomorphism $h$ and potential $Phi$ satisfy
  $"cost"_"dirty" = h + delta Phi$. _Desk argument (upgraded from
  an open claim, 2026-08-10; AIP-5 §2)._ (i) $B NN$ is
  *commutative*, so any homomorphism factors through the
  abelianization: $h$ sees only a word's letter counts — how many
  `down0`s, `down1`s, `up`s, `write`s — nothing of their order.
  (ii) Build two *closed* walks at the same configuration $c_0$
  (root, clean tree, all-zero store) with equal letter counts.
  The sparse walk makes $m$ isolated round trips to depth-$n$
  leaves writing 1s, then repeats them writing 0s back — store
  restored, every path flushed. The dense walk writes a $2^k$-leaf
  block ($2^k = m$) in one streaming sweep and erases it likewise,
  then *pads* with clean write-free excursions in an untouched
  subtree until every letter count matches — always solvable in
  root-returning chunks of depth $lt.eq n$, since each walk
  individually balances downs against ups. (iii) Identical
  endpoints kill $delta Phi$ *exactly* (both boundary terms are
  $Phi(c_0) - Phi(c_0) = 0$); equal counts make $h$ agree; but the
  sparse walk pays $Theta(m n)$ in write-backs (every up on an
  isolated dirty path pays, both passes) against the dense walk's
  $Theta(m + n)$ (each region edge dirty-crossed once; the padding
  pays its downs — which $h$ sees equally on both sides — but its
  ups are clean and free). With $m = Theta(n)$ the totals are
  $4m n + 2m$ against $2m n + 2m + Theta(m+n)$: an unexplained
  $Theta(n^2)$ gap — contradiction. The exact padding counts are
  written out in AIP-5 §2; the gap is precisely the sparse walk's
  dirty ups against the padding's clean ones.
]

So — modulo that bookkeeping — it is a theorem, not a slogan:
*bandwidth cannot be statically priced.*
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
