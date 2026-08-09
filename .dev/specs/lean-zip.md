# Track: lean-zip — zip as the first machine program with a proven cost bound

Worker: gpt-5.6-sol via codex, same pane/worktree. Branch: create
`track/lean-zip` off local `main` (it now contains your merged
lean-machine work). Same LOG.md discipline; append.

**The out, first:** if any part of this fights back for more than
~30 min, or the spec turns out to be wrong or ambiguous somewhere,
say so and stop — "ik loop tegen problemen aan" plus a precise
description in the LOG is a fully valued deliverable. Never bend a
statement to make it provable; never write a prompt-pleasing green.

## Context

Roadmap "worked-examples ladder" step 1 (aips/draft/roadmap.md):
zip is the first real machine program — two input heads, one write
head — and the first genuine *use* of your locality/metric results.
Convo background: [52]–[59] (zip confirms streaming is linear).

## The subtlety you must handle honestly (read before designing)

zip's *itinerary* is oblivious (data-independent), but its *writes*
are data-dependent (the written bit equals the input bit). A pure
`ActionWord` cannot express that (write0/write1 carry fixed bits);
a fixed finite-control program CAN branch on `read`, but a single
grade-uniform program cannot detect end-of-input without sentinel
machinery — that is the known partial-at-each-grade seam (convo
[15]), deferred to the calculus. Do NOT fake either.

The v0-honest formalization is the **oblivious schedule**: define,
by recursion on the grade, a data-indexed word family
`zipWord n (a b : Tree n) : ActionWord 3` whose *shape* (positions
visited, move/read/write skeleton, and hence cost) is independent of
the data — only the choice between write0/write1 at each write
depends on the input bit. Prove the shape-independence as a theorem
(cost of `zipWord n a b` equals a closed form in n alone), so the
data-dependence is provably confined to zero-cost bit choice.
Record in the LOG (friction journal) that the uniform-program
version awaits calculus-level end-detection — that note feeds an
AIP.

## Deliverable

In the same lake project, `lean/Adic/Zip.lean` (or your judgment):

1. **Layout + semantics.** `interleave : Tree n → Tree n → Tree
   (n+1)` by recursion (`interleave (a₀,a₁) (b₀,b₁) =
   (interleave a₀ b₀, interleave a₁ b₁)`; check the n=0,1 cases give
   a₀b₀a₁b₁… in leaf order — state this as a lemma against
   `leftToRightLeaves`-style enumeration so the semantics is
   readable). Machine layout: one grade-(n+2) memory with input A
   under 00, input B under 01, output under 1; three heads.
2. **The program.** `zipWord n a b : ActionWord 3` as above:
   synchronized tours of A and B, writing the interleaving into the
   output subtree.
3. **Theorems.**
   - *Correctness*: running `zipWord n a b` from the standard start
     configuration succeeds, and the output subtree of the final
     memory equals `interleave a b` (inputs unchanged).
   - *Cost*: `actionCost (zipWord n a b) = Z n` for a closed form
     `Z` independent of a, b, with `Z n ≤ c · 2^n` for an explicit
     constant c you determine — i.e. amortized O(1) per element.
   - *Optional, only if it falls out naturally*: connect to your
     metric/locality lemmas (e.g. the input tours are within a
     constant of the metric lower bound). Skip without guilt if it
     doesn't.
4. **Quality gate** — as always, synchronous receipts in LOG.md:
   fresh-shell clean `lake build` exit 0, zero sorry, `#print
   axioms` core-only for the main theorems.

## Out of scope

Uniform finite-control zip (end-detection), Kraft/cursor weights,
mergesort, multi-grade uniformity theorems, paper text.
