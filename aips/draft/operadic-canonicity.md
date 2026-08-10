# Operadic canonicity: what grafting proves, and where the mounting image is too small

Draft (2026-08-10). Desk report for the `operadic-canonicity` track.
This document makes no design decision. It tests whether the mounting operad
removes the qualification from `campbell-renyi.md` §8.

Claim labels used throughout:

- **Verified** means checked against a cited primary source or an already
  mechanized fact in this repository.
- **Desk-proved** means a complete finite derivation is given here but is not
  yet mechanized.
- **Conjectured** means a plausible extension whose proof is not supplied.
- **Wall** means the target does not follow in the stated representation or
  without an additional hypothesis.

## 1. Verdict first

**Desk-proved, repair.** Mountings do form an operad under grafting. A mount
path is a finite bit word; substituting paths below a mounted head concatenates
words. Consequently depths add and cylinder masses multiply:

$$
d_{ij}=d_i+e_{ij},
\qquad
2^{-d_{ij}}=2^{-d_i}2^{-e_{ij}}.
$$

This is exactly the machine-native composition law proposed in the track.

**Wall, representation.** The resulting Kraft-mass operad is *not* the
dyadic-rational suboperad of the simplex operad. A head mounted at one path has
one mass $2^{-d_i}$, not an arbitrary dyadic rational. Incomplete mountings
have total mass at most one rather than exactly one. Even after restricting to
complete mountings, the fixed-arity image is not dense: a complete two-head
mounting has mass vector only $(1/2,1/2)$. Thus continuity cannot extend a law
from physical mounting masses to a whole simplex. This is the precise wall in
the proposed Bradley/Faddeev import.

**Desk-proved, repair.** Put $t>0$ and
$\alpha=1/(1+t)$. Campbell's continuously optimal endpoint moment is

$$
M_t(p)=2^{tH_\alpha(p)}
=\left(\sum_i p_i^\alpha\right)^{1/\alpha}.
$$

The quantity satisfying the proposed grafting law is therefore not $M_t$
itself but its $\alpha$th power, the partition functional

$$
Z_\alpha(p):=M_t(p)^\alpha
=2^{(1-\alpha)H_\alpha(p)}
=\sum_i p_i^\alpha.
$$

For $p\circ(q_i)=(p_iq_{ij})_{i,j}$,

$$
Z_\alpha(p\circ(q_i))
=\sum_i p_i^\alpha Z_\alpha(q_i).
$$

This is exact in the continuous Kraft relaxation. The exact physical statement
for integer paths is the unoptimized fixed-mounting grafting identity; integer
optima retain Campbell's rounding gap.

**Desk-proved, repair.** At $\alpha=1$, $Z_1$ is the constant one, so its
pointwise limit is not the Shannon chain rule. The chain rule is the
*derivative* of the partition law at $\alpha=1$:

$$
H(p\circ(q_i))=H(p)+\sum_i p_iH(q_i).
$$

Equivalently, the Tsallis normalization of $Z_\alpha-1$ converges to Shannon
entropy and obeys the $p_i^\alpha$-deformed derivation law before taking the
limit.

**Verified, import rather than reproof.** The deformed uniqueness theorem
already exists. Baez, Fritz, and Leinster's Theorem 7, using Furuichi's
generalized Faddeev theorem, characterizes Tsallis entropy by continuity,
functoriality, and degree-$\alpha$ compatibility with convex combinations.
In operadic notation its strong-additivity weight is exactly $p_i^\alpha$.
Rényi entropy is the monotone logarithmic transform of the same partition
functional. Bradley supplies the topological-operad derivation framework for
the Shannon case, but her theorem says that evaluation at zero of any such
derivation is a Shannon multiple; it does not say that every entire derivation
is the constant Shannon derivation.

**Desk-proved, conditional converse.** Two clean hypotheses do force the
machine schedule to be exponential:

1. if a positive affine normalization of endpoint cost is multiplicative under
   depth addition, then it is $q^d$ on $d\in\mathbb N$;
2. in the differentiable continuous, separable Kraft relaxation, if every
   optimizer is an escort distribution of one fixed order $\alpha$, then
   endpoint cost is $A2^{td}+B$, with $t=(1-\alpha)/\alpha$.

These results pin the schedule *within the stated ansatz*. The bare physical
mounting operad does not supply the missing density or the hypotheses that
connect an arbitrary schedule to a simplex functional.

**Desk-proved, recommended workaround.** Density is unnecessary if workloads
and mountings are kept as the two factors of a scheduled-mounting operad
$\Delta\times\mathcal M$. Local factorization of a separable endpoint
observable on that paired operad, tested already on unary paths, forces
$g(d+e)=g(d)g(e)$ and hence $g(d)=q^d$. Fiberwise Campbell optimization then
induces the escort/Tsallis/Rényi law on the workload factor. This preserves the
literal one-path-per-head machine representation and pins the classification
under one explicit operadic locality axiom.

## 2. The mounting operad, precisely

Let $B^*$ be the finite words in $B=\{0,1\}$, including the empty word
$\epsilon$. Write $u\preceq v$ when $u$ is a prefix of $v$. Two words are
prefix-incomparable when neither prefixes the other.

### 2.1 Operations and grafting

**Definition.** For $n\ge1$, the arity-$n$ mounting space
$\mathcal M(n)$ consists of
ordered tuples

$$
u=(u_1,\ldots,u_n)\in(B^*)^n
$$

whose entries are pairwise prefix-incomparable. We use the reduced convention:
there are no nullary operations. The symmetric group acts by permuting
entries. Given $u\in\mathcal M(n)$ and
$v^i=(v^i_1,\ldots,v^i_{m_i})\in\mathcal M(m_i)$, define simultaneous
grafting by

$$
u\circ(v^1,\ldots,v^n)
:=(u_iv^i_j)_{1\le i\le n,\ 1\le j\le m_i},
$$

where juxtaposition is word concatenation. The unit is $(\epsilon)$.

**Desk-proved.** Grafting preserves prefix-incomparability. If two grafted
words have different outer indices $i\ne i'$, a prefix relation between them
would imply a prefix relation between $u_i$ and $u_{i'}$. If they have the same
outer index, canceling the common prefix $u_i$ would give a prefix relation
between two distinct entries of $v^i$. Both contradict the hypotheses.
Associativity is associativity of word concatenation, the empty word gives the
unit laws, and permutation compatibility is immediate. Hence $\mathcal M$ is a
symmetric operad.

**Verified.** This definition matches the repository's mechanized
`Mounting`: one path per head, prescribed path length, injectivity, and pairwise
prefix-incomparability. The theorem `Adic.Dyadic.kraft_iff_mounting` proves
that this is equivalent to the repository's all-natural Kraft condition.

### 2.2 Depths and Kraft masses

For $u\in\mathcal M(n)$ define

$$
d_i(u)=|u_i|,
\qquad
\mu_i(u)=2^{-|u_i|}.
$$

**Desk-proved.** Grafting gives

$$
d_{ij}(u\circ v)=d_i(u)+d_j(v^i),
\qquad
\mu_{ij}(u\circ v)=\mu_i(u)\mu_j(v^i).
$$

The first identity is length-additivity under concatenation; exponentiation
gives the second.

Let

$$
\overline\Delta(n)
=\left\{x\in\mathbb R_{\ge0}^n:\sum_i x_i\le1\right\}.
$$

It is a subprobability operad under
$x\circ(y^i)=(x_iy^i_j)_{i,j}$, since

$$
\sum_{i,j}x_iy^i_j
=\sum_i x_i\sum_jy^i_j
\le\sum_i x_i\le1.
$$

**Desk-proved.** Kraft's inequality says that
$\mu:\mathcal M\to\overline\Delta$ is an operad map. The complete
mountings

$$
\mathcal M_=(n)=\left\{u\in\mathcal M(n):\sum_i2^{-|u_i|}=1\right\}
$$

form a suboperad, and their masses land in the ordinary probability simplex.

### 2.3 The image is smaller than the dyadic simplex

Define the physical mass image

$$
P_2(n)=\left\{(2^{-d_1},\ldots,2^{-d_n}):
d_i\in\mathbb N,\ \sum_i2^{-d_i}\le1\right\}.
$$

Its complete part uses equality. Every coordinate is dyadic rational, but the
converse is false: for example $3/8$ is dyadic rational and is not $2^{-d}$.

**Desk-proved.** A complete positive two-coordinate physical mass vector is
only $(1/2,1/2)$. Suppose without loss of generality $a\le b$ and

$$
2^{-a}+2^{-b}=1.
$$

Multiplying by $2^b$ gives $2^{b-a}+1=2^b$. The left side is odd unless
$a=b$; hence $a=b$, and then $2^{1-a}=1$, so $a=b=1$.

**Wall.** Thus the complete arity-two physical mass image is a singleton and
is not dense in the line segment $\Delta(2)$. Allowing incomplete mountings does not help: each
coordinate still lies in the discrete set
$\{1,1/2,1/4,\ldots\}$, whose only accumulation point is zero.

The genuinely dyadic simplex

$$
D_2(n)=\{p\in\Delta(n):p_i\in\mathbb Z[1/2]\ \text{ for every }i\}
$$

*is* dense and is closed under simplex-operad composition, but it is not the
mass image of one-path-per-head mountings. Realizing $k_i/2^N$ physically
requires giving head $i$ a union of $k_i$ depth-$N$ cylinders. That changes a
mount slot from one connected subtree to a generally disconnected forest and
destroys its single scalar distance.

## 3. Functionals and derivations without hidden subtraction

There are two different inputs in the machine story:

- a **workload vector** $p=(p_i)$ records head frequencies;
- a **mounting mass vector** $r=(2^{-d_i})$ records allocated fast-state
  cylinders.

They coincide only at the Shannon continuous optimum. At the Campbell optimum,
$r$ is the escort of $p$, not $p$ itself. Keeping these objects separate is
load-bearing.

### 3.1 Algebra-level functionals

**Definition.** An algebra-level functional is a symmetric family
$F_n:\Delta(n)\to A$, where $A$ is an ordered commutative additive monoid or
a real vector space. It is *mass-local on mountings* when its value on a
complete mounting factors through the mass map $\mu$.

Let $w:[0,1]\to\mathbb R_{\ge0}$ be a scalar weight system.

**Definition.** A $w$-derivation in simultaneous-composition form is a family
$S_n:\Delta(n)\to\mathbb R$ satisfying

$$
S(p\circ(q_i))=S(p)+\sum_iw(p_i)S(q_i).
\tag{D}
$$

The strict Shannon derivation has $w(x)=x$. The
$\alpha$-deformed derivation has $w(x)=x^\alpha$.

This is the scalar shadow of Bradley's operadic bimodule derivation. It is also
Faddeev's strong additivity law. It states composition directly and uses no
coboundary subtraction.

For $0<\alpha<1$, define the positive partition functional and Tsallis
normalization

$$
Z_\alpha(p)=\sum_i p_i^\alpha,
\qquad
S_\alpha(p)=\frac{Z_\alpha(p)-1}{1-\alpha}.
$$

**Desk-proved, exchange form.** The deformed law can be written entirely with
positive quantities as

$$
Z_\alpha(p\circ(q_i))
=\sum_i p_i^\alpha Z_\alpha(q_i).
\tag{P}
$$

Substituting $Z_\alpha=1+(1-\alpha)S_\alpha$ and using
$\sum_i p_i^\alpha=Z_\alpha(p)$ gives

$$
S_\alpha(p\circ(q_i))
=S_\alpha(p)+\sum_ip_i^\alpha S_\alpha(q_i).
\tag{T}
$$

Equation (P) is the exchange-form-friendly version: it avoids both subtraction
and division, just as AIP-5 recommends rearranging cost/potential identities
into a positive equality.

### 3.2 Fixed-mounting cost is already operadic

Let $g:\mathbb N\to\mathbb R_{\ge0}$ be an endpoint price and define

$$
E_g(p,u)=\sum_i p_i g(d_i(u)).
$$

**Desk-proved.** For arbitrary $g$,

$$
E_g(p\circ(q_i),u\circ(v^i))
=\sum_{i,j}p_iq^i_jg(d_i+e^i_j).
\tag{F}
$$

If $g(d)=d$, (F) becomes the strict law

$$
E_g(p\circ q,u\circ v)
=E_g(p,u)+\sum_i p_iE_g(q_i,v^i).
$$

If $g(d)=2^{td}$, it becomes the exact deformed fixed-mounting law

$$
E_t(p\circ q,u\circ v)
=\sum_i p_i2^{td_i}E_t(q_i,v^i).
\tag{F$_t$}
$$

No relaxation or optimality is used here. This is the strongest exact law on
literal integer mountings.

## 4. Forward direction: Campbell under grafting

Fix $t>0$ and put

$$
\alpha=\frac1{1+t},
\qquad
t=\frac{1-\alpha}{\alpha}.
$$

Let $p$ have positive coordinates. In the continuous Kraft relaxation, use
shares $r_i=2^{-d_i}>0$ with $\sum_i r_i=1$. The endpoint moment is

$$
E_t(p,r)=\sum_i p_i r_i^{-t}.
$$

### 4.1 Escort optimum

**Desk-proved.** Define

$$
Z_\alpha(p)=\sum_i p_i^\alpha,
\qquad
r_i^*=\frac{p_i^\alpha}{Z_\alpha(p)}.
$$

Then

$$
\begin{aligned}
E_t(p,r^*)
&=\sum_i p_i
  \left(\frac{p_i^\alpha}{Z_\alpha(p)}\right)^{-t}\\
&=Z_\alpha(p)^t\sum_i p_i^{1-\alpha t}\\
&=Z_\alpha(p)^{1+t}
=Z_\alpha(p)^{1/\alpha},
\end{aligned}
$$

because $1-\alpha t=\alpha$ and $1+t=1/\alpha$.

For any other $r$ with $\sum_i r_i=1$, Hölder with conjugate exponents
$1/\alpha$ and $1/(1-\alpha)$ gives

$$
\begin{aligned}
Z_\alpha(p)
&=\sum_i(p_ir_i^{-t})^\alpha r_i^{1-\alpha}\\
&\le
\left(\sum_i p_ir_i^{-t}\right)^\alpha
\left(\sum_i r_i\right)^{1-\alpha}
=E_t(p,r)^\alpha.
\end{aligned}
$$

Thus $r^*$ is optimal and

$$
M_t(p):=\min_rE_t(p,r)
=Z_\alpha(p)^{1/\alpha}
=2^{tH_\alpha(p)}.
\tag{C}
$$

Zero-probability coordinates can be deleted before the relaxation; literal
finite mountings may place them in unused deep slots afterward.

### 4.2 Exact value law and hierarchical optimizer

Let $p\in\Delta(n)$ and $q_i\in\Delta(m_i)$. Write
$P_{ij}=p_iq^i_j$ and $Z_i=Z_\alpha(q_i)$.

**Desk-proved.** Directly,

$$
\begin{aligned}
Z_\alpha(P)
&=\sum_{i,j}(p_iq^i_j)^\alpha\\
&=\sum_i p_i^\alpha\sum_j(q^i_j)^\alpha\\
&=\sum_i p_i^\alpha Z_\alpha(q_i).
\end{aligned}
\tag{G}
$$

Combining (C) and (G) gives the exact Campbell value law

$$
M_t(P)^\alpha
=\sum_i p_i^\alpha M_t(q_i)^\alpha.
\tag{M}
$$

Equivalently,

$$
2^{(1-\alpha)H_\alpha(P)}
=\sum_i p_i^\alpha
  2^{(1-\alpha)H_\alpha(q_i)}.
$$

This verifies the displayed identity in the track specification, with the
important correction that its operadic observable is $M_t^\alpha$, not $M_t$.

**Desk-proved.** The optimizer itself is compatible with hierarchical grafting
only after the inner values reweight the outer problem. Optimize each inner
share as

$$
s^i_j=\frac{(q^i_j)^\alpha}{Z_i}.
$$

The remaining outer objective is

$$
\sum_i p_iR_i^{-t}M_t(q_i).
$$

Its escort optimum, applied to the coefficients $p_iM_t(q_i)$, is

$$
R_i
=\frac{(p_iM_t(q_i))^\alpha}
       {\sum_k(p_kM_t(q_k))^\alpha}
=\frac{p_i^\alpha Z_i}{Z_\alpha(P)}.
$$

Therefore

$$
R_is^i_j
=\frac{p_i^\alpha(q^i_j)^\alpha}{Z_\alpha(P)},
$$

which is exactly the global escort share for $P$. Naively grafting the outer
escort of $p$ with the inner escorts of the $q_i$ would omit the factors $Z_i$
and is generally not globally optimal.

### 4.3 Raw cumulative machine travel

For level prices $c_t(\ell)=2^{t\ell}$, cumulative travel to distance $d$ is

$$
C_t(d)=\sum_{\ell=0}^d2^{t\ell}
=\frac{2^t}{2^t-1}2^{td}-\frac1{2^t-1}.
$$

**Desk-proved.** Expected cumulative travel is a positive affine transform of
the endpoint moment:

$$
T_t(p,d)
=\frac{2^t}{2^t-1}E_t(p,d)-\frac1{2^t-1}.
$$

Thus it has the same continuous optimizer. Its normalized endpoint observable

$$
G_t(T)=\frac{(2^t-1)T+1}{2^t}
$$

is $M_t$ at the optimum, and $G_t(T)^\alpha=Z_\alpha$. Raw travel itself does
not satisfy (G); the affine normalization and $\alpha$th power are essential.

### 4.4 What remains exact for integer prefix paths

**Verified.** Campbell's coding theorem gives the integer prefix-code bounds

$$
H_\alpha(p)\le\frac1t\log_2E_t(p,d)<H_\alpha(p)+1,
$$

and block coding reduces the per-symbol gap to $1/m$. The full derivation and
the corresponding affine raw-travel bounds are in `campbell-renyi.md` §2–3.

**Wall, exact physical optimum.** A continuous escort share is generally not a
power of two, hence not the cylinder mass of one physical mount path. Moreover,
an arbitrary globally optimal prefix code for the leaves $(i,j)$ need not
factor through a prescribed outer grouping $i$. Therefore (G) and (M) are exact
for the continuous relaxation, while (F$_t$) is exact for each grafted integer
mounting. There is no exact identity (M) for unrestricted one-letter integer
mounting optima without changing the representation or admitting rounding
slack.

## 5. Shannon is the derivative at the undeformed point

Use base-two logarithms. For $p_i>0$,

$$
\left.\frac1{\ln2}\frac{d}{d\alpha}Z_\alpha(p)\right|_{\alpha=1}
=\sum_ip_i\log_2p_i=-H(p).
$$

**Desk-proved.** Differentiate (G) at $\alpha=1$ and divide by $\ln2$.
Since $Z_1(q_i)=1$,

$$
\begin{aligned}
-H(P)
&=\sum_i p_i\log_2p_i
  +\sum_i p_i(-H(q_i))\\
&=-H(p)-\sum_i p_iH(q_i).
\end{aligned}
$$

Negating yields

$$
H(p\circ(q_i))=H(p)+\sum_i p_iH(q_i).
$$

The same result follows by taking $\alpha\to1$ in (T), since
$S_\alpha\to H$ and $p_i^\alpha\to p_i$.

**Verified.** This is Faddeev's strong-additivity law and Bradley's scalar
operadic Leibniz rule. Bradley proves that the constant function
$d_p(x)=H(p)$ defines a derivation of the operad of topological simplices with
values in an endomorphism-operad bimodule.

## 6. The full-simplex converse already exists

### 6.1 From an unknown scalar weight to a power

The literature usually fixes the deformation order. The following elementary
step explains why a coordinatewise weight system must be a power when the order
is initially unknown.

**Desk-proved, conditional proposition.** Suppose a nonzero symmetric family
$S_n$ on all finite probability simplices satisfies (D), including operadic
units. Assume $w(0)=0$, $w(x)>0$ for $x>0$, and $w$ is monotone. Then

$$
w(xy)=w(x)w(y)
\qquad(0<x,y\le1).
$$

To prove this, compare the two parenthesizations of a three-level refinement.
Associativity and two applications of (D) give

$$
\sum_{i,j}
\bigl(w(p_iq^i_j)-w(p_i)w(q^i_j)\bigr)S(r^{ij})=0.
$$

Choose all $r^{ij}$ to be the one-point distribution except one, and choose the
exception to have nonzero $S$. Since arbitrary $x,y\in(0,1)$ can occur as
coordinates of binary distributions, the surviving coefficient gives
$w(xy)=w(x)w(y)$. The unit law gives $w(1)=1$.

Put $x=e^{-s}$ and
$a(s)=-\log w(e^{-s})$. Then $a(s+t)=a(s)+a(t)$ and monotonicity rules out the
pathological Cauchy solutions, so $a(s)=\alpha s$. Consequently

$$
w(x)=x^\alpha.
$$

If $w$ is nondecreasing with $w(0)=0$, then $\alpha>0$. Continuity can replace
monotonicity here; monotonicity is the weaker usable regularity assumption.

### 6.2 Furuichi and Baez–Fritz–Leinster finish the entropy part

**Verified.** Furuichi's Theorem V.2 is a generalized Faddeev theorem: symmetry,
continuity, and the recursion

$$
S(tp_1,(1-t)p_1,p_2,\ldots)
=S(p_1,p_2,\ldots)+p_1^\alpha S(t,1-t)
$$

characterize a nonnegative scalar multiple of order-$\alpha$ Tsallis entropy.

**Verified.** Baez, Fritz, and Leinster package this as their Theorem 7. A
continuous functorial information-loss map compatible with convex sums by

$$
F(\lambda f\oplus(1-\lambda)g)
=\lambda^\alpha F(f)+(1-\lambda)^\alpha F(g)
$$

is exactly a nonnegative multiple of Tsallis information loss. Their proof
explicitly imports Furuichi. Applied to collapse maps, the statement is the
$p_i^\alpha$ strong-additivity law (T).

**Desk-proved.** Rényi entropy is a monotone transform of the same object:

$$
H_\alpha^{\text{R}}(p)
=\frac1{1-\alpha}\log_2 Z_\alpha(p)
=\frac1{1-\alpha}
  \log_2\bigl(1+(1-\alpha)S_\alpha(p)\bigr).
$$

Thus the operadic uniqueness theorem selects Tsallis in additive/exchange
coordinates and selects Rényi after the logarithmic coordinate change. It does
not make Rényi itself satisfy the linear deformed derivation law.

### 6.3 What Bradley proves

**Verified, correction.** Bradley defines derivations of an operad with values
in an abelian bimodule and proves:

- the constant assignment $p\mapsto H(p)$ is a derivation of the topological
  simplex operad;
- for every such derivation $d$, evaluation at the zero vector satisfies
  $d_p(0)=cH(p)$ for some constant $c$.

The second statement relies on a Faddeev–Leinster characterization. It is weaker
than saying every function-valued derivation $d_p$ is itself constant at
$cH(p)$. For this track, the scalar evaluation is enough to recover Shannon's
law on the full simplex, but Bradley alone does not provide the deformed
Tsallis theorem; Furuichi and Baez–Fritz–Leinster do.

## 7. Conditional converse from grafting to exponential schedules

The entropy theorem classifies functionals on workloads. To classify machine
prices, one must add a bridge from depth addition to the functional. There are
two clean bridges.

### 7.1 Discrete affine-multiplicative endpoint costs

**Desk-proved.** Let $C:\mathbb N\to\mathbb R$ be endpoint or cumulative
travel cost. Suppose there are constants $A\ne0$ and $B$ such that

$$
G(d)=AC(d)+B>0,
\qquad G(0)=1,
$$

and grafting depth satisfies

$$
G(d+e)=G(d)G(e).
\tag{S}
$$

Set $q=G(1)$. Induction using (S) gives

$$
G(d)=q^d,
\qquad
C(d)=\frac{q^d-B}{A}.
$$

If $C$ is nonconstant and increasing, then $q>1$. Its level increments are

$$
c(d)=C(d)-C(d-1)
=\frac{q-1}{A}q^{d-1}
\qquad(d\ge1),
$$

so all positive-depth level increments are geometric. The level-zero touch is
an affine-baseline convention; the usual machine normalization below puts it
on the same geometric progression. For the machine schedule
$c_t(\ell)=2^{t\ell}$,

$$
C_t(d)=\frac{2^{t(d+1)}-1}{2^t-1},
\qquad
G(d)=\frac{(2^t-1)C_t(d)+1}{2^t}=2^{td}.
$$

This converse is purely discrete and needs no density argument. Its
load-bearing axiom is the affine-normalized multiplicativity (S), not merely
monotonicity or cumulative doubling.

### 7.2 A smooth optimizer converse

**Desk-proved, conditional proposition.** Let
$f:(0,1]\to\mathbb R$ be continuously differentiable and strictly decreasing.
For every positive finite probability vector $p$, suppose the unique minimizer
of

$$
\sum_i p_if(r_i)
\quad\text{subject to}\quad
r_i>0,\quad\sum_i r_i=1
$$

is

$$
r_i=\frac{p_i^\alpha}{\sum_jp_j^\alpha}
$$

for one fixed $0<\alpha<1$. Then

$$
f(r)=Ar^{-(1-\alpha)/\alpha}+B
$$

for constants $A>0$ and $B$.

Indeed, take any interior share vector $r$ and choose
$p_i\propto r_i^{1/\alpha}$, so that $r$ is its assumed optimizer. The Lagrange
stationarity equations give $p_if'(r_i)=\lambda$, hence

$$
r_i^{1/\alpha}f'(r_i)
=r_j^{1/\alpha}f'(r_j)
$$

for every pair of coordinates. By embedding arbitrary $x,y\in(0,1)$ into
interior probability vectors (using an intermediate coordinate if $x+y\ge1$),
$r^{1/\alpha}f'(r)$ is one constant on $(0,1)$. Strict decrease makes it
negative. Integration yields the displayed form.

Writing $r=2^{-d}$ and $t=(1-\alpha)/\alpha$ gives

$$
C(d):=f(2^{-d})=A2^{td}+B.
$$

The limiting case $\alpha=1$ yields
$f(r)=-A\log_2r+B$ and therefore $C(d)=Ad+B$, the constant-level-price
Shannon case.

**Wall, scope of converse.** Neither proposition says that symmetry,
monotonicity, and Kraft admissibility alone force exponentials. Section 7.1
assumes a graft-multiplicative affine normalization; §7.2 assumes a separable,
differentiable continuous relaxation and a universal escort optimizer. The
doubling axiom from `campbell-renyi.md` §7.3 supplies integer rounding stability
but does not imply either bridge.

## 8. Why the physical suboperad blocks the desired import

The full-simplex proof in §6 uses arbitrary binary coordinates twice:

1. associativity isolates $w(xy)=w(x)w(y)$ for arbitrary $x,y$;
2. Faddeev's recursion varies $t$ continuously and then uses continuity.

**Wall.** The complete physical two-head mounting image supplies only
$x=t=1/2$. There is no sequence of physical two-head mass vectors approaching,
say, $(1/3,2/3)$. Therefore neither use can be recovered from density.

**Desk-proved.** Replacing physical masses by all dyadic simplex points would
repair the density step. If a family $S$ and its grafting law are defined on
$D_2(n)$ and extend continuously to $\Delta(n)$, then both sides of the law are
continuous and equality extends from the dense dyadic subset. The full-simplex
Furuichi/Baez–Fritz–Leinster theorem then applies.

**Wall, machine meaning.** That repair is not free. A dyadic coordinate
$k/2^N$ represents a finite union of cylinders, not one mount path; a head no
longer has one distance. Alternatively, one can keep physical mountings and put
the simplex operad on workload vectors $p$. Then Campbell optimization is a map
from workload distributions to *continuous* shares, with integer mountings as
rounding approximations. This second separation preserves the machine model but
makes the operadic classification a theorem about the relaxation, not an exact
classification internal to the mounting operad.

**Literature check, no located import.** Targeted searches around Faddeev,
simplex operads, dyadic probabilities, and restricted/dyadic suboperads found
the full-simplex characterizations and algebraic constructions involving
Rényi/Tsallis, but no theorem that derives the full continuous classification
from the one-cylinder-per-coordinate image $P_2(n)$. This is a report of the
search performed, not a proof that no such result exists.

## 9. What exactly is canonical

The chain of implications that survives is:

$$
\begin{array}{c}
\text{full workload simplex + continuous generalized grafting law}\\
\Downarrow\quad\text{Furuichi / Baez--Fritz--Leinster}\\
\text{Tsallis }S_\alpha\text{ and weights }p_i^\alpha\\
\Downarrow\quad Z=1+(1-\alpha)S_\alpha\\
Z_\alpha(p)=\sum_i p_i^\alpha\\
\Downarrow\quad\text{monotone logarithm}\\
\text{Rényi }H_\alpha\\
\Downarrow\quad\text{separable Campbell optimization}\\
r_i\propto p_i^\alpha,
\quad M_t=Z_\alpha^{1/\alpha},
\quad t=(1-\alpha)/\alpha.
\end{array}
$$

**Verified/desk-proved.** The first implication is imported; the remaining
algebra and optimization are desk-proved above. With either schedule bridge in
§7, the endpoint cost is exponential and the cumulative level schedule is
geometric.

**Wall.** Without a schedule bridge, an entropy characterization does not
classify arbitrary machine costs. Without broadening or separating the
physical mounting masses, their suboperad is too small for the full-simplex
converse. The operadic line therefore sharpens the canonicity claim
substantially but does not make it unconditional.

## 10. Workaround: couple workloads to mountings instead of identifying them

The density wall is avoidable. It came from trying to make one vector do two
jobs. Workload probabilities already range over a simplex; physical mount
masses do not need to.

### 10.1 The scheduled-mounting operad

**Definition.** Let

$$
\mathcal A(n)=\Delta(n)\times\mathcal M(n).
$$

An element $(p,u)$ is a workload distribution together with a physical
mounting of the same arity. Compose componentwise:

$$
(p,u)\circ((q_i,v^i)_i)
=\bigl(p\circ(q_i),\ u\circ(v^i)\bigr).
$$

**Desk-proved.** Since both factors are symmetric operads, their aritywise
product is a symmetric operad. Its composite has workload coordinates
$p_iq^i_j$ and physical depths $d_i+e^i_j$. No map from Kraft masses to
workload probabilities is asserted or needed.

For a normalized endpoint price $g:\mathbb N\to\mathbb R_{>0}$ with
$g(0)=1$, define the separable evaluation

$$
E_g(p,u)=\sum_i p_i g(d_i(u)).
$$

This is an observable on the *paired* operad, not a functional on either factor
alone.

### 10.2 Operadic locality forces the exponential

The appropriate local grafting axiom says that the contribution of outer slot
$i$ to a refined schedule depends only on its own probability and depth.

**Axiom (local factorization).** There is a scalar coefficient
$a:[0,1]\times\mathbb N\to\mathbb R_{\ge0}$ such that for every scheduled
mounting and every family grafted below it,

$$
E_g(p\circ(q_i),u\circ(v^i))
=\sum_i a(p_i,d_i)E_g(q_i,v^i).
\tag{L}
$$

**Desk-proved, exact converse.** For every coefficient pair that occurs in a
scheduled mounting, Axiom (L) forces

$$
a(p,d)=p\,g(d),
\qquad
g(d+e)=g(d)g(e),
$$

and hence $g(d)=q^d$ for $q=g(1)$.

First restrict (L) to unary outer and inner mountings. Their workload
probability is one, while their paths may have arbitrary depths $d$ and $e$.
The law says

$$
g(d+e)=a(1,d)g(e).
$$

Putting $e=0$ gives $a(1,d)=g(d)$, hence
$g(d+e)=g(d)g(e)$. Induction gives $g(d)=q^d$. If $g$ is increasing and
nonconstant, then $q>1$.

It remains to identify the general coefficient. Once $q\ne1$, fix an outer
operation and choose unary inner paths of depths $e_i$. Equation (L) becomes

$$
\sum_i p_ig(d_i)q^{e_i}=\sum_i a(p_i,d_i)q^{e_i}.
$$

First set every $e_i=0$, then change only $e_i$ to one and subtract the two
real equalities. Since $q-1\ne0$, this isolates
$a(p_i,d_i)=p_ig(d_i)$. The constant case $g\equiv1$ is the trivial schedule;
(L) then determines only the sum of the coefficients and is intentionally
excluded from the nontrivial classification.

This theorem is stronger and cleaner than attempting to recover exponential
prices from density. It uses only literal integer paths and literal grafting.
For cumulative travel $C$, apply it to an affine normalization
$g(d)=AC(d)+B$ as in §7.1; the level increments of $C$ are then geometric.

**Desk-proved.** Conversely, $g(d)=q^d$ satisfies (L) exactly, with
$a(p,d)=pq^d$, by (F$_t$). Thus local factorization characterizes exponential
endpoint schedules on the physical paired operad, rather than merely showing
they are examples.

**Desk-proved, undeformed branch.** The Shannon endpoint observable uses the
additive character $h(d)=d$, not the multiplicative character $g(d)=q^d$.
The corresponding local law is

$$
E_h(p\circ(q_i),u\circ(v^i))
=E_h(p,u)+\sum_i p_iE_h(q_i,v^i).
$$

Conversely, testing a normalized endpoint price $h(0)=0$ on unary grafts
forces $h(d+e)=h(d)+h(e)$, hence $h(d)=d\,h(1)$ by induction. Its cumulative
travel is affine in $1+d$, so its level increments are constant. It is also the
regular limit

$$
\lim_{t\to0}\frac{2^{td}-1}{2^t-1}=d.
$$

Thus the paired operad classifies both branches: additive/linear gives Shannon,
while multiplicative/nonconstant gives the positive-$t$ exponential family.

### 10.3 Fiberwise optimization produces the deformed simplex law

Relax the mounting fiber over a workload $p$ from integer paths to complete
real shares $r_i>0$, $\sum_i r_i=1$, with $d_i=-\log_2r_i$. For
$q=2^t$, minimize the paired observable along that fiber:

$$
\mathcal V_t(p)
=\inf_r\sum_i p_ir_i^{-t}.
$$

**Desk-proved.** Section 4 gives

$$
\mathcal V_t(p)=Z_\alpha(p)^{1/\alpha},
\qquad
\alpha=\frac1{1+t},
$$

and therefore

$$
\mathcal V_t(p\circ(q_i))^\alpha
=\sum_i p_i^\alpha\mathcal V_t(q_i)^\alpha.
$$

So the $p_i^\alpha$ law is not postulated on physical Kraft masses. It is the
law induced on the workload factor by fiberwise optimization of the uniquely
graft-local physical price family. The three canonicity steps are now cleanly
separated:

$$
\begin{array}{c}
\text{local factorization on }\Delta\times\mathcal M\\
\Downarrow\\
g(d)=2^{td}\ \text{(or }h(d)=d\text{ in the additive branch)}\\
\Downarrow\quad\text{continuous Kraft minimization}\\
r_i\propto p_i^{1/(1+t)},\quad
Z_\alpha=\mathcal V_t^\alpha\\
\Downarrow\quad\text{Furuichi / BFL}\\
\text{the induced continuous grafting functional is Tsallis,}\\
\text{or Rényi after the logarithmic transform.}
\end{array}
$$

**Desk-proved, workaround verdict.** This coupled-operad theorem pins the
classification within a natural and explicit axiom set while leaving the
one-path-per-head machine representation untouched. The remaining relaxation
gap is Campbell's familiar integer rounding gap, not an operadic density gap.
For the paper, this is the recommended repair.

### 10.4 Optional extension: the labelled dyadic envelope

If a literal dense dyadic suboperad is desirable for other reasons, there is a
second, representation-enlarging workaround.

**Definition.** A labelled dyadic operation of arity $n$ consists of a finite
complete prefix code $L\subset B^*$ and a labelling
$\lambda:L\to\{1,\ldots,n\}$, not necessarily surjective. Its mass vector is

$$
p_i=\sum_{u\in L:\lambda(u)=i}2^{-|u|}.
$$

Graft a copy of the inner labelled code for $i$ below every outer leaf labelled
$i$, and retain the inner label on the composite leaf.

**Desk-proved.** These operations form a symmetric operad. Their mass map lands
in $D_2(n)$ and is surjective: for
$p_i=k_i/2^N$ with $\sum_i k_i=2^N$, take all $2^N$ words of depth $N$ and
label exactly $k_i$ of them by $i$. Grafting multiplies and sums masses, giving
exactly $(p_iq^i_j)_{i,j}$. Hence this extension has a dense mass image. A
uniformly continuous mass-local law on this dyadic subspace extends uniquely
to the full simplex; alternatively, continuous extendability can be stated as
the regularity axiom. Mere continuity on a non-complete dense subspace is not
enough.

**Wall, physical interpretation.** A label may occur on many leaves, so this is
not a static one-path-per-head mounting. It can model a dyadic randomized
router, a coarse-graining of mounted micro-outcomes, or a block-code
relaxation. Adopting it as literal fast-state geometry would require a rule for
choosing among replicas and maintaining coherent head state. It is therefore a
useful algebraic envelope, but not the recommended core-machine change.

## 11. Replacement for `campbell-renyi.md` §8

The qualified claim in that report can be replaced by the following precise
statement:

> **Verified plus desk-proved.** On the full operad of finite probability
> simplices, a continuous nontrivial symmetric grafting functional with a
> monotone coordinatewise weight system has power weights $p_i^\alpha$;
> Furuichi's generalized Faddeev theorem, equivalently the
> Baez–Fritz–Leinster information-loss theorem, then makes the functional a
> scalar Tsallis entropy. Its positive partition coordinate is
> $Z_\alpha=\sum_i p_i^\alpha$, its logarithmic coordinate is Rényi entropy,
> and Campbell's separable Kraft optimization has escort shares and endpoint
> value $Z_\alpha^{1/\alpha}$. If affine-normalized endpoint price is
> multiplicative under additive depths—or, in the smooth relaxation, if the
> universal optimizer is escort—then the machine schedule is exponential.
> The repository's literal one-path-per-head mounting masses are not dense in
> the simplex, so this converse is a theorem of the workload/continuous-share
> layer, not of the physical mounting suboperad alone.

This is stronger than the earlier appeal to Rényi's quasi-arithmetic means: the
deformed grafting uniqueness is a direct imported theorem, and the exact extra
hypothesis needed to reach machine schedules is visible.

The preferred formulation can now be sharper still: use the scheduled-mounting
operad $\Delta\times\mathcal M$. Local factorization on its physical depth
component forces the exponential schedule exactly; fiberwise Kraft
optimization induces the escort/Tsallis/Rényi law on its workload component.
No density claim about physical Kraft masses is needed.

## 12. Lean mechanization ladder

**Recommendation (design, not decision).** Mechanize in separate namespaces so
the physical and continuous layers cannot be conflated.

1. **Bit-word operad (easy).** Define mounting graft by list append; prove
   prefix-incomparability, associativity, units, permutation compatibility,
   `graft_depth`, and `graft_kraft_mass`. Reuse `Mounting` and
   `PrefixIncomparable` from `Adic.Distance`/`Adic.Locality`.
2. **Physical-image obstruction (easy).** Prove that tight two-head distances
   satisfy $d_0=d_1=1$, and record that the physical image is not the dyadic
   simplex. This is all-natural power arithmetic.
3. **Fixed-mounting graft costs (easy/medium).** For natural macro prices prove
   the analogues of (F) and (F$_t$) by finite-sum rearrangement and
   `Nat.pow_add`.
4. **Partition operad algebra (medium).** Over `NNReal` or `Real`, define
   simplex composition and $Z_\alpha$ for a rationally represented order;
   prove (G), the Tsallis exchange identity, and the Rényi logarithmic transform.
5. **Campbell optimum (hard).** Reuse the proposed `Adic.Campbell` ladder:
   denominator-cleared natural Hölder first, then connect it to the real
   escort optimum and $M_t^\alpha=Z_\alpha$. This remains the hard analytic
   rung already named in `campbell-renyi.md`.
6. **Shannon derivative (medium/hard).** Prove differentiability of finite
   power sums at $\alpha=1$ and differentiate (G), or avoid calculus by proving
   the Shannon chain rule directly and separately proving the Tsallis limit.
7. **Weight-system converse (hard).** Formalize the associativity isolation
   argument, monotone multiplicative functions on $(0,1]$, and the reduction to
   Furuichi. The final uniqueness theorem is not currently in Mathlib and would
   require a substantial functional-equation development or be stated as an
   imported paper theorem rather than immediately mechanized.
8. **Paired-operad schedule converse (easy/medium).** Define the product of
   workload vectors and mountings, state local factorization (L), isolate one
   summand, and derive `g (d + e) = g d * g e` and `g d = (g 1) ^ d`.
   This is the recommended first canonicity theorem.
9. **Smooth schedule converse (hard).** The escort converse needs constrained
   first-order optimality and integration over reals.
10. **Optional labelled envelope (medium).** Define complete prefix codes with
    repeated finite labels, graft them, prove the mass composition law, and
    construct a labelled full-depth code for every dyadic simplex point.

The first three rungs certify the exact machine-native content. Rungs 4–6
certify the forward relaxation. Rungs 7–8 certify the conditional canonicity
claim. None should state that physical mounting masses are dense.

## 13. Open items

### With Mathijs

1. Should the paper adopt the **scheduled-mounting product operad**
   $\Delta\times\mathcal M$ (recommended), or also present the labelled dyadic
   envelope as a secondary algebraic completion?
2. Is affine-normalized multiplicativity under depth addition accepted as the
   schedule-canonicity axiom, or should the paper instead use the smoother but
   stronger universal-escort-optimizer axiom?
3. Should the exact operadic observable be named the *partition functional*
   $Z_\alpha=M_t^\alpha$, reserving $M_t$ for Campbell's endpoint moment
   (recommended)?

### For agents

1. Add the small mounting-graft API, the product-operad evaluation, and the
   local-factorization schedule converse to Lean.
2. Mechanize the two-head physical-image obstruction before any prose calls the
   image “the dyadic simplex”.
3. If the full converse is prioritized, first survey Mathlib for monotone
   multiplicative-function and Faddeev-style functional-equation support; do
   not begin from Bradley's theorem as though it classified the entire
   function-valued derivation.

## References

- D. K. Faddeev,
  [“On the Concept of Entropy of a Finite Probabilistic Scheme”](https://www.mathnet.ru/eng/rm7756),
  *Uspekhi Matematicheskikh Nauk* 11(1/67), 227–231, 1956 (Russian;
  German translation, 1957).
- A. Rényi,
  [“On Measures of Entropy and Information”](https://static.renyi.hu/renyi_cikkek/1961_on_measures_of_entropy_and_information.pdf),
  *Proceedings of the Fourth Berkeley Symposium on Mathematical Statistics and
  Probability*, vol. 1, 547–561, 1961.
- L. L. Campbell,
  [“A Coding Theorem and Rényi's Entropy”](https://doi.org/10.1016/S0019-9958(65)90332-3),
  *Information and Control* 8(4), 423–429, 1965.
- S. Furuichi,
  [“On Uniqueness Theorems for Tsallis Entropy and Tsallis Relative Entropy”](https://arxiv.org/abs/cond-mat/0410270),
  *IEEE Transactions on Information Theory* 51(10), 3638–3645, 2005,
  doi:10.1109/TIT.2005.855606.
- J. C. Baez, T. Fritz, and T. Leinster,
  [“A Characterization of Entropy in Terms of Information Loss”](https://arxiv.org/abs/1106.1791),
  *Entropy* 13(11), 1945–1957, 2011,
  doi:10.3390/e13111945.
- T. Leinster,
  [*Entropy and Diversity: The Axiomatic Approach*](https://doi.org/10.1017/9781108963558),
  Cambridge University Press, 2021. See Theorem 2.5.1 for the
  Faddeev–Leinster characterization and Chapter 12 for its categorical origins.
- T.-D. Bradley,
  [“Entropy as a Topological Operad Derivation”](https://doi.org/10.3390/e23091195),
  *Entropy* 23(9), article 1195, 2021.
- M. Marcolli and R. Thorngren,
  [“Thermodynamic Semirings”](https://doi.org/10.4171/JNCG/156),
  *Journal of Noncommutative Geometry* 8, 337–392, 2014. This develops
  operadic/algebraic structures for Shannon, Rényi, and Tsallis, but is not the
  deformed Faddeev uniqueness theorem used above.
