# Track: lean-fvec — streaming copy + the telescoping doubling bound

Worker: gpt-5.6-sol via codex, same pane/worktree. Branch:
`git switch -c track/lean-fvec main` (contains your merged zip).
Same LOG.md discipline; append.

**The out:** anything fights back > ~30 min, or the spec is wrong or
ambiguous → say so and stop. Honest wall = valued deliverable.

## Context

Worked-examples ladder step 2 (aips/draft/roadmap.md): FVec's
amortized O(1) push rests on one machine-level fact — copying a
grade-n region costs O(2^n), so the doubling chain of copies
telescopes to O(final size). Convo background: [14]–[21] (doubling
Vec, telescoping copy), [247] (geometric cofinal re-indexing).
Full FVec (allocation, indices, push semantics) is calculus-tier;
v0 mechanizes the two cost facts that make it work.

## Deliverable

`lean/Adic/Copy.lean` (or your judgment), same lake project:

1. **Streaming copy as oblivious schedule** (reuse the Zip pattern —
   shape/OperationShape machinery is already in the codebase; share
   rather than duplicate where reasonable):
   `copyWord n (source : Tree n) : ActionWord 2` — head 0 reads a
   source subtree, head 1 writes a same-grade destination subtree
   (layout: source under 0, destination under 1 of a grade-(n+1)
   memory; your judgment if a cleaner layout serves).
   Theorems, mirroring Zip's:
   - *shape independence*: the action shape is data-independent;
   - *correctness*: running it maps destination to an exact copy of
     source, source unchanged, heads back at start;
   - *cost*: exact closed form `copyCost n` with
     `copyCost n ≤ c · 2^n`, explicit c.
2. **The telescoping bound** (pure arithmetic over the cost form —
   no machine needed): total cost of the doubling chain,
   `Σ_{i ≤ c} copyCost i ≤ C · 2^c` for an explicit C — the
   machine-level content of "amortized O(1) push". State it as a
   closed-form total (AIP-2 §5f), phrased so it reads as: geometric
   re-indexing telescopes; linear re-indexing (Σ_{i ≤ N} of a
   per-step linear cost) does not — include the contrast lemma
   only if cheap, skip without guilt otherwise.
3. **Quality gate** — as always: fresh-shell clean `lake build`
   exit 0, zero sorry, `#print axioms` core-only, receipts in
   LOG.md, friction journal.

## Out of scope

FVec proper (indices, push, partiality-at-grade), allocation,
uniform programs, Kraft, mergesort/transpose, paper text.
