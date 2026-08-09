# Track: lean-receipts — the receipts harness (AIP-4 §3)

Worker: gpt-5.6-sol, same pane. Branch:
`git switch -c track/lean-receipts main`. Same LOG discipline.

**The out:** problems or ambiguity > ~30 min → say so and stop.
Lean metaprogramming API friction is the plausible wall here;
a precise report of where the API fought you is a full deliverable.

## Context

AIP-4 (accepted): expositions in `expo/*.typ` cite Lean theorems
via receipt boxes rendered from `expo/receipts.json`. Read
`aips/accepted/0004-expositions.md` §3 and `expo/lib.typ` (the
consumer — its `leanthm` defines the JSON contract) and
`expo/style-demo.typ` (a hand-pasted mock of the target output).

## Deliverable

1. **`lake exe receipts`** (new lake executable in the existing
   project, e.g. `lean/Receipts.lean`): reads a manifest
   `expo/receipts-manifest.txt` (one fully-qualified declaration
   name per line, `#`-comments allowed), and writes
   `expo/receipts.json`: an array of
   `{ "name": …, "statement": …, "axioms": […], "hash": … }`.
   - *statement*: the declaration's type pretty-printed as it would
     appear in `#check` output, prefixed `theorem <shortname> : ` —
     readable, stable formatting (fixed width 80, no info nodes).
   - *axioms*: the `#print axioms` set (use the CollectAxioms
     machinery), sorted.
   - *hash*: a short (12 hex chars suffices) content hash of the
     statement string — stable across runs on unchanged code. Use
     SHA-256 truncated if available in core, else document what you
     used and why it is stable.
   - Unresolvable manifest names must FAIL the exe with a clear
     message (exit ≠ 0) — a silent skip would forge the ledger.
2. **Seed manifest**: populate the manifest with the main theorems
   so far (streaming, random_access, movement_cost_lower_bound,
   movement_cost_realizable, random_access_optimal,
   disjoint_subtree_commute, disjoint_subtree_interleaving,
   zipWord_correct, zipWord_cost, zipWord_shape_independent,
   copyWord_correct, doublingCopyTotal_linear_bound,
   ram_program_simulation — check exact names) and generate the
   real `expo/receipts.json`.
3. **Wire the gate**: document (LOG + a line in `expo/README.md`)
   the invocation `lake exe receipts && typst compile expo/…`;
   verify `expo/style-demo.typ` still compiles (it uses a local
   mock, not the JSON — leave it as the style reference).
4. **Quality gate**: fresh clean `lake build` + `lake exe receipts`
   exit 0 synchronously observed; committed receipts.json matches a
   fresh regeneration (`git diff --exit-code` after regen); zero
   sorry; letters + demo compile; receipts in LOG.

## Out of scope

Expo 1's prose (Claude writes that), attribute-based collection
(@[expo] — manifest file is v0), incremental generation, Verso.
