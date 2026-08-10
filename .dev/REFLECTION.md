# Reflection — the cohomology days (2026-08-09/10)

Written at session close, per Mathijs's request. The LOG has the
what; this records the how and what to change.

## The arc, in one paragraph

Two days took "cost is a cocycle" from a design essay to a closed
theory: Grothendieck framing made explicit → AIP-5 (exchange-form
ℕ-discipline, ratified same day) → cocycle framework mechanized →
padding proof completed by hand → local-classes found the class
zoo (incl. torsion) → operadic canonicity pinned the schedule
family → priorart bounded the claim honestly → classification
delivered the canonical exact sequence + verified SNF → the
left-subtree embedding broke the tower wall → three closing
tracks (exchange-comparison, pricing-surface, ledger-saturation)
finished every named question, leaving exactly one precisely
stated open equation (rational phase-diamond filling). In
parallel: free-up retrofit landed, Expo 2 renamed and
definition-retrofitted, Expos 4–6 written, adaptive entropy
mechanized, Rust entered with a measured s ≈ 2.41, and Expo 3
went from all-amber to all-green within one calendar day.

## What worked (keep doing)

- **The read-and-steer loop.** Reading worker LOGs mid-flight and
  steering with queued prompts was the highest-leverage activity
  of the session. Scorecard: short-witness steer → dirty-mech's
  flagship proof simplified before it was attempted;
  left-subtree embedding → became the core of the tower theory;
  harvest-the-corollary → dirty's uniform tower verdict;
  aperiodic-case steer → proved, killing the torsion wall for all
  named observers; axiom-lattice conjecture → refuted with exact
  witnesses (equally valuable). Five steers, five substantive
  outcomes. The mechanism: steers as *queued* prompts (no
  interrupt), phrased with "an honest refutation is as valuable
  as a proof".
- **Walls as deliverables.** Every spec carried the out-clause and
  every wall that came back was precise (Kraft-infeasibility as a
  spec bug; the mounting-image ≠ dyadic simplex; the phase
  diamond). Wall → repair → green cycled same-day, three times.
  The culture is now self-sustaining: workers volunteer guards
  (oriented-surface ℕ-vs-ℤ; the weak-surface counterexample)
  without being asked.
- **Badges as worklist.** Expo 3 demonstrated the full AIP-4
  lifecycle: design theory in the morning, every box
  machine-checked by midnight, with the desk arguments retained
  as explanation next to the formal receipts. The receipt/pin
  discipline caught nothing today — because it didn't have to;
  the discipline is what made same-day flipping safe.
- **Import over reprove.** The priorart track cost one worker-hour
  and reshaped the paper's entire claim posture before anything
  was overclaimed publicly. Do this *before* believing any
  "breakthrough" feeling, always.
- **The joint conversation loop.** The best track seeds came from
  Mathijs's associations (operadic characterization, the
  mount-tree memory, "kunnen we cohomologie zelf gebruiken?").
  The pattern: his association → my sharpening in chat → spec
  same hour → worker result same evening → his read redirects.
  Conversation is the ideation engine; the fleet is the
  laboratory.

## Friction (change these)

1. **My recurring merge-in-worktree mistake (3×).** Compound
   commands `cd <worktree> && ... && git merge` left the merge
   running inside the worktree (silent no-op "Already up to
   date") and once broke the shell cwd during cleanup. Rule
   adopted: merges happen as the FIRST command of a fresh
   invocation from `/home/mathijs/adic`, never chained after a
   `cd`, and the merge output is checked for the file list.
2. **Herdr steer recipe drift.** The global context documented
   `herdr agent send` + Enter/Tab/Escape; this herdr build has no
   `agent send`. Working replacement (observed repeatedly):
   `herdr agent prompt <name> '<text>'` to a working codex agent
   queues the text and delivers at the next turn boundary.
   Global context updated this session.
3. **PDF inspection tooling.** Workers repeatedly noted
   `pdfinfo`/`pdftotext` missing from devenv and improvised
   (uv+pypdf, nix shell poppler). Consider adding
   `pkgs.poppler-utils` to devenv.nix — three workers paid the
   same friction.
4. **receipts-manifest as a conflict axis.** Union + deterministic
   regeneration works, but every parallel Lean track collides
   there. A per-module manifest (globbed by the receipts
   executable) would dissolve the axis entirely.
5. **Conjecture-heavy specs.** My axiom-lattice conjecture went
   out as a target and came back refuted — fine, but the spec
   framing "prove X" cost the worker a detour. Better framing
   used later and to keep: "test X; refutation-first; a
   counterexample is a full deliverable."

## Handoff

`.dev/LOG.md` top entry is current. Open with Mathijs: the review
stack (three theory reports + operadic + classification +
empirical berry + Expos 3–6), the q2/paper fork (cohomology paper
is now a serious first-paper candidate), veto 5/7, terminology
amendments proposed by exchange-comparison and pricing-surface,
s ≈ 2.41 replication (mine to run on a quiet machine). Open for
agents: nothing — the fleet is drained and every named question
is closed or precisely walled.
