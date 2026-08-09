# Letters: the paper's precursor genre

## 1. The problem

The paper must ultimately be written by Mathijs — that is essential
to what it is (decided 2026-08-09). But the theory-building happens
in dialogue with Claude, and that thinking needs a durable home that
is none of the existing ones: not the paper (Mathijs's voice, the
record), not the AIPs (decisions, not arguments), not chat (which
evaporates).

## 2. Prior work

- The Grothendieck–Serre correspondence — the canonical case of a
  mathematics growing up inside letters before its book form; apt
  for a project already running on Grothendieck's own tools
  (Ind/Pro-completions, profinite structure).
- Bell Labs technical memoranda — Shannon's own precursor genre for
  the exact paper this project's paper is benchmarked against.
- MIT AI Memos — the same genre in computing.

## 3. Decision

- `letters/` at the repo root: Claude-authored letters addressed to
  Mathijs. Numbered, cited as "Letter 1"; one file per letter,
  `letters/NN-slug.typ` — **Typst** (Mathijs, 2026-08-09: letters
  are already pieces of formalized prose mathematics, precursor
  chunks of the paper, so they get real typesetting; each letter
  must `typst compile` — part of the gate). English by default (the
  repo's language; the live conversation is Dutch — letters are its
  distillate). Compiled PDFs are gitignored.
- Register: a letter argues, proposes, and is allowed to be wrong
  out loud. It is never the record. AIPs stay the decision record;
  the paper stays the theory record.
- Lifecycle: the paper cannibalizes letters freely. Letters are
  never edited for consistency after absorption — they are
  correspondence, not documentation. Corrections happen in later
  letters.
- Replies: Mathijs replies in chat, in the margins, or — if he
  likes — with letters of his own in the same directory.

## 3b. Disposition: superseded by expositions (2026-08-09, same day)

AIP-4 (expositions) largely replaces letters as the precursor
vehicle: readable mathematics belongs in `expo/` with receipt
badges; Letters 1–2 get reformulated as expos. `letters/` remains
as an immutable correspondence archive, and the genre stays
available for genuinely personal correspondence — but the default
home for precursor mathematics is now an exposition.

## 4. Disposition of the paper draft (2026-08-09)

With this AIP accepted, the paper AIP draft defers (moved to
`aips/deferred/paper.md`): its calls (Typst vs LaTeX, title,
skeleton timing) become relevant only when Mathijs starts writing.
Until then the intended chapter structure is carried by the letters
— see the prospective index in `letters/README.md`. `typst compile`
joins the gate when `paper/` exists, as already recorded.
