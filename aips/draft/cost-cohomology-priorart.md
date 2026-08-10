# Cost cohomology prior art: the primitive is classical; the machine computation may not be

Draft (2026-08-10). Positioning report for the
`cost-cohomology-priorart` track. This document makes no design decision.
It tests which parts of the proposed cost-cohomology programme are prior art
and which parts remain plausible contributions.

Claim labels used throughout:

- **Verified** means checked against a cited primary source or an accepted
  repository source.
- **Desk-proved** means the identification follows by the displayed finite
  calculation, but is not a literature-priority claim.
- **Search finding** means no instance was found in the stated, bounded search;
  it is not a proof of absence.
- **Positioning risk** marks wording that would overclaim.

## 1. Verdict first

**Verified: the unqualified slogan is not new.** Additive weights on paths are
1-cocycles; changing an edge weight by the difference of endpoint potentials
is a coboundary or gauge transformation; closed-path sums are invariant; and,
under the usual connectivity hypotheses, they classify weights up to that
transformation. This is standard graph cohomology. It appears operationally as
weight pushing in weighted automata, as cohomology of functions in symbolic
dynamics, as gauge freedom and cycle affinity in stochastic thermodynamics,
and as potential reweighting in max-plus algebra. Baues and Wirsching provide
the broader cohomology of small categories. The paper must not present “cost
models form a cohomology” or “amortization is addition of a potential” as a
discovery.

**Verified: the potential equation is standard amortized analysis.** The
physicist's method replaces actual step cost by actual cost plus change in
potential and telescopes over a run. Modern cost-aware type theories,
separation logics, and Grodin and Harper's coalgebraic account internalize this
idea. The inspected canonical PL sources do not call the equation a
1-coboundary or organize *all* cost models into cohomology classes, but the
mathematical equation is already there. Renaming it is not a technical
contribution.

**Verified: symbolic dynamics is the closest mature classification theory.**
For functions on shifts of finite type, cohomology is literally quotient by
$f-f\circ\sigma$; periodic-orbit sums detect coboundaries under regularity
hypotheses; Parry and Tuncel compute first cohomology and use information
cocycles in classification; and ordered cohomology retains a positive cone.
Any claim of being the first to combine local finite observation, positivity,
and cocycles must therefore be much narrower than those words suggest.

**Plausibly differentiated bundle, not a priority claim.** The following
combination was not found in the inspected literature:

1. the operational semantics of a deterministic graded machine as an action
   category, with a cost model a functor from runnable programs;
2. *static priceability* as factorization through the projection from runnable
   executions to the instruction-word monoid;
3. an $\mathbb N$-positive exchange quotient, rather than only an abelian-group
   cohomology or ordered group;
4. a fixed finite observer language whose reachable augmented graphs are
   computed grade by grade, with one word-price vector required across the
   tower; and
5. concrete machine theorems identifying free directions and divisibility
   phenomena with bandwidth, invalidation, and recycling granularity.

The defensible contribution is thus a **machine-specific positive and local
cohomology theory plus computations**, built on classical ingredients. The
defensible novelty is not the existence of cocycles or potentials.

**Recommended positioning sentence.**

> Building on classical cohomology of dynamical weights, graph-potential
> reweighting, and the potential method of amortized analysis, we define an
> observer-local positive cost quotient for a graded machine and compute it for
> the dyadic machine, where its free and divisibility structure distinguishes
> bandwidth, invalidation, and recycling effects.

That sentence avoids an unsupported “first.” A stronger sentence can be used
only after the tower classification and the claimed free/torsion structure are
proved, not merely illustrated at fixed grades.

## 2. What the programme is claiming

Let $\mathcal C$ be the category whose objects are machine configurations and
whose morphisms are runnable instruction words. Composition is concatenation.
Let $B\mathbb N$ be the one-object category with natural numbers as morphisms
and addition as composition. The accepted machine claim has several logically
separate layers.

### 2.1 Additivity

A cost model is a functor

$$
c:\mathcal C\longrightarrow B\mathbb N,
$$

so

$$
c(g\circ f)=c(f)+c(g).
\tag{1}
$$

This is the categorical form of a normalized additive 1-cocycle. It is also
the writer effect for the monoid $(\mathbb N,+,0)$. Both descriptions are
standard.

### 2.2 Potentials and exchange

For group-valued costs, an object function $\Phi$ changes the representative
by

$$
c'(f)=c(f)+\Phi(\operatorname{target}f)
                -\Phi(\operatorname{source}f).
\tag{2}
$$

This is an ordinary coboundary. Natural-number costs cannot in general perform
the subtraction in (2). AIP-5 instead uses the exchange equation

$$
c'(f)+\Phi(\operatorname{source}f)
=c(f)+\Phi(\operatorname{target}f),
\qquad c,c',\Phi\in\mathbb N.
\tag{3}
$$

Equation (3) is the subtraction-free form of (2), but the resulting quotient
is not automatically classical $H^1$. It is a commutative-monoid or ordered
refinement whose behavior under cancellation and group completion must be
proved. In particular, a statement such as “$r$ copies become statically
priceable” is an $r$-divisibility or torsion phenomenon in the stated class
monoid; it need not be torsion in ordinary graph $H^1$, which is torsion-free
for a finite graph with integer coefficients.

### 2.3 Static priceability

There is a projection

$$
\pi:\mathcal C\longrightarrow B M
$$

that forgets the configuration and remembers only the instruction word in the
free monoid $M$. A cost is statically priceable when, up to (3), it factors as

$$
\mathcal C\xrightarrow{\pi}BM\xrightarrow{\lambda}B\mathbb N.
\tag{4}
$$

Thus every occurrence of a generator has one context-independent price.
This factorization target is more restrictive than merely being a coboundary:
the “zero class” is the family of word-price cocycles, not just the zero edge
function.

### 2.4 Locality and the grade tower

A finite observer augments each machine configuration with finite marks. A
local cost table reads a generator and a finite observation. At every finite
grade this gives a finite reachable directed graph and hence a finite exchange
feasibility problem. The tower problem requires a single generator-price
vector $\lambda$ to work at all grades, while potentials may vary by grade.
This fixed observer language and uniformity condition are substantial parts of
the proposed result; neither follows from saying “$H^1$.”

The rest of the report compares each layer separately. Similar notation alone
is not counted as anticipation of the whole bundle.

## 3. Foundational graph and category cohomology

This area was not named in the track brief, but it is the baseline against
which every novelty claim must be measured.

### 3.1 A fixed graph is already a cochain complex

Orient a connected finite graph $G=(V,E)$ and let $A$ be an abelian group. An
edge weighting is a 1-cochain $c\in A^E$. A vertex potential
$\Phi\in A^V$ has coboundary

$$
(\delta\Phi)(u\to v)=\Phi(v)-\Phi(u).
$$

There are no 2-cells, so every 1-cochain is a cocycle and

$$
H^1(G;A)=A^E/\delta A^V.
$$

**Desk-proved.** Choose a spanning tree and use a potential to make every tree
edge zero. The residual value on each non-tree edge is the signed sum around
its fundamental cycle. Hence cycle holonomies classify edge weights modulo
potentials, with $|E|-|V|+1$ independent coordinates when $A$ is a field or
free rank is meant. For directed closed walks alone, strong connectivity is a
necessary qualification; otherwise the signed underlying-cycle criterion is
the correct general statement.

This elementary result already contains “weights are resources/classes,” if
“resource” means no more than an element of the quotient. Calling those
classes *machine resources* and proving which physical effects represent them
is additional content.

### 3.2 Small-category cohomology is also established

Baues and Wirsching's 1985 theory defines cohomology of a small category with
coefficients in a natural system and identifies degree one with derivations
modulo inner derivations. For constant abelian coefficients, an additive
function on composable morphisms is exactly the elementary cocycle used here.
The machine action category is therefore a new object of study, not a new
reason that category cohomology exists.

There is a coefficient caveat. A functor to $B\mathbb N$ is perfectly valid,
but standard cohomology is normally group-valued. The positive exchange
construction must be presented as an ordered or semimodule refinement unless
its relation to a named cohomology theory is established.

### 3.3 Closest finite-graph gauge classification

Polettini's gauge treatment of a finite Markov graph is especially damaging to
an unqualified priority claim. The edge force transforms by an endpoint
difference; path sums are additive; closed Wilson loops are gauge invariant;
a spanning tree fixes a representative; and the $|E|-|V|+1$ fundamental
loops reconstruct the gauge potential up to gauge. In other words, it gives
the fixed-graph classification above in physical language. Section 6 returns
to its thermodynamic interpretation.

**Positioning consequence.** “We classify finite edge-cost functions up to
potential by their cycle sums” is classical. A publishable theorem must reside
in the special coefficient order, the quotient by word prices, the observer
restriction, tower uniformity, an algorithm with proved complexity, or the
computed dyadic answer.

## 4. Weighted automata

### 4.1 Weight pushing is the potential transformation

Mohri's weight-pushing algorithm computes a distance $d(q)$ at every state
and reweights a transition $e:p\to q$ over a semifield by

$$
w'(e)=d(p)^{-1}\cdot w(e)\cdot d(q),
\tag{5}
$$

with matching changes to initial and final weights. In the tropical semiring,
where multiplication is addition, (5) is

$$
w'(p\to q)=-d(p)+w(p\to q)+d(q).
$$

That is precisely (2), including the endpoint terms needed to preserve the
total weight of every successful path. Weight pushing is used before
determinization or minimization and can normalize where a path's weight is
stored without changing the weighted language.

This is not a loose analogy: it is the same algebra on a finite state graph.
The differences are in the semantic quotient and coefficient structure.

### 4.2 What is classified up to pushing?

There are three distinct questions that should not be conflated.

1. **Fixed graph, group-like weights.** Two edge weightings are related by a
   vertex push exactly when their difference is a coboundary. Their cycle sums,
   with initial/final boundary data handled separately, classify the push
   orbit. This is the graph calculation of §3, whether or not an automata paper
   calls it cohomology.
2. **Minimal deterministic weighted automata.** In the setting covered by
   Mohri's minimization construction, pushing followed by ordinary automaton
   minimization yields a minimal representative. Minimal equivalent weighted
   automata have the same underlying topology and can differ by the
   distribution of weights, which pushing changes. This is a strong
   normalization result, not a computation of the whole cohomology of an
   arbitrary machine semantics.
3. **Weighted-language equivalence.** Equality of the function recognized by
   two possibly nondeterministic automata is broader than push-equivalence on
   one graph. State splitting, merging, initial/final weights, inaccessible
   states, and semiring-specific behavior matter. “Equivalent modulo pushing”
   is therefore not a synonym for general weighted-automaton equivalence.

Mohri's *twins property* concerns determinization: roughly, sibling states
must assign matching weights to corresponding cycles. Under the stated trim,
unambiguous/tropical hypotheses it characterizes when determinization is
available. It is not a classification of all edge functions modulo
potentials.

### 4.3 How close, and what remains

**Exists.** Potential reweighting, preservation of path totals, canonical
normalization for algorithmic purposes, and an implicit fixed-graph
classification by cycle values.

**Does not follow from this literature.** The automaton state graph is usually
part of a recognizer and the invariant is a weighted language. The proposed
adic object instead fixes an operational machine, quotients context-sensitive
execution costs by configuration potential *and by instruction prices*, and
restricts admissible cocycles via finite observers across grades. Mohri does
not supply that tower computation or the $\mathbb N$ exchange monoid.

**Search finding.** The inspected handbook chapter and overview use “weight
pushing,” not “cohomology” or “coboundary.” This terminological fact does not
make the transformation new.

## 5. Symbolic dynamics and ergodic theory

This is the mathematically closest literature, because it studies local
functions on shift spaces, takes their quotient by coboundaries, and uses
closed-orbit data both for classification and rigidity.

### 5.1 Cohomology of functions on a shift

Let $(X,\sigma)$ be a shift of finite type and let $f,g:X\to A$ be continuous
or regular functions. They are cohomologous when

$$
f-g=h-h\circ\sigma
\tag{6}
$$

for a transfer function $h$. Birkhoff sums telescope:

$$
\sum_{k=0}^{n-1}(h-h\circ\sigma)(\sigma^k x)
=h(x)-h(\sigma^n x).
$$

Thus periodic-orbit sums are invariants. Locally constant functions on a
finite-state presentation are edge or block weights, so (6) specializes
directly to graph potential reweighting.

Parry and Tuncel's monograph contains chapters on the information cocycle and
the computation of the first cohomology group, and uses cohomological
invariants in classification problems for topological Markov chains. Their
1981 paper gives a particularly concrete near-neighbor: under finite
equivalence of Markov chains, the information cocycles differ by a continuous
coboundary. Associated pressure/spectral data are invariants.

### 5.2 Livšic and Walters: periodic data detect exactness

Livšic's theorem, in its shift/hyperbolic forms, says under transitivity and
regularity hypotheses that a cocycle is a coboundary when all periodic-orbit
sums vanish. Walters' regularity framework and work on pressure and
compensation functions use the same cohomology relation for functions on
subshifts.

The qualification matters. Arbitrary functions need not be reconstructed from
periodic data; continuity alone can also be too weak in general dynamical
systems. The adic finite-observer setting is locally constant at each grade,
so it lies in a favorable finite-state regime, but a uniform theorem over the
tower is extra.

### 5.3 Positivity and classification are already partly combined

Boyle and Handelman study ordered first cohomology and show that it is a
complete invariant for flow equivalence of irreducible shifts of finite type.
The quotient is equipped with a positive cone, not merely a bare abelian
group. Later topological-Markov-shift work likewise uses

$$
C(X,\mathbb Z)/\{\xi-\xi\circ\sigma\}
$$

with its order structure.

Consequently, “cocycles + local functions + positivity + classification” is
not a safe novelty bundle. The precise distinction is that ordered cohomology
starts with the integer group and remembers which classes have nonnegative
representatives. AIP-5's exchange relation starts in $\mathbb N$, also
quotients by a family of instruction-price cocycles, and may retain
noncancellative divisibility information that group completion erases. That
difference is real only after the quotient and its comparison with ordered
cohomology are defined and proved carefully.

### 5.4 What symbolic dynamics never needed to ask

The cited classification problems concern orbit, flow, finite, or measure
equivalence of dynamical systems and Markov chains. They do not identify
machine engineering phenomena such as bandwidth, dirty invalidation, or
recycling granularity. They do not use factorization through an instruction
monoid as the definition of static prices. They also do not impose the exact
adic observer interface or its one-price-vector-across-grades condition.

Those are application and computation differences, not a new cohomological
primitive. The strongest useful import is methodological: construct a finite
presentation, compute cycle data, retain the positive order, and prove a
Livšic-style completeness theorem for the chosen observer tower.

## 6. Nonequilibrium statistical mechanics

### 6.1 Entropy production is an additive path observable

For a Markov process, the logarithm of the ratio between a path probability
and the probability of its time reversal is additive under path
concatenation. Lebowitz and Spohn use this action functional to formulate a
Gallavotti–Cohen-type symmetry for stochastic dynamics and identify its
steady-state average with entropy production under their hypotheses. This is
a real-valued trajectory cocycle.

Schnakenberg's network theory expresses nonequilibrium thermodynamics through
cycle currents and cycle affinities. Polettini makes the cohomological rhyme
literal. For transition rates $w_{ij}$, the force

$$
A_{ij}=\log\frac{w_{ij}}{w_{ji}}
$$

is an edge gauge potential. A change of prior induces

$$
A_{ij}\longmapsto A_{ij}+\varphi_j-\varphi_i.
$$

Closed-loop affinities are invariant. Vanishing loop affinities are the
Kolmogorov cycle criterion and make the connection exact; physically this is
equilibrium/detailed balance. A spanning tree yields a basis of fundamental
cycles and a gauge-fixed representative.

Therefore the attractive slogan “the cocycle is trivial iff detailed balance”
already has a precise finite-state realization. The Gallavotti–Cohen symmetry
then concerns the fluctuations of a generally nontrivial entropy-production
observable; it is not itself the coboundary classification theorem.

### 6.2 Has this been connected to computation cost?

Yes, but in a different sense. Wolpert's review develops the stochastic
thermodynamics of computation, including physical entropy production and
energy costs for erasure, circuits, reversible computation, and Turing
machines. It would be false to claim that trajectory cocycles or entropy
production have never been related to computation.

What was not found is a use of thermodynamic gauge classes to classify
*abstract operational cost models* such as time, dyadic bandwidth, cache
invalidation, or observer-local write-back. Stochastic thermodynamics uses
probabilistic rates, time reversal, real-valued antisymmetric affinities, and
physical entropy. The adic costs are deterministic, usually
$\mathbb N$-valued, and need not reverse. The overlap is a powerful analogy and
a source of cycle-basis methods, not identity of the theories.

### 6.3 Positioning use

The physical analogy can be stated safely as follows:

> Configuration potentials change the bookkeeping of open executions but not
> the cost holonomy of closed executions, just as a thermodynamic gauge changes
> edge forces but not cycle affinities.

Do not say that detailed balance is newly reinterpreted, or that observer
dependence plus gauge invariance originates here: Polettini explicitly derives
the gauge symmetry from the choice of prior and discusses what depends on the
observer.

## 7. Amortized analysis and programming-language theory

### 7.1 The physicist's method already is the displayed boundary equation

For a transition $d\to d'$ with actual cost $c$, the amortized cost is

$$
\widehat c=c+\Phi(d')-\Phi(d).
\tag{7}
$$

Summing (7) over a sequence telescopes. Tarjan systematized amortized
complexity; this potential method is now standard. Equation (7) is (2) up to
sign convention. The equality case changes representative inside one
group-valued cohomology class; the usual inequality
$c+\Phi(d')-\Phi(d)\leq b$ chooses a subaction or upper-bounding
representative.

The new paper can make that relation explicit and useful, but cannot claim the
equation.

### 7.2 Resource-aware logics and type systems

Atkey attaches amortized resources to data through affine separation logic
and proves soundness. Charguéraud and Pottier treat time credits as separation
logic resources and verify a pointer-based union-find implementation and its
amortized complexity in Coq. These works make stored potential a first-class
logical resource.

Hofmann and Jost's type-based resource analysis, and Hoffmann, Aehlig, and
Hofmann's multivariate AARA, infer polynomial potential annotations and reduce
resource-bound inference to linear constraints. The goal is automatic upper
bounds, not classification of every exact cost instrumentation modulo
potential.

The *calf* framework makes cost a computational effect over a cost monoid,
separates cost from behavior, and mechanizes the physicist's method. This is
very close to (1) at the level of cost composition and directly relevant to a
future formalization.

### 7.3 Grodin and Harper are the closest categorical PL source

Grodin and Harper write the potential equation explicitly and reinterpret a
potential as a coalgebra morphism in a category of writer-monad algebras. Colax
morphisms represent imprecise upper bounds; indexed coalgebras compose
amortization arguments. This is a substantive categorical account, not just a
data-structure example.

Their object of study is nevertheless a potential witnessing an amortized
implementation or bound. They do not, in the inspected paper, form a first
cohomology quotient of all exact cost models, classify its nonzero elements,
or compute a positive local class monoid of a machine.

### 7.4 Does anyone say “amortization is a 1-coboundary”?

**Search finding, not a universal negative.** Searches for the conjunctions
of amortized analysis with “cohomology,” “coboundary,” and “1-cocycle,” plus
text searches in the primary Mohri, Atkey, Charguéraud–Pottier, *calf*, and
Grodin–Harper sources, did not find that wording. The canonical sources speak
of potential differences, credits, cost effects, coalgebra morphisms, and
telescoping.

It is safe to write:

> The potential method is exactly a coboundary change of an exact cost
> cocycle, although amortized-analysis literature normally uses potential or
> credit language.

It is not safe to write “we discover that amortization is cohomology.” The
identity is immediate once (7) and the graph cochain complex are placed side
by side.

### 7.5 What can remain ours

PL work supplies cost effects, stored resources, inference of potentials,
proof rules, and categorical composition. The proposed contribution instead
asks for the obstruction when no potential makes a context-dependent cost
static, treats the obstruction itself as a resource, restricts which costs are
observable, and computes the obstruction for a fixed machine geometry. That
shift from *find one useful potential* to *classify the failure of all static
prices* is a defensible conceptual distinction.

## 8. Max-plus algebra, ergodic optimization, and weak KAM

### 8.1 Tropical potential reweighting is standard

In max-plus or min-plus algebra, multiplying a matrix by a diagonal similarity
is addition of a vertex potential to edge weights. Cycle weights and cycle
means are invariant because the endpoint terms telescope. Shortest-path
reduced costs and Johnson-style reweighting have the same form.

Schneider and Schneider prove a particularly close finite result. For a
strongly connected weighted directed graph, they find a vertex potential $p$
such that

$$
g^p(u\to v)=p(u)+g(u\to v)-p(v)
$$

is max-balanced; the potential is unique up to an additive constant under
their normalization. Thus tropical theory not only quotients by potentials
but selects useful canonical representatives using maximum cycle means.

Akian, Gaubert, and Walsh's discrete max-plus spectral theory develops the
associated eigenvector and boundary machinery. None of this is specific to
machine costs.

### 8.2 Ergodic optimization and weak KAM use subactions

Ergodic optimization routinely adds a coboundary without changing integrals
against invariant measures. A calibrated subaction solves an equality on
optimizing trajectories and an inequality elsewhere, for example

$$
f-\beta(f)\leq u\circ T-u.
$$

This is the dynamical analogue of choosing an amortized upper-bound
representative. Weak KAM theory similarly uses Lax–Oleinik operators, Mañé
potentials, and critical subsolutions; exact changes contribute endpoint
terms, while cohomology classes of closed forms parameterize Mather's
effective action.

These theories go beyond the elementary quotient: they optimize within or
over cohomological data and study calibrated representatives. They are close
to amortization, especially when a bound rather than equality is desired.

### 8.3 Difference from the adic target

The max-plus and weak-KAM questions concern spectral values, optimal invariant
measures, long-run average cost, or minimizing trajectories. They do not
quotient by instruction-word prices, restrict edge functions to finite
machine observers, or compute a grade-uniform positive class monoid. Their
canonical-representative and subaction algorithms should nevertheless be
cited as prior art and may be reusable.

## 9. Direct searches, resource theories, and observer covers

### 9.1 Direct “cohomology of computation/cost” search

**Search finding.** Broad searches for “cost cohomology,” “cohomology of
computation,” “cohomology of machines,” cocycles of operational semantics,
and cost models modulo potentials produced the established neighboring lines
already discussed, plus unrelated uses of cohomology in complexity theory and
topological data analysis. No source was found that states the complete bundle
of §1 or computes it for a memory machine.

This bounded result must not be converted into “there is no prior art.” The
generic mathematical instance is already covered by graph and category
cohomology, so a differently named application could easily exist. A
publication should describe the search scope and avoid a priority claim.

### 9.2 Categorical resource theories

Coecke, Fritz, and Spekkens model resource theories categorically; Fritz
develops resource convertibility through ordered commutative monoids and
conversion rates. Quantum resource theories, such as the stabilizer resource
theory, likewise form algebraic structures of resources under composition and
identify free operations.

The analogy is useful but limited. In those theories a resource is typically
an object or state and the order says which conversions are possible. Here a
“resource” is proposed to be an equivalence class of path-cost
instrumentations under bookkeeping changes and static word prices. An
ordered-commutative-monoid structure is shared; the equivalence relation and
operational interpretation are not.

The paper should either define the conversion preorder and free operations
that make this literally a resource theory, or use “resource class” in the
more modest sense of an additive invariant. The monoid word alone is not
enough to import quantum-resource results.

### 9.3 Local observers and sheaf/cohomology analogies

Abramsky and Brandenburger use a measurement cover and sheaf gluing to model
local observations in contextuality. Abramsky, Mansfield, and Barbosa then
construct a Čech cohomology obstruction to a global section. This is a genuine
precedent for “observer cover + cohomological obstruction.”

It does not classify accumulated machine costs. Their local sections are
measurement outcomes and the class obstructs a compatible global assignment;
the adic observer is a finite marking automaton that presents a set of
reachable cost tables. Still, any broad slogan that cohomology newly arises
from local observers needs this caveat. The original part would be the exact
observer category, its positive cost coefficients, and the computed machine
classes.

## 10. Comparison table

| Proposed ingredient | Status in prior art | Closest sources | What must remain in the adic result |
|---|---|---|---|
| Additive path cost is a 1-cocycle | **Exists** | graph and small-category cohomology; symbolic dynamics | a precise machine action category and formal semantics |
| Potential changes cost by a coboundary | **Exists** | weighted-automata pushing; graph gauges; tropical reweighting | the chosen positive exchange relation and its laws |
| Closed loops classify fixed-graph weights | **Exists** | graph $H^1$; Polettini; Livšic under regularity | quotient also by word prices; directed/reachability qualifications |
| Amortization chooses a representative | **Exists mathematically; terminology adjacent** | Tarjan; AARA; *calf*; Grodin–Harper | classify obstructions, not merely exhibit a potential |
| Static priceability is factorization through words | **Adjacent / likely new packaging** | weighted automata and functorial semantics | prove factorization is equivalent to the intended operational property |
| Positivity matters | **Exists in adjacent form** | ordered cohomology; resource monoids | compare the $\mathbb N$ exchange quotient with group completion and positive cone |
| Local observers yield cohomological data | **Exists as a broad pattern** | locally constant shift cocycles; sheaf contextuality | exact finite observer language and reachable augmented-machine construction |
| Uniform class computation over a grade tower | **Not found** | finite graph algorithms are per presentation | stabilization/decision theorem or an honest infinitary statement |
| Bandwidth and invalidation give free classes | **Not found** | physical cycle affinities are only an analogy | machine proof, independence, and completeness |
| Recycling/visit granularity gives torsion | **Not found in this machine setting** | modulo-$r$ cocycles are elementary; ordered groups warn about terminology | prove torsion in the precisely defined monoid and state what group completion does |
| Cost cohomology is a categorical resource theory | **Adjacent, not automatic** | ordered commutative monoids; quantum resource theories | define free operations, composition, and conversion order |

## 11. Claim ladder and recommended paper language

### 11.1 Claims that always need a prior-art caveat

The following should be introduced as identifications or imports:

- execution costs compose as cocycles;
- potentials act by coboundaries;
- closed executions detect the obstruction to exactness;
- amortized analysis changes cost by a potential difference;
- finite graph classes can be represented on a cycle basis;
- positive/order structure can refine a dynamical cohomology group; and
- local-observer covers can carry cohomological obstructions.

Suggested wording is “we instantiate,” “we refine,” “we adapt,” or “we compute,”
not “we discover.”

### 11.2 Claims that may be made once proved internally

These are mathematical statements about the specified adic object and do not
require a priority superlative:

- “Static priceability is equivalent to factorization through the
  instruction-word projection, up to positive exchange.”
- “At fixed grade and fixed observer, triviality reduces to the displayed
  finite integer feasibility problem.”
- “For strongly connected reachable augmented graphs, the qualified
  closed-walk criterion is complete.”
- “For this observer, the dirty and warmth tables represent nonzero classes.”
- “For this definition of the class monoid, the visit-modulo-$r$ class has the
  proved $r$-divisibility/torsion property.”
- “The grade tower has the computed free rank and generators,” once a uniform
  proof or stabilization theorem exists.

These claims are about a particular construction and can be original without
saying they are the first of their kind.

### 11.3 Claims not yet supported

- “Cost cohomology is a breakthrough.” The primitive is demonstrably old.
- “No one connected cohomological entropy production to computation.” Physical
  computation is already part of stochastic thermodynamics.
- “Weighted automata classify all equivalent machines by pushing.” Pushing on
  a fixed topology is narrower than weighted-language equivalence.
- “Positivity and locality are new to cohomology.” Ordered symbolic cohomology
  and locally constant cocycles are counterexamples at that level of
  generality.
- “The tower cohomology is computable.” Fixed grades are finite; no uniform
  stabilization bound is currently supplied by `local-classes.md`.
- “Visit parity is torsion in $H^1$.” It is a torsion statement only in the
  particular positive quotient unless a different coefficient theory is
  proved.
- Any “first,” “only,” or “no previous work” sentence. This desk search cannot
  justify one.

## 12. Recommended research actions

1. **Name the object conservatively.** Use “positive cost quotient” until its
   functoriality, congruence, cancellation behavior, and relation to ordered
   $H^1$ are proved. Then decide whether “cohomology monoid” is mathematically
   stable terminology.
2. **State the coefficient comparison theorem.** Map the $\mathbb N$ exchange
   quotient to integer graph cohomology modulo word-price classes. Identify
   exactly what group completion forgets. This turns positivity from rhetoric
   into a theorem.
3. **Separate three classifications.** Keep fixed graph up to potential,
   automata up to recognized-language equivalence, and machine observers up to
   exchange visibly distinct.
4. **Prove the tower step.** A finite-grade solver is not yet a computation of
   the infinite graded tower. Establish stabilization, a finite cutoff, a
   Presburger-plus-exponentials schema, or state the result gradewise.
5. **Use a fundamental-cycle certificate.** Every nontriviality and
   independence result should ship with explicit reachable cycles and a rank
   or integer-feasibility certificate. That is both readable and close to the
   strongest prior methods.
6. **Treat the physical analogy as validation.** Thermodynamic affinities make
   the closed-loop interpretation intuitive, while weighted automata and
   max-plus theory supply normalization algorithms. Cite them as foundations,
   not competitors to be renamed.
7. **Lead the paper with the computed machine theorem.** The paper becomes
   compelling if the dyadic geometry forces a class structure that predicts
   or separates actual hardware costs. An abstract reprise of graph $H^1$
   will not carry the novelty burden.

## 13. Final assessment

The prior-art result is a useful negative answer with a positive repair.

The negative answer is firm: **“cost models form a cohomology” is not new as a
mathematical principle.** Every piece of the bare sentence has well-developed
precedents, and several sources implement almost the same finite graph
calculus. Symbolic dynamics already combines local weight functions,
coboundaries, periodic data, positivity, computation of first cohomology, and
classification. Programming-language theory already makes potentials and
cost effects formal and categorical.

The repair is equally clear: the programme need not depend on that priority
claim. Its prospective contribution is to choose a machine-native semantic
category, impose a positive and observationally finite cost language, quotient
by both potentials and static instruction prices, solve the resulting uniform
tower problem, and interpret the computed algebra as concrete resource
phenomena of dyadic hardware. No inspected source does that complete job.

That is a narrower claim, but also a better theorem.

## References

- H.-J. Baues and G. Wirsching,
  [“Cohomology of Small Categories”](https://doi.org/10.1016/0022-4049%2885%2990008-8),
  *Journal of Pure and Applied Algebra* 38, 187–211, 1985.
- M. Mohri,
  [“Weighted Automata Algorithms”](https://doi.org/10.1007/978-3-642-01492-5_6),
  in *Handbook of Weighted Automata*, 213–254, Springer, 2009.
- W. Parry and S. Tuncel,
  [*Classification Problems in Ergodic Theory*](https://doi.org/10.1017/CBO9780511629389),
  London Mathematical Society Lecture Note Series 67, Cambridge University
  Press, 1982.
- W. Parry and S. Tuncel,
  [“On the Classification of Markov Chains by Finite Equivalence”](https://doi.org/10.1017/S0143385700001279),
  *Ergodic Theory and Dynamical Systems* 1, 303–335, 1981.
- A. N. Livšic,
  [“Cohomology of Dynamical Systems”](https://doi.org/10.1070/IM1972v006n06ABEH001919),
  *Mathematics of the USSR-Izvestiya* 6(6), 1278–1301, 1972.
- P. Walters,
  [“Relative Pressure, Relative Equilibrium States, Compensation Functions and
  Many-to-One Codes Between Subshifts”](https://doi.org/10.1090/S0002-9947-1986-0837796-8),
  *Transactions of the American Mathematical Society* 296(1), 1–31, 1986.
- M. Boyle and D. Handelman,
  [“Orbit Equivalence, Flow Equivalence and Ordered Cohomology”](https://doi.org/10.1007/BF02761039),
  *Israel Journal of Mathematics* 95, 169–210, 1996.
- J. Schnakenberg,
  [“Network Theory of Microscopic and Macroscopic Behavior of Master Equation
  Systems”](https://doi.org/10.1103/RevModPhys.48.571),
  *Reviews of Modern Physics* 48, 571–585, 1976.
- J. L. Lebowitz and H. Spohn,
  [“A Gallavotti–Cohen-Type Symmetry in the Large Deviation Functional for
  Stochastic Dynamics”](https://doi.org/10.1023/A:1004589714161),
  *Journal of Statistical Physics* 95, 333–365, 1999.
- M. Polettini,
  [“Nonequilibrium Thermodynamics as a Gauge Theory”](https://doi.org/10.1209/0295-5075/97/30003),
  *EPL* 97, article 30003, 2012.
- D. H. Wolpert,
  [“The Stochastic Thermodynamics of Computation”](https://doi.org/10.1088/1751-8121/ab0850),
  *Journal of Physics A: Mathematical and Theoretical* 52, article 193001,
  2019.
- R. E. Tarjan,
  [“Amortized Computational Complexity”](https://doi.org/10.1137/0606031),
  *SIAM Journal on Algebraic and Discrete Methods* 6(2), 306–318, 1985.
- R. Atkey,
  [“Amortised Resource Analysis with Separation Logic”](https://doi.org/10.2168/LMCS-7%282:17%292011),
  *Logical Methods in Computer Science* 7(2:17), 2011.
- A. Charguéraud and F. Pottier,
  [“Verifying the Correctness and Amortized Complexity of a Union-Find
  Implementation in Separation Logic with Time Credits”](https://chargueraud.org/research/2017/credits_jar/credits_jar.pdf),
  *Journal of Automated Reasoning* 62(3), 331–365, 2019.
- M. Hofmann and S. Jost,
  [“Static Prediction of Heap Space Usage for First-Order Functional
  Programs”](https://doi.org/10.1145/640128.604148),
  *Proceedings of POPL 2003*, 185–197, 2003.
- J. Hoffmann, K. Aehlig, and M. Hofmann,
  [“Multivariate Amortized Resource Analysis”](https://doi.org/10.1145/1926385.1926427),
  *Proceedings of POPL 2011*, 357–370, 2011.
- Y. Niu, J. Sterling, H. Grodin, and R. Harper,
  [“A Cost-Aware Logical Framework”](https://doi.org/10.1145/3498670),
  *Proceedings of the ACM on Programming Languages* 6 (POPL), article 9, 2022.
- H. Grodin and R. Harper,
  [“Amortized Analysis via Coalgebra”](https://doi.org/10.46298/entics.14797),
  *Electronic Notes in Theoretical Informatics and Computer Science*, volume 4,
  Proceedings of MFPS XL, article 10, 2024.
- H. Schneider and M. H. Schneider,
  [“Max-Balancing Weighted Directed Graphs and Matrix Scaling”](https://doi.org/10.1287/moor.16.1.208),
  *Mathematics of Operations Research* 16(1), 208–222, 1991.
- M. Akian, S. Gaubert, and C. Walsh,
  [“Discrete Max-Plus Spectral Theory”](https://arxiv.org/abs/math/0405225),
  in *Idempotent Mathematics and Mathematical Physics*, Contemporary
  Mathematics 377, 53–77, 2005.
- A. Fathi,
  [*Weak KAM Theorem in Lagrangian Dynamics*](https://www.math.u-bordeaux.fr/~pthieull/Recherche/KamFaible/Publications/Fathi2008_01.pdf),
  preliminary version 10, 2008.
- B. Coecke, T. Fritz, and R. W. Spekkens,
  [“A Mathematical Theory of Resources”](https://doi.org/10.1016/j.ic.2016.02.008),
  *Information and Computation* 250, 59–86, 2016.
- T. Fritz,
  [“Resource Convertibility and Ordered Commutative Monoids”](https://doi.org/10.1017/S0960129515000444),
  *Mathematical Structures in Computer Science* 27(6), 850–938, 2017.
- V. Veitch, S. A. H. Mousavian, D. Gottesman, and J. Emerson,
  [“The Resource Theory of Stabilizer Quantum Computation”](https://doi.org/10.1088/1367-2630/16/1/013009),
  *New Journal of Physics* 16, article 013009, 2014.
- S. Abramsky and A. Brandenburger,
  [“The Sheaf-Theoretic Structure of Non-Locality and Contextuality”](https://doi.org/10.1088/1367-2630/13/11/113036),
  *New Journal of Physics* 13, article 113036, 2011.
- S. Abramsky, S. Mansfield, and R. S. Barbosa,
  [“The Cohomology of Non-Locality and Contextuality”](https://arxiv.org/abs/1111.3620),
  *Proceedings of QPL 2011*, Electronic Proceedings in Theoretical Computer
  Science 95, 1–14, 2012.
