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

**Wall, tower stabilization.** The named examples stabilize by grade two,
but the proposed fixed-gadget theorem is not proved and is false for the
ambient cohomology groups: their free ranks already grow from $84$ to $6828$
for first touch. For the finite-dimensional local-table image, stabilization
would require a grade-compatible finite boundary summary of integral
holonomy relations. Leaf-only reads and writes, path-wide `WriteBelow`, and
child-wide `ParentFill` prevent the obvious grade embedding from preserving
either labels or tables. That missing boundary-summary lemma is the precise
obstruction.

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
  \tag{20}
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

### 5.3 Mayer--Vietoris and the missing boundary object

Cut the depth-$(n+1)$ tree into its root and two depth-$n$ subtrees. A
Mayer--Vietoris recurrence would need each subtree to expose a finite boundary
summary from which all global holonomy and price-extension relations can be
reconstructed.

**Wall.** The obvious summary “root head position plus root mark” is not
closed under the operations:

- reads and writes are legal only at the grade-dependent leaf boundary;
- `WriteBelow` changes every marked node on a root-to-leaf path, coupling the
  boundary to unboundedly many internal nodes;
- `ParentFill` changes two child marks across the proposed cut;
- an exchange potential may inspect the entire augmented configuration and
  can carry unbounded integral offsets even though the observer is finite.

Consequently the grade-$n$ graph is not a label-and-cost-preserving subgraph
of grade $n+1$. Replacing an old leaf operation by “down, operate, up” changes
both the letter-count vector and the observer events. There is no canonical
map under which the relation lattices form an ascending or descending chain.
Noetherian stabilization of sublattices of a fixed $\mathbb Z^D$ therefore
cannot yet be invoked.

### 5.4 The exact theorem still needed

For the fixed reachable table domain $D$ define the relation lattice

$$
\mathcal R_n=\left\{(t,\lambda)\in\mathbb Z^D\oplus\mathbb Z^\Sigma
\;\middle|\;
\rho_n(t)-\ell_n^*\lambda\in\delta\mathbb Z^{V_n}\right\}.
\tag{21}
$$

Its positive part is Presburger at each grade. Tower triviality of $t$ asks
for one $\lambda\in\mathbb N^\Sigma$ with
$(t,\lambda)\in\mathcal R_n$ for every $n$.

**Conjectured, finite-boundary stabilization.** For each observer whose update
monoid is a finite commuting band and whose priced events are radius zero,
there is an effectively computable $N(A)$ and a finite boundary transfer
object such that (21), including its positive price projection, is determined
for every $n\ge N(A)$ by one fixed transfer relation.

The commuting-band and radius-zero hypotheses are deliberately stronger than
the failed axiom lattice. They rule out (17) and the explicit cross-boundary
reset. Leaf-only operations remain the hard case.

**Wall, current track.** No such transfer object or pumping lemma has been
constructed. In particular, storing only observer states is insufficient;
the summary must preserve an integral lattice of holonomies and its
nonnegative price cone. This is the precise obstruction to the requested
all-grade theorem. The fixed-grade SNF is complete, but a fixed finite gadget
does not currently answer every grade.

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
11. **Scheduling examples.** Mechanize the short uniform dirty pair (20), the
    dirty-read pair (3), and the warmth paths. These exercise equal-count
    holonomy without the large sparse/dense witness.
12. **Exact-sequence theorem.** After the graph layer is stable, formalize (1)
    for finite free abelian groups. The covering-space transgression should be
    a later track; it is not needed for the machine's SNF classifier.

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

**Wall.** The all-grade result remains open at a finite-boundary transfer
lemma, not at SNF. The ambient groups demonstrably do not stabilize. A future
tower track should target the local relation lattices (21) under a narrower
commuting-band observer, not attempt to stabilize all of $H^1(G_n)$.

## Repository anchors

- AIP-5 §§0--2 and §4: action-category cocycles, exchange-form natural
  discipline, dirty holonomy, and the local-class question.
- `aips/draft/local-classes.md`: the observer event language, fixed-grade edge
  feasibility, and the four example witnesses.
- `lean/Adic/Cocycle.lean`: `IsCocycle`, `Exchange`, `exchange_append`, and
  `freeUp_exchange`.
- `lean/Adic/Machine.lean`: `ActionConfig`, `AddressedOp`, `actionStep`, and
  the six raw local operations used by the finite enumeration.
