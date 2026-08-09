# The paper as organizing artifact

## 1. The problem

adic's ambition is a coherent abstraction — machine, graded towers,
cost calculus — more than any single implementation. The natural
organizing artifact is a thesis-length paper (Mathijs: the length of
Shannon's information theory papers), grown alongside the prototype
rather than written after it. Without a designated home, results
scatter across AIPs, code comments, and chat.

## 2. Prior work

Shannon 1948 as the length/depth benchmark. Composix's tour: executable
docs drift-checked against the implementation — the analogue here is a
paper whose claims are checked against the simulator. The AIP process
records *decisions*; the paper records the *theory* the decisions add
up to.

## 3. Recommendation

- `paper/` at the repo root, written in Typst, compiled by the gate
  (a paper that stops compiling is a broken build).
- Skeleton chapters: (1) the dyadic machine; (2) simulation and basic
  cost theorems; (3) graded towers — types without infinities; (4) the
  calculus and cost soundness (initiality + adequacy); (5) worked
  examples: FVec, zip, mergesort, transpose; (6) cursor weights, Kraft
  accounting, entropy bounds; (7) related work.
- Standing rule: every accepted AIP eventually has a home in the paper;
  "not yet absorbed into the paper" is a tracked state, not a silence.
- A claims ledger (in or beside the paper) grades every stated theorem
  or cost claim: desk-proved / simulator-checked / mechanized — honest
  distinctions, composix-ledger style.

## 4. Open questions

1. **Typst or LaTeX?** — rec: Typst. Fast compile for the gate, sane
   diffs, nix-friendly; LaTeX export exists if a venue ever demands it.
2. **Working title?** — rec: "adic: computation over dyadic space"
   (placeholder; the title is the last thing to fix).
3. **Start the skeleton now or after the machine AIP lands?** — rec:
   after; chapter 1 transcribes that AIP, and an empty skeleton earns
   nothing.
