# Track: lean-spike — mechanize D_n + theorems 1–2 (calibration)

Worker: gpt-5.6-sol via codex. Branch `track/lean-spike` in a herdr
worktree. This is a **calibration spike**: besides the artifact, we
are measuring Lean proficiency (yours and the orchestrator's). Honest
walls are a valued outcome; flailing is not.

## Context (read first)

- `aips/accepted/0002-dyadic-machine-v0.md` — the machine. §3 is the
  definition, §5 (addendum) is the *designed-for-proof* guidance you
  must follow: recursive memory, zipper heads, monoid-action
  presentation, Option-partiality, closed-form totals.
- `AGENTS.md` — project conventions (LOG discipline, receipts).

## Deliverable

A Lean 4 mechanization of the movement/cost core of D_n plus theorem
targets 1–2 from AIP-2 §3, in a lake project at repo root `lean/`.

1. **Toolchain.** Add Lean 4 to `devenv.nix` (devenv's lean support
   or `pkgs.lean4` — your judgment; it must work through
   direnv/devenv in this worktree). No mathlib — core Lean only
   (`omega`, `simp`, `decide` are available in core). No network
   package fetching.
2. **Definitions** (follow AIP-2 §5a–c; naming free):
   - `Tree : Nat → Type` with `Tree 0 = Bool`,
     `Tree (n+1) = Tree n × Tree n`.
   - Positions as bit-paths; a head as a zipper (path + context) so
   	 it can rest at internal nodes.
   - Moves `up | down0 | down1` as partial functions (Option), a
     run as a *word* (List) of moves, cost = word length.
   - Movement only — no finite control, no multi-head, no read/write
     semantics needed for these two theorems. Keep it minimal.
3. **Theorem A (random access, AIP-2 §3 target 2).** For every n and
   every path p (length n): the descend-word of p, executed from the
   root zipper, succeeds, ends at the leaf addressed by p, and costs
   exactly n (= the word's length).
4. **Theorem B (streaming, AIP-2 §3 target 1).** Define
   `euler n : Word`. Prove BOTH:
   - (length) `cost (euler n) ≤ 4 * 2^n`;
   - (visits) executing `euler n` from the root succeeds and the
     sequence of leaf-positions passed through is *exactly* the
     2^n leaves in left-to-right tree order.
   The visits half is the content — a length bound on an unverified
   word is worthless. Formalize "sequence of leaf-positions passed
   through" honestly (e.g. the trace of configurations filtered to
   leaf-focus); state it so a reviewer can read the theorem statement
   alone and believe the claim.
5. **Quality gate (your receipts must show these, synchronously):**
   - `lake build` exit 0 in a fresh shell in the worktree;
   - zero `sorry`, zero new `axiom`s; include `#print axioms` output
     for both theorems in the LOG;
   - `lean --version` / toolchain pin recorded.

## Process

- Commit on `track/lean-spike` in this worktree, small commits fine.
  Do not touch `main`. Do not commit LOG.md.
- Keep `LOG.md` at the worktree root; first action: add `LOG.md` to
  `.git/info/exclude`, verify with `git check-ignore LOG.md`.
  Append-only, timestamped: decisions, current state, next step,
  exact repro commands.
- **Friction journal** (section in LOG.md): everything that was not
  immediately intuitive — AIP ambiguities, devenv/lean toolchain
  papercuts, statement-formalization doubts. This feeds the DX loop
  and is a first-class deliverable.
- If a wall costs you more than ~30 min without progress, record it
  precisely in the LOG (what you tried, why it fails) and move on or
  stop. An honest wall beats a fake green. Never claim green from
  detached or quiet output — receipts are synchronous exit statuses
  you observed.

## Out of scope

Multi-head, read/write, finite control/programs, theorems 3–4, the
tree-metric lower bound, simulation results, paper text, mathlib.
