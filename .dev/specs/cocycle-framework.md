# Track: cocycle-framework — cost-as-functor in Lean + the free-up identity goes green

Worker: gpt-5.6-terra, herdr worktree, branch `track/cocycle-framework`.
LOG.md at worktree root; first action: add it to `.git/info/exclude`,
verify with `git check-ignore LOG.md`. Append-only, timestamped,
synchronous receipts only. Friction journal as always.

**The out:** problems or ambiguity > ~30 min on any rung →
wall-report that rung honestly, land the rest.

## Context

AIP-5 (`aips/accepted/0005-dirty-cocycle.md`) §1B ratified the
exchange-form ℕ-framework; §3 ratified framework-first
mechanization. Expo 3 (`expo/03-cost-is-a-cocycle.typ`) is the
design: cost models are cocycles over the machine's action;
homomorphisms are state-blind; coboundaries are potentials; the
free-up desk claim ("Free up is a change of representative") is
this track's flagship badge flip. The free-up retrofit is MERGED
on main: `cost` in `lean/Adic/Dyadic.lean` now prices `up` at 0.

## Deliverable: `lean/Adic/Cocycle.lean` (new file; import, don't edit, existing modules)

The ladder (deviations allowed, log them):

1. **Cocycle predicate** over the partial movement action
   (`run : Word → Head n → Option (Head n)`), exchange-form ℕ
   throughout, no Int anywhere:
   `IsCocycle (f : Word → Head n → Nat) : Prop :=`
   `(∀ h, f [] h = 0) ∧`
   `(∀ w₁ w₂ h h', run w₁ h = some h' → f (w₁ ++ w₂) h = f w₁ h + f w₂ h')`.
2. **The two trivial classes.** `symCost w := w.length` (define
   locally if no current name). Show state-blind additive costs
   are cocycles: `IsCocycle (fun w _ => cost w)` and same for
   `symCost` — the homomorphism examples.
3. **Exchange relation** (cohomologous-via-potential, AIP-5 §1B —
   this is Tarjan's identity):
   `Exchange (f g : Word → Head n → Nat) (Φ : Head n → Nat) : Prop :=`
   `∀ w h h', run w h = some h' → f w h + Φ h = g w h + Φ h'`.
   Prove the sanity lemma: if `Exchange f g Φ` and both sides are
   cocycles, the relation is preserved under word composition
   (whatever exact form is natural — the point is the definition
   composes; keep it small).
4. **The free-up identity (flagship).** With `Φ = depth of the
   head` (find or define the depth of a `Head n` from its
   breadcrumbs):
   `theorem freeUp_exchange : ∀ w h h', run w h = some h' →`
   `2 * cost w + depth h = symCost w + depth h'`
   by induction on the word (per-letter: down `2 = 1 + 1`, up
   `0 = 1 - 1` in exchange form). This is Expo 3's desk claim
   exactly; state it in this 2·form (ℕ-native, no subtraction).
   Corollary while you're there: `symCost w ≤ 2 * cost w + depth h`
   (the "moves ≤ 2·cost + initial depth" safety bound, now as a
   one-line consequence).
5. **Receipts + badge flip**: add the new theorems to
   `expo/receipts-manifest.txt`, regenerate `receipts.json`
   (`lake exe receipts` exit 0). In Expo 3, convert the deskthm
   "Free up is a change of representative" to a `leanthm` with the
   new receipt name + pin (read the statement, pin provisionally,
   record old-desk-text vs new formal statement in your LOG for
   the orchestrator's merge re-read). Adjust that box's prose
   minimally (it may keep the elementary explanation; it gains the
   receipt).

## Out of scope

The dirty model itself (pricing waits on call 2); any edit to
existing lean modules; the classification question (dormant);
touching Expo 1/2. NOTE: `track/adaptive-entropy` runs in parallel
and also appends to the receipts manifest — a merge conflict there
is expected and fine; do NOT try to coordinate, just keep your
manifest additions minimal and at the end.

## Gate

`lake build` (zero sorry; `#print axioms` on new theorems core
only), `lake exe receipts` exit 0, `lake exe sim` PASS, every
`expo/*.typ` and `letters/*.typ` compiles. Synchronous receipts in
LOG. Commit on the track branch only.
