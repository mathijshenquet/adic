#import "lib.typ": *

// Style demo for AIP-4 §4.3 — NOT an exposition. The green box below
// uses a hand-pasted receipt (the real streaming theorem, copied from
// lean/Adic/Dyadic.lean) so the style can be judged before the
// harness exists; `lake exe receipts` replaces this mechanism, after
// which hand-pasted receipts are forbidden.

#let demo-receipts = (
  (
    name: "Adic.Dyadic.streaming",
    statement: "theorem streaming (n : Nat) :\n    cost (euler n) ≤ 2 * 2 ^ n ∧\n    run (euler n) (rootHead n) = some (rootHead n) ∧\n    leafVisits (euler n) (rootHead n) = some (leftToRightLeaves n) ∧\n    (leftToRightLeaves n).length = 2 ^ n",
    axioms: ("propext", "Quot.sound"),
    hash: "demo-hand-pasted",
  ),
)

#expo("0 (style demo)", "Three claim levels", "2026-08-09")[

Running mathematics stays in prose: the scan word $e_n$ visits the
$2^n$ leaves in tree order, and its cost telescopes because
$sum_(i<2^n) v_2(i) < 2^n$. No box — the reader is not being asked
to audit anything yet.

#leanthm(
  "Adic.Dyadic.streaming",
  pin: "demo-hand-pasted",
  title: "Streaming is amortized O(1)",
  receipts: demo-receipts,
)[
  A full left-to-right scan of the $2^n$ leaves costs at most
  $2 dot 2^n$: the Euler word succeeds from the root, returns to the
  root, and visits exactly the leaves, in order, once each.
]

#deskthm(title: "Mergesort's honest cost")[
  On $D$, mergesort over $N$ elements of $w$ bits costs
  $Theta(N w log N)$ bit-operations: each of the $log N$ passes is a
  constant number of interleaved streams. Desk-argued; mechanization
  queued behind the ladder.
]

#openclaim(title: "No cost-bounded cone")[
  Any family of maps presenting one object as the limit of the
  projection chain ${ZZ\/2^n}$ has unbounded cost, while the colimit
  is presented at cost zero per element. (Letter 2's thesis
  sentence, awaiting a cost-enriched setting even to state.)
]

]
