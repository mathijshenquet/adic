# Track: lean-ram-lift — program-level reverse simulation

Worker: gpt-5.6-sol, same pane. Branch:
`git switch -c track/lean-ram-lift main`. Same LOG discipline.

**The out:** problems > ~30 min on the invariant design → precise
wall report; terra's LOG analysis (transient selected-register
state between generated fragments) is the known crux.

## Context

AIP-2 target 3, reverse direction, final step. Terra's
`ram_action_simulation` (Ram.lean) gives ≤3 register-RAM
instructions per D action with `RegisterRep`. Terra's honest
deferral note: composing fragments needs `RegisterRep` strengthened
to track the transient selected-register state between fragments.
Read terra's foundation code first — extend, don't rebuild.

## Deliverable

1. **Strengthened representation relation** (your design): an
   invariant that composes across concatenated per-action fragments
   — likely "RegisterRep + the selected register mirrors head h's
   encoding" or a normalization step (re-select/commit) between
   fragments; pick the design that keeps the per-action lemma
   reusable rather than re-proving it.
2. **The lift**: for every D action word of cost T, a compiled RAM
   program with `runRegisterRam … = some target`, final state
   representing the final D configuration, and cost ≤ c·T for an
   existential constant. This completes AIP-2 target 3 reverse:
   D and the word RAM differ by exactly one logarithm, in exactly
   one direction, both machine-checked.
3. **Receipts + full gate** as always; add the lift theorem to the
   manifest.

## Out of scope

Finite-control simulation, optimal constants, TM simulations.
