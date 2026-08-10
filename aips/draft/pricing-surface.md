# The pricing surface: bandwidth is the unique eviction-priced dirty resource

Draft (2026-08-10). Research report for the `pricing-surface` track. This
report restricts which local observations may affect a price; it does not
change the observer transition semantics of `local-classes.md`.

Claim labels used throughout:

- **Verified** means checked against an accepted AIP, a mechanized repository
  fact, or the exact finite calculation in §3.
- **Desk-proved** means a complete mathematical argument is given here but is
  not mechanized.
- **Conjectured** means a precise plausible statement whose proof is not
  supplied.
- **Wall** means the stated conclusion is false under the named interpretation.

## 1. Verdict first

**Desk-proved, headline.** Let the dirty observer have

$$
Q=\{C,D\},\qquad q_0=C,\qquad F=L=C,\qquad W=D,\qquad P=\operatorname{id}.
$$

A local price on its **positive eviction surface** is an
observation-blind word price plus a nonnegative surcharge supported only on
$(\mathsf{up},D)$. At every positive grade its semantic class monoid modulo
word prices and exchange potentials is

$$
\mathcal P^{\text{ev}}_{\text{dirty},n}
\cong \mathbb N\,[\mathsf{writeback}].
\tag{1}
$$

The generator has infinite order. Equivalently, the group completion is the
torsion-free rank-one group $\mathbb Z[\mathsf{writeback}]$, while the
physically realizable cone selects its nonnegative ray. This holds uniformly
over the whole tower, not merely at the two computed grades.

**Verified, finite calculation.** Restricting the table-to-edge map of
`cocycle-classification.md` to the two `up` columns gives rank one modulo word
prices at grades one and two. Its only relation is

$$
[u_C]+[u_D]=[\mathsf{up}]=0,
\tag{2}
$$

and $[u_D]$ has infinite order. Restricting further to the oriented positive
surface leaves exactly $\mathbb N[u_D]$. The enumerated graph sizes and cycle
ranks reproduce the earlier calculation exactly.

**Wall for the weaker reading.** “Only `up` may inspect the observer” is not,
by itself, enough to prove (1) as a statement about a nonnegative monoid. It
also permits a surcharge on clean `up`. By (2),

$$
[u_C]=-[u_D],
$$

so the image of all nonnegative tables on the two `up` columns is the entire
group $\mathbb Z[u_D]$, not one copy of $\mathbb N$. A pricing surface must
therefore be oriented: it specifies nonnegative **surcharges above an
observation-blind baseline**, not merely a set of columns allowed to vary.
The cache model supplies the orientation—clean eviction is the free baseline
and dirty eviction carries the liability—so this is a physical restriction,
not a choice made to repair the algebra after the fact.

**Desk-proved, scope.** Under eviction-only pricing, warmth disappears but
visit counters survive. For the warmth observer every state-sensitive `up`
column is a word price plus a potential, at every grade. For the modulo-$r$
visit observer, charging one chosen post-fill state on `up` represents the
same exact order-$r$ class as charging the corresponding visit on `down`.
Thus “eviction-visible” is narrower than “nontrivial local resource,” but it
does not mean “physically a write-back”: finite-state phase can also be read
at a boundary.

## 2. Pricing surfaces

### 2.1 Positive surcharge surfaces

Fix a finite observer $A=(Q,q_0,F,W,L,P)$ and the generator alphabet $\Sigma$
of `local-classes.md`. A local table is a function

$$
T:\Sigma\times Q\longrightarrow\mathbb N.
$$

**Definition.** A *pricing surface* is a subset
$S\subseteq\Sigma\times Q$. Its cone of admissible tables is

$$
\mathsf{Tab}_S=
\left\{
T\ \middle|\
\begin{array}{l}
\text{there are }\lambda\in\mathbb N^\Sigma
\text{ and }s\in\mathbb N^{\Sigma\times Q}\text{ such that}\\
T(a,q)=\lambda_a+s(a,q),\qquad
s(a,q)=0\text{ for }(a,q)\notin S
\end{array}
\right\}.
\tag{3}
$$

The vector $\lambda$ is the observation-blind baseline and $s$ is the
surface surcharge. In particular, every entry off $S$ equals the baseline
for its generator and is observation-blind. The positivity in (3) is
load-bearing: a surface says which observed conditions may add a charge, not
which arbitrary signed deviations are allowed.

Let $\rho_n$ be the reachable table-to-edge map and let $q_n$ quotient edge
cochains by word prices and exchange potentials, as in
`cocycle-classification.md` §2. Define the fixed-grade surface image

$$
\mathcal P^S_{A,n}=q_n\rho_n(\mathsf{Tab}_S).
\tag{4}
$$

Unreachable surface entries map to zero. Definition (4) therefore retains
the earlier reachable-image discipline: choosing a syntactic pair does not
manufacture a semantic class.

There are two related objects which must not be conflated:

1. The formal-difference surface group uses $\mathbb Z^S$ and records all
   signed combinations of surface columns.
2. The physical surface monoid is the image of the cone (3). It may be a
   proper cone in that group, or it may contain units when distinct allowed
   surcharges become opposite classes.

The weak “allowed columns” reading forgets item 2 and is exactly what causes
the counterexample in §1.

### 2.2 The eviction surface

For an observer with baseline mark $q_0$, define the maximal oriented
eviction surface

$$
S_{\text{ev}}(A)
=\{(\mathsf{up},q):q\ne q_0\}.
\tag{5}
$$

Thus non-baseline observer state may add a charge only when the focused
subtree is left. The distinguished baseline entry
$T(\mathsf{up},q_0)=\lambda_{\mathsf{up}}$ pins the orientation. A model may
choose a smaller liability set $E\subseteq Q\setminus\{q_0\}$ and use
$\{\mathsf{up}\}\times E$.

For dirty, $q_0=C$ and (5) is the singleton

$$
S_{\text{ev}}(\text{dirty})=\{(\mathsf{up},D)\}.
\tag{6}
$$

Consequently every admissible dirty table has the unique pointwise normal
form

$$
T(a,q)=\lambda_a+k\,
\mathbf 1_{(a,q)=(\mathsf{up},D)},
\qquad \lambda\in\mathbb N^\Sigma,\quad k\in\mathbb N.
\tag{7}
$$

This is already the “word prices plus write-back” existence statement. The
content of the uniqueness theorem is that semantic quotienting introduces no
identification between different values of $k$.

## 3. Exact grades one and two

### 3.1 Calculation

The finite check repeats `cocycle-classification.md` §2.4 with only the
surface columns retained.

1. Enumerate the reachable augmented graph from every base memory and legal
   initial head position, with all observer marks initially $q_0$.
2. Keep parallel addressed-generator edges and choose an undirected spanning
   forest.
3. Form fundamental-cycle residual columns for the six word prices and the
   allowed table entries.
4. Compute the exact integer relations among those columns. Rational rank
   detects the free surface directions; the integral relations and the
   closed-walk witness detect torsion and the positive image.

**Verified, finite computation.** For dirty the results are:

| grade | $|V|$ | $|E|$ | $b_1$ | rank of word columns | rank after $u_C,u_D$ | surface group |
|---:|---:|---:|---:|---:|---:|---|
| 1 | 20 | 72 | 53 | 5 | 6 | $\mathbb Z$ |
| 2 | 272 | 992 | 721 | 5 | 6 | $\mathbb Z$ |

In the column order

$$
(\mathsf{down0},\mathsf{down1},\mathsf{up},\mathsf{read},
\mathsf{write0},\mathsf{write1},u_C,u_D),
$$

the integral kernel is generated at both grades by

$$
(-1,-1,1,0,0,0,0,0)
\quad\text{and}\quad
(-1,-1,0,0,0,0,1,1).
\tag{8}
$$

The first vector is the depth coboundary
$\mathsf{down0}+\mathsf{down1}-\mathsf{up}=\delta(\mathsf{depth})$.
Subtracting it from the second gives (2). There is no further relation, so
$[u_D]$ is a primitive infinite-order generator and the restricted group is
torsion-free. Intersecting with the cone (6) permits only $k[u_D]$ for
$k\ge0$, proving (1) at the two finite grades. Allowing both `up` states
instead gives
$a[u_C]+b[u_D]=(b-a)[u_D]$, whose positive image is all of $\mathbb Z$.

### 3.2 Direct fixed-grade proof

The computation has a short conceptual certificate.

**Theorem, desk-proved (dirty uniqueness at a fixed grade).** For every
$n\ge1$, the map

$$
\mathbb N\longrightarrow\mathcal P^{\text{ev}}_{\text{dirty},n},
\qquad k\longmapsto k[u_D]
\tag{9}
$$

is an isomorphism of commutative monoids.

*Proof.* Surjectivity is the normal form (7), because the quotient removes
$\lambda$. For injectivity use the words `shortA n` and `shortB n` from
`Adic.Dirty`. They start at the same configuration, end at the same
configuration, and have identical counts of every generator. Their clean
instruction costs are therefore equal. The first has no dirty `up`; the
second has exactly $n$. If $k[u_D]=k'[u_D]$, exchange on these two paths
cancels both the potential and all word prices and gives

$$
kn=k'n.
$$

Since $n\ge1$, $k=k'$. □

The same witness shows that no positive multiple of $[u_D]$ vanishes, so the
group completion of (9) is torsion-free. Grade zero has no runnable `up` and
is intentionally excluded: its surface image is zero.

## 4. The tower

Let $D=\Sigma\times Q$ be the grade-independent table domain and let
$\mathcal R_n\subseteq\mathbb Z^D\oplus\mathbb Z^\Sigma$ be the relation
lattice of `cocycle-classification.md` equation (20). For a surface $S$, let
$i_S$ include its formal surcharge columns and the baseline word-price
columns into that fixed presentation space. Then

$$
\mathcal R^S_n=i_S^{-1}(\mathcal R_n).
\tag{10}
$$

**Desk-proved (surface restriction preserves descent).** Whenever the
strong-connectivity theorem gives
$\mathcal R_{n+1}\subseteq\mathcal R_n$, taking preimages in (10) gives

$$
\mathcal R^S_{n+1}\subseteq\mathcal R^S_n.
\tag{11}
$$

Thus imposing a pricing surface only shrinks the relation lattice. The
rational surface spaces still form a descending chain in one fixed
finite-dimensional space and eventually stabilize. No new saturation claim
is needed or made.

**Desk-proved, dirty tower theorem.** Dirty is strongly connected at every
grade by `cocycle-classification.md` §5.5, so (11) applies. More strongly, the
normal form (7) and the witness proof of (9) are uniform in $n$. Hence the
entire positive-grade tower has the same class monoid
$\mathbb N[\mathsf{writeback}]$, with the same coefficient $k$ in every
grade. This direct proof does not depend on an effective stabilization bound
and does not touch the report's integral saturation wall.

## 5. Which resources are eviction-visible?

### 5.1 Warmth vanishes

For warmth, $Q=\{C,H\}$, $q_0=C$, $F=H$, $P=C$, and
$W=L=\operatorname{id}$. The maximal oriented surface (5) permits only the
hot-up surcharge $u_H$.

**Desk-proved.** Let $A_C(x)$ be the number of cold nodes on the active head
path. A cold active node can only come from the arbitrary initial head
position: entering a node applies $F$ and makes it hot, while `ParentFill`
resets only inactive children. Therefore a cold `up` consumes exactly one
unit of $A_C$, and no other step changes $A_C$. After complementing this
bounded finite-grade potential, $u_C$ is an exchange coboundary. Pointwise,

$$
u_C+u_H=\mathsf{up},
$$

so $u_H$ is a word price plus a potential as well. Every warmth eviction
surface table is trivial modulo word prices at every grade.

**Verified, finite computation.** At grades one and two, adding both $u_C$
and $u_H$ raises the word-column rank by zero. The exact relations contain
$u_C=0$ and $u_H=\mathsf{down0}+\mathsf{down1}$ modulo potentials. The graph
triples $(|V|,|E|,b_1)$ are respectively $(40,128,89)$ and
$(3248,10080,6833)$, reproducing the prior warmth enumeration.

Warmth's original nontrivial witness is necessarily `down`-priced: it detects
whether a fill finds a cold or hot child. Once only the leaving boundary may
inspect state, that information has been overwritten by $F=H$.

### 5.2 The modulo-$r$ counter survives

For the visit observer, $Q=\mathbb Z/r\mathbb Z$, $q_0=0$, $F(q)=q+1$,
and $W=L=P=\operatorname{id}$. Let $u_j$ charge an `up` whose source mark is
$j$.

**Desk-proved.** The down into a node observes $j-1$, changes it to $j$, and
the matching up observes $j$; the mark cannot change while that node remains
on the active path. The discrepancy on open paths is the boundary of the
number of active nodes in state $j$. Hence $u_j$ is exchange-equivalent to
charging the corresponding phase transition on `down`. Phase-edge charges
on the cyclic state graph differ by vertex potentials, so every $[u_j]$ is
the same generator.

The closed word

$$
(\mathsf{down0}\;\mathsf{up})^r
$$

visits every phase once and has $u_j$-cost one. Its word price is a multiple
of $r$, so $k[u_j]\ne0$ for $1\le k<r$. Conversely, the node-counter
potential from `local-classes.md` §4.5 shows that $r[u_j]$ is one static down
price. Thus $[u_j]$ has exact order $r$ at every positive grade. Since the
oriented eviction surface contains $u_j$ for every $j\ne0$, its positive
image is the cyclic group $\mathbb Z/r$ as soon as $r\ge2$.

**Verified, finite computation for $r=2$.** At grades one and two, the
surface columns add no rational rank, but the primitive integral relation is
$2u_j=\mathsf{down0}+\mathsf{down1}$ modulo potentials. The graph triples are
$(48,160,113)$ and $(7168,24576,17409)$, matching the prior parity
calculation. The two-visit loop proves that the order is two rather than one.

### 5.3 Summary

| observer | original priced event | eviction-surface image | tower verdict | reading |
|---|---|---|---|---|
| dirty | dirty `up` | $\mathbb N[\text{writeback}]$ | uniform for $n\ge1$ | unique positive bandwidth resource |
| warmth | cold `down` | $0$ | uniform | invalidation is fill-visible, not eviction-visible |
| visit mod $r$ | wrapping `down` | $\mathbb Z/r$ | uniform for $n\ge1$ | finite phase is boundary-visible |

The table separates two questions. A class may be visible at eviction without
being bandwidth, as the counter shows. The uniqueness theorem says that for
the **dirty observer** and its physical positive surface, bandwidth is the
only non-word-price direction.

## 6. Physical reading

The surface is the algebraic form of an existing machine decision. AIP-2
identifies `down` with acquisition and clean `up` with free discard;
`cache-v0.md` §4b's discharged call 2 identifies `up` with eviction and makes
every dirty eviction pay its eager write-back. AIP-5 fixes the same dirty
observer and explains flush-at-boundary as a gauge change rather than a
second operational semantics. Equation (6) merely says which event is
allowed to inspect the liability bit under those decisions: potential-
consuming clean departure remains at the blind baseline, while a dirty
departure externalizes pending data and adds a nonnegative charge.

## 7. Lean statement ladder

The present deliverable is a report, not a mechanization. The following
statements fit the existing `Adic.Dyadic.Dirty` vocabulary and reuse
`Config`, `step`, `run`, `Prices`, `letterCost`, `Exchange`, `shortA`, and
`shortB`.

First separate the named surcharge from the already mechanized total dirty
cost:

```lean
def writebackCharge (operation : LocalOp) (config : Config n) : Nat :=
  match operation, config.marks with
  | .up, true :: _ => 1
  | _, _ => 0

def writebackCost : Word → Config n → Nat
  | [], _ => 0
  | operation :: word, config =>
      match step operation config with
      | none => 0
      | some next =>
          writebackCharge operation config + writebackCost word next

def evictionSurfaceCost (prices : Prices) (coefficient : Nat) :
    Word → Config n → Nat := fun word config =>
  letterCost prices word config + coefficient * writebackCost word config
```

The structural and compatibility statements should then be:

```lean
theorem writebackCost_isCocycle :
    IsCocycle (writebackCost (n := n))

theorem dirtyCost_eq_clean_add_writeback
    (word : Word) (config final : Config n)
    (hrun : run word config = some final) :
    dirtyCost word config = cleanCost word + writebackCost word config

theorem writebackCost_shortA (n : Nat) :
    writebackCost (shortA n) (root n) = 0

theorem writebackCost_shortB (n : Nat) :
    writebackCost (shortB n) (root n) = n
```

The headline uniqueness statement can avoid defining an abstract quotient:

```lean
theorem evictionCoefficient_unique
    (n : Nat) (hn : 1 ≤ n)
    (leftPrices rightPrices : Prices) (left right : Nat)
    (potential : Config n → Nat)
    (h : Exchange
      (evictionSurfaceCost (n := n) leftPrices left)
      (evictionSurfaceCost (n := n) rightPrices right)
      potential) :
    left = right
```

Its proof is the existing `dirty_not_cohomologous` proof with `shortA` and
`shortB`, retaining the coefficient instead of specializing it to one. The
surface normal form is most naturally encoded as data rather than as a
predicate on arbitrary tables:

```lean
structure DirtyEvictionTable where
  prices : Prices
  writeback : Nat

def DirtyEvictionTable.cost (table : DirtyEvictionTable) :
    Word → Config n → Nat :=
  evictionSurfaceCost table.prices table.writeback

theorem dirtyEvictionTable_classification
    (n : Nat) (hn : 1 ≤ n) :
    Function.Injective (fun k : Nat =>
      -- semantic exchange class of coefficient k at grade n
      dirtyEvictionClass n k)
```

The last theorem needs the repository's eventual concrete class-quotient
type; until then `evictionCoefficient_unique` is the subtraction-free,
fully meaningful theorem. It states exactly that the semantic surface monoid
is a free commutative monoid on write-back.

## 8. Boundaries and friction

- The result is relative to the dirty observer and the oriented positive
  surface. It does not classify arbitrary finite observers.
- The unrestricted `up`-observable cone is not an $\mathbb N$-ray; clean-up
  surcharge supplies the negative generator. Any future use of “eviction
  surface” must retain the baseline/orientation in definition (3).
- The modulo-$r$ result is a mathematical boundary-visible class, not a claim
  that a visit counter is physical bandwidth.
- Surface restriction inherits the rational descending-chain theorem but
  does not solve or use the general irreversible-observer saturation wall.
- The exact calculation was straightforward once the earlier table-to-edge
  map was reconstructed. The non-obvious point was that positivity lives in
  the presentation cone, not in the SNF group completion; omitting that
  distinction reverses the headline monoid.

## References inside the project

- AIP-2, `aips/accepted/0002-dyadic-machine-v0.md`, especially the free clean
  `up` amendment.
- AIP-5, `aips/accepted/0005-dirty-cocycle.md`, especially §§1, 2, and 5.
- `aips/draft/cache-v0.md` §4b, discharged dirty-up pricing call.
- `aips/draft/local-classes.md`, observer semantics and fixed-grade exchange
  criterion.
- `aips/draft/cocycle-classification.md` §§2, 3.2, and 5, table-to-edge SNF,
  failed unrestricted theorem, and local-to-global descent.
- `lean/Adic/Dirty.lean`, mechanized dirty configuration, costs, witnesses,
  and `dirty_not_cohomologous`.
