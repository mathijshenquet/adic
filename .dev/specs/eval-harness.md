# Track: eval-harness — the executable falsification harness

Worker: gpt-5.6-terra via codex, own worktree, branch
`track/eval-harness`. LOG.md at worktree root, git-excluded
(`.git/info/exclude`), append-only, timestamped — see AGENTS.md.

**The out:** problems or ambiguity > ~30 min → say so and stop. An
honest wall report is a fully valued deliverable.

**Receipts discipline (non-negotiable):** every green claim must be
a SYNCHRONOUS exit status you observed in the foreground — never
detached, backgrounded, or inferred from quiet output. Paste the
command + exit code in LOG.md.

## Context

Roadmap (aips/draft/roadmap.md, "Lean-first" ratified): the Lean
definition doubles as the v0 simulator via #eval. AIP-2 §3 calls the
theorem targets "each falsifiable against the simulator" — this
track builds that falsifier. Read `lean/Adic/Dyadic.lean`,
`Zip.lean`, `Copy.lean` first (definitions + the closed cost forms:
`cost_euler_closed`, `zipCost`, `copyCost`).

## Deliverable

1. **`lake exe sim`** (new lake executable, e.g. `lean/Sim.lean`):
   for grades n = 0..N (CLI arg, default 12):
   - compute `actionCost`/`cost` of `euler n`, `zipWord n a b`,
     `copyWord n src` on concrete inputs (use `falseTree` and at
     least one non-trivial input; the shape-independence theorems
     justify that cost is input-independent — cite them in a
     comment);
   - CHECK each against its proven closed form (euler: cost + 4 =
     4·2^n; zip: 20·2^n − 12; copy: 10·2^n − 8) — a mismatch means
     the executable and the proofs diverged: print FAIL and exit
     non-zero;
   - actually RUN the words (`run`/`runActions`) and check success
     plus output correctness (zip output = `interleave`, copy
     destination = source) on grades up to a size that stays fast
     (your judgment; record the ceiling);
   - print a small cost table (grade, euler, zip, copy) so a human
     sees the 2^n scaling at a glance.
2. Exit 0 iff every check passes; any failure → non-zero with a
   precise message. This exe joins the gate mentality: it is the
   falsifier the AIP promises.
3. **Quality gate**: fresh clean `lake build` exit 0; `lake exe sim`
   exit 0, both synchronously observed; zero sorry; letters + expo
   demo still compile; receipts + friction journal in LOG.md.

## Out of scope

Weighted/Kraft costs (B4 lands first), RAM simulation execution,
wall-clock benchmarking, plotting, Rust.
