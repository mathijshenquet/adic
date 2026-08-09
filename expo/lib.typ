// expo/lib.typ — shared machinery for adic expositions (AIP-4).
//
// Three claim levels, visually distinct:
//   #leanthm(..)   green  — machine-checked, receipt from receipts.json
//   #deskthm(..)   amber  — desk-proved, not yet mechanized
//   #openclaim(..) grey   — unformalized / conjectural
//
// leanthm asserts the receipt exists and (when pinned) that the Lean
// statement's hash still matches the pin; a changed statement fails
// the compile until a human re-reads and re-pins (AIP-4 §3).

#let accent-lean = rgb("#1a7f5a")
#let accent-desk = rgb("#b7791f")
#let accent-open = rgb("#7a7a7a")

#let _badge(color, label) = box(
  fill: color.lighten(90%),
  stroke: 0.5pt + color,
  inset: (x: 5pt, y: 2.5pt),
  radius: 2pt,
  text(size: 7.2pt, fill: color.darken(25%), raw(label)),
)

#let _claimblock(color, badge, title, body, receipt: none) = block(
  stroke: (left: 2.5pt + color),
  fill: color.lighten(97%),
  inset: (x: 10pt, y: 8pt),
  width: 100%,
  above: 1.1em, below: 1.1em,
  {
    _badge(color, badge)
    if title != none { h(7pt); text(weight: "bold", title) }
    v(5pt)
    body
    if receipt != none {
      v(5pt)
      block(
        fill: white.darken(3%),
        stroke: 0.4pt + color.lighten(50%),
        inset: 6pt, radius: 2pt, width: 100%,
        {
          set text(size: 8pt)
          receipt
        },
      )
    }
  },
)

// Machine-checked theorem. `name` must exist in receipts.json (built
// by `lake exe receipts`); `pin` is the statement hash from that
// file, copied in by the author after reading the formal statement.
#let leanthm(name, pin: none, title: none, receipts: auto, body) = {
  let data = if receipts == auto { json("receipts.json") } else { receipts }
  let entry = data.find(e => e.name == name)
  assert(
    entry != none,
    message: "no Lean receipt for '" + name + "' — regenerate receipts.json or fix the name",
  )
  if pin != none {
    assert(
      entry.hash == pin,
      message: "statement pin mismatch for '" + name + "': Lean now states something else (current hash " + entry.hash + "). Re-read the formal statement, update the prose if needed, then re-pin.",
    )
  }
  _claimblock(
    accent-lean,
    "LEAN ⊢ " + name,
    title,
    body,
    receipt: {
      raw(entry.statement, lang: "lean", block: true)
      text(size: 7.2pt, fill: accent-lean.darken(20%), raw("axioms: " + entry.axioms.join(", ") + "   hash: " + entry.hash))
    },
  )
}

// Desk-proved: argued on paper, not mechanized. Honest amber.
#let deskthm(title: none, body) = _claimblock(
  accent-desk, "DESK-PROVED — not mechanized", title, body,
)

// Unformalized: stated, believed, unbacked. Honest grey.
#let openclaim(title: none, body) = _claimblock(
  accent-open, "UNFORMALIZED", title, body,
)

// Ordinary running mathematics needs no box — prose and $math$ as
// usual. Boxes are for *claims the reader might want to audit*.

#let expo(number, title, date, body) = {
  set page(width: 168mm, height: auto, margin: (x: 18mm, y: 16mm))
  set text(size: 10.5pt)
  set par(justify: true)
  set heading(numbering: "1.1")
  align(right, emph[adic — Expo #number · #date])
  align(center, text(size: 15pt, weight: "bold", title))
  v(6pt)
  body
}
