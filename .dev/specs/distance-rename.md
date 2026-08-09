# Track: distance-rename — Kraft terminology: weight → distance

Worker: gpt-5.6-sol, herdr worktree, branch `track/distance-rename`.
LOG.md at worktree root; first action: add it to `.git/info/exclude`,
verify with `git check-ignore LOG.md`. Append-only, timestamped,
exact repro commands. Friction journal section as always.

**The out:** problems or ambiguity > ~30 min → say so and stop. An
honest wall/blocked report is a valued deliverable, never a failure.

## Context (the decision — .dev/LOG.md entry "2026-08-10 (eve)")

Mathijs renamed the Kraft parameter: *weight* $w_i$ → **distance**
$d_i$. "Weight" collides with the cited literature (Huffman,
Bent–Sleator–Tarjan), where weight = frequency: heavy = hot = cheap.
Our parameter is mount-path depth — the opposite polarity. "Distance"
reads correctly: far = expensive; the $1+d$ surcharge is travel time;
Kraft $\sum 2^{-d_i} \le 1$ is "only so much fits nearby" — hot is
near. Agreed vocabulary going forward:

- parameter: **distance** $d_i$; "a head at distance $d$";
  variables `w`/`weights` → `d`/`dists` (prose: "distances").
- the model / Expo 2 title: **"Heads at a distance"**.
- Lean `weightedCost` → **`distCost`**; do NOT introduce "travel
  cost" as a term (post free-up, *all* cost is travel — total cost
  stays just "cost").
- **Kraft** and **mounting** keep their names: distance is what a
  head costs, mounting is where it hangs.

## Deliverable

A context-aware rename across the repo. NOT a blind sed: "weight"
must only change where it means this Kraft/head parameter. Known
false friends: `text(weight: "bold")` (typst font weight, e.g.
`expo/lib.typ`), any "size-weighted" phrasing about future v1
(rename to size-aware distances only if the sentence stays honest —
judgment call, log it).

1. **Lean** (`lean/Adic/Weighted.lean`, `Entropy.lean`, `Gibbs.lean`,
   plus imports in `Adic.lean` and any other references — grep):
   rename `Weighted.lean` → `Distance.lean`; `weightedCost` →
   `distCost`; `Weights` → `Dists` (or your cleaner judgment, log
   it); theorem names, binders, and docstrings follow. Semantics
   must be UNTOUCHED — this is a pure rename; no statement may
   change strength.
2. **Receipts**: update `expo/receipts-manifest.txt` to the new
   names, regenerate `receipts.json` (`lake exe receipts`, exit 0,
   synchronous). Statement hashes will move.
3. **Expo 2**: `git mv expo/02-weighted-heads.typ
   expo/02-heads-at-a-distance.typ`; title "Heads at a distance";
   prose reworked to the new vocabulary (Kraft framing: "only so
   much fits nearby"); every `leanthm(name, pin:)` updated to the
   new receipt name + new pin — and for EACH re-pin, record in your
   LOG the old and new formal statement side by side so the
   orchestrator can re-read them at merge (AIP-4 discipline: a pin
   is set after a human reads the statement; your re-pin is
   provisional). `git rm` the old PDF, compile and commit the new
   one (PDFs stay in repo).
4. **Other live docs**: `expo/01-the-dyadic-machine.typ`,
   `expo/README.md`, root `README.md`, `aips/draft/cache-v0.md`,
   `aips/draft/roadmap.md`, `aips/deferred/paper.md` — apply the
   rename where it means this parameter. Do NOT touch
   `docs/convo.md`, `docs/convo-summary.md`, `letters/` (historical
   source material and dated letters stay as written), `.dev/LOG.md`
   history, or old spec files in `.dev/specs/`.
5. **Gate** (synchronous receipts in LOG): `lake build` (zero sorry;
   `#print axioms` on the renamed theorems shows core axioms only),
   `lake exe receipts` exit 0, `lake exe sim` still passes, every
   `expo/*.typ` and `letters/*.typ` compiles with `typst compile`.

## Out of scope

Any semantic change to Lean statements; the letters→expo
reformulation; dynamic/adaptive distances; executing anything from
Expo 3 (cocycle). Commit on the track branch only; do not touch main.
