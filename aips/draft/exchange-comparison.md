# The positive exchange quotient: what completion does not forget

Draft (2026-08-10). Research report for the `exchange-comparison` track.
This document makes no machine decision and does not edit the coefficient
discipline of AIP-5.

Claim labels used throughout:

- **Verified** means checked against an accepted AIP, a mechanized repository
  fact, or the exact finite computation in `cocycle-classification.md` §2.4.
- **Desk-proved** means a complete mathematical argument is given here but is
  not mechanized.
- **Conjectured** means a precise statement whose proof is not supplied.
- **Wall** means that the requested conclusion is false as stated or stops at
  a named missing lemma.

## 1. Verdict first

Fix a finite reachable action graph $G=(V,E)$ with finite instruction
alphabet $\Sigma$ and edge labeling $\ell:E\to\Sigma$. Let

$$
L:\mathbb Z^\Sigma\longrightarrow\mathbb Z^E,
\qquad (L\lambda)(e)=\lambda_{\ell(e)},
$$

and let $\delta\phi(e)=\phi(t(e))-\phi(s(e))$. The formal classification
group of `cocycle-classification.md` is

$$
\mathcal Q_G=\mathbb Z^E/(\delta\mathbb Z^V+L\mathbb Z^\Sigma).
\tag{1}
$$

**Desk-proved, main comparison theorem.** The natural exchange quotient
defined below maps injectively to $\mathcal Q_G$. Two nonnegative costs have
the same formal class if and only if they are related by the natural monoid
congruence. Consequently the quotient is cancellative, and there is no pair
of $\mathbb N$-costs that becomes equal only after group completion.

There is a stronger finite-grade conclusion. Every integral edge cost can be
made nonnegative by adding a sufficiently large nonnegative price separately
to each instruction. Those prices are zero in the quotient. Therefore

$$
\mathcal M_G\cong\mathcal Q_G;
\tag{2}
$$

the positive edge-cost quotient is already an abelian group. For local
tables, the corresponding quotient is the subgroup

$$
\mathcal M^{\text{loc}}_G
\cong q\rho(\mathbb Z^D)\subseteq\mathcal Q_G,
\tag{3}
$$

and it too is already a group. Its group completion changes nothing.

**Wall, proposed “positive image” distinction.** Under the stated word-price
quotient, the affine semigroup
$q\rho(\mathbb N^D)$ from `cocycle-classification.md` (11) is not an extra
cone: it equals $q\rho(\mathbb Z^D)$. Thus group completion does **not**
forget positivity here. The useful positive datum is instead the relation

$$
R_c=\{(k,\lambda)\in\mathbb N\times\mathbb N^\Sigma:
kc\text{ exchanges with }L\lambda\},
\tag{4}
$$

which records which formal torsion relations admit nonnegative word prices.
The existing four-example computations of $R_c$ remain substantive and are
collected in §4.

Visit parity illustrates the separation exactly. Before killing word prices,
twice the surcharge exchanges with the natural price “one per down.” In
$\mathcal M_G$ this says $x\ne0$ but $2x=0$; in $\mathcal Q_G$ it says that
the image of $x$ has exact order two. Injectivity of (2) makes these the same
equality viewed in a monoid presentation and in a group, not information lost
by completion.

## 2. The natural quotient

### 2.1 Edge costs and local tables

The ambient version begins with the commutative monoid

$$
S_G=\mathbb N^E.
$$

For a fixed observer and grade, let $D\subseteq\Sigma\times Q$ be the
reachable generator/observation pairs and let

$$
\rho:\mathbb N^D\longrightarrow\mathbb N^E
$$

be the table-to-edge map of `local-classes.md` §5.1. The semantic local
version begins with $S_G^{\text{loc}}=\rho(\mathbb N^D)$. A constant table
$j\lambda(a,q)=\lambda_a$ satisfies $\rho(j\lambda)=L\lambda$, so both
starting monoids contain every natural word-price cost.

The edge version makes the comparison with (1) transparent. Every result
below restricts to the local image, and (3) states the only change.

### 2.2 Exact congruence

For $c,d\in S_G$, define

$$
\begin{split}
c\equiv_+d \quad\Longleftrightarrow\quad
&\exists\alpha,\beta\in\mathbb N^\Sigma,
\ \exists\Phi\in\mathbb N^V,\ \forall e\in E,\\
&c(e)+(L\alpha)(e)+\Phi(s(e))
=d(e)+(L\beta)(e)+\Phi(t(e)).
\end{split}
\tag{5}
$$

There are two price vectors because the congruence permits adding a natural
word price on either side. Equation (5) is entirely subtraction-free. With
$\alpha=\beta=0$ it is exactly exchange with an $\mathbb N$-potential; with
$\Phi=0$ it identifies a cost with any natural word-price shift.

**Desk-proved.** Relation (5) is the least monoid congruence containing

1. every exchange pair
   $c+\Phi\circ s=d+\Phi\circ t$ with $\Phi:V\to\mathbb N$; and
2. every word-price pair $c\sim c+L\lambda$ with
   $\lambda\in\mathbb N^\Sigma$.

*Proof.* Reflexivity uses zero data. Addition compatibility follows by adding
the same cost to both sides. Transitivity adds the two price vectors and the
two potentials. For symmetry, choose $K\ge\max_v\Phi(v)$ and put
$\Psi=K-\Phi$. Rearranging (5) without leaving $\mathbb N$ gives

$$
d+L\beta+\Psi\circ s=c+L\alpha+\Psi\circ t.
$$

Thus (5) is a monoid congruence containing the generators. Conversely, its
displayed witness factors through one price shift on each side and one
exchange, so every pair in (5) belongs to the generated congruence. □

Define

$$
\mathcal M_G=S_G/{\equiv_+},
\qquad
\mathcal M_G^{\text{loc}}=S_G^{\text{loc}}/{\equiv_+}.
\tag{6}
$$

This definition avoids an ambiguity in “modulo exchange and prices”: it is a
congruence compatible with addition, not merely the transitive closure of a
directed rewriting rule.

## 3. The comparison and kernel theorems

Let $q:\mathbb Z^E\to\mathcal Q_G$ be the quotient map. Sending the class of
$c$ to $q(c)$ defines

$$
\iota_G:\mathcal M_G\longrightarrow\mathcal Q_G.
\tag{7}
$$

It is well-defined because (5) implies

$$
c-d=L(\beta-\alpha)+\delta\Phi.
\tag{8}
$$

### 3.1 Equality reflection

**Theorem, desk-proved.** For $c,d\in\mathbb N^E$,

$$
q(c)=q(d)\quad\Longleftrightarrow\quad c\equiv_+d.
\tag{9}
$$

The same equivalence holds for two costs in the reachable local image.

*Proof.* The reverse implication is (8). For the forward implication, equality
in (1) gives an integer price $z\in\mathbb Z^\Sigma$ and integer potential
$\phi\in\mathbb Z^V$ such that

$$
c-d=Lz+\delta\phi.
$$

Write $z=z^+-z^-$ coordinatewise, with
$z^+,z^-\in\mathbb N^\Sigma$. Since $V$ is finite, choose one constant $K$
such that $\Phi=\phi+K$ is nonnegative on $V$. Constants have zero
coboundary, and the last display becomes

$$
c+Lz^-+\Phi\circ s=d+Lz^++\Phi\circ t,
$$

which is the natural witness (5). No edge cost is subtracted. □

**Corollary, desk-proved.** The map $\iota_G$ is injective. Both
$\mathcal M_G$ and $\mathcal M_G^{\text{loc}}$ are cancellative. In
particular,

$$
a+x=b+x\Longrightarrow a=b.
$$

This answers the kernel question: neither direction admits a counterexample.
The finiteness of $V$ is used precisely to naturalize the integer potential.
It is the fixed-grade content of AIP-5 §1C; no uniform bound on the shift $K$
across the grade tower is asserted.

### 3.2 The quotient is already a group

Injectivity alone does not usually make a positive monoid a group. Killing
all word prices does so here.

**Theorem, desk-proved.** Map (7) is an isomorphism. The local map is an
isomorphism onto $q\rho(\mathbb Z^D)$.

*Proof for edge costs.* Given $c\in\mathbb N^E$, choose

$$
\kappa_a=\max\{c(e):\ell(e)=a\},
$$

with maximum zero if no edge has label $a$. Then
$c^\vee=L\kappa-c$ is an honest nonnegative edge cost, and

$$
c+c^\vee=L\kappa\equiv_+0.
\tag{10}
$$

Thus every element of $\mathcal M_G$ has an inverse. Its image contains
$q(\mathbb N^E)$; every integral edge cochain becomes nonnegative after a
possibly larger per-letter shift, so $q(\mathbb N^E)=q(\mathbb Z^E)
=\mathcal Q_G$.

For a local table $T$, take
$\kappa_a=\max\{T(a,q):(a,q)\in D\}$ and define
$T^\vee(a,q)=\kappa_a-T(a,q)$. Then
$T+T^\vee=j\kappa$, giving the same inverse argument inside local tables.
An arbitrary integral local table is naturalized in the same way. Hence its
image is exactly $q\rho(\mathbb Z^D)$. □

**Answer: what completion forgets.** At a fixed finite grade, for the quotient
specified in §2, nothing: the unit
$\mathcal M_G\to\operatorname{Gr}(\mathcal M_G)$ is an isomorphism, and the
induced map

$$
\operatorname{Gr}(\mathcal M_G)\xrightarrow{\sim}\mathcal Q_G
$$

is an isomorphism as well. For local tables, replace the target by the local
formal subgroup in (3).

What *is* forgotten by (1) is not recovered by calling (6) positive:

- the actual nonnegative representative $T$ and its magnitude;
- whether an equality to a word price uses a nonnegative price vector;
- the semigroup of all such witnesses $(k,\lambda)$;
- across a tower, whether the **same** $\lambda$ works at every grade.

These live before or over the quotient. The next section isolates the part
that the current reports already compute.

## 4. Image, cone, and the four examples

### 4.1 The image cone collapses

Let

$$
\mathcal H_G=\mathbb Z^E/\delta\mathbb Z^V,
\qquad
\mathcal H_G^+=\operatorname{image}(\mathbb N^E\to\mathcal H_G).
\tag{11}
$$

This is the ordinary ordered graph-cohomology layer before word prices are
killed. Let $\pi:\mathcal H_G\to\mathcal Q_G$ be the price quotient.

**Desk-proved.** The pushed-forward cone is all of $\mathcal Q_G$:

$$
\pi(\mathcal H_G^+)=\mathcal Q_G.
\tag{12}
$$

For local tables,

$$
q\rho(\mathbb N^D)=q\rho(\mathbb Z^D).
\tag{13}
$$

Both statements are the naturalization construction in (10). In particular,
the preorder induced on the word-price quotient is indiscrete: every element
and its negative are positive. Equation (13) corrects the interpretation,
though not the formula, of the “full positive image” in
`cocycle-classification.md` (11).

### 4.2 The positive relation that remains

For a named nonnegative cost $c$, retain

$$
R_c=\left\{(k,\lambda)\in\mathbb N\times\mathbb N^\Sigma\ \middle|\
\exists\Phi\in\mathbb N^V,
kc+\Phi\circ s=L\lambda+\Phi\circ t\right\}.
\tag{14}
$$

Equivalently, before quotienting prices, $kc$ equals the positive price
$L\lambda$ in $\mathcal H_G$. In cycle coordinates this is the homogeneous
Diophantine system $L_{\text{cyc}}\lambda=k c_{\text{cyc}}$ from
`cocycle-classification.md` (13). It is a Presburger-definable affine
semigroup. Unlike (12), it distinguishes an integer torsion relation from one
realizable by natural prices.

**Verified, imported exact computation and witnesses.** Use price-vector
order

$$
(\mathsf{down0},\mathsf{down1},\mathsf{up},
  \mathsf{read},\mathsf{write0},\mathsf{write1}).
$$

The four named costs have the following data. Here $x=[c]$; the “named
subgroup” column concerns only this class, not the whole, much larger local
group.

| observer | grades | named subgroup | $R_c$ |
|---|---:|---|---|
| first touch | every grade | $0$ | $\{(k,0):k\in\mathbb N\}$ |
| dirty write-back | $n\ge1$ | $\mathbb Zx$ | $\{(0,0)\}$ |
| visit parity | $n\ge1$ | $\mathbb Z/2=\{0,x\}$ | $k=2m$ and $\lambda=(m-u,m-u,u,0,0,0)$, $0\le u\le m$ |
| warmth | $n=1$ | $0$ | $\{(k,0):k\in\mathbb N\}$ |
| warmth | $n\ge2$ | $\mathbb Zx$ | $\{(0,0)\}$ |

The grade-one/two orders and relations were computed exactly by SNF and
integer kernels in `cocycle-classification.md` §2.4–2.5. The direct first-touch
and parity identities prove their all-grade rows. The uniform dirty and
warmth witnesses in that report §5.1 extend their displayed nontriviality and
the absence of any nonzero $(k,\lambda)$ to later grades.

Every element of each displayed named subgroup has a nonnegative table
representative. For dirty and warmth this may initially look surprising. If
$T$ is a zero-one surcharge, its per-letter complement
$T^\vee=j\kappa-T$ is nonnegative and represents $-x$. Repeated sums give all
integer multiples. This is precisely why representability alone is not the
positive invariant wanted by AIP-5.

## 5. Parity: divisibility and torsion

Let $c_{\text{par}}$ charge the transitions $1\to0$ of the visit-parity
observer, and let $\Phi$ count marks in state zero. Let $\lambda_\downarrow$
price each down instruction by one and every other instruction by zero.

**Verified, direct identity.** On every runnable edge,

$$
2c_{\text{par}}+\Phi\circ s
=L\lambda_\downarrow+\Phi\circ t.
\tag{15}
$$

There are three exact readings.

1. In the exchange quotient **before** word prices are killed,
   $2[c_{\text{par}}]=[L\lambda_\downarrow]$. This is the natural
   divisibility statement: two copies are an honest natural static price.
2. In $\mathcal M_G$, word prices are the trivial class, so for
   $x=[c_{\text{par}}]$ equation (15) is $2x=0$.
3. In $\mathcal Q_G$, $2\iota_G(x)=0$ is an ordinary group-torsion
   equation.

**Verified, exactness of the order.** The closed word

$$
(\mathsf{down0}\;\mathsf{up})^2
$$

returns every state to its start and has parity cost one. A natural or integer
word price gives it an even value, while a potential cancels. Hence $x\ne0$
in both quotients. Its order is exactly two.

It is safe to say “order-two torsion” in $\mathcal Q_G$. In
$\mathcal M_G$ one can say more explicitly that $x$ is a nonzero unit with
$x+x=0$; since §3 proves that $\mathcal M_G$ is a group, “torsion” is also
literally correct there. The natural content not visible in the bare group
equation is the witness $\lambda_\downarrow\ge0$, recorded by $R_c$.

## 6. Boyle–Handelman: captured data and the extra structure

For a two-sided topological Markov shift $(X,\sigma)$, Boyle and Handelman's
ordered first cohomology is the quotient

$$
H(X,\sigma)=
C(X,\mathbb Z)/\{\xi-\xi\circ\sigma:\xi\in C(X,\mathbb Z)\},
\tag{16}
$$

equipped with the positive cone $H(X,\sigma)^+$ consisting of classes of
nonnegative continuous integer functions. This concrete definition and its
attribution are restated in Matsumoto, §1, pp. 2–3. Boyle–Handelman call the
result preordered in general and prove that the ordered group is a complete
invariant for flow equivalence of irreducible shifts of finite type. See
[Boyle–Handelman (1996)](https://doi.org/10.1007/BF02761039) and the explicit
definition in
[Matsumoto (2015), arXiv:1501.06965](https://arxiv.org/abs/1501.06965).

This already captures the basic combination “integer cocycles modulo
potentials, together with classes having nonnegative representatives.” For an
edge shift, a one-edge locally constant function is an edge cochain and a
vertex transfer function gives the graph coboundary. Thus (11) is the
one-block finite-presentation slice of (16). Allowing higher-block
presentations accounts for more general locally constant functions.

There are two qualifications before identifying their object with ours.

- Boyle–Handelman work with the invertible two-sided shift and, for their
  completeness theorem, irreducible shifts of finite type. Reachable machine
  graphs with reset observers can have transient edges and irreversible
  components. Their bi-infinite edge shifts need not retain those open-run
  edges. Our signed-cycle/edge-system criterion deliberately covers them.
- Their quotient removes coboundaries. It does not come with the machine's
  distinguished labeling map $L:\mathbb Z^\Sigma\to\mathcal H_G$, nor does
  it quotient by its image.

The exact fixed-grade relationship is therefore

$$
(\mathcal H_G,\mathcal H_G^+)
\xrightarrow{\text{quotient by }L\mathbb Z^\Sigma}
\mathcal Q_G,
\tag{17}
$$

together with the reachable local subgroup $q\rho(\mathbb Z^D)$. The first
pair is standard ordered-cohomology data at the graph-local level. The arrow,
the specified price map $L$, and the local-table presentation $\rho$ are our
additional fixed-grade data.

Starting with $\mathbb N$ does not, by itself, add a new invariant here. The
positive cone in (16) already records nonnegative representatives, and after
the price quotient its image is all of $\mathcal Q_G$ by (12). In fact the
useful positive relation can be reconstructed from ordered cohomology **plus
the distinguished natural price map**:

$$
R_c=\{(k,\lambda)\in\mathbb N\times\mathbb N^\Sigma:
k[c]=[L\lambda]\text{ in }\mathcal H_G\}.
\tag{18}
$$

So the honest comparison is:

| datum | ordered cohomology | adic fixed grade |
|---|---|---|
| integer local functions modulo potentials | yes | $\mathcal H_G$ |
| cone of nonnegative representatives | yes | $\mathcal H_G^+$ |
| distinguished instruction-price map | not part of the invariant | $L$ |
| quotient by instruction prices | not part of the invariant | $\mathcal Q_G$ |
| reachable observer-table image | not part of the invariant | $\rho$ |
| natural trivialization relation | recoverable after adding $L$ | $R_c$ |
| one price vector across all grades | no | tower condition |
| reset-observer open-run semantics | not covered by the irreducible two-sided setting | yes |

The defensible difference is not “they use $\mathbb Z$, we use
$\mathbb N$.” At fixed finite grade, that difference dissolves exactly. It is
the structured quotient by machine instruction prices, the observer-local
image, and the uniform graded tower problem. Conversely, Boyle–Handelman's
positive cone is richer than the cone pushed into our price quotient; their
framework warns us not to discard the pre-price ordered layer if lower bounds
need a nondegenerate order.

## 7. Lean statement ladder

The current file `lean/Adic/Cocycle.lean` provides `IsCocycle`, `Exchange`,
and `exchange_append`, with costs and potentials in `Nat`. The graph and local
observer types do not yet exist, so the declarations below are proposed
signatures rather than compiled code. They keep integer arithmetic behind an
opaque `FormalClass`; all operational statements are subtraction-free.

First package the exact congruence using the existing exchange orientation:

```lean
def ExchangeModuloPrices
    (f g : Word → Head n → Nat) : Prop :=
  ∃ leftPrice rightPrice : Move → Nat, ∃ potential : Head n → Nat,
    Exchange (addCost f (letterCost leftPrice))
      (addCost g (letterCost rightPrice)) potential
```

The first rung is purely natural:

```lean
theorem exchangeModuloPrices_equivalence :
    Equivalence (@ExchangeModuloPrices n)

theorem exchangeModuloPrices_add
    (hfg : ExchangeModuloPrices f g) :
    ExchangeModuloPrices (addCost f k) (addCost g k)
```

At graph level, define `PositiveClass G` as the quotient by this congruence
and expose the formal comparison without exposing integer coefficients in the
theorem statement:

```lean
def PositiveClass.toFormal : PositiveClass G → FormalClass G

theorem toFormal_injective :
    Function.Injective (@PositiveClass.toFormal G)

theorem positiveClass_add_right_cancel
    (a b k : PositiveClass G) (h : a + k = b + k) :
    a = b
```

The proof of `toFormal_injective` may use integers internally: split the
formal price vector into positive and negative parts, then shift the finite
potential by its minimum. A useful public lemma states the resulting witness
only in naturals:

```lean
theorem sameFormal_iff_naturalWitness (c d : EdgeCost G) :
    PositiveClass.toFormal ⟦c⟧ = PositiveClass.toFormal ⟦d⟧ ↔
      ∃ α β : LetterPrice G, ∃ Φ : Vertex G → Nat,
        ∀ e, c e + α (label e) + Φ (source e) =
          d e + β (label e) + Φ (target e)
```

The result that the monoid is already a group should also be stated in
exchange form:

```lean
theorem exists_natural_inverse (c : EdgeCost G) :
    ∃ cInv : EdgeCost G, ∃ price : LetterPrice G,
      Exchange (edgeCost (c + cInv)) (letterCost price) 0

theorem positiveClass_isAddGroup :
    ∀ x : PositiveClass G, ∃ y, x + y = 0
```

For local tables, `cInv` is the per-letter complement of the table, so this
theorem requires no `Int`. The local comparison target should be named
`LocalFormalClass G`, preventing the ambient/local-image confusion warned
about in `cocycle-classification.md` §2.1.

Finally parity separates the positive witness from formal torsion:

```lean
theorem parity_twice_exchange :
    Exchange (fun word config => 2 * parityCost word config)
      (letterCost downPrice) parityPotential

theorem parity_not_exchange :
    ¬ ∃ price potential,
      Exchange parityCost (letterCost price) potential

theorem parity_positiveClass_order_two :
    parityClass ≠ 0 ∧ parityClass + parityClass = 0
```

These are the main comparison results in the vocabulary of AIP-5 §1B. The
only essential finiteness hypothesis enters natural symmetry and
`sameFormal_iff_naturalWitness`, where an integer potential is shifted into
`Nat`.

## 8. Consequences and boundary

1. **Desk-proved.** “Positive cost quotient” is algebraically safe but
   misleading if read as a nontrivially ordered monoid: after quotienting all
   word prices it is a group with total image cone.
2. **Desk-proved.** SNF loses no equality between natural costs at a fixed
   grade. It loses the sign of a trivializing price witness unless $R_c$ (or
   the pre-price ordered group with distinguished $L$) is retained.
3. **Verified for the examples.** Parity is the minimal arithmetic case:
   exact group order two and an explicit natural doubled-price witness. Dirty
   and warmth are infinite-order scheduling cases; first touch is zero.
4. **Wall, tower extrapolation.** The proof naturalizes a potential using a
   grade-dependent finite maximum. It does not provide a uniform potential
   bound or a single price vector across grades. The tower wall remains the
   separate one already named in `cocycle-classification.md`.
5. **Recommendation.** Preserve $(\mathcal H_G,\mathcal H_G^+)$ and the
   distinguished map $L$ until after positive lower-bound questions are
   asked. Derive $\mathcal Q_G$ for formal classification, and derive $R_c$
   for realizable pricing. Do not describe $q\rho(\mathbb N^D)$ alone as the
   retained positive layer.

## Repository anchors

- AIP-5 §§0–2: natural exchange form and the fixed-grade bounded-potential
  observation.
- `aips/draft/local-classes.md` §§3–5: observer tables, exchange feasibility,
  parity, and the original class-monoid formulation.
- `aips/draft/cocycle-classification.md` §§1–2: $\mathcal Q_G$, SNF, the four
  exact computations, and $R_c$.
- `aips/draft/cost-cohomology-priorart.md` §§5.3 and 12: the
  Boyle–Handelman warning and the coefficient-comparison action.
- `lean/Adic/Cocycle.lean`: current `Nat`-valued `Exchange` vocabulary.

## References

- M. Boyle and D. Handelman,
  [“Orbit Equivalence, Flow Equivalence and Ordered Cohomology”](https://doi.org/10.1007/BF02761039),
  *Israel Journal of Mathematics* 95, 169–210, 1996.
- K. Matsumoto,
  [“Continuous Orbit Equivalence, Flow Equivalence of Markov Shifts and Circle
  Actions on Cuntz–Krieger Algebras”](https://arxiv.org/abs/1501.06965),
  *Mathematische Zeitschrift* 285, 121–141, 2017; §1 explicitly restates the
  ordered-cohomology group and its positive cone.
