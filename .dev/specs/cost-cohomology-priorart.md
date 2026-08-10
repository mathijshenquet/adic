# Track: cost-cohomology-priorart — is "cost models form a cohomology" new?

Worker: gpt-5.6-sol, herdr worktree, branch `track/cost-cohomology-priorart`.
LOG.md at worktree root; first action: add it to `.git/info/exclude`,
verify with `git check-ignore LOG.md`. Friction journal as always.

**The out:** an honest "this exists, here is where" is the MOST
valuable outcome — the point of this track is to protect the
programme from overclaiming. Walls > ~30 min: record, move on.

## Context

The programme is converging on a claim: *the cost models of a
machine form a cohomology (of its action category and its
observer coverings); resources are classes; amortization is
choice of representative; static priceability is factorization;
and for the dyadic machine this cohomology is computable, with
hardware phenomena as its structure (bandwidth = free rank,
invalidation = second free class, recycling granularity =
torsion).* Sources: AIP-5 (+§8b), Expo 3,
`aips/draft/local-classes.md`. Before anyone calls this a
breakthrough, position it honestly against the literature. You
have network access — use primary sources where possible.

## Deliverable: `aips/draft/cost-cohomology-priorart.md` (+ PDF per AGENTS.md recipe)

A positioning report with, per area: what exactly exists (with
citations), how close it is, and what remains genuinely ours.
Areas to cover (extend if you find more):

1. **Weighted automata**: Mohri's weight pushing = potential/
   coboundary transformation; equivalence modulo pushing;
   twins/minimization theory. How much of "cost modulo
   coboundary" is already standard there? Is there any
   *classification of weight functions up to pushing* result?
2. **Symbolic dynamics**: Parry–Tuncel (cohomology of weight
   functions on Markov shifts), Livšic theory (cocycle rigidity,
   periodic-orbit criteria), Walters. The mathematically closest
   line — say precisely what they classify and what they never
   asked (machine resources, ℕ-positivity, local observers).
3. **Nonequilibrium statistical mechanics**: entropy production
   as a cocycle; Gallavotti–Cohen; "trivial iff detailed
   balance". The physical rhyme — anyone connecting it to
   computation cost?
4. **Amortized analysis in PL theory**: Tarjan; Atkey;
   Charguéraud–Pottier; Hofmann's AARA; Grodin–Harper (calf,
   amortized analysis categorically). Does ANYONE state
   amortization = 1-coboundary / cohomology class explicitly?
5. **Max-plus / tropical spectral theory**: weights up to
   coboundary in tropical algebra (ergodic control, Mañé
   potentials, weak KAM — the "Aubry–Mather / discounted" world
   has exactly cost-plus-potential normalizations). How close?
6. **Anything directly on "cohomology of computation/cost"**:
   search broadly (cohomology of machines, resource theories
   categorically — also quantum resource theories' monoid
   structure as an analogy).
7. **Verdict section**: a sober table (exists / adjacent / ours),
   and a recommended positioning sentence for the paper — what
   we can claim without a caveat, and what needs one.

## Gate

PDF renders (pandoc recipe); every citation checked against a
real source (no hallucinated references — if you cannot verify a
work exists, say so); no edits outside your report + LOG. Commit
on the track branch only.
