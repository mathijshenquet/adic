# Track: operadic-canonicity — pinning the schedule classification via the mounting operad

Worker: gpt-5.6-sol, herdr worktree, branch `track/operadic-canonicity`.
LOG.md at worktree root; first action: add it to `.git/info/exclude`,
verify with `git check-ignore LOG.md`. Friction journal as always.

**The out:** desk mathematics — a precise wall (exactly where the
converse gets hard, and why) is a first-class deliverable. Walls
> ~30 min on a sub-question: record and move on.

## Context

`aips/draft/campbell-renyi.md` §7–8 left the schedule
classification not pinned: the additivity/KN canonicity argument
is qualified, borrowed from Rényi's quasi-arithmetic-means
axiomatics. Mathijs's proposal (2026-08-10): replace it with the
*operadic* characterization line — Faddeev (1956), Baez–Fritz–
Leinster information loss (2011), Leinster's *Entropy and
Diversity*, and Tai-Danae Bradley's theorem that Shannon entropy
is, up to scalar, the unique derivation of the operad of
(topological) simplices; Tsallis satisfies the q-deformed Leibniz
rule $S_q(p compose q) = S_q(p) + sum_i p_i^q S_q(q_i)$, Rényi is
a monotone transform. The machine-native observation
(orchestrator, verify it): mountings compose by *grafting* —
substituting a sub-mounting into a mount slot adds depths and
multiplies Kraft masses — so Kraft vectors form the
dyadic-rational suboperad of the simplex operad, and under
$c_t(\ell) = 2^{t\ell}$ the optimal travel
$M_t(p) = 2^{t H_\alpha(p)}$ ($\alpha = 1/(1+t)$) satisfies the
exact grafting law
$$2^{(1-\alpha)H_\alpha(p \circ q)}
  = \sum_i p_i^\alpha\, 2^{(1-\alpha)H_\alpha(q_i)},$$
degenerating to the strict derivation (Shannon chain rule) at
$\alpha \to 1$.

## Deliverable: `aips/draft/operadic-canonicity.md` (+ PDF per AGENTS.md recipe)

1. **The mounting operad, precisely.** Dyadic prefix-free trees
   with substitution; composition law on depths and Kraft masses;
   the inclusion into the simplex operad as the dyadic-rational
   points. State what an "algebra-level functional" and a
   "derivation" mean here, in exchange-form-friendly language
   (AIP-5 §1B is the house style for ℕ-affine statements).
2. **The forward direction, exact.** Verify the orchestrator's
   grafting law for $M_t$ from Campbell's escort optimum
   (your own report's §2 has the machinery); state the Shannon
   case as the strict Leibniz rule and the $t > 0$ family as the
   deformed one. Full desk proofs.
3. **The converse (the prize; wall precisely if unreachable).**
   Axiom set to aim for: symmetry + a grafting-Leibniz law with
   *some* weight system + a regularity axiom (continuity, or
   monotone + dyadic density — choose the weakest that works) ⇒
   the weight system is an escort family and the schedule is
   exponential. Bradley's uniqueness proof is the template; our
   suboperad only has dyadic-rational points, so density/extension
   is where it will fight. Partial results welcome: e.g. converse
   within the ansatz $c(\ell)$ monotone with the doubling axiom
   (campbell-renyi §7.3).
4. **Literature check** (you have network): pin the exact
   citations — Faddeev; Rényi 1961; Baez–Fritz–Leinster 2011;
   Leinster, *Entropy and Diversity* (CUP 2021); Bradley,
   "Entropy as a Topological Operad Derivation" (2021); and
   whether a Tsallis/Rényi *operadic* (deformed-derivation)
   uniqueness theorem already exists — if someone has already
   proved the deformed analogue, say so prominently: importing
   beats reproving. Record anything about DYADIC/restricted
   simplex suboperads.
5. **Verdict section**: does this pin the classification? What
   exactly replaces campbell-renyi §8's qualified claim; what a
   Lean mechanization would take (rung list); what stays open.

## Gate

PDF renders (pandoc recipe, `\text{}` not `\mathrm{}`); every
claim labeled verified / desk-proved / conjectured / wall; no
edits outside your report + LOG; expos still compile (untouched —
verify). Commit on the track branch only.
