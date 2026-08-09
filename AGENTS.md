# adic — agent context

A programming language in which infinite types exist only as graded
towers of finite ones — `uint` is the tower {ℤ/2ⁿ}, never a `u64` with
undef edges — over a dyadic-tree machine whose geometry makes the cost
model structural: streaming O(1) and random access Θ(log) are theorems,
not assumptions. Prototype in Rust; the organizing artifact is a
thesis-length paper; arithmetic side-conditions discharge to a
decidable fragment (Presburger + 2^x, master-theorem schemas), with
Lean as a later backend for what falls outside it.

## Where truth lives (read in this order to rebuild context)
1. `.dev/LOG.md` — session journal, newest entry first. Top entry =
   current state + open items.
2. `aips/` — decision registry (cite as "AIP-1"). `accepted/` is
   authoritative; `draft/` is a strict inbox for Mathijs.
3. `docs/convo.md` — the founding design conversation (source
   material, not authority; `docs/convo-summary.md` summarizes).

## Environment
- devenv + direnv (`.envrc`); Rust toolchain + typst.
- Cargo workspace and paper directory arrive with their first AIPs.

## Conventions (adopted from composix, 2026-08-09)
- Work happens on `track/<name>` branches in herdr-managed worktrees;
  spec file per track in `.dev/specs/`.
- Keep your assigned LOG.md current (append-only, timestamped).
- "Green" claims by agents get independently re-verified before merge —
  leave exact repro commands in your LOG. A receipt is a SYNCHRONOUS
  exit status you observed, never detached or quiet output.
- Every worker spec asks for a friction journal: record what was not
  immediately intuitive — it feeds the DX loop.
- Decisions live in `aips/` only; don't fork design prose into other
  files.
- AIP drafts render to a PDF next to the source (Mathijs reads the
  math as PDF): after editing `aips/**/<f>.md`, regenerate with
  `pandoc <f>.md --pdf-engine=typst -V mainfont="Libertinus Serif"
  -V monofont="DejaVu Sans Mono" -o <f>.pdf` and commit both. Use
  `\text{…}` (not `\mathrm{…}`) for upright words in math — the
  typst conversion garbles the latter.
- Gate: `lake build` in `lean/` (zero sorry, `#print axioms` on
  stated theorems shows core axioms only); every `letters/*.typ`
  compiles (`typst compile`); once Rust code exists: `cargo fmt
  --check`, warning-denied clippy, `cargo test --workspace`; once
  the paper exists: `typst compile`. The gate
  grows with the project; agents never hand-pick what counts as
  green.

## Session close (orchestrator)
Append a dated entry to `.dev/LOG.md`: merged work, decisions taken
(with AIP numbers), open items *with Mathijs* vs open items *for
agents*.
