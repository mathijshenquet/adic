# Local cocycle classes: what finite observers can and cannot absorb

Draft (2026-08-10). Desk report for the `local-classes` track. This document
makes no machine decision. The classification is relative to the observation
language fixed in §2.

Claim labels used throughout:

- **Verified** means checked against an accepted AIP or a mechanized fact in
  this repository.
- **Desk-proved** means a complete finite argument is given here but is not
  mechanized.
- **Conjectured** means a plausible statement whose proof is not supplied.
- **Wall** means the proposed conclusion does not follow in the stated
  language or without an additional hypothesis.

## 1. Verdict first

**Desk-proved.** For a fixed finite observer and a fixed grade, triviality is
an exact finite feasibility problem. Let $G=(V,E)$ be the directed graph of
reachable augmented machine configurations, let $ℓ:E→Σ$ label an
edge by its generator, and let $c_T:E→ℕ$ be the cost induced by a
local table. Then $T$ is a word price plus a potential exactly when there are
letter prices $λ_a∈ℕ$ and a potential
$Φ:V→ℕ$ satisfying, for every edge $e:x→y$,

$$
c_T(e)+Φ(x)=λ_{ℓ(e)}+Φ(y).
\tag{E}
$$

This is precisely the one-step form of `Adic.Dyadic.Exchange`; induction on a
word gives the repository's exchange equation.

**Desk-proved.** If the augmented graph is strongly connected, $E$ is
equivalent to the closed-walk criterion

$$
c_T(W)=\sum_{a\in\Sigma}λ_a\,N_a(W)
\quad\text{for every directed closed walk }W,
\tag{H}
$$

for one natural price vector $λ$. Thus the precise slogan is:

> A local table is trivial iff its closed-walk holonomy is an **integral,
> nonnegative linear function** of letter counts.

The emphasized qualification matters. Merely showing that equal-count loops
have equal cost tests the kernel of the count map, but does not show that the
resulting function extends to natural prices on individual letters.

**Desk-proved.** Write-back is not the only nontrivial local class in the
observation language of §2.

- First touch is trivial: it is exactly the change in the number of touched
  nodes.
- Dirty write-back is nontrivial by AIP-5's equal-letter closed walks.
- Every-second-visit pricing is nontrivial, even though twice that cocycle is
  trivial. Its obstruction is integral divisibility, not order-sensitive
  holonomy.
- Warmth since the parent's last fill is nontrivial. Two equal-letter paths
  with the same endpoints cost $3$ and $5$.
- More generally, charging on every $r$-th visit gives a class whose
  $r$-fold sum is trivial while none of its first $r-1$ multiples is.

The last item supplies a candidate beyond the requested examples (take
$r=3$). It also rules out the hoped-for answer “homomorphisms plus one
write-back generator” for this observation language.

**Wall, representation.** There is no single finite “local class monoid” until
the observer is fixed. Allowing an arbitrary finite marking automaton allows
the visit-counter family for every $r$, irreversible bits such as first
touch, and radius-one invalidation such as warmth. As in the mounting-image
wall of `operadic-canonicity.md`, the image must be stated exactly: a table is
only observable on generator/mark pairs that occur on reachable edges.
Classifying the ambient set $Σ × Q$ silently counts unreachable
entries.

**Wall, uniformity.** The fixed-grade problem is finite and decidable. The
tower problem asks for one price vector $λ$ that works at every grade;
the potentials may vary with the grade. No stabilization bound reducing that
infinite family to finitely many grades is proved here.

## 2. The observation language

### 2.1 A finite event observer

Fix the raw generator alphabet

$$
\Sigma=\{\mathsf{down0},\mathsf{down1},\mathsf{up},\mathsf{read},
\mathsf{write0},\mathsf{write1}\}.
$$

For multiple heads, the addressed head index can be included in the finite
generator alphabet. Nothing below otherwise changes. `halt` has no outgoing
machine edge and is omitted.

**Definition.** A *node observer* $A$ consists of a finite set $Q$, an
initial mark $q₀$, and four deterministic updates

$$
F,W,L,P:Q\to Q.
$$

They mean `Fill`, `WriteBelow`, `Leave`, and `ParentFill`. At grade $n$, every
geometric node of the depth-$n$ tree carries one mark in $Q$, initialized
to $q₀$. A successful generator step dispatches events in the following
fixed order.

1. `downb` observes the target child's mark, charges the table, applies $F$
   to that child, then applies $P$ to each of the child's immediate children.
2. `up` observes the source node's mark, charges the table, then applies $L$
   to that source node.
3. `writeb` observes the focused leaf's mark, charges the table, then applies
   $W$ to every non-root node on the root-to-focus path, including the leaf.
   The root has no parent to which it could owe a write-back.
4. `read` observes the focused leaf's mark and charges the table; it does not
   change marks.

The transition is performed only when the underlying partial machine step is
runnable. The charge reads the pre-event mark. A local table is therefore

$$
T:\Sigma\times Q\longrightarrow\mathbb N.
$$

Only the event node is observed: not its address or depth, not its parent or
sibling marks, not another head, and not the stored data bit. The write
generators already distinguish the value written. This is a strict finite
presentation independent of the grade.

`ParentFill` is the one deliberate radius-one operation. It makes the requested
“visited since the parent's last fill” observer expressible. Setting $P$ to
the identity recovers the stricter `Fill`/`WriteBelow`/`Leave` language
suggested in AIP-5. Removing $P$ removes the warmth example; it does not
affect the other verdicts.

### 2.2 Knobs fixed, and knobs left out

The report fixes the following choices.

- **Persistent geometric marks.** A mark belongs to a tree node, not merely to
  a stack frame. `Fill` or `Leave` may reset it if the observer chooses.
- **Automaton-relative classes.** The automaton is part of a presentation.
  Two observers are compared through their synchronous product; their tables
  are pulled back along the two projections. Pointwise addition also uses this
  product. Thus examples with different minimal state spaces still live in a
  common additive framework.
- **Reachable image.** $G_{A,n}$ contains augmented configurations reachable
  from the standard mark $q₀$, with arbitrary legal base memory and head
  positions as starting machine data. A table entry not used by any reachable
  edge has no semantic class.
- **Arbitrary potentials.** A potential may inspect the whole augmented
  configuration. It need not itself be local or finitely presented. This is
  the strongest reasonable notion of “absorbable”: a nontriviality result here
  survives every narrower choice of potentials.
- **Uniform word prices.** For the tower, $λ$ is independent of the
  grade. A separate natural potential $Φ_n$ is allowed at each finite
  grade.

Not included are unbounded timestamps, exact recency order, addresses, depth,
subtree population counts, or broadcasts beyond children. Those choices would
define different classification problems.

### 2.3 The examples are honest instances

**Desk-proved.** Each requested observer is a finite instance of the preceding
definition.

- First touch: $Q=\{U,S\}$, $F(U)=F(S)=S$, and the other updates are the
  identity.
- Dirty write-back: $Q=\{C,D\}$, $F=L=C$, $W=D$, and $P$ is the
  identity.
- Visit modulo $r$: $Q=\mathbb Z/r\mathbb Z$, $F(q)=q+1$, with other
  updates the identity.
- Warmth: $Q=\{C,H\}$, $F(C)=F(H)=H$, $P(C)=P(H)=C$, with $W,L$ the
  identity.

Products combine these observations without changing their individual
updates.

## 3. Exchange form and the exact finite criterion

For a runnable word $w$ from augmented configuration $x$, let
$C_{T,x}(w)$ be the sum of its table charges. The event semantics is
deterministic, so splitting a run after $u$ partitions the same edge list.

**Desk-proved.** $C_T$ is a cocycle in the exact shape of
`Adic.Dyadic.IsCocycle`:

$$
C_{T,x}(uv)=C_{T,x}(u)+C_{T,x\cdot u}(v).
$$

This is finite-sum concatenation; no property of the observer updates beyond
determinism is needed.

For $λ∈ℕ^Σ$, write

$$
h_λ(w)=\sum_{a\in\Sigma}λ_aN_a(w).
$$

Because the target monoid $(ℕ,+)$ is commutative, every word
homomorphism has exactly this form: it sees only letter counts (AIP-5 §2).

**Definition.** A table is *trivial at grade $n$* when there are
$λ∈ℕ^Σ$ and
$Φ_n:V(G_{A,n})→ℕ$ such that

$$
C_{T,x}(w)+Φ_n(x)
=h_λ(w)+Φ_n(x\cdot w)
\tag{X}
$$

for every runnable word. It is *tower-trivial* when one $λ$ makes $X$
true at every grade, allowing a different $Φ_n$ at each grade. This is
`Exchange C_T h_λ Φ_n`, not subtraction disguised as natural arithmetic.

### 3.1 Edge feasibility

**Theorem (desk-proved).** Equation $X$ holds iff its one-edge instances $E$
hold.

*Proof.* Necessity uses one-letter words. Conversely, suppose $E$ holds on
every edge of $x=x_0→x_1→\cdots→x_k=y$. Adding the equations cancels
all intermediate potentials and gives

$$
∑_i c_T(e_i)+Φ(x)=∑_iλ_{ℓ(e_i)}+Φ(y),
$$

which is $X$. This is the table-level analogue of the mechanized
`exchange_append`. □

For a fixed finite grade, $E$ is a finite system of integer equalities with
nonnegativity constraints on $λ$. Potential nonnegativity adds no
obstruction: any integer solution for $Φ$ can be shifted by a constant on
each weak component until it is natural-valued. Hence fixed-grade triviality
is decidable by integer linear feasibility.

### 3.2 Directed graphs: what holonomy does and does not prove

Fix $λ$ and put

$$
d_\lambda(e)=c_T(e)-\lambda_{\ell(e)}\in\mathbb Z.
$$

Equation $E$ says exactly that $d_λ(e)=Φ(t(e))-Φ(s(e))$.

**Theorem (desk-proved, general directed case).** Such a potential exists iff
the signed sum of $d_λ$ vanishes around every cycle of the underlying
undirected multigraph: traverse a forward edge with sign $+1$ and a backward
edge with sign $-1$.

*Proof.* Gradients telescope around every signed cycle. Conversely, in each
weak component choose a root and a spanning tree, define $Φ$ by signed
path sums along that tree, and use the fundamental cycle made by each non-tree
edge to prove its edge equation. Shift $Φ$ to $ℕ$. □

**Theorem (desk-proved, strongly connected case).** If $G_{A,n}$ is strongly
connected, the signed-cycle test is equivalent to $H$.

*Proof.* Gradients telescope on directed closed walks. Conversely suppose all
directed closed walks have zero $d_λ$-sum. Fix a root $r$. For a
vertex $v$, choose a directed path $P:r→v$ and set
$Φ(v)=d_λ(P)$. If $Q:r→v$ is another choice, strong
connectivity supplies $R:v→r$. Both $PR$ and $QR$ are directed closed
walks, so $d(P)+d(R)=d(Q)+d(R)=0$, hence $d(P)=d(Q)$. Comparing a chosen
path to $s(e)$ followed by $e$ proves the edge equation. Finally shift the
finite range of $Φ$ into $ℕ$. □

**Warning (desk-proved).** The base dyadic-machine graph is strongly connected:
heads can return and writes can restore the store. An augmented observer graph
need not be. First touch has a transition $U→S$ and no return. In a
general directed graph, directed closed walks can miss an inconsistent signed
cycle (for example, a square oriented from two sources to two sinks). This is
why $E$, not a bare closed-loop slogan, is the primary criterion.

### 3.3 Two obstructions hidden by the slogan

Let $Z(W)=(N_a(W))_a$ be a closed walk’s count vector.

**Desk-proved.** In a strongly connected slice, triviality requires two
logically separate facts.

1. **Kernel/order condition:** if $Z(W)=Z(W′)$, then
   $c_T(W)=c_T(W′)$.
2. **Integral extension condition:** the induced additive price on realizable
   closed-walk count vectors is the restriction of dot product with some
   $λ∈ℕ^Σ$.

Together they are exactly $H$. Write-back and warmth fail the first condition.
Visit counters pass the first but fail the second. Thus equal-letter witness
search is powerful but not complete.

## 4. Worked examples

The examples price only the named surcharge. Adding any fixed base instruction
price is adding a homomorphism and does not change a verdict.

### 4.1 First touch — trivial

Let $S(x)$ be the number of nodes marked seen in configuration $x$. Charge
one on `down0` or `down1` exactly when its target is $U$, and zero otherwise.

**Verdict: trivial (desk-proved).** A first touch changes exactly one mark from
$U$ to $S$, so on every edge

$$
c_{\mathrm{first}}(e)+S(s(e))=S(t(e)).
$$

Thus $E$ holds with $h=0$ and potential $S$. Equivalently, if $U(x)$ is
the number of untouched nodes, then

$$
U(s(e))=c_{\mathrm{first}}(e)+U(t(e)),
$$

which is the candidate “count untouched nodes” in the reverse exchange
orientation. Since a grade has finitely many nodes, $S+U$ is constant and
the two formulations are the same exchange class.

This calibration also demonstrates why irreversible observer state is not a
problem for $E$, but is a problem for using only directed loops.

### 4.2 Dirty write-back — nontrivial

Charge one on an `up` whose source mark is $D$, zero on a clean `up`, and
zero on all other generators. `write0` or `write1` marks every active ancestor
dirty; leaving a node writes it back and clears its mark.

**Verdict: nontrivial (desk-proved).** Use the complete padding construction
of AIP-5 §2. At a clean, root-focused, all-zero configuration $x₀$, choose
$m=2^k=Θ(n)$.

- The sparse loop makes $m$ isolated depth-$n$ round trips writing ones and
  repeats them writing zero. Balanced addresses give $mn$ occurrences of
  each down letter, $2mn$ ups, and $2m$ writes. Every up is dirty, so the
  write-back surcharge is $2mn$.
- The dense loop writes and erases the leftmost $m$-leaf block by two Euler
  sweeps. It is padded by clean excursions into the untouched right half until
  its counts of `down0`, `down1`, `up`, and writes equal the sparse loop's
  counts exactly. Its write-backs are only
  $2[2^{k+1}-2+n-k]=Θ(m+n)$; padding ups are clean.

Both are closed at $x₀$: the store is restored, the head is at the root,
and every dirty mark has been cleared. A homomorphism gives equal prices to
their equal letter counts and a potential vanishes on both loops, but their
write-back costs differ by

$$
2mn-\Theta(m+n)=\Theta(n^2).
$$

This is exactly AIP-5's holonomy argument, phrased for the observer above. It
fails the kernel/order condition of §3.3.

### 4.3 Visit parity — nontrivial, but twice trivial

Let a target node's mark toggle on each fill. Charge one when the pre-fill mark
is $1$, so visits numbered $2,4,6,\ldots$ pay.

**Verdict: nontrivial (desk-proved).** At grade at least one, start at the root
with its left child in state $0$. The word

$$
(\mathsf{down0}\;\mathsf{up})^2
$$

returns the head and every observer mark to its starting value and costs one.
Any natural word price assigns it

$$
2(\lambda_{\mathsf{down0}}+\lambda_{\mathsf{up}}),
$$

which is even. A potential cancels on the loop, so $H$ is impossible.

**Desk-proved.** Twice the parity cocycle is trivial. Give every down generator
static price one. Let

$$
Φ(x)=\#\{v:q_v=0\}.
$$

On $0→1$, no visit charge is paid and $Φ$ decreases by one; on
$1→0$, twice the charge is two and $Φ$ increases by one. In both cases

$$
2c_{\mathrm{parity}}(e)+\Phi(s(e))
=1+\Phi(t(e)).
$$

Other generators change neither side. Hence $2[c_{\mathrm{parity}}]=0$ in
the quotient by word prices and exchange potentials, while
$[c_{\mathrm{parity}}]\ne0$. This is an integral divisibility obstruction;
over rational coefficients it would disappear.

It is also not generated by write-back: the parity witness contains no writes,
so every multiple of the write-back surcharge is zero on it, while the same
evenness contradiction excludes a correcting natural word price.

### 4.4 Warmth since the parent's last fill — nontrivial

A node is cold immediately after its parent is filled and hot after it is
itself filled. A down into a cold target costs one; a down into a hot target is
free. This is the $P$-event observer of §2.

At depth two, name $p=0$, $x=00$, and $y=01$. Write $d_b$ for
`downb` and $u$ for `up`. Compare the paths

$$
\begin{aligned}
A={}&d_0\;(d_0u\;d_0u)\;u\;d_0\;(d_1u\;d_1u)\;u\;d_0u,\\
B={}&d_0\;(d_0u\;d_1u)\;u\;d_0\;(d_0u\;d_1u)\;u\;d_0u.
\end{aligned}
$$

The first entry to $p$ starts epoch one; the second starts epoch two and
invalidates both children; the final entry to $p$ normalizes both children
to cold before returning to the root.

**Verdict: nontrivial (desk-proved).** Both paths have five `down0`s, two
`down1`s, and seven `up`s. They start at the same all-cold configuration and
end at the same configuration: the head is at the root, $p$ is hot, and
$x,y$ are cold. In $A$, each epoch repeats one child, so the warmth cost is
one initial miss at $p$ plus one miss at $x$ and one at $y$, total $3$.
In $B$, both children miss in both epochs, giving one plus four, total $5$.
Equal endpoints cancel every potential and equal counts cancel every word
price, a contradiction.

This class is not generated by write-back either. The witness is write-free,
so dirty surcharge is zero on both paths, yet warmth distinguishes them after
word prices and potentials have canceled.

### 4.5 Candidate: every $r$-th visit

Fix $r\ge2$. Increment a mark in $\mathbb Z/r\mathbb Z$ on each fill and
charge one exactly on the transition $r-1→0$. Parity is $r=2$; the
requested additional candidate may be taken as $r=3$.

**Verdict: nontrivial with exact additive period $r$ (desk-proved).** The
closed word

$$
(\mathsf{down0}\;\mathsf{up})^r
$$

costs one from counter state zero. A word price gives a multiple of $r$, so
the class is nonzero. More generally, its $k$-fold sum costs $k$ on this
loop and is nontrivial for every $1\le k<r$.

For the $r$-fold sum, price every down by one and define

$$
Φ(x)=\sum_v(r-1-q_v),
$$

using representatives $q_v\in\{0,\ldots,r-1\}$. A non-wrapping visit lowers
$Φ$ by one and pays zero; a wrapping visit raises $Φ$ by $r-1$ and
pays $r$. In both cases

$$
r c_r(e)+\Phi(s(e))=1+\Phi(t(e)).
$$

Thus $r[c_r]=0$, and the loop proves that no smaller positive multiple is
zero. Arbitrary finite local automata therefore introduce genuine arithmetic
classes that a write-back-only classification cannot see.

## 5. What has actually been classified

### 5.1 The fixed-observer class monoid

Tables add pointwise. Tables over different observers add after pullback to the
synchronous product observer. Exchange equivalence is compatible with
addition because letter prices and potentials add.

**Desk-proved.** At a fixed finite grade, exchange is symmetric despite its
directed-looking natural form. If

$$
C+\Phi_{\mathrm{before}}=D+\Phi_{\mathrm{after}},
$$

choose $K\ge\max Φ$ and put $Ψ=K-Φ$. Then

$$
D+\Psi_{\mathrm{before}}=C+\Psi_{\mathrm{after}}.
$$

It is also reflexive and transitive. Taking this exchange quotient and then the
congruence that identifies every word price with zero produces a commutative
class monoid. The modulo-$r$ examples show that this monoid need not be
torsion-free.

For computation, let $D_{A,n}\subseteq\Sigma\times Q$ be the set of
generator/observation pairs that occur on reachable edges. The table-to-edge
map is

$$
ρ_{A,n}:\mathbb N^{D_{A,n}}\longrightarrow\mathbb N^{E(G_{A,n})}.
$$

**Desk-proved.** The fixed-grade semantic class monoid is exactly the image of
$ρ_{A,n}$, modulo the edge relations $E$. This is a finite presentation
and can be computed by integer linear algebra or Presburger feasibility. It is
the reachable image, not all of $\mathbb N^{\Sigma\times Q}$.

### 5.2 Across the graded tower

**Desk-proved.** A table is tower-trivial iff one
$λ\in\mathbb N^\Sigma$ makes the finite edge system $E$ feasible for
every $n$. The potentials $Φ_n$ need not be uniformly bounded: adding a
grade-dependent constant changes no exchange equation. This matches AIP-5's
warning that fixed-grade potential bounds do not settle an across-grade
question.

**Wall.** This report does not prove a locality or pumping theorem of the form
“checking through grade $N(A)$ suffices.” The configuration graphs grow with
both the data tree and the distributed observer state. The finite table is a
compact presentation, but compact presentation alone is not a finite bound on
all holonomy relations it generates.

### 5.3 What the examples say about generators

**Desk-proved.** There are at least two qualitatively different sources of
nontriviality in the chosen language.

1. **Scheduling/holonomy classes:** equal letter counts can be ordered to
   produce different cost. Dirty write-back and warmth are examples.
2. **Arithmetic classes:** holonomy depends only on letter counts on realizable
   loops but cannot be extended to natural prices per letter. Visit modulo
   $r$ is the example.

Write-back is therefore neither the only class nor a generator for the
examples above. First touch, by contrast, is a pure potential. These verdicts
are stable under adding static base prices.

**Conjectured, narrower dirty slice.** If the observer is fixed to the single
dirty bit, the only order-sensitive generator may be dirty `up`, with other
state-sensitive table entries reducing to word prices, potentials, or its
multiples. This report does not prove that claim. In particular, prices on
“first write since fill” must be checked rather than assumed reducible.

## 6. A mechanization-ready formulation

The definitions can be consumed by a future Lean track without changing the
existing cocycle API.

1. Define a finite `Observer` with `init`, `fill`, `writeBelow`, `leave`, and
   `parentFill`.
2. Extend a grade-$n$ action configuration by a finite vector of node marks.
3. Define the successful one-step event dispatcher and a table lookup before
   its updates.
4. Prove `localCost_isCocycle` by the same word split used by
   `cost_isCocycle`.
5. State `TableTrivial T prices potential` as
   `Exchange (localCost T) (letterCost prices) potential`.
6. Prove the edge iff word theorem; this is the local-table specialization of
   `exchange_append`.
7. Mechanize the parity and warmth witnesses before attempting a general
   solver. They exercise the integral-extension and equal-count branches
   separately.

The exact natural equation should remain

$$
localCost(w,x)+Φ(x)
=\text{letterCost}(w)+Φ(x\cdot w),
$$

matching `Adic.Dyadic.Exchange`. Integer subtraction is useful in this report's
proofs of the graph criterion, but is not required in executable definitions
or theorem statements.

## 7. Walls, design consequences, and next work

**Wall.** The broad finite-observer language is too expressive for the class
monoid to be generated by write-back. This is a mathematical counterexample,
not merely missing proof technique: visit modulo $r$ and warmth are explicit
finite observers with desk proofs.

**Wall.** “Closed-walk holonomy classifies everything” is false without either
strong connectivity of the *augmented* graph or replacement by the signed
underlying-cycle/edge-system criterion. First touch is the smallest warning.

**Recommendation.** If the programme wants a quotable theorem that
write-back is the unique local resource, it must first narrow the observation
language, most plausibly to the resettable dirty-bit slice, and then classify
all reachable entries of that slice. The present broader language is better
suited to the different theorem: finite local resources are decidable at each
grade, and they split into scheduling and arithmetic obstructions.

**Recommendation.** A future mechanization should implement the finite edge
criterion before attempting the all-grade theorem. The all-grade
stabilization question is a separate research track, not a routine corollary
of finite presentability.

## Repository anchors

- AIP-2 §3: raw dyadic-machine instructions and free `up`.
- AIP-5 §§0–2, §4, §8b: cocycles, exchange form, the complete dirty padding
  witness, and the local-class question.
- `lean/Adic/Cocycle.lean`: `IsCocycle`, `Exchange`, `exchange_append`, and
  `freeUp_exchange`.
- Expo 3, `Cost is a cocycle`: categorical framing and the write-back
  holonomy proof.
- `aips/draft/operadic-canonicity.md` §2.3: the analogous warning to classify
  the representation's actual image rather than its ambient set.
