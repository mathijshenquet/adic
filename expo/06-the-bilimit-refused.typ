#import "lib.typ": *

#expo(6, "The bilimit, refused", "2026-08-10")[

_Reformulation of Letter 2 (2026-08-09) as an exposition, per
AIP-4; the letter remains in the archive. Sanctioned as a theorem
target by Mathijs (2026-08-10): the no-go below is now on the
list, and this exposition clarifies the link to classical domain
theory that motivates it._

Classical domain theory has a celebrated move for interpreting
recursion: complete the tower. adic's founding decision is to
refuse that move — to work with the diagram of finite machines
and never take the limit. This exposition upgrades the refusal
from taste to a theorem shape: *the completion is not merely
unnecessary for us; it is a lossy operation, and the loss is
exactly the subject of the theory.*

= The objects

#defn(title: "the tower and its ep-pairs")[
  The graded machines carry the address towers
  ${ZZ\/2^n}$ with the zero-padding inclusion
  $e_n : ZZ\/2^n arrow.r ZZ\/2^(n+1)$ and the truncating
  projection $p_n$ back. These form an *embedding–projection
  chain*: $p_n compose e_n = "id"$ exactly, and
  $e_n compose p_n$ ("keep the low part") sits below the identity
  in the partial-map order. The colimit of the embeddings is $NN$
  (finite-support bitstrings); the limit of the projections is
  $ZZ_2$ (all bitstreams).
]

#defn(title: "cones, and what presenting a limit costs")[
  A *cone* over the projection chain is an object $X$ with maps
  $q_n : X arrow.r ZZ\/2^n$ satisfying $p_n compose q_(n+1) = q_n$;
  it *presents the limit* when it is universal. On the machine,
  realizing $q_n$ at a point $x$ means a run that writes the
  truncation $tau_n (x)$ into a grade-$n$ tree; its cost is the
  run's cost. Write $"bits"(x, n)$ for the number of 1-bits of
  $x$ below position $n$ — the information the truncation carries.
]

#defn(title: "attainment")[
  A point $x$ of the limit is *attained at grade $g$* when its
  truncations stabilize there: $tau_n (x)$ is the zero-padding of
  $tau_g (x)$ for all $n gt.eq g$. The attained points are
  exactly $NN subset ZZ_2$ — finite support. A point of
  $ZZ_2 without NN$ is attained at no grade.
]

= The classical coincidence

The *limit–colimit coincidence* (Smyth–Plotkin 1982, after
Scott's $D_infinity$): in a cpo-enriched category, an
$omega$-chain of ep-pairs has a *bilimit* — the colimit of the
embeddings and the limit of the projections are canonically the
same object. Freyd sharpened this to *algebraic compactness*:
initial algebra and final coalgebra coincide, $mu F tilde.equiv nu F$,
which is exactly why general recursion is interpretable there.
Applied to our tower, enriched over partiality: the bilimit
exists, and $NN$ and $ZZ_2$ glue into one object. This is
standard, cited mathematics; no badge.

= The no-go, at machine level

The founding conversation named *extensional collapse* — semantics
blind to the difference between cheap and expensive — as the
problem to organize the language around. The claim: the bilimit
coincidence is the categorical mechanism of that collapse, and
cost-grading is precisely the obstruction that keeps the two
completions apart. Since free-`up` (AIP-2), cost is *acquired
address bits*, and the obstruction becomes one asymmetry:

#deskthm(title: "The cone asymmetry: no cost-bounded cone presents the limit")[
  *(i) Colimit side, cheap.* For $x in NN$ attained at grade $g$:
  realizing $tau_n (x)$ costs $O("bits"(x) + g)$ *uniformly in*
  $n$ — beyond $g$ the truncations are zero-paddings; the same
  finitely many writes at the same leaves present every later
  stage. The cocone maps are realized at bounded total
  information-cost per element.

  *(ii) Limit side, unbounded.* For $x in ZZ_2 without NN$: any
  run writing $tau_n (x)$ performs at least $"bits"(x, n)$ paid
  writes, and $"bits"(x, n) arrow.r infinity$. Every family
  $(r_n)$ realizing the cone at $x$ has
  $"cost"(r_n) gt.eq "bits"(x, n)$, unbounded in $n$: presenting
  a genuine limit point never stops acquiring bits.

  *(iii) No finite stage presents the limit.* A grade-$m$
  configuration has finitely many states, $ZZ_2$ has continuum
  many: no fixed-grade object with compatible projections can be
  universal — pigeonhole. Parts (i) and (ii) are elementary desk
  arguments over the mechanized cost model; (iii) is counting. A
  Lean track could take (i)+(ii) nearly verbatim; the *enriched*
  statement — the chain has no bilimit in the cost-enriched
  category — needs the cost-enriched categorical setting and
  stays calculus-tier.
]

So the sharp sentence, now theorem-shaped rather than slogan:

#align(center)[*domain theory is the image of adic under the
cost-erasing functor.*]

Erase the price column — enrich over partiality, let $bot$ make
the chain self-dual — and Smyth–Plotkin fires: the ep-pairs
become self-dual, $mu = nu$, and you land in $D_infinity$. Read
backwards: the coincidence *needs* the erasure. Algebraic
compactness fails in the costed world, and its failure is not a
defect but the content — the gap between $mu$ and $nu$ is where
complexity lives.

= The link, clarified

Three classical worlds sort themselves around the refused bilimit:

+ *Scott / Smyth–Plotkin / Freyd* is the cost-erased shadow: both
  completions taken and identified. It works as well as it does
  because it is a faithful shadow — and it could never see
  complexity, because the shadow is taken by the very functor
  that forgets it.
+ *Metric semantics* (America–Rutten's complete ultrametric
  spaces, Banach-fixed-point recursion) is the *limit side kept
  honestly apart*: $ZZ_2$ with the 2-adic metric — which is
  exactly the geometry of our address tree, distance
  $2^(-|"lcp"|)$. That school solved recursive equations on the
  Pro side without collapsing; adic's cost is, once again, the
  logarithm of their metric.
+ *adic* keeps the diagram and the price: $NN$ and $ZZ_2$ as the
  two poles of one ep-chain, never identified, with the cone
  asymmetry as the reason why. The odometer streams along the
  colimit; the boundary of the tree is the limit; programs live
  strictly between.

#openclaim(title: "The enriched no-go")[
  In the cost-graded enrichment (morphisms carrying cost, the
  grading of AIP-2), the ep-chain ${ZZ\/2^n}$ has a colimit with
  cost-bounded cocone and *no* limit with cost-bounded cone; in
  particular no bilimit, and algebraic compactness fails. The
  machine-level asymmetry above is the finite shadow of this
  statement; the enriched category itself is calculus-tier
  machinery and does not exist yet. This is the formal target
  Mathijs sanctioned (2026-08-10).
]

What this buys the programme: the strong claim (B6) in its
sharpest dress. adic is not a tower we decline to complete; it is
the observation that completing it is lossy, that the loss is
precisely computational cost, and that the two classical schools
are the two projections of the one costed diagram — one forgetting
the price, the other forgetting the finite stages.

]
