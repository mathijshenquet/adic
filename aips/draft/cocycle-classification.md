# Cocycle classification: cycle lattices, arithmetic torsion, and the tower wall

Draft (2026-08-10). Research report for the `cocycle-classification` track.
This document makes no machine decision and does not change the observation
language of `local-classes.md`.

Claim labels used throughout:

- **Verified** means checked against an accepted AIP, a mechanized repository
  fact, or the exact finite computation described in §2.4.
- **Desk-proved** means a complete mathematical argument is given here but is
  not mechanized.
- **Conjectured** means a precise plausible statement whose proof is not
  supplied.
- **Wall** means the requested conclusion is false as stated or the attempted
  method stops at a named missing lemma.

## 1. Verdict first

**Desk-proved.** At a fixed grade, formal-difference cocycle classes have a
complete Smith-normal-form classification. For the reachable augmented
configuration graph $G$, let

$$
z:H_1(G;\mathbb Z)\longrightarrow \mathbb Z^\Sigma
$$

send a signed cycle to its signed letter-count vector. Then

$$
\mathcal Q_G
=H^1(G;\mathbb Z)/z^*\operatorname{Hom}(\mathbb Z^\Sigma,\mathbb Z)
$$

is the group of integral edge costs modulo potentials and static letter
prices. If $K=\ker z$ and $B=\operatorname{im}z$, there is a short exact
sequence

$$
0\longrightarrow
\operatorname{Ext}^1(\mathbb Z^\Sigma/B,\mathbb Z)
\longrightarrow \mathcal Q_G
\longrightarrow \operatorname{Hom}(K,\mathbb Z)
\longrightarrow0.
\tag{1}
$$

The right side is the free **scheduling** part: it measures equal-count
holonomy. The left side is the finite **arithmetic** part:

$$
\operatorname{Ext}^1(\mathbb Z^\Sigma/B,\mathbb Z)
\cong
\operatorname{Hom}(\operatorname{Tor}(\mathbb Z^\Sigma/B),\mathbb Q/\mathbb Z).
\tag{2}
$$

Thus the scheduling/arithmetic split proposed in `local-classes.md` is not
merely descriptive; it is the canonical fixed-grade exact sequence.

**Verified, finite computation.** Exact enumeration and SNF reproduce all
four examples with no example-specific witness in the calculation:

- first touch has class order $1$ at grades one and two;
- dirty write-back has infinite order at grades one and two;
- visit parity has exact order $2$ at grades one and two;
- warmth has order $1$ at grade one and infinite order from grade two.

The parity ambient quotient contains $(\mathbb Z/2)^2$ at both computed
grades. Dirty and warmth land in the free scheduling quotient. First touch is
a gradient.

**Wall, requested axiom theorem; verified counterexample.** Divisible
coefficients, idempotent observer updates, and radius-zero events do **not**
reduce local classes to homomorphisms plus write-back. The radius-zero
two-state dirty observer itself has a grade-one local-table quotient of free
rank three over $\mathbb Q$. Besides dirty `up`, charging `read` while dirty
is independent: the two paths

$$
\begin{aligned}
A&=\mathsf{down0}\;\mathsf{read}\;\mathsf{write1}\;\mathsf{up},\\
B&=\mathsf{down0}\;\mathsf{write1}\;\mathsf{read}\;\mathsf{up}
\end{aligned}
\tag{3}
$$

have the same start, endpoint, letter counts, and write-back cost, but their
dirty-read charges are $0$ and $1$. No coefficient divisibility can remove an
equal-count holonomy difference. Allowing `ParentFill` adds warmth as another
write-free free class rather than repairing the theorem.

**Desk-proved, partial transgression theorem.** For a genuine connected
regular finite observer cover $Y\to X$ with deck group $D$, the usual
five-term sequence is exact in this graph setting and identifies invariant
upstairs classes modulo pullbacks of **all** base classes with
$H^2(D;\mathbb Z)$. For finite $D$ this is
$\operatorname{Hom}(D,\mathbb Q/\mathbb Z)$; the every-$r$-th-visit class on
the one-node return loop is its generator for $D=\mathbb Z/r$. Equation (2)
is the corresponding exact statement after retaining only global letter
prices.

**Wall, transgression conjecture as stated.** The two quotients are not the
same in general. The machine quotient removes only pullbacks from the letter
rose, whereas the five-term quotient removes every class from the unobserved
base graph. Moreover, idempotent observers are deterministic finite lifts but
not graph coverings because their updates are not invertible. “Arithmetic
classes are exactly transgressions of observer coverings” is therefore true
for the cyclic covering slice and false without these two qualifications.

**Desk-proved, tower progress.** The whole-root grade embedding is the wrong
map, but the left-subtree embedding supplies a genuine finite boundary
object. With $W=P=\operatorname{id}$, all tower-triviality questions reduce
exactly to two finite one-leaf graphs at grade one. More generally, if every
reachable augmented graph is strongly connected, the integral relation
lattices (20) form a descending chain under left-subtree lifting; after
tensoring with $\mathbb Q$ this chain stabilizes. Thus the divisible,
strongly-connected slice has an all-grade stabilization theorem.
If all observer updates are permutations, finite monodromy bounds every
arithmetic index by the exponent of one grade-independent permutation group;
the integral relation lattices then stabilize as well.

**Wall, remaining tower theorem.** The ambient cohomology groups still do not
stabilize: their free ranks grow from $84$ to $6828$ for first touch. For
general reset observers, signed underlying cycles need not lift through the
reachable boundary fiber. Integrally, a descending chain of sublattices of
$\mathbb Z^m$ need not stabilize at all. The full theorem now has two precise
missing lemmas: reachability/saturation of the finite boundary transfer and a
uniform bound on its arithmetic indices.

## 2. Fixed grade by Smith normal form

### 2.1 From the free action category to a graph group

Fix one finite observer $A$ and grade $n$. Let $G=G_{A,n}=(V,E)$ be the
directed multigraph of reachable augmented action configurations, retaining a
separate edge for each runnable addressed generator. The path category of
$G$ is free on its edges. An integral cocycle on that category is consequently
an arbitrary edge cochain

$$
c\in C^1(G;\mathbb Z)=\mathbb Z^E.
$$

**Desk-proved.** Quotienting edge cochains by potentials gives ordinary graph
cohomology:

$$
C^1(G;\mathbb Z)/\delta C^0(G;\mathbb Z)
\cong H^1(G;\mathbb Z)
\cong\operatorname{Hom}(H_1(G;\mathbb Z),\mathbb Z).
\tag{4}
$$

This statement uses signed cycles in the underlying multigraph. It does not
need strong connectivity and therefore includes irreversible observers such
as first touch. Static prices form $\mathbb Z^\Sigma$; the labeling
$\ell:E\to\Sigma$ pulls them back to edge cochains. The formal class group is
the cokernel

$$
\mathcal Q_G=\operatorname{coker}
\left(\mathbb Z^\Sigma\xrightarrow{\ell^*}H^1(G;\mathbb Z)\right).
\tag{5}
$$

This is the precise form of the SNF method requested by the track.

**Warning, desk-proved.** Equation (5) is the ambient edge-cost group, not the
claim that every edge cochain is a local table. If
$\rho:\mathbb Z^D\to\mathbb Z^E$ is the reachable table-to-edge map, the
local-table group is its image in $\mathcal Q_G$. A named surcharge is one
element of that image. Thus “first touch is zero” means that element is zero;
it does not mean the very large ambient group (5) vanishes.

### 2.2 The canonical scheduling/arithmetic exact sequence

Let $H=H_1(G;\mathbb Z)$, $K=\ker z$, and $B=\operatorname{im}z$, where
$z:H\to\mathbb Z^\Sigma$ is signed letter count.

**Theorem, desk-proved.** Sequence (1) is exact and splits noncanonically.

*Proof.* The sequence

$$
0\to K\to H\to B\to0
$$

has free quotient $B$, so restriction of homomorphisms gives

$$
0\to\operatorname{Hom}(B,\mathbb Z)
\to\operatorname{Hom}(H,\mathbb Z)
\to\operatorname{Hom}(K,\mathbb Z)\to0.
\tag{6}
$$

The image of a static price inside the left term is its restriction from
$\mathbb Z^\Sigma$ to $B$. Applying $\operatorname{Hom}(-,\mathbb Z)$ to
$0\to B\to\mathbb Z^\Sigma\to\mathbb Z^\Sigma/B\to0$ gives

$$
\operatorname{coker}\left(
\operatorname{Hom}(\mathbb Z^\Sigma,\mathbb Z)
\to\operatorname{Hom}(B,\mathbb Z)
\right)
\cong\operatorname{Ext}^1(\mathbb Z^\Sigma/B,\mathbb Z).
$$

Quotient (6) by static prices to obtain (1). Since
$\operatorname{Hom}(K,\mathbb Z)$ is free, the extension splits, although no
choice-free splitting is implied. Finally, for a finitely generated abelian
group $C$, $\operatorname{Ext}^1(C,\mathbb Z)$ is canonically dual to its
torsion through $\mathbb Q/\mathbb Z$, giving (2). □

**Desk-proved.** A class is scheduling-trivial exactly when its holonomy
vanishes on $K$, equivalently when equal-count signed cycles have equal cost.
Such a class induces an integral functional $B\to\mathbb Z$. Its arithmetic
order is the least positive denominator needed to extend that functional to
$\mathbb Z^\Sigma$. This recovers both obstructions in
`local-classes.md` §3.3 and proves that every arithmetic obstruction is
torsion.

### 2.3 The matrix

Choose an undirected spanning forest $T$ of $G$. For an edge cochain $x$,
integrate $x$ from the root of each component along $T$ to obtain a tree
potential $p_x$. For every non-tree edge $e:u\to v$, define its fundamental
cycle residual

$$
h_x(e)=x(e)+p_x(u)-p_x(v).
\tag{7}
$$

There are

$$
b_1=|E|-|V|+\#\text{components}
$$

such edges. The residuals identify (4) with $\mathbb Z^{b_1}$. Put the six
letter-indicator residuals in the columns of

$$
L\in\mathbb Z^{b_1\times|\Sigma|}.
$$

**Desk-proved.** If the nonzero Smith diagonal of $L$ is
$d_1\mid\cdots\mid d_s$, then

$$
\mathcal Q_G\cong
\mathbb Z^{b_1-s}\oplus
\bigoplus_{d_i>1}\mathbb Z/d_i.
\tag{8}
$$

For a named cost with residual column $c$, its order is the positive generator
of the projection to $k$ of

$$
\ker_{\mathbb Z}[L\mid-c]
=\{(\lambda,k):L\lambda=kc\}.
\tag{9}
$$

If that projection is zero, the class has infinite order. Equations (8) and
(9) are independent of the chosen forest because changing the forest changes
the cycle basis unimodularly.

### 2.4 Exact computation

The computation used the single addressed head needed by the four examples.
For each grade it did the following.

1. Enumerate every base memory and every legal initial head position with all
   observer marks at $q_0$.
2. Close that set under all six runnable generators using the exact event
   order of `local-classes.md` §2.1. The charge reads the pre-update mark;
   writes update every non-root node on the focused path.
3. Retain parallel generator edges, build an undirected spanning forest, and
   form (7) for the six letter cochains and the named table.
4. Compute the Smith diagonal of $L$ and of the seven-column constraint (9)
   over exact integers.

**Verified, finite computation.** Every enumerated graph below is weakly
connected. Here $s$ is the rank of $L$; `torsion` lists the non-unit Smith
entries of $L$; `order` is the named class order.

| observer | grade | $|V|$ | $|E|$ | $b_1$ | $s$ | free rank | $\operatorname{Tor}$ | order |
|---|---:|---:|---:|---:|---:|---:|---|---:|
| first | 1 | 40 | 128 | 89 | 5 | 84 | none | 1 |
| first | 2 | 3248 | 10080 | 6833 | 5 | 6828 | none | 1 |
| dirty | 1 | 20 | 72 | 53 | 5 | 48 | none | $\infty$ |
| dirty | 2 | 272 | 992 | 721 | 5 | 716 | none | $\infty$ |
| parity | 1 | 48 | 160 | 113 | 5 | 108 | $2,2$ | 2 |
| parity | 2 | 7168 | 24576 | 17409 | 5 | 17404 | $2,2$ | 2 |
| warmth | 1 | 40 | 128 | 89 | 5 | 84 | none | 1 |
| warmth | 2 | 3248 | 10080 | 6833 | 5 | 6828 | none | $\infty$ |

The rank is five rather than six because on every signed cycle the total
number of downs equals the total number of ups. Equivalently,

$$
\mathsf{down0}+\mathsf{down1}-\mathsf{up}=\delta(\text{depth}).
\tag{10}
$$

**Desk-checked.** The computed orders agree with direct identities. First
touch is the change in the number of seen nodes. Twice parity is the price
one on each down plus the potential counting zero marks. Dirty and warmth
have the equal-count holonomy paths already established in
`local-classes.md`; equation (9) shows no nonzero multiple can become a
letter price plus a potential. Warmth is trivial at grade one because a
filled leaf has no children for `ParentFill` to invalidate; depth two is the
first grade at which its witness exists.

### 2.5 The nonnegative refinement

SNF works in the group completion. It does not by itself say which formal
classes or trivializations are realizable by nonnegative costs.

For a nonnegative table $t\in\mathbb N^D$, define its realizable formal class
to be the image of $\rho(t)$ in $\mathcal Q_G$. The full positive image is the
affine semigroup

$$
\mathcal P_{A,n}=q\rho(\mathbb N^D)\subseteq\mathcal Q_G,
\tag{11}
$$

where $q:\mathbb Z^E\to\mathcal Q_G$ is the quotient. For one named
nonnegative cost $c$, define the realizable-price relation

$$
R_c=\left\{(k,\lambda)\in\mathbb N\times\mathbb N^\Sigma\;\middle|\;
\exists\Phi\in\mathbb Z^V,\;
kc+\Phi\circ s=\ell^*\lambda+\Phi\circ t\right\}.
\tag{12}
$$

**Desk-proved.** Integer potentials in (12) may be shifted by a componentwise
constant into $\mathbb N^V$, so (12) is exactly the repository's exchange
discipline. In cycle coordinates it is

$$
R_c=\left\{(k,\lambda)\in\mathbb N^{1+|\Sigma|}\;\middle|\;
L\lambda=kc\right\}.
\tag{13}
$$

It is therefore a homogeneous Presburger-definable affine semigroup. This is
the separate positive layer that SNF intentionally forgets.

**Verified for the named examples.** Write a price vector in the order
`down0`, `down1`, `up`, `read`, `write0`, `write1`.

- First touch, at every grade: $R_c=\{(k,0):k\in\mathbb N\}$.
- Parity, at every positive grade: $k$ must be even. For $k=2m$, all
  nonnegative prices are

  $$
  \lambda=(m-u,m-u,u,0,0,0),\qquad 0\le u\le m.
  \tag{14}
  $$

  Equation (10) explains the freedom to move price from downs to ups.
- Dirty write-back, at grades one and two: $R_c=\{(0,0)\}$.
- Warmth: the first-touch cone at grade one, and $R_c=\{(0,0)\}$ at grade
  two.

The same descriptions for dirty and warmth hold at every later grade by the
uniform witnesses in §5.1.

## 3. The axiom lattice

The proposed restrictions are:

1. coefficients in the divisible ordered monoid $\mathbb Q_{\ge0}$;
2. each primitive update $F,W,L,P:Q\to Q$ is idempotent;
3. radius zero, meaning $P=\operatorname{id}$.

“Idempotent” here means each named update squares to itself. Stronger notions
such as a commuting semilattice action or a single dirty bit are different
axioms and are not silently substituted.

### 3.1 What each restriction really removes

**Desk-proved.** Divisible coefficients kill the arithmetic term (2): tensoring
(1) with $\mathbb Q$ kills all finite torsion. They do not kill the free
scheduling term: the rationalization of $\operatorname{Hom}(K,\mathbb Z)$.
Consequently dirty, dirty-read, redundant-write, and warmth holonomies all
survive averaging.

**Wall, idempotence is too weak.** Idempotence excludes the literal update
$q\mapsto q+1$ on a counter, but it does not force primitive updates to
commute and does not collapse their generated transformation semigroup to a
set/reset bit. Even the standard dirty bit has more priced events than dirty
`up`.

**Desk-proved.** Radius zero removes the warmth construction because no event
at a parent can invalidate its children. It leaves parity, dirty write-back,
dirty-read, and redundant-write tables untouched.

### 3.2 All three axioms, without `ParentFill`

Use $Q=\{C,D\}$ with

$$
F=L=C,\qquad W=D,\qquad P=\operatorname{id}.
$$

All updates are idempotent and radius zero. At grade one, after removing a
static baseline for each letter, the reachable state-sensitive table entries
are represented by

$$
u_D,\quad r_D,\quad z_D,\quad o_D,
$$

meaning dirty `up`, dirty `read`, dirty `write0`, and dirty `write1`.

**Verified, finite SNF; desk interpretation.** Their only relation modulo
letter prices and potentials is

$$
u_D+z_D+o_D=\mathsf{write0}+\mathsf{write1}.
\tag{15}
$$

Indeed, within each fill/leave epoch, the first write makes the node dirty,
every later write sees $D$, and the final dirty up occurs exactly when at
least one write occurred. Hence the number of all writes is the number of
dirty writes plus the dirty-up indicator. The local-table quotient is
torsion-free of rank three, with basis, for example,

$$
[u_D],\ [r_D],\ [z_D].
$$

The dirty-read independence witness is (3). For redundant `write0`, compare

$$
\mathsf{down0}\;\mathsf{write0}\;\mathsf{write1}\;\mathsf{write0}
\quad\text{and}\quad
\mathsf{down0}\;\mathsf{write1}\;\mathsf{write0}\;\mathsf{write0}.
\tag{16}
$$

They have the same endpoint and counts; both remain dirty and end with bit
zero, but the dirty-`write0` counts are one and two. Thus the rank-three
result persists over $\mathbb Q_{\ge0}$.

**Wall, target theorem.** The conjunction of all three proposed axioms has
already failed before adding a second observer or `ParentFill`. A theorem with
one generator would need an additional restriction on **which events may be
priced**, such as “only `up` may inspect the dirty bit,” not merely a
restriction on state updates.

### 3.3 All three axioms, with `ParentFill`

**Desk-proved.** The dirty rank-three slice embeds by synchronous product into
the language with $P$. The two-state warmth observer also has idempotent
updates: $F=H$, $P=C$, and $W=L=\operatorname{id}$. Its depth-two witness is
write-free, so it is independent of every dirty class detected only by writes
or dirty state. Thus the divisible group completion has rank at least four:
three dirty-table directions plus warmth.

This does both resource slices requested by the track. Choosing whether
invalidation is priced selects between “at least rank three” and “at least
rank four”; it cannot select the proposed rank-one headline.

### 3.4 Each single omission

**Verified/desk-proved summary.** Each omission leaves a strict obstruction;
none repairs the failed target.

| omitted restriction | remaining restrictions | exact obstruction |
|---|---|---|
| divisibility | idempotent, radius zero | order-$2$ arithmetic class at grade one |
| idempotence | divisible, radius zero | free reset-counter holonomy |
| radius zero | divisible, idempotent | free warmth holonomy |

For the first row, take $Q=\{0,1,2,3\}$, $q_0=0$, $W=P=\operatorname{id}$,
and

$$
F=(0,0,2,2),\qquad L=(3,1,1,3),
\tag{17}
$$

where a tuple lists the four function values. Both $F$ and $L$ are
idempotent, while $L\circ F$ has the reachable two-cycle $3\leftrightarrow1$.
Charge `down0` exactly when its pre-fill state is $1$.

**Verified, finite SNF.** The grade-one graph has $84$ vertices and $264$
edges; (9) gives exact class order $2$. Thus “primitive updates are
idempotent” does not imply “the generated dynamics have no counters.”

For the second row, take $Q=\{0,1\}$, let $F$ toggle, let $W$ reset to zero,
and let $L=P=\operatorname{id}$. Charge a down whose pre-state is $1$. From an
all-zero root configuration, compare

$$
\begin{aligned}
A&=\mathsf{down0}\;\mathsf{up}\;\mathsf{down0}\;
   \mathsf{write0}\;\mathsf{write0},\\
B&=\mathsf{down0}\;\mathsf{write0}\;\mathsf{up}\;
   \mathsf{down0}\;\mathsf{write0}.
\end{aligned}
\tag{18}
$$

They have identical endpoints and counts, but costs one and zero. This is free
scheduling holonomy, so rational divisibility does not remove it. The third
row is the existing warmth pair with costs three and five.

**Wall, complete axiom-lattice classification.** The tables above classify
the proposed rank-one theorem negatively and give exact lower bounds for all
four regimes. They do not present the entire class monoid of every finite
idempotent transformation semigroup. That broader classification would first
need a stronger algebraic definition of “set/reset automaton”; the literal
idempotence axiom admits arbitrary noncommuting idempotents such as (17).

## 4. Arithmetic classes and transgression

### 4.1 The graph-cover five-term sequence

Let $p:Y\to X$ be a connected regular finite graph cover with deck group
$D$. Put $\pi=\pi_1(X)$ and $N=\pi_1(Y)$, so
$1\to N\to\pi\to D\to1$. Graph fundamental groups are free and have
cohomological dimension one.

**Theorem, desk-proved.** With trivial integral coefficients, the five-term
sequence reduces to

$$
0\longrightarrow H^1(X;\mathbb Z)
\xrightarrow{p^*}H^1(Y;\mathbb Z)^D
\xrightarrow{\operatorname{tr}}H^2(D;\mathbb Z)
\longrightarrow0.
\tag{19}
$$

*Proof.* The standard restriction/transgression sequence for
$1\to N\to\pi\to D\to1$ begins with $H^1(D;\mathbb Z)=0$ because $D$ is
finite, and ends here with $H^2(\pi;\mathbb Z)=0$ because $\pi$ is free.
This gives (19). From $0\to\mathbb Z\to\mathbb Q\to\mathbb Q/\mathbb Z\to0$
and vanishing of positive-degree finite-group cohomology with rational
coefficients,

$$
H^2(D;\mathbb Z)\cong H^1(D;\mathbb Q/\mathbb Z)
=\operatorname{Hom}(D,\mathbb Q/\mathbb Z).
$$

□

### 4.2 The visit counter is literally a transgression

Restrict to one child and let $a=\mathsf{down0}\;\mathsf{up}$ be its return
loop. The modulo-$r$ observer replaces that loop by its connected $r$-fold
cyclic cover. Its closed upstairs loop is $a^r$.

**Desk-proved.** The every-$r$-th-visit cost sends $a^r$ to one. It is
invariant under the deck action. Extending it to the base would require
assigning $a$ the value $1/r$, so its transgression is the generator of

$$
H^2(\mathbb Z/r;\mathbb Z)\cong\mathbb Z/r.
$$

Multiplying by $r$ makes the extension integral, exactly reproducing the
exchange potential and static down price in `local-classes.md` §4.5. This is
the promised five-term explanation of visit torsion.

### 4.3 What survives for the full action graph

The machine quotient (5) does not divide by $p^*H^1(X;\mathbb Z)$; it divides
only by static prices pulled back along the labeling map to the six-letter
rose. These agree on the one-loop slice above but not on a general action
graph, whose base $H^1$ is much larger.

**Desk-proved replacement theorem.** The arithmetic subgroup of the machine
quotient is exactly (2). Put

$$
D_{\mathrm{count}}=\operatorname{Tor}(\mathbb Z^\Sigma/B).
$$

Then arithmetic classes are precisely the characters
$D_{\mathrm{count}}\to\mathbb Q/\mathbb Z$. This finite group is the
abelian **count monodromy**: it measures which integral letter-count
functionals exist on realized cycles but require denominators to extend to
all formal letter counts.

This is transgression algebra, and it is computed by the same non-unit Smith
entries as §2. It need not equal the deck group of the full observer cover.

### 4.4 Precise wall on the conjecture

**Wall.** A deterministic observer projection has unique forward path lifting,
but it is a topological graph cover only when every event update is invertible
on the reachable fiber. First touch, dirty, and warmth use resets and therefore
fail the incoming-star condition. They have finite state, not finite
monodromy in the covering-space sense.

**Wall.** Even for permutation observers, (19) quotients by all base classes,
while (5) quotients by only six letter prices. The conjecture becomes correct
in either of two qualified forms:

1. for a genuine finite regular observer cover, invariant classes modulo all
   base cohomology are exactly the transgressions (19); or
2. for any fixed-grade labeled graph, arithmetic classes modulo word prices
   are exactly the count-monodromy characters (2).

Identifying these two groups requires an extra hypothesis that base
cohomology itself is generated by letter prices. The dyadic action graph does
not satisfy that hypothesis: the large free ranks in §2.4 are direct finite
counterexamples.

## 5. The tower attack

For the fixed presentation domain $D=\Sigma\times Q$ define the relation
lattice below; $\rho_n$ simply ignores entries that are unreachable at grade
$n$.

$$
\mathcal R_n=\left\{(t,\lambda)\in\mathbb Z^D\oplus\mathbb Z^\Sigma
\;\middle|\;
\rho_n(t)-\ell_n^*\lambda\in\delta\mathbb Z^{V_n}\right\}.
\tag{20}
$$

Its positive part is Presburger at each grade. Tower triviality of $t$ asks
for one $\lambda\in\mathbb N^\Sigma$ with
$(t,\lambda)\in\mathcal R_n$ for every $n$.

### 5.1 What stabilizes in the examples

**Desk-proved.** The four named costs have uniform tower verdicts after grade
two.

- First touch is a potential at every grade.
- Visit modulo $r$ has exact order $r$ at every positive grade: the repeated
  left-child loop proves nontriviality, and the sum of node-counter potentials
  proves the $r$-fold relation.
- Dirty write-back is nontrivial at every positive grade. Let
  $D=\mathsf{down0}^n$ and $U=\mathsf{up}^n$. Compare

  $$
  D\,U\,D\,\mathsf{write0}\,\mathsf{write0}
  \quad\text{with}\quad
  D\,\mathsf{write0}\,U\,D\,\mathsf{write0}.
  \tag{21}
  $$

  Both paths have the same endpoint, memory, dirty path, and letter counts.
  The first has zero dirty ups and the second has $n$.
- Warmth is trivial at grade one and nontrivial for every $n\ge2$. The
  depth-two witness remains valid inside every deeper tree: both paths perform
  the same fills of the depth-two nodes, so any additional child resets below
  them also agree.

Thus the examples have threshold at most two. This is evidence for a local
theorem, not a proof for arbitrary finite observers.

### 5.2 Equivariant reduction does not compute the full group

The complete tree has a large automorphism group, and the observer table is
address-blind. It is tempting to quotient configurations by tree symmetry and
compute one orbit gadget.

**Wall, verified finite obstruction.** Cohomology does not commute with this
orbit quotient. Non-invariant cycles survive in $H_1(G_n;\mathbb Z)$, and the
ambient free rank grows sharply:

$$
84\longrightarrow6828
$$

already between grades one and two for the first-touch graph. The parity
graphs grow from free rank $108$ to $17404$. An orbit graph can compute the
invariant summand, not the full SNF in (8), unless all nontrivial symmetry
representations are carried as coefficients. That coefficient system grows
with the grade, defeating the fixed-gadget claim.

### 5.3 The left-subtree correction

The previous attack tried to keep the old root as the new root. It therefore
turned an old leaf operation into “down, operate, up” and changed its word
price. That obstruction is real for that embedding but does not exhaust the
tree recursion.

Embed the whole grade-$n$ tree as the left depth-$n$ subtree of grade $n+1$.
Old leaves are still leaves. Because reachable configurations permit an
arbitrary initial head position, the head may start at the left-child root;
conjugating by `down0` and `up` is unnecessary. Run the old word without ever
taking `up` from that child root.

**Lemma, desk-proved (open left-subtree lift).** Every reachable grade-$n$
path has a grade-$(n+1)$ lift whose internal memory, head, non-root observer
marks, letter word, and table charge are identical. The only extra state is
the mark $q$ on the old root, which was exempt from `WriteBelow` at grade $n$
but is non-root at grade $n+1$. If the old path contains $k$ writes, its
boundary effect is

$$
q\longmapsto W^k(q).
\tag{22}
$$

*Proof.* Start the deeper machine with the corresponding head position and
standard marks, keep the right subtree untouched, and replay the old path in
the left subtree. Every old target, source, leaf, memory update, `ParentFill`,
and table observation is unchanged. A write additionally applies $W$ to the
one new ancestor, the old root. No table entry observes that ancestor during
the confined path. Induction on the word proves the claim. The same replay
also proves the required internal reachability. □

If root-normalized statements insist on the conjugation
`down0 · word · up`, the finite cap is slightly larger: the opening down
applies $F$ to the old root and $P$ to its two children, and the closing up
observes and applies $L$ to the old root. Thus radius zero has a one-node
boundary; the full `ParentFill` language has a width-one collar of three
marks. The open lift avoids that extra cap entirely.

Equation (22) is the missing finite transfer datum. It is a finite boundary
automaton on $Q$, driven only by the total number of writes. It does not yet
imply absolute stabilization, because closing a relative boundary path and
lifting every signed cycle are separate questions.

### 5.4 A complete uncoupled local-to-global theorem

Assume

$$
W=P=\operatorname{id}.
\tag{23}
$$

The observer may still have arbitrary finite, possibly irreversible $F$ and
$L$, and the table may price every reachable event/state pair. For
$b\in\{0,1\}$ define the finite *one-leaf graph* $\Gamma_b$ as follows. A
vertex records

$$
(q,\epsilon,m)\in Q\times\{\text{outside},\text{inside}\}
\times\{0,1\},
$$

restricted to the states reachable from mark $q_0$, either initial head
phase, and arbitrary initial memory bit. Its edges are:

- `downb`: $(q,\text{outside},m)\to(Fq,\text{inside},m)$;
- `up`: $(q,\text{inside},m)\to(Lq,\text{outside},m)$;
- `read`: an inside self-loop;
- `write0` and `write1`: inside edges setting $m$ to the named bit.

Each edge carries the corresponding table charge read at $q$ and its raw
letter label. The down/up subgraph of $\Gamma_b$ is also the complete gadget
for an internal node of orientation $b$.

**Theorem, desk-proved (uncoupled tower classification).** Under (23), a
local table is tower-trivial iff it is trivial at grade one. More precisely,
the formal local class is its image in

$$
\operatorname{coker}\left(
\mathbb Z^\Sigma\longrightarrow
H^1(\Gamma_0;\mathbb Z)\oplus H^1(\Gamma_1;\mathbb Z)
\right),
\tag{24}
$$

and the natural refinement is the intersection of the corresponding finite
edge system with $\lambda\in\mathbb N^\Sigma$.

*Proof.* Necessity is restriction to grade one, whose two leaves realize
$\Gamma_0$ and $\Gamma_1$. Conversely choose one-step potentials
$\phi_0,\phi_1$ on the two gadgets for a common static price $\lambda$. For a
global configuration and each non-root node $v$, let
$\epsilon_v$ say whether the head is inside the subtree rooted at $v$.
If $v$ is a leaf, evaluate $\phi_b$ on its actual bit; if it is internal,
evaluate the down/up restriction at either fixed bit. Define

$$
\Phi_n=\sum_{v\ne\text{root}}
\phi_{b(v)}(q_v,\epsilon_v,m_v).
\tag{25}
$$

A down or up changes exactly the summand belonging to the crossed node. A
read or write changes exactly the focused leaf summand. Assumption (23)
ensures that no operation changes another summand. The applicable gadget edge
equation therefore proves the global one-edge exchange equation. Summing
gives `Exchange` for every word. Integer gadget potentials can be shifted to
naturals before taking the finite sum, so the proof also preserves AIP-5's
subtraction-free discipline. □

**Verified, finite computation.** For both first touch and visit parity, the
full reachable local-table image has rational rank three at grades one and
two. Equation (24) explains the observed equality without enumerating the
grade-two graph: it is already the image of the two grade-one leaf gadgets.
The named first-touch class is zero; the named parity class is the order-two
arithmetic element described earlier.

This is a clean cohomology theory: the enormous global configuration graph is
replaced by two finite cellular $H^1$ computations, and the global potential
is the sum of local potentials.

### 5.5 What survives with `WriteBelow`

For a closed directed walk $w$ at grade $n$, its open lift returns the entire
old configuration and acts on the extra boundary mark by the finite map
$W^{k(w)}$. Starting at any reachable lift and iterating $w$ eventually
reaches a periodic boundary state. Some positive power $w^r$ is therefore a
closed grade-$(n+1)$ walk with exactly $r$ times the old charge and letter
counts.

**Theorem, desk-proved (strongly connected descent).** If every augmented
$G_{A,n}$ is strongly connected, then

$$
\mathcal R_{n+1}\subseteq\mathcal R_n
\tag{26}
$$

for the integral relation lattices (20).

*Proof.* Let $(t,\lambda)\in\mathcal R_{n+1}$ and let $w$ be any directed
closed grade-$n$ walk. Close a periodic open lift as above. Exchange on the
lift gives

$$
r\bigl(c_t(w)-\lambda\mathbin{\cdot}N(w)\bigr)=0.
$$

The coefficient group $\mathbb Z$ is torsion-free, so the parenthesized
integer is zero. Hence $\lambda$ prices every directed closed walk at grade
$n$. Strong connectivity and `local-classes.md` §3.2's closed-walk criterion
give the edge potential required by (20). □

**Corollary, desk-proved (divisible stabilization).** Under the same strong
connectivity hypothesis, the rational relation spaces

$$
(\mathcal R_n)_{\mathbb Q}
\subseteq\mathbb Q^{D+\Sigma}
$$

form a descending chain in one fixed finite-dimensional vector space and
therefore eventually stabilize. The same conclusion holds after imposing
$\lambda\in\mathbb Q_{\ge0}^\Sigma$. Thus the divisible strongly-connected
slice has a finite, although not yet effectively bounded, tower threshold.

**Lemma, desk-proved (dirty is strong; warmth is not).** The dirty augmented
graph is strongly connected at every grade. From any reachable state, moving
the head to the root applies $L=C$ to every possibly dirty node on the active
path; no dirty node can remain off that path, because leaving it would already
have cleared it. The base memory can then be restored by root-to-leaf trips,
each of which returns clean, and any target reachable state can be replayed
from a clean root. In contrast, warmth is not strongly connected: once a
depth-one child is filled it is hot forever, because the root is never itself
filled and hence never sends `ParentFill` to its children.

**Corollary, desk-proved/verified (dirty harvest).** The full dirty-table
relation spaces form a descending rational chain and eventually stabilize.
Exact computations give local-image ranks

$$
3,\ 4,\ 4
$$

at grades one, two, and three. The named dirty write-back class is already
nonzero at grade one, so (26) makes it nonzero at every grade over
$\mathbb Q$; the explicit paths (21) strengthen this named verdict to
integral coefficients. The strong-connectivity theorem does not apply to
warmth, but its write-free depth-two witness embeds unchanged at every later
grade and gives the same uniform named verdict directly.

### 5.6 Integral stabilization for permutation observers

Suppose all four primitive observer updates are permutations of $Q$. Let
$G(A)\le\operatorname{Sym}(Q)$ be the finite group they generate and let
$e(A)$ be its exponent.

**Theorem, desk-proved (permutation tower stabilization).** For a permutation
observer, the integral relation lattices $\mathcal R_n$ eventually stabilize.
Every arithmetic class at every grade has order dividing $e(A)$.

*Proof.* Forgetting observer marks maps the augmented graph to the strongly
connected unobserved action graph. Bijectivity gives a finite graph cover.
Every reachable cover component is strongly connected: a reverse edge in an
undirected path can be replaced by a directed return path followed by a
positive power of a finite-monodromy loop. Hence (26) applies.

At grade $n$, monodromy acts coordinatewise on the node marks, so its image is
a subgroup of a power of $G(A)$ and has exponent dividing $e(A)$. Passing to
the regular closure if the cover is not regular, the count-monodromy group of
§4.3 is a quotient of the abelianization of this finite monodromy group. Its
exponent therefore also divides $e(A)$. The unobserved base contributes no
arithmetic torsion: its closed count lattice is the primitive lattice

$$
N_{\mathsf{up}}=N_{\mathsf{down0}}+N_{\mathsf{down1}},
$$

with independent primitive `read`, `write0`, and `write1` loops. Equation (2)
now bounds all arithmetic torsion by $e(A)$.

Let $S_n$ be the saturation of $\mathcal R_n$ in the fixed presentation
lattice. The rational descent theorem says that $S_n$ eventually equals one
fixed saturated lattice $S$. The torsion bound gives

$$
e(A)S\subseteq\mathcal R_n\subseteq S
$$

from that point on. There are only finitely many subgroups between $e(A)S$
and $S$; since (26) is descending, the integral chain stabilizes. □

This proves the candidate “arithmetic index divides the observer group
exponent” in the genuine finite-monodromy slice. The extension from
permutations to the maximal subgroups of a noninvertible transformation
monoid is exactly the remaining integral conjecture below.

### 5.7 Why this is not yet the full integral theorem

There are two independent gaps.

**Wall, reachability.** When resets make $G_{A,n}$ non-strongly-connected,
edge feasibility is controlled by signed cycles of the underlying graph, not
only directed closed walks. The open lift is a deterministic finite lift, but
a noninvertible $W$ need not lift every reverse edge or signed diamond inside
the standard-reachable fiber. Replacing the reachable graph by all mark
assignments would manufacture a covering but would change the semantic class
problem. The needed statement is:

> the projection of reachable relative cycle lattices is saturated, up to a
> uniformly bounded finite boundary cokernel.

This is the precise reachability/realization lemma.

**Wall, the Noetherian step.** Even if (26) holds, “descending subgroups of a
finitely generated abelian group stabilize by Noetherianity” is false:

$$
\mathbb Z\supset2\mathbb Z\supset4\mathbb Z\supset\cdots.
\tag{27}
$$

Noetherianity controls ascending chains. Tensoring with $\mathbb Q$ repairs
the argument because finite-dimensional vector spaces satisfy the descending
chain condition. Integrally, it would suffice to prove a uniform exponent
$e(A)$ for the boundary torsion: after the rational spans stabilize, every
relation lattice would lie between a fixed saturated lattice $S$ and
$e(A)S$. Only finitely many such sublattices exist.

The finite transformation monoid generated by $F,W,L,P$ is the natural source
of such an exponent. All node updates are coordinatewise, so permutation
subgroups of a grade-$n$ fiber embed in a power of one fixed finite monoid;
their element orders are uniformly bounded. Turning that observation into a
bound for the **reachable signed-cycle cokernel**, including noninvertible
components, remains conjectural.

### 5.8 The local event ledger

The preceding proofs suggest the correct general cohomological object. Give
each geometric node a copy of the finite event graph on $Q$ with edges

$$
q\to Fq,\qquad q\to Lq,\qquad q\to Wq,\qquad q\to Pq.
$$

A global signed cycle projects to local event circulations coupled by the
tree equations

$$
\begin{aligned}
N_F(v)&=N_{\mathsf{down}}(v),&
N_L(v)&=N_{\mathsf{up}}(v),\\
N_P(v)&=N_F(\operatorname{parent}(v)),&
N_W(v)&=\sum_{x\text{ leaf below }v}N_{\mathsf{write}}(x).
\end{aligned}
\tag{28}
$$

Leaf gadgets additionally carry the two-state memory graph. Table cochains
and word prices are linear functionals on this ledger. Warmth is the
noncommuting $P/F$ gluing class; dirty write-back is the $W/L$ gluing class;
visit torsion is local event-graph monodromy. In this sense the three families
are now parts of one theory rather than an example list.

Let $\mathcal L_n$ be the lattice of compatible local circulations satisfying
(28), and let

$$
\eta_n:H_1(G_{A,n};\mathbb Z)\longrightarrow\mathcal L_n
\tag{29}
$$

be the event-ledger map.

**Conjectured, ledger realization.** The cokernel of $\eta_n$ has exponent
bounded by a constant depending only on the finite observer, not on $n$.
After tensoring with $\mathbb Q$, $\eta_n$ is therefore surjective. Under this
statement, the tree equations (28) form the desired finite-collar chain
complex; contracting the underlying tree gives rational stabilization, and
the bounded exponent upgrades it to integral stabilization as in §5.6.

This is the sharpened all-grade target. It is stronger and more testable than
the previous undefined “finite boundary summary”: compute the cokernels of
(29) at small grades, and either find growing Smith exponents or obtain
certificates for the proposed uniform bound.

### 5.9 The exact theorem still needed

**Desk-proved progress.** The transfer object exists exactly in the uncoupled
slice (23), giving (24), and the open boundary mark gives the descent theorem
(26) in the strongly connected slice. These are genuine local-to-global
theorems, not evidence from finitely many grades.

**Wall, current full language.** Proving the ledger-realization conjecture
(29), or finding a counterexample with unbounded cokernel exponent, is now the
remaining hard rung. The fixed-grade SNF can compute each instance, but no
uniform reachability/saturation proof is supplied here.

## 6. Lean rung list

The statements below preserve the subtraction-free public vocabulary of
`lean/Adic/Cocycle.lean`. Integer matrices may be used inside decidability
proofs without changing executable cost statements.

1. **Finite observer.** Define `Observer` with finite `Mark`, `init`, `fill`,
   `writeBelow`, `leave`, and `parentFill`, plus an augmented
   `ActionConfig` carrying one mark per geometric node.
2. **Event semantics.** Define the pre-observation dispatcher for
   `AddressedOp` and prove that its base projection is `actionStep`.
3. **Local cocycle.** Define `localCost table word config` and prove
   `localCost_isCocycle` in the action-configuration analogue of
   `IsCocycle`.
4. **Letter prices.** Define `letterCost : (AddressedOp k → Nat) → ...` and
   prove its cocycle law. State table triviality only as
   `Exchange (localCost table) (letterCost prices) potential`.
5. **Edge/word equivalence.** Prove that one-step exchange on every reachable
   edge is equivalent to word exchange. The forward induction should reuse
   the shape of `exchange_append`.
6. **Natural symmetry at fixed grade.** On a finite reachable graph, prove
   that reversing an exchange uses `K - potential`, with $K$ the finite
   maximum. This internalizes AIP-5's fixed-grade group-completion argument.
7. **Cycle criterion.** Build an undirected spanning forest and prove that an
   integer edge cochain is a gradient iff every fundamental residual (7)
   vanishes. Keep this lemma separate from directed closed-walk statements.
8. **Smith interface.** Define the letter residual matrix $L$ and prove the
   presentation (8), either using a library SNF or a verified certificate
   checker for externally produced unimodular matrices.
9. **Positive cone.** State and prove the equivalence between natural
   `Exchange` feasibility and the nonnegative Diophantine system (13), using
   componentwise shifts to naturalize integer potentials.
10. **Calibration examples.** Mechanize first touch with its seen-count
    potential; parity nontriviality from the two-return loop; and the doubled
    parity exchange identity. These exercise zero and torsion.
11. **Scheduling examples.** Mechanize the short uniform dirty pair (21), the
    dirty-read pair (3), and the warmth paths. These exercise equal-count
    holonomy without the large sparse/dense witness.
12. **Exact-sequence theorem.** After the graph layer is stable, formalize (1)
    for finite free abelian groups. The covering-space transgression should be
    a later track; it is not needed for the machine's SNF classifier.
13. **One-leaf reduction.** Define the two finite gadgets $\Gamma_b$ and
    mechanize (24)--(25) for $W=P=\operatorname{id}$. This is the smallest
    genuine tower theorem and needs no SNF inside its sufficiency proof.
14. **Open left lift.** Formalize the grade-$n$ replay inside the left subtree
    and prove that only the old-root mark changes, by $W^k$ as in (22).
15. **Strong descent.** Under finite strong connectivity, mechanize periodic
    closure of the boundary orbit and derive (26) from the directed-loop
    criterion.
16. **Permutation exponent.** Represent a permutation observer as a finite
    cover, bound count monodromy by the exponent of $G(A)$, and prove the
    finite-sublattice argument of §5.6.

**Verified vocabulary alignment.** Rungs 3--5 state costs with
`IsCocycle`, `Exchange`, and `exchange_append`; no theorem statement requires
subtracting natural costs. This matches AIP-5 §1B and the current
`lean/Adic/Cocycle.lean` API.

## 7. Walls and design consequences

**Desk-proved.** Fixed-grade classification is complete at the formal group
level: compute the cycle lattice, apply SNF, and intersect with the
Presburger-positive cone when realizable prices matter. Equation (1) is the
quotable theorem: local cost has a free scheduling part and a finite
arithmetic part.

**Wall.** “Divisible + idempotent + radius zero implies write-back only” is
mathematically false. The minimal repair is not a proof trick; the observer
language must constrain priced events or impose a substantially stronger
algebra, such as a commuting set/reset band together with a declared pricing
surface.

**Wall.** “Arithmetic equals transgression” needs a quotient named. It is
true for invariant classes modulo all base cohomology and, separately, true
as count-monodromy duality modulo word prices. Equating those versions is
false on the dyadic action graphs.

**Desk-proved.** There is now a clean local-to-global theory in two substantial
slices: the uncoupled observer reduces to the finite one-leaf cohomology
(24), and permutation observers have integral tower stabilization controlled
by finite monodromy. Strongly connected reset observers, including dirty,
stabilize after rationalization.

**Wall.** The all-grade theorem for arbitrary noninvertible observers remains
open at the reachable event-ledger map (29), not at SNF. Warmth supplies the
minimal warning: its top-level hot marks make the augmented graph
irreversible, so directed-loop descent is insufficient. The next theorem is
a uniform saturation/exponent bound for the maximal-group pieces of the
finite transformation monoid; the next counterexample target is an observer
whose ledger cokernel has growing Smith exponent.

## Repository anchors

- AIP-5 §§0--2 and §4: action-category cocycles, exchange-form natural
  discipline, dirty holonomy, and the local-class question.
- `aips/draft/local-classes.md`: the observer event language, fixed-grade edge
  feasibility, and the four example witnesses.
- `lean/Adic/Cocycle.lean`: `IsCocycle`, `Exchange`, `exchange_append`, and
  `freeUp_exchange`.
- `lean/Adic/Machine.lean`: `ActionConfig`, `AddressedOp`, `actionStep`, and
  the six raw local operations used by the finite enumeration.
