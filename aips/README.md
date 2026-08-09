# AIPs — adic improvement proposals

Process adopted 2026-08-09 (Mathijs), copied from composix's CIP process
(`~/composix/cips/README.md`).

## Process

- **Drafts** live in `aips/draft/<name>.md` — name only, no number.
  Anyone (usually the orchestrator) writes one when a design question
  surfaces; the author points Mathijs at the file (path, or URL once a
  remote exists).
- **Adoption** is Mathijs's call. On adoption the file moves to
  `aips/accepted/<NNNN>-<name>.md`. Numbering starts at **AIP-1**
  (filename `0001-<name>.md`); there is no predecessor sequence.
- **Amendments**: while adic is v0, landed AIPs may be amended in
  place. Every amendment appends a dated line to the AIP's Changelog
  section. Post-1.0, amendments become new AIPs that supersede.
- **`draft/` is a strict inbox for Mathijs**: it holds only items
  awaiting his read or decision. Everything decided moves out:
  rejected/superseded drafts to `aips/rejected/` with
  `Status: rejected (<why>)` or `superseded` (refusals are records),
  and deliberately-parked items to `aips/deferred/` (Mathijs wants
  them later, not now).

## Template

Four chapters (per Mathijs's format), plus one on adoption:

1. **The problem** — from zero context, concise.
2. **Prior work** — may be thicker.
3. **Recommendation**.
4. **Open questions** — each one answerable with a short taste call.
5. **Decision** (added at adoption) — what was decided, including the
   open-question answers, plus the Changelog.

## The founding conversation

`docs/convo.md` is the imported claude.ai design conversation
("Dependently typed language over idealized computation models",
2026-08; `docs/convo-summary.md` is a summary). AIPs cite it as
`convo [n]` by message index. It is source material, not authority —
decisions bind only once landed as an AIP.
