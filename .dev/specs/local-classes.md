# Track: local-classes — classifying the local cocycle classes

**DORMANT** (Mathijs 2026-08-10, superseding his same-day
activation): wait until the cocycle theory has crystallized
(free-up landed, framework mechanized, padding argument written).
Spec stays ready to fire.

Worker: gpt-5.6-sol, herdr worktree, branch `track/local-classes`.
LOG.md at worktree root; first action: add it to `.git/info/exclude`,
verify with `git check-ignore LOG.md`. Append-only, timestamped.
Friction journal section as always.

**The out:** this is research — walls are expected. Anything
genuinely stuck > ~30 min: record the wall precisely (what you
tried, why it fails) and move to the next question. An honest
partial report is the deliverable, not a failure. Aim for a solid
first report over completeness; ~half-day horizon.

**CONTAINMENT (Mathijs, 2026-08-10, explicit):** this track's ONLY
outputs are `aips/draft/local-classes.md` + its PDF + your LOG. Do
not edit any other file — not the roadmap, not other AIPs, not
lean/. If your findings suggest re-prioritization, say so in a
closing section *of the report*; nowhere else. Lean experiments
are allowed as scratch but are not committed.

## Context (read first)

`aips/accepted/0005-dirty-cocycle.md` — especially §0 (background),
§1 (ℕ-coefficients: exchange form is the ratified framework), §2
(the commutativity/holonomy argument), §4 (this track's question,
verbatim). Expo 3 (`expo/03-cost-is-a-cocycle.typ`) for the
cocycle framing. AIP-2 §3 for the machine's instructions (note:
`up` is free by amendment).

## The question

Cost models on the machine are cocycles: functions
cost_c(w) with cost_c(w1·w2) = cost_c(w1) + cost_{c·w1}(w2).
The *finitely-presentable* ones are given by a table
T : generator × local observation → ℕ. Classify these up to
(homomorphism + coboundary), in exchange form (0005 §1B): which
tables are genuinely state-dependent — not absorbable into a
word-only price plus a potential? Is write-back the *only*
nontrivial local class (up to the obvious monoid operations), or
are there others?

## Deliverable: `aips/draft/local-classes.md`

1. **Fix the observation language precisely** (this is design work
   and part of the deliverable — the classification is *relative*
   to it, and 0005 §4 warns the answer changes with it). Suggested
   frame: a node carries a finite marking updated by a fixed local
   automaton on visit events (fill / write-below / leave); the
   table may read the current node's marking. Dirtiness is the
   1-bit instance. State your choice and its knobs explicitly.
2. **Worked examples, each with a verdict + desk proof:**
   - *first-touch pricing* (pay only on a node's first-ever visit —
     cold misses): expected TRIVIAL — candidate potential: count of
     untouched nodes. Work it out; it is the calibration case.
   - *write-back / dirty bit*: expected NONTRIVIAL — adapt 0005
     §2's padding/holonomy argument to your framework.
   - *visit-parity bit* (pay on every second visit): verdict?
   - *warmth/recency* (free if visited since parent's last fill):
     verdict?
   - at least one candidate of your own choosing.
3. **The general statement**, as far as it honestly goes: a
   criterion for triviality of a table (e.g. "trivial iff its
   closed-walk holonomy is a linear function of letter counts",
   made precise), and whatever structure of the class monoid you
   can prove or must leave conjectured. Useful facts on the table:
   B(ℕ,+) is commutative, so homomorphisms see only letter counts
   (0005 §2); the configuration graph is strongly connected (writes
   can restore any store), so potentials are determined up to
   constant by closed-walk-vanishing differences — argue carefully
   what this gives you in the directed (non-invertible) setting.
4. **PDF**: render per the AGENTS.md recipe (pandoc + typst,
   `\text{…}` not `\mathrm{…}`) and commit both.

## Gate

`typst compile` of all expos still passes (you touched nothing —
verify anyway), the PDF renders, and the report's every claim
carries an honest label: proved / desk-proved / conjectured /
wall. Commit on the track branch only.
