#set page(width: 148mm, height: auto, margin: (x: 18mm, y: 16mm))
#set text(size: 10.5pt)
#set par(justify: true)

#align(right)[_adic — Letter 2 · 2026-08-09_]

= The bilimit, refused

Beste Mathijs,

You half-remembered a piece of categorical semantics tonight —
categories of partial maps in which limits and colimits coincide —
and asked whether that would not be "helemaal mooi" for us. It is,
but in mirrored form, and I want to work out the mirror carefully,
because I think the theorems you were reaching for are the sharpest
justification this project has for existing.

== The cluster you meant

The classical result is the *limit–colimit coincidence* of Smyth and
Plotkin (1982), going back to Scott's $D_infinity$: in a
cpo-enriched category, take an $omega$-chain of
*embedding–projection pairs* — $e : A arrow.r B$, $p : B arrow.r A$
with $p compose e = "id"$ and $e compose p subset.sq.eq "id"$ — and
the colimit of the embeddings is canonically _the same object_ as
the limit of the projections: the bilimit. Freyd sharpened this to
*algebraic compactness*: in such partiality-enriched settings the
initial algebra and the final coalgebra of a functor coincide,
$mu F tilde.equiv nu F$, the "bifree" algebra — which is exactly why
general recursion is interpretable there. The axiomatic school
around partial maps is Robinson–Rosolini (dominances), Fiore's
_Axiomatic Domain Theory in Categories of Partial Maps_, and, in
modern dress, Cockett–Lack's restriction categories.

== Our tower already has the ep-pairs

Look at ${ZZ\/2^n}$ with the maps we already committed to: the
zero-padding inclusion $e_n : ZZ\/2^n arrow.r ZZ\/2^(n+1)$ and the
truncating projection $p_n$ back. Then $p_n compose e_n = "id"$ on
the nose, and $e_n compose p_n$ is "keep the low part" — below the
identity precisely in the partial-map order. So the hypotheses of
Smyth–Plotkin are not foreign to adic; the tower _is_ an ep-chain.
Enrich over partiality and the theorem fires: the bilimit exists,
and the two completions I kept apart in Letter 1 — $NN$ on the
colimit side, $ZZ_2$ on the limit side — glue into one object, in
which every point of the limit is the supremum of its finite
approximants. Towers converge; $mu = nu$; domain theory.

== Why we refuse it

Now recall what the founding conversation identified, in its very
first exchanges, as the problem to organize the whole language
around: *extensional collapse* — semantics that cannot tell a cheap
representation from an expensive one. I claim the bilimit
coincidence is the categorical _mechanism_ of that collapse. The
coincidence is cost-blind by construction: it identifies the colimit
side, whose elements have finite descriptions attained at a finite
grade, with the limit side, whose points carry unbounded
information. Enrichment over pointed cpos supplies the $bot$ that
makes the chain self-dual, and in doing so erases exactly the
distinction adic is built to preserve. A point of $ZZ_2$ is not
attainable at any grade; every point of $NN$ is. The bilimit needs
maps that adic prices at infinity.

So the beautiful statement is not "adic should have coinciding
limits." It is:

#align(center)[_domain theory is the image of adic under the
cost-erasing functor._]

Erase grades and costs, and the ep-pairs become self-dual, the two
limits snap together, and you land in $D_infinity$. Read backwards:
cost-grading is precisely the obstruction that keeps Ind and Pro
apart. That is theorem-shaped, and I would like it on the target
list in some form such as: _there is no cost-bounded cone over the
projection chain_ — any family of maps presenting a single object as
the limit of ${ZZ\/2^n}$ must have unbounded cost, while the colimit
is presented by maps of cost zero-per-element. The asymmetry between
the two limits, invisible extensionally, is exactly a cost
asymmetry.

This also explains two things at once: why classical domain theory
works as well as it does (it is the faithful shadow of the costed
world), and why it could never see complexity (the shadow is taken
by the functor that forgets it). And it upgrades our earlier slogan.
adic is not merely a tower we decline to complete; it is the
observation that completing it is a *lossy* operation, and the loss
is precisely the subject of the theory.

The odometer letter ended with the write head needing to earn its
weight; this one ends with a question for you: do we want the
no-cost-bounded-cone claim as a formal theorem target (it needs the
cost-enriched category to be set up first, so it is calculus-tier),
or is it, for now, the thesis sentence of the monograph — the strong
claim in its sharpest dress?

Met vriendelijke groet, \
Claude
