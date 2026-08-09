#import "lib.typ": *

#expo(2, "Heads at a distance", "2026-08-10")[

The dyadic machine of Expo 1 prices space by grade and movement by
the tree metric, but it treats all heads alike: any number of them,
each moving at unit cost. Real machines do not extend that
courtesy. A pointer that stays hot lives in registers and low cache
levels; keep many of them hot and they compete for the same fast
silicon. This exposition adds that competition to $D$ as a *priced,
structural* resource — no cache simulator, no eviction model: one
inequality and one surcharge.

= The model

Every head $i$ is mounted at a distance $d_i in NN$. Two rules
(cache-v0, after convo [55]–[59]):

+ *Budget.* An assignment is admissible iff
  $sum_i 2^(-d_i) lt.eq 1$ — the Kraft inequality. Only so much fits
  nearby: head $i$ occupies the fraction $2^(-d_i)$ of fast state,
  and the shares are disjoint (no overlap between heads, by design:
  overlap is what makes sharing models treacherous).
+ *Surcharge.* Every paid operation of head $i$ costs $1 + d_i$;
  `up` remains free because it acquires no address bit. The distance
  is the head's address depth in an implicit
  fast-state tree. A hot head is near and therefore cheaper to touch.

The plain machine is the fiber $d equiv 0$:

#leanthm(
  "Adic.Dyadic.distCost_zero",
  pin: "86a107f6f54c",
  title: "Distance is a refinement",
)[
  At distance zero everywhere, cost is exactly the old cost — every
  Expo 1 theorem survives as the $d equiv 0$ fiber, and cost remains
  a homomorphism on words.
]

The Kraft condition is not an analogy but the region algebra
itself: admissible distances are exactly antichains of dyadic mount
slots.

#leanthm(
  "Adic.Dyadic.kraft_iff_mounting",
  pin: "9f2039740bce",
  title: "Kraft = an antichain of mount slots",
)[
  A distance assignment satisfies Kraft *iff* the heads can be
  mounted injectively on pairwise prefix-incomparable paths with
  $|"path"_i| = d_i$ — prefix-free codes, dyadic disjointness, and
  fast-state budgeting are one condition. Both directions, with a
  constructive canonical mounting.
]

= Streaming survives distance

#leanthm(
  "Adic.Dyadic.distZipCost_closed",
  pin: "aa03139efba5",
  title: "Zip at a distance, exact",
)[
  The zip schedule of Expo 1 under fixed distances has an exact
  closed-form cost, still linear in $2^n$ — the paid leaf and node
  coefficients expose the surcharge exactly, while free ascents
  contribute nothing. The convo's own
  worked example ([59]) — three heads at uniform distance 2, Kraft
  mass $3/4$ — is instantiated and checked:
]

#leanthm(
  "Adic.Dyadic.uniformThreeDists_kraft",
  pin: "8e9b9e91f167",
  title: "…and [59]'s example is admissible",
)[
  $3 dot 2^(-2) lt.eq 1$, in the all-natural formulation, no real
  numbers anywhere.
]

= The entropy bound

Which distances should a program choose? Count the touches: head $i$
touched $c_i$ times out of $n$. Choosing distances against inverse
empirical frequency is admissible and essentially optimal — the
fast-state allocation problem *is* source coding.

#leanthm(
  "Adic.Dyadic.empiricalDists_kraft",
  pin: "29c28abfbdf7",
  title: "Inverse-frequency distances are admissible",
)[
  The inverse-frequency choice $d_i = ceil(log_2 (n\/c_i))$
  satisfies Kraft — the classical prefix-code argument, in ℕ.
]

#leanthm(
  "Adic.Dyadic.touchCost_empirical_entropy_bound",
  pin: "e49667460df8",
  title: "Achievability: cost ≤ entropy + slack",
)[
  Under those distances the total touch cost is bounded by the
  empirical entropy of the touch sequence (count form
  $sum_i c_i log(n\/c_i)$) plus explicit linear slack — the
  $H(p) + O(1)$ per touch of convo [57], with every ceiling
  accounted.
]

#leanthm(
  "Adic.Dyadic.touchCost_entropy_lower",
  pin: "3e2e47c38273",
  title: "Optimality: no distances beat entropy",
)[
  Conversely, *every* Kraft-admissible assignment pays at least the
  empirical entropy (floor form, explicit slack): Shannon's lower
  bound, carried by a discrete Gibbs/log-sum inequality proved by
  the counting route —
]

#leanthm(
  "Adic.Dyadic.discrete_gibbs_log_sum",
  pin: "21aec34cbd41",
  title: "The discrete log-sum inequality",
)[
  $sum_i c_i floor(log_2 (n\/c_i)) lt.eq sum_i c_i d_i + n$ for any
  Kraft-admissible $d$ — all-natural, zero-count heads included.
]

Together: fast state allocated like a prefix code, priced like a
code length, optimal like a Shannon code. Biased search trees
(Bent–Sleator–Tarjan) are the data-structure ancestor; adaptive
distance assignment via dynamic Huffman/FGK reweighting is a known
road, deferred.

= What this model refuses

#deskthm(title: "Kraft pricing is not cliff pricing")[
  k-way merge under Kraft distances costs $n log n$ for *every* k —
  the multi-way tradeoff cancels exactly ([57]'s honest
  computation). The external-memory win (log base $M/B$) comes from
  the capacity *cliff*, which this model deliberately lacks: it
  never under-charges, and pessimism is the right failure mode for
  a verifier. Mechanizing this cancellation is phase 3; until then
  it is desk-level.
]

#openclaim(title: "The write-head distance ([72])")[
  Should zip's write head, moving twice the data, get a larger
  share? Touch-frequency pricing says no (all three heads touch
  equally often); data-rate pricing says yes. The tension is
  exactly touch-frequency distances vs size-aware distances, and its
  resolution belongs to the size-aware distance refinement (v1),
  where a head's state size enters the budget.
]

]
