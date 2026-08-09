# Campbell–Rényi under level prices: verification, repair, and a Lean ladder

Draft (2026-08-09). Desk report for the `campbell-renyi` track.
This document makes no design decision; it verifies the proposed
correspondence and records the choices exposed by making it exact.

Claim labels used throughout:

- **Verified** means checked against a cited primary source or against
  an already mechanized fact in this repository.
- **Desk-proved** means a complete finite derivation is given here but
  is not yet mechanized.
- **Conjectured** means a plausible extension whose proof is not given.
- **Wall** means the stated target cannot honestly be obtained without
  changing the representation or adding a hypothesis.

## 1. Verdict first

**Desk-proved.** The order claimed in `shannon-programme.md` is right:
for

$$
c_t(\ell)=2^{t\ell},\qquad t>0,
\qquad \alpha=\frac1{1+t},
$$

the continuously optimal mount shares are the escort distribution

$$
r_i=\frac{p_i^\alpha}{Z_\alpha},
\qquad Z_\alpha=\sum_jp_j^\alpha,
$$

and hence

$$
d_i^*=-\log_2 r_i
=\log_2 Z_\alpha-\alpha\log_2p_i.
$$

Thus the informal slope
$d_i\approx\alpha\log_2(1/p_i)$ is correct, but it omitted the common
normalizing offset $\log_2Z_\alpha$. That offset is not optional: it is
what makes Kraft tight.

**Desk-proved, correction.** The optimal *value* needs more careful
wording. Campbell minimizes the logarithmically normalized exponential
moment

$$
L_t(d)=\frac1t\log_2\sum_i p_i2^{td_i}.
$$

Our machine instead charges cumulative travel

$$
C_t(d)=\sum_{\ell=0}^{d}2^{t\ell}.
$$

For integer $d$ this is an affine function of $2^{td}$, so it has the
same optimizer, but its optimum is an affine function of
$2^{tH_\alpha}$, not $H_\alpha$ itself. The surviving precise slogan is:

> **Exponential level prices select a Rényi order; normalized log travel
> is Rényi, while raw travel is exponential in Rényi.**

**Desk-proved, correction.** The mounting constraint does not change:
Kraft remains the antichain-packing law. Only the objective changes.
“Level prices turn Kraft into Rényi” is therefore half-right. The
correct version is:

> **Kraft stays Kraft; exponential travel turns Shannon's objective
> into Campbell's objective, whose optimum is Rényi.**

**Wall (representation, not mathematics).** For $t=1/2$ and $t=1/3$,
the literal prices $2^{t\ell}$ are generally irrational. An exact
natural-valued Lean cost cannot at the same time be literally that
schedule. There are three honest choices: use exact algebraic/real
costs; round each level price to a natural; or group $k$ binary levels
into one natural-priced macro-level. Section 4 recommends the last as
the first all-$\mathbb N$ theorem layer and a sandwich theorem relating
it to the literal model. There is no honest “exact $\mathbb N$ form” of
an irrational equality without making such a representation choice.

## 2. Continuous check from scratch

Fix a finite probability vector $p_i>0$ with $\sum_i p_i=1$. Heads with
$p_i=0$ can be removed from the optimization; in the finite machine
they may later be placed in unused deep slots. Put $q=2^t>1$.

### 2.1 Cumulative travel reduces to an exponential moment

**Desk-proved.** With the convention that distance zero still pays the
level-zero touch, matching Expo 2's $1+d$ when $t=0$,

$$
C_t(d)=\sum_{\ell=0}^{d}q^\ell
=\frac{q^{d+1}-1}{q-1}
=\frac q{q-1}q^d-\frac1{q-1}.
$$

Therefore

$$
T_t(p,d):=\sum_i p_i C_t(d_i)
=\frac q{q-1}M_t(p,d)-\frac1{q-1},
\qquad
M_t(p,d):=\sum_i p_i2^{td_i}.
$$

The affine coefficient is positive, so $T_t$ and $M_t$ have exactly
the same minimizers. This is where machine travel and Campbell meet.
They differ only after the minimizer has been chosen: Campbell reports
$L_t=(1/t)\log_2M_t$, while the machine reports $T_t$.

### 2.2 Lagrange calculation

**Desk-proved.** Relax $d_i$ from naturals to nonnegative reals and
minimize $M_t$ under $\sum_i2^{-d_i}\le1$. Except for the one-head
degenerate case, the constraint is tight: if it had slack, every
$d_i$ could be decreased slightly and the objective would fall. With
multiplier $\lambda$,

$$
\mathcal L(d,\lambda)
=\sum_i p_i2^{td_i}
+\lambda\left(\sum_i2^{-d_i}-1\right).
$$

Stationarity gives

$$
t p_i2^{td_i}=\lambda2^{-d_i},
\qquad
2^{(1+t)d_i}=\frac{\lambda}{tp_i}.
$$

Thus $2^{-d_i}$ is proportional to
$p_i^{1/(1+t)}$. Writing
$\alpha=1/(1+t)$ and normalizing by Kraft yields

$$
2^{-d_i^*}=r_i=\frac{p_i^\alpha}{Z_\alpha},
\qquad
d_i^*=\log_2Z_\alpha-\alpha\log_2p_i.
$$

Every $r_i$ lies in $(0,1]$, so the nonnegativity constraints on the
$d_i$ introduce no extra case.

### 2.3 Optimal value

**Desk-proved.** Since $\alpha t=1-\alpha$,

$$
\begin{aligned}
M_t(p,d^*)
&=\sum_i p_i r_i^{-t}\\
&=Z_\alpha^t\sum_i p_i^{1-\alpha t}\\
&=Z_\alpha^{1+t}
=Z_\alpha^{1/\alpha}
=2^{tH_\alpha(p)},
\end{aligned}
$$

where

$$
H_\alpha(p)=\frac1{1-\alpha}
\log_2\sum_i p_i^\alpha.
$$

Consequently the exact continuous values are

$$
L_t^*=H_\alpha(p)
$$

and

$$
T_t^*
=\frac{2^t}{2^t-1}\,2^{tH_\alpha(p)}
-\frac1{2^t-1}.
$$

This proves the proposed order $\alpha=1/(1+t)$ and repairs the claim
about the raw amortized value.

**Desk-proved.** The $t\to0$ limit recovers the unit-price model:
$C_0(d)=1+d$, $\alpha\to1$, $d_i^*=-\log_2p_i$, and
$T_0^*=1+H_1(p)$. The apparent singularity in the geometric-series
formula is removable.

## 3. What Campbell's theorem actually says

**Verified.** Campbell's 1965 paper defines, for a $D$-ary uniquely
decipherable code with lengths $n_i$,

$$
L(t)=\frac1t\log_D\sum_i p_iD^{tn_i},
$$

with the arithmetic mean as the $t\to0$ limit and the maximum length
as $t\to\infty$. It relates this exponential mean to Rényi entropy of
order $(1+t)^{-1}$; block coding makes the per-symbol gap arbitrarily
small. This normalization and order are stated in the publisher's
record for [Campbell 1965](https://doi.org/10.1016/S0019-9958(65)90332-3).

**Desk-proved.** The one-letter binary form, which is all this machine
needs, is

$$
H_\alpha(p)\le L_t(d)<H_\alpha(p)+1.
$$

The lower bound holds for every integer distance assignment satisfying
Kraft. Indeed,

$$
\begin{aligned}
Z_\alpha
&=\sum_i
\left(p_i2^{td_i}\right)^\alpha
\left(2^{-d_i}\right)^{1-\alpha}\\
&\le
\left(\sum_i p_i2^{td_i}\right)^\alpha
\left(\sum_i2^{-d_i}\right)^{1-\alpha}\\
&\le M_t(p,d)^\alpha
\end{aligned}
$$

by Hölder and Kraft. Hence
$M_t\ge Z_\alpha^{1/\alpha}=2^{tH_\alpha}$.

For achievability, take the escort shares
$r_i=p_i^\alpha/Z_\alpha$ and integer lengths

$$
d_i=\left\lceil-\log_2r_i\right\rceil.
$$

Then $2^{-d_i}\le r_i$, so Kraft holds, while
$d_i<-\log_2r_i+1$. It follows that

$$
M_t(p,d)<2^tZ_\alpha^{1/\alpha}
=2^{t(H_\alpha+1)}.
$$

For blocks of length $m$, apply the same construction to the product
distribution and divide the resulting Campbell length by $m$; Rényi
additivity changes the $+1$ into $+1/m$. This is the “arbitrarily
close” part of Campbell's coding theorem.

**Desk-proved, comparison.** Since raw travel is affine in $M_t$, the
machine's exact integer bounds are

$$
\frac q{q-1}2^{tH_\alpha}-\frac1{q-1}
\le T_t(p,d)
<\frac q{q-1}2^{t(H_\alpha+1)}-\frac1{q-1}.
$$

Thus the two problems coincide in constraint, optimizer, and ordering
of assignments. They differ in reported units and in composition:
Campbell's logarithm turns products into sums; raw machine travel does
not.

## 4. The discrete/counting version

Let positive touch counts be $m_i\in\mathbb N_{>0}$ and
$n=\sum_i m_i$. This matches the positivity hypothesis already used by
`Adic.Entropy.empiricalDists_kraft`; zero-count heads should either be
removed or handled by a separate inactive-head mounting lemma.

### 4.1 The honest discrete theorem still has non-natural values

**Desk-proved.** Substituting $p_i=m_i/n$ into the continuous optimum
cancels $n$ from the *total* moment:

$$
n\,M_t^*
=\left(\sum_i m_i^\alpha\right)^{1/\alpha}.
$$

For every Kraft-feasible natural distance vector,

$$
\left(\sum_i m_i^\alpha\right)^{1/\alpha}
\le \sum_i m_i2^{td_i},
$$

and escort-ceiling distances achieve a factor less than $2^t$ above
that benchmark. These are finite, discrete coding statements, but for
$t=1/2$ or $1/3$ their values are not naturals.

**Desk-proved, repair of the proposed assignment.** The bare formula

$$
d_i=\left\lceil\alpha\log_2(n/m_i)\right\rceil
$$

is not generally Kraft-feasible. For eight equally frequent heads and
$\alpha=2/3$, it assigns every head distance $2$, giving Kraft mass
$8/4=2$. The missing term is $\log_2Z_\alpha$, equivalently the escort
normalization. Any mechanization statement must include it, either
explicitly or through a common shift computed from the preliminary
masses.

### 4.2 Exact all-natural macro-level formulation

**Desk-proved design.** For rational $t=a/b$ with $a,b\ge1$, group
$b$ binary levels into one macro-level. A head gets macro-distance
$e_i\in\mathbb N$, corresponding to binary distance $d_i=be_i$.
Define, entirely in $\mathbb N$,

$$
\begin{aligned}
\text{MacroKraft}_b(e)&:\quad
\sum_i2^{b(E-e_i)}\le2^{bE},
\qquad E=\max_i e_i,\\
A_a(m,e)&=\sum_i m_i2^{ae_i},\\
B_a(e)&=\sum_{j=0}^{e}2^{aj},\\
\text{Travel}_a(m,e)&=\sum_i m_iB_a(e_i).
\end{aligned}
$$

`MacroKraft` is exactly $\sum_i2^{-be_i}\le1$ after clearing a
power-of-two denominator. The order selected by this pair is

$$
\alpha=\frac{b}{a+b}.
$$

For the Euclidean variants $a=1,b=k$, this is $k/(k+1)$.

**Desk-proved.** Cumulative travel and the moment satisfy an exact
natural identity, with no division:

$$
(2^a-1)\,\text{Travel}_a(m,e)+n
=2^a A_a(m,e).
$$

This is the all-natural replacement for the affine geometric-series
formula.

Define natural roots by

$$
\begin{aligned}
\lfloor\sqrt[r]{x}\rfloor_{\mathbb N}
&=\max\{u:u^r\le x\},\\
\lceil\sqrt[r]{x}\rceil_{\mathbb N}
&=\min\{u:x\le u^r\}.
\end{aligned}
$$

Put

$$
l_i=\left\lfloor\sqrt[a+b]{m_i^b}\right\rfloor_{\mathbb N},
\quad
u_i=\left\lceil\sqrt[a+b]{m_i^b}\right\rceil_{\mathbb N},
\quad W=\sum_i l_i,\quad U=\sum_i u_i.
$$

The floor and ceiling escort masses differ by at most one per head:
$W\le\sum_i m_i^\alpha\le U\le W+h$, where $h$ is the number of
heads. This is the promised linear head-count slack, expressed before
any real logarithm is introduced.

**Desk-proved, achievability.** Define $e_i$ as the least natural with

$$
U\le u_i2^{be_i}.
$$

Then `MacroKraft` holds. To see it, multiply each desired Kraft term at
common width $E$ by $U$, use the defining inequality pointwise, sum,
and cancel the positive $U$.

Let

$$
R=\left\lceil\sqrt[b]{U^a}\right\rceil_{\mathbb N}.
$$

The achieved moment has the exact natural bound

$$
A_a(m,e)\le2^aUR.
$$

For each head, minimality gives
$u_i2^{be_i}<2^bU$ (the $e_i=0$ case is easier), while
$m_i^b\le u_i^{a+b}$. Raising the desired pointwise bound to the
$b$th power gives

$$
(m_i2^{ae_i})^b
<(2^au_i)^bU^a
\le(2^au_iR)^b.
$$

Monotonicity of natural powers and summation finish the proof. For
$a=1,b=k$ this simplifies to

$$
A_1(m,e)\le2U
\left\lceil\sqrt[k]{U}\right\rceil_{\mathbb N}.
$$

The factor $2^a$ is exactly the one-macro-digit ceiling slack; in
binary Campbell-length units it is an additive $b$.

**Desk-proved statement; wall at mechanization until the hard rung is
proved.** For every `MacroKraft` assignment, the all-natural converse
is

$$
W^{a+b}\le A_a(m,e)^b.
$$

A stronger denominator-cleared form is

$$
W^{a+b}2^{abE}
\le A_a(m,e)^b
\left(\sum_i2^{b(E-e_i)}\right)^a.
$$

This is rational Hölder with every denominator and fractional exponent
cleared. `MacroKraft` reduces the rightmost factor to $2^{abE}$ and
cancellation gives the first inequality. The statement is finite and
purely natural; the missing artifact is a Lean proof of this generalized
Hölder polynomial inequality. This is the hard rung, not a hidden use of
real analysis.

### 4.3 Relating the macro model to literal $2^{\ell/k}$ prices

**Desk-proved design.** Macro-levels preserve the exponent and Rényi
order but coarsen binary distances. For a faithful natural-valued
binary schedule, define

$$
\widehat c_k(\ell)
=\left\lceil\sqrt[k]{2^\ell}\right\rceil_{\mathbb N},
\qquad
\widehat C_k(d)=\sum_{\ell=0}^{d}\widehat c_k(\ell).
$$

This is all-natural and satisfies

$$
2^{\ell/k}\le\widehat c_k(\ell)<2^{\ell/k}+1
\le2\cdot2^{\ell/k}.
$$

Consequently literal algebraic travel and rounded-natural travel differ
by at most $d+1$ per touch and by at most a factor two. Grouping levels
into blocks of $k$ then compares $\widehat C_k$ with the macro schedule
within a constant depending only on $k$.

**Recommendation (design, not decision).** Mechanize the macro theorem
first because every statement above is in the existing
`Nat`/power-of-two style. Then add the rounded binary schedule and
constant-factor sandwich. Use `Real` or exact algebraic numbers only if
the paper truly needs the literal constants $\sqrt2$ and $\sqrt[3]2$;
the complexity exponents and Rényi orders do not need them.

## 5. The two Euclidean instantiations

Let

$$
Z_\alpha=\sum_i p_i^\alpha,
\qquad q_k=2^{1/k}.
$$

**Desk-proved.** The exact continuous table is:

| ambient dial | $t$ | $\alpha$ | optimal share $2^{-d_i^*}$ | optimal moment | optimal cumulative travel |
|---|---:|---:|---|---|---|
| $k=2$ | $1/2$ | $2/3$ | $p_i^{2/3}/Z_{2/3}$ | $Z_{2/3}^{3/2}=2^{H_{2/3}/2}$ | $\dfrac{\sqrt2}{\sqrt2-1}2^{H_{2/3}/2}-\dfrac1{\sqrt2-1}$ |
| $k=3$ | $1/3$ | $3/4$ | $p_i^{3/4}/Z_{3/4}$ | $Z_{3/4}^{4/3}=2^{H_{3/4}/3}$ | $\dfrac{\sqrt[3]2}{\sqrt[3]2-1}2^{H_{3/4}/3}-\dfrac1{\sqrt[3]2-1}$ |

### Worked three-head sanity check

Take

$$
p=(1/2,1/4,1/4).
$$

**Desk-proved baseline.** For the unit-price model, Shannon's assignment is already integral:
$d=(1,2,2)$, Kraft is tight, $H_1=3/2$, and expected travel
$\sum p_i(1+d_i)=5/2$.

**Desk-proved, $k=2$.** Here

$$
Z_{2/3}=2^{-2/3}+2\cdot2^{-4/3}\approx1.423661,
\qquad H_{2/3}\approx1.528817.
$$

The escort shares and real distances are

$$
r\approx(0.442493,0.278753,0.278753),
\qquad
d^*\approx(1.176272,1.842939,1.842939).
$$

Kraft sums to one by construction. Direct substitution gives

$$
M_{1/2}^*\approx1.698673,
\qquad T_{1/2}^*\approx3.385420.
$$

Rounding with the escort ceiling again gives $d=(2,2,2)$, but that is
not the best integer code. The feasible code $(1,2,2)$ has

$$
M_{1/2}=\tfrac12\sqrt2+\tfrac12\cdot2
\approx1.707107,
\qquad
T_{1/2}=2+\sqrt2\approx3.414214,
$$

and Campbell length $2\log_2M_{1/2}\approx1.543107$, between
$H_{2/3}$ and $H_{2/3}+1$.

**Desk-proved, $k=3$.** Here

$$
Z_{3/4}=2^{-3/4}+2\cdot2^{-3/2}\approx1.301710,
\qquad H_{3/4}\approx1.521634,
$$

with

$$
r\approx(0.456786,0.271607,0.271607),
\qquad
d^*\approx(1.130408,1.880408,1.880408).
$$

Direct substitution gives

$$
M_{1/3}^*\approx1.421300,
\qquad T_{1/3}^*\approx3.042178.
$$

For the integer code $(1,2,2)$,

$$
M_{1/3}=\tfrac12 2^{1/3}+\tfrac12 2^{2/3}
\approx1.423661,
\qquad
T_{1/3}\approx3.053622,
$$

and $3\log_2M_{1/3}\approx1.528817$, again above the corresponding
Rényi entropy.

**Desk-proved, interpretation.** The rare heads move from ideal
Shannon distance $2$ to about $1.84$ or $1.88$, while the hot head
moves from $1$ to about $1.18$ or $1.13$. The assignment flattens:
expensive depth pulls rare heads inward and gives up some of the hot
head's privileged nearness. Integer prefix geometry can hide that
motion in small examples; the real relaxation exposes the direction.

## 6. Expo 2 at $k$ dimensions

**Verified baseline.** Expo 2 has already mechanized that Kraft is
equivalent to an antichain mounting and that unit-price touch cost is
bounded above and below by the Shannon count form, with explicit
natural slack. None of those mounting facts depends on a level-price
schedule.

**Desk-proved exposition sketch.** The Euclidean continuation can therefore begin without changing a
single mounting sentence:

> Three heads still occupy disjoint dyadic shares. The same Kraft
> inequality says which shares fit. What changes is how far-away
> shares are charged. At $k$ dimensions, a level-$\ell$ crossing costs
> $2^{\ell/k}$, so cumulative travel to distance $d$ is geometric.
> The best shares are no longer $p_i$ but the escort shares
> $p_i^{k/(k+1)}/\sum_jp_j^{k/(k+1)}$. Rare heads are pushed less deep
> because depth is now superlinearly priced. The normalized optimum is
> Rényi entropy of order $k/(k+1)$; raw travel is exponential in it.

**Desk-proved.** The before/after table for the exposition is:

| feature | informational machine, $c\equiv1$ | $k$-dimensional price, $c(\ell)=2^{\ell/k}$ |
|---|---|---|
| mounting law | $\sum_i2^{-d_i}\le1$ | unchanged |
| ideal share | $p_i$ | $p_i^{k/(k+1)}/Z$ |
| ideal distance | $\log_2(1/p_i)$ | $\log_2Z+\frac{k}{k+1}\log_2(1/p_i)$ |
| optimized normalized value | $H_1(p)$ | $H_{k/(k+1)}(p)$ |
| optimized raw touch travel | $1+H_1(p)$ | $\dfrac{q_k}{q_k-1}2^{H_{k/(k+1)}/k}-\dfrac1{q_k-1}$ |
| integer rounding | Shannon/Huffman | Campbell/generalized Huffman |

**Desk-proved worked example.** The three-head vector
$(1/2,1/4,1/4)$ from Section 5 is a useful successor to [59]. It keeps
Kraft tight at integer distances $(1,2,2)$ while the relaxed distances
visibly flatten. [59]'s uniform vector $(1/3,1/3,1/3)$ remains uniform
under every Rényi order and still uses integer distances $(2,2,2)$;
that makes it a good mounting example but a bad example of the changed
optimizer.

The corrected one-line slogan for the page is:

> **Same Kraft geometry, new travel objective: Shannon at unit prices,
> Rényi after exponential normalization.**

## 7. Which schedules are well behaved?

Let $c:\mathbb N\to\mathbb R_{\ge0}$ be a nonnegative monotone level
price and

$$
C(d)=\sum_{\ell=0}^{d}c(\ell).
$$

For a grade-$n$ tree, write $N=2^n$.

### 7.1 The streaming boundary

**Desk-proved, correction of the literal counting claim.** In a cyclic
odometer sweep of all $N$ leaves, the number of paid crossings at scale
$\ell$ is

$$
2^{n-\ell},\qquad 0\le\ell\le n,
$$

*in aggregate*. It is not the crossing count of each fixed edge. A
one-way sweep differs by at most one crossing at each scale; the cyclic
form is the clean exact identity. Its priced movement is

$$
S_n(c)=\sum_{\ell=0}^{n}c(\ell)2^{n-\ell}
=N\sum_{\ell=0}^{n}c(\ell)2^{-\ell}.
$$

Leaf reads add another $\Theta(N)$.

**Desk-proved.** Because the terms are nonnegative, uniformly
$O(1)$ amortized movement per leaf holds if and only if

$$
\sum_{\ell\ge0}c(\ell)2^{-\ell}<\infty.
$$

No doubling hypothesis is needed for this equivalence.

**Desk-proved.** For $c_s(\ell)=2^{\ell/s}$:

| range | one random access, $C_s(n)$ | full sweep, $S_n(c_s)$ |
|---|---|---|
| $s>1$ | $\Theta(N^{1/s})$ | $\Theta(N)$ |
| $s=1$ | $\Theta(N)$ | $\Theta(N\log N)$ |
| $0<s<1$ | $\Theta(N^{1/s})$ | $\Theta(N^{1/s})$ |

**Desk-proved, correction.** The $s=1$ point has tape-like random
access but not tape-like streaming. A Turing tape reaches an arbitrary
cell in $\Theta(N)$ and scans $N$ adjacent cells in $\Theta(N)$; the
priced dyadic path pays one $\Theta(N)$ contribution at every scale,
hence the extra logarithm. So the proposed dial is exact for random
access,

$$
s=1\ \text{linear},\qquad s=2,3\ \text{Euclidean},
\qquad s\to\infty\ \text{informational/logarithmic},
$$

but “$s=1$ is the Turing tape” is false as a whole-machine statement.
No schedule with $c(\ell)=\Theta(2^\ell)$ can also satisfy the
streaming summability condition.

**Desk-proved.** Near-tape schedules show the sharp boundary. If
$c(\ell)=2^\ell/(\ell+1)^r$, then random access is
$\Theta(N/(\log N)^r)$, while streaming is linear exactly when $r>1$;
$r=1$ gives $\Theta(N\log\log N)$ for the sweep.

### 7.2 Growth map

**Desk-proved.** The useful classification is by both $C(n)$ and the
weighted series above; neither alone controls the other.

- If $c$ is bounded above and bounded away from zero, then
  $C(n)=\Theta(n)$: random access is $\Theta(\log N)$ and streaming is
  linear. This is the informational/hyperbolic fiber.
- If $c(\ell)=\Theta(\ell^r)$, then
  $C(n)=\Theta(n^{r+1})$: random access is polylogarithmic in $N$ and
  streaming remains linear. Polynomial growth of $C$ in *tree depth*
  is therefore not Euclidean; the corresponding ball growth is
  stretched exponential. Euclidean polynomial volume growth requires
  $C(n)$ exponential in depth.
- If $c$ is subexponential, for example $2^{\sqrt\ell}$, random access
  is subpolynomial in $N$ and streaming is still linear.
- If $c(\ell)=\Theta(2^{\ell/s})$ with $s>1$, random access is
  $\Theta(N^{1/s})$ and streaming is linear. Integer $s$ gives the
  Euclidean dimensions; noninteger $s$ is the fractal dial.
- At the critical envelope $2^\ell$ the slowly varying factor decides
  streaming, as above.
- Faster-than-critical exponential and super-exponential schedules
  destroy constant-amortized streaming. When the last term dominates,
  random access and a full sweep can have the same order: the rare top
  boundary costs as much as the whole traversal.

### 7.3 What a doubling axiom buys

**Desk-proved.** A cumulative doubling bound

$$
C(d+1)\le K C(d)
$$

is a useful *rounding-stability* axiom: increasing a real optimum by
one integer level loses at most a factor $K$. It also makes local
changes of distance quantitatively tame. It is not the general
well-behavedness axiom:

- streaming needs the independent summability condition;
- exact random-access cost is $C(n)$ and needs no doubling;
- Rényi identification needs $C(d)$ to be affine in an exponential,
  or at least two-sided comparable to one;
- doubling alone neither supplies additivity nor selects a Rényi order.

A clean theorem interface should therefore expose separate hypotheses:
nonnegative monotonicity for basic cost lemmas, summability for
streaming, cumulative doubling for integer rounding, and two-sided
geometric growth for Campbell/Rényi comparisons. Conflating these into
one “reasonable schedule” class would hide real boundary cases.

## 8. Why exponentials are canonical—and the precise limit of that claim

**Verified.** Rényi's original 1961 characterization starts from a
Kolmogorov–Nagumo quasi-arithmetic mean and an additivity requirement
for independent experiments. Under its continuity and monotonicity
postulates, the admissible mean generator is linear or exponential;
the corresponding entropies are Shannon and the Rényi family. See
Theorems 2 and 3 in [Rényi, “On Measures of Entropy and Information”](https://static.renyi.hu/renyi_cikkek/1961_on_measures_of_entropy_and_information.pdf).

**Desk-proved in the present setting.** For independent head groups
with probabilities $p_i$ and $s_j$, and additive product distance
$d_i+e_j$,

$$
\sum_{i,j}p_is_j2^{t(d_i+e_j)}
=\left(\sum_i p_i2^{td_i}\right)
\left(\sum_j s_j2^{te_j}\right).
$$

Therefore $L_t=(1/t)\log_2M_t$ is additive. Its continuous optimum is
Rényi entropy, which is itself additive on product distributions. The
$t\to0$ limit is the arithmetic mean and Shannon entropy.

**Desk-proved, qualification.** Raw cumulative travel is not additive:
it is an affine function of $M_t$. It becomes additive only after the
normalization

$$
\Phi_t(T)=\frac1t\log_2
\left(\frac{(2^t-1)T+1}{2^t}\right)=L_t.
$$

Likewise, integer code optima are additive only up to rounding slack.
The axiomatic claim is therefore not “all additive machine costs are
exponential.” The honest statement is:

> Among continuous, strictly monotone quasi-arithmetic aggregations of
> additive distances that compose over independent products, the
> generators are linear or exponential. Their coding optima are
> Shannon or Rényi. Geometric level schedules are exactly the machine
> schedules whose cumulative cost is affine in the exponential
> generator.

**Conjectured extension.** A machine-native characterization could take
product composition, translation covariance under a common distance
shift, and continuity/monotonicity as axioms and derive the same
linear/exponential dichotomy. The finite functional-equation proof is
not supplied here. Rényi's theorem strongly suggests it, but citing the
information-measure theorem is not itself a proof for arbitrary machine
schedule functionals.

## 9. Lean mechanization ladder

**Recommendation (design, not decision).** The module name should be
`Adic.Campbell`. Use `h` for the number
of heads and reserve `k` for ambient dimension.

### Rung 1: macro Kraft arithmetic

**Desk-proved design, easy.** Define:

```text
blockKraftMassAt (b width : Nat) (dists : Fin h → Nat) : Nat
BlockKraftOk (b : Nat) (dists : Fin h → Nat) : Prop
expMomentCost (a : Nat) (counts dists : Fin h → Nat) : Nat
blockTravel (a dist : Nat) : Nat
blockTravelCost (a : Nat) (counts dists : Fin h → Nat) : Nat
```

Prove:

```text
blockKraftOk_iff
blockKraft_shift
blockTravel_geometric
blockTravelCost_moment_identity
```

The key exact statement is

```text
(2 ^ a - 1) * blockTravelCost a counts dists + finSum counts =
  2 ^ a * expMomentCost a counts dists
```

under `0 < a`.

### Rung 2: integer roots

**Desk-proved design, routine but library-sensitive.** Either reuse
Mathlib's natural root API or define least roots locally. Prove:

```text
floorRoot_pow_le
lt_succ_floorRoot_pow
le_ceilRoot_pow
ceilRoot_le_floorRoot_add_one
pow_le_pow_iff
```

with positive exponents. Friction risk: names and available generic
`Nat` root lemmas may dictate the local API.

### Rung 3: escort weights and distances

**Desk-proved design, medium.** Define:

```text
escortFloor (a b count : Nat) := floorRoot (a + b) (count ^ b)
escortCeil  (a b count : Nat) := ceilRoot  (a + b) (count ^ b)
escortMass  (a b : Nat) (counts : Fin h → Nat) : Nat
blockInverseFrequencyDist (b total share : Nat) : Nat
campbellDists (a b : Nat) (counts : Fin h → Nat) : Fin h → Nat
```

where `blockInverseFrequencyDist` is the least $e$ satisfying
`total ≤ share * 2 ^ (b * e)`. Prove:

```text
blockInverseFrequencyDist_spec
blockInverseFrequencyDist_minimal
campbellDists_blockKraft
escortMass_floor_ceiling_slack
```

Hypotheses: `0 < a`, `0 < b`, and every count positive.

### Rung 4: achievability

**Desk-proved design, medium-hard.** With
`U := finSum (escortCeil a b ∘ counts)` and
`R := ceilRoot b (U ^ a)`, prove:

```text
expMomentCost_campbell_upper :
  expMomentCost a counts (campbellDists a b counts) ≤
    2 ^ a * U * R
```

Then transfer it through `blockTravelCost_moment_identity`. This rung is
pointwise power arithmetic plus a finite sum; it should not require
analysis.

### Rung 5: cleared Hölder converse

**Wall / hard rung.** Prove a reusable natural inequality:

```text
campbell_holder_cleared :
  W ^ (a + b) * 2 ^ (a * b * E) ≤
    expMomentCost a counts dists ^ b *
      blockKraftMassAt b E dists ^ a
```

where

```text
W = finSum (fun i => floorRoot (a + b) (counts i ^ b))
E = maxDist dists
```

and the usual positivity hypotheses hold. Then derive:

```text
expMomentCost_campbell_lower
blockTravelCost_campbell_lower
```

from `BlockKraftOk`. This is the exact all-natural Campbell converse
and the only genuinely difficult rung. A multinomial/counting proof is
preferred if manageable; a first implementation through nonnegative
rationals followed by denominator clearing would still keep the public
theorem all-natural, but would be a larger dependency than
`Entropy.lean` currently needs.

### Rung 6: $k=2,3$ binary schedules

**Desk-proved design, medium.** Define:

```text
natLevelPrice (k level : Nat) := ceilRoot k (2 ^ level)
natTravel (k dist : Nat) := ∑ level in Finset.range (dist + 1),
  natLevelPrice k level
```

Prove the block sandwich for `k=2` and `k=3`, then expose named
instances:

```text
campbellOrder2_num = 2
campbellOrder2_den = 3
campbellOrder3_num = 3
campbellOrder3_den = 4
natTravel_two_dimensional_bounds
natTravel_three_dimensional_bounds
```

No theorem should claim literal equality with $2^{\ell/k}$ while its
codomain is `Nat`.

## 10. Stretch: the WBE rhyme

**Verified.** West, Brown, and Enquist derive quarter-power scaling
from a space-filling branching transport network with size-invariant
terminal units and an energy-dissipation optimization; the original
model is [West–Brown–Enquist 1997](https://doi.org/10.1126/science.276.5309.122).
Their later dimensional summary writes the exponent as $d/(d+1)$
([West–Brown 2005](https://doi.org/10.1242/jeb.01589)),
which is $3/4$ in three dimensions. The model and the empirical
universality of the exact $3/4$ exponent have been disputed; see, for
example, [Dodds–Rothman–Weitz 2001](https://doi.org/10.1006/jtbi.2000.2238).

**Desk-proved negative result.** The WBE optimization is not a
Campbell problem after an evident change of variables. Campbell has a
probability vector, a Kraft/prefix-packing constraint, and minimizes an
exponential mean of code lengths. WBE constrains a space-filling
vascular network, terminal units, fluid flow, and hydrodynamic energy.
There is no symbol probability distribution, no prefix budget, and no
exponential mean whose logarithm is an information measure. The two
problems do share homogeneous branching and a Lagrange balance between
$d$ geometric directions and one additional constraint, so the ratio
$d/(d+1)$ can appear in both.

**Conclusion on the stretch.** At present the coincidence is a useful
rhyme, not an identification. Claiming a Campbell theorem in disguise
would require an explicit map carrying WBE's feasible networks to
Kraft-feasible shares and its dissipation objective to an exponential
moment. No such map is visible, and the empirical/theoretical debate
around WBE makes it a poor foundation for a machine theorem. Keep it as
a one-paragraph cross-disciplinary observation, not as evidence.

## 11. Open gaps and requested repairs

**Desk-proved summary.** The main proposed correspondence survives with
these repairs:

1. include the escort normalization $\log_2Z_\alpha$ in the optimal
   distance;
2. say raw travel is affine in $2^{tH_\alpha}$, while Campbell's
   normalized logarithm equals $H_\alpha$;
3. keep Kraft geometry unchanged;
4. qualify $s=1$ as a random-access tape endpoint only;
5. distinguish polynomial growth in depth from Euclidean polynomial
   ball growth;
6. choose explicitly how irrational Euclidean prices enter an
   all-natural mechanization.

**Wall report.** No mathematical contradiction was found in the key
order $\alpha=1/(1+t)$, and no sub-question consumed the track without
a result. The honest unresolved proof obligation is the natural
cleared-Hölder rung. The honest design wall is exact irrational pricing
with a `Nat` codomain. Both are isolated above; neither blocks the desk
result or the recommended macro-level theorem.

## References

- L. L. Campbell, [“A Coding Theorem and Rényi's Entropy”](https://doi.org/10.1016/S0019-9958(65)90332-3), *Information and Control* 8(4), 423–429, 1965.
- A. Rényi, [“On Measures of Entropy and Information”](https://static.renyi.hu/renyi_cikkek/1961_on_measures_of_entropy_and_information.pdf), *Proceedings of the Fourth Berkeley Symposium on Mathematical Statistics and Probability*, vol. 1, 547–561, 1961.
- G. B. West, J. H. Brown, and B. J. Enquist, [“A General Model for the Origin of Allometric Scaling Laws in Biology”](https://doi.org/10.1126/science.276.5309.122), *Science* 276, 122–126, 1997.
- G. B. West and J. H. Brown, [“The Origin of Allometric Scaling Laws in Biology from Genomes to Ecosystems”](https://doi.org/10.1242/jeb.01589), *Journal of Experimental Biology* 208, 1575–1592, 2005.
- P. S. Dodds, D. H. Rothman, and J. S. Weitz, [“Re-examination of the ‘3/4-law’ of Metabolism”](https://doi.org/10.1006/jtbi.2000.2238), *Journal of Theoretical Biology* 209, 9–27, 2001.
