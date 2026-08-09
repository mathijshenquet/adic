#import "lib.typ": *

#expo(2, "Weighted heads, or fast state under Kraft", "2026-08-10")[

The dyadic machine of Expo 1 prices space by grade and movement by
the tree metric, but it treats all heads alike: any number of them,
each moving at unit cost. Real machines do not extend that
courtesy. A pointer that stays hot lives in registers and low cache
levels; keep many of them hot and they compete for the same fast
silicon. This exposition adds that competition to $D$ as a *priced,
structural* resource — no cache simulator, no eviction model: one
inequality and one surcharge.

= The model

Every head $i$ carries a weight $w_i in NN$. Two rules (cache-v0,
after convo [55]–[59]):

+ *Budget.* An assignment is admissible iff
  $sum_i 2^(-w_i) lt.eq 1$ — the Kraft inequality. Head $i$
  occupies the fraction $2^(-w_i)$ of fast state; the shares are
  disjoint (no overlap between heads, by design: overlap is what
  makes sharing models treacherous).
+ *Surcharge.* Every operation of head $i$ costs $1 + w_i$ instead
  of $1$: the weight is the head's address depth in an implicit
  fast-state tree — a lighter-weighted (hotter) head is cheaper to
  touch.

The plain machine is the fiber $w equiv 0$:

#leanthm(
  "Adic.Dyadic.weightedCost_zero",
  pin: "ec00b0653fab",
  title: "Weighting is a refinement",
)[
  At weight zero everywhere, weighted cost is exactly the old cost
  — every Expo 1 theorem survives as the $w equiv 0$ fiber, and
  weighted cost remains a homomorphism on words.
]

The Kraft condition is not an analogy but the region algebra
itself: admissible weights are exactly antichains of dyadic mount
slots.

#leanthm(
  "Adic.Dyadic.kraft_iff_mounting",
  pin: "95f1dbc459c2",
  title: "Kraft = an antichain of mount slots",
)[
  A weight assignment satisfies Kraft *iff* the heads can be
  mounted injectively on pairwise prefix-incomparable paths with
  $|"path"_i| = w_i$ — prefix-free codes, dyadic disjointness, and
  fast-state budgeting are one condition. Both directions, with a
  constructive canonical mounting.
]

= Streaming survives weighting

#leanthm(
  "Adic.Dyadic.weightedZipCost_closed",
  pin: "1a624131020f",
  title: "Weighted zip, exact",
)[
  The zip schedule of Expo 1 under weights has an exact closed-form
  cost, still linear in $2^n$ — the surcharge enters as the
  multiplicative $(1 + w)$ and nothing worse. The convo's own
  worked example ([59]) — three heads at uniform weight 2, Kraft
  mass $3/4$ — is instantiated and checked:
]

#leanthm(
  "Adic.Dyadic.uniformThreeWeights_kraft",
  pin: "beecf57bdf70",
  title: "…and [59]'s example is admissible",
)[
  $3 dot 2^(-2) lt.eq 1$, in the all-natural formulation, no real
  numbers anywhere.
]

= The entropy bound

Which weights should a program choose? Count the touches: head $i$
touched $c_i$ times out of $n$. Choosing weights against inverse
empirical frequency is admissible and essentially optimal — the
fast-state allocation problem *is* source coding.

#leanthm(
  "Adic.Dyadic.empiricalWeights_kraft",
  pin: "d692acac2be1",
  title: "Frequency weights are admissible",
)[
  The inverse-frequency choice $w_i = ceil(log_2 (n\/c_i))$
  satisfies Kraft — the classical prefix-code argument, in ℕ.
]

#leanthm(
  "Adic.Dyadic.touchCost_empirical_entropy_bound",
  pin: "457dac133f84",
  title: "Achievability: cost ≤ entropy + slack",
)[
  Under those weights the total touch cost is bounded by the
  empirical entropy of the touch sequence (count form
  $sum_i c_i log(n\/c_i)$) plus explicit linear slack — the
  $H(p) + O(1)$ per touch of convo [57], with every ceiling
  accounted.
]

#leanthm(
  "Adic.Dyadic.touchCost_entropy_lower",
  pin: "f52ccc2b3713",
  title: "Optimality: no weights beat entropy",
)[
  Conversely, *every* Kraft-admissible assignment pays at least the
  empirical entropy (floor form, explicit slack): Shannon's lower
  bound, carried by a discrete Gibbs/log-sum inequality proved by
  the counting route —
]

#leanthm(
  "Adic.Dyadic.discrete_gibbs_log_sum",
  pin: "02a7eba433b8",
  title: "The discrete log-sum inequality",
)[
  $sum_i c_i floor(log_2 (n\/c_i)) lt.eq sum_i c_i w_i + n$ for any
  Kraft-admissible $w$ — all-natural, zero-count heads included.
]

Together: fast state allocated like a prefix code, priced like a
code length, optimal like a Shannon code. Biased search trees
(Bent–Sleator–Tarjan) are the data-structure ancestor; dynamic
reweighting (Huffman/FGK) is a known road, deferred.

= What this model refuses

#deskthm(title: "Kraft pricing is not cliff pricing")[
  k-way merge under Kraft weights costs $n log n$ for *every* k —
  the multi-way tradeoff cancels exactly ([57]'s honest
  computation). The external-memory win (log base $M/B$) comes from
  the capacity *cliff*, which this model deliberately lacks: it
  never under-charges, and pessimism is the right failure mode for
  a verifier. Mechanizing this cancellation is phase 3; until then
  it is desk-level.
]

#openclaim(title: "The write-head weight ([72])")[
  Should zip's write head, moving twice the data, get a larger
  share? Touch-frequency pricing says no (all three heads touch
  equally often); data-rate pricing says yes. The tension is
  exactly touch-weighted vs size-weighted Kraft, and its resolution
  belongs to the size-weighted refinement (v1), where a head's
  state size enters the budget.
]

]
