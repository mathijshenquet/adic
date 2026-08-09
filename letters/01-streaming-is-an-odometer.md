# Letter 1 — Streaming is an odometer

Beste Mathijs,

Today we named the machine, and I want to put on paper the small
discovery that fell out of the naming argument, because I think it
is the first genuinely *pretty* fact this project owns — and because
the way it appeared says something about how the whole project wants
to be worked.

You asked whether p-adic is even the right kind of limit for us —
inverse or direct? The honest answer turned out to be "neither, and
that is the point." The tower {ℤ/2ⁿ} carries both limits: the direct
limit along the zero-padding inclusions is ℕ — every element finite,
appearing at its grade, which is exactly our discipline for
inductive data — and the inverse limit along the projections is ℤ₂,
the 2-adic integers, which is where codata and the "read one digit
at a time" topology live. adic refuses to take either limit; we
work with the diagram itself. The machine is the same refusal made
physical: D_n *is* the tower, never its completion. If someone asks
what kind of object the dyadic machine is, the sharpest answer I
have is: a pro-object we deliberately never complete.

Now the pretty fact. While checking whether "adic machine" would
collide with existing names, I ran into Vershik's adic
transformations — the ergodic-theory family generalizing the
odometer, the "adding machine" acting on ℤ₂ by +1 with carries. My
first reading was: soft collision, avoid the name. The second
reading was better: it is not a collision, it is *kinship*, because
our streaming theorem is literally an odometer statement. Number the
leaves of D_n in left-to-right tree order (paths read MSB-first).
Moving a head from leaf i to leaf i+1 costs the walk up to their
lowest common ancestor and back down, which is 2·(1 + v₂(i+1)) —
the tree distance is governed by how far the carry propagates when
you increment i. Summing over a full scan,

    Σ_{i<2ⁿ} (1 + v₂(i))  telescopes to  ≈ 2·2ⁿ,

which is the ≤ 4·2ⁿ Euler bound: amortized O(1) per leaf. In other
words: theorem target 1, the fact that streaming is cheap on our
machine, is the fact that the odometer performs amortized O(1)
carries. The 2-adic valuation is not decoration on the cost model;
it *is* the cost model, seen from the address side. (The boundary
spike — leaves 2ᵏ−1 and 2ᵏ costing 2k to cross — is the odometer's
long carry, and pages and cache lines have the same spike for the
same reason.)

This settled the naming question for me. The machine is the *dyadic*
machine — descriptive, unclaimed, and p = 2 is the only
non-arbitrary base, the same refusal as bits-not-words — while the
2-adic kinship goes where it belongs: into theorems, where it can be
checked, rather than into the name, where it could only be vibes.
"adic" stays the name of the discipline, and it honestly covers both
limits of the tower.

One seam this exposed, so it doesn't get lost: the convo chose
little-endian numeral layout (so that grade embeddings commute with
arithmetic and successor is one uniform program), while the odometer
analysis above lives in the MSB-first *numbering* of leaves. These
are two different layers — what we call a leaf, versus how a number
lies down on leaves — and they compose without conflict, but only
because we now say so explicitly (AIP-2 §4.7). I flag it because it
is exactly the kind of convention that, left implicit, costs a week
somewhere in chapter 4.

A last thought on method. The theorem-shaped machine design — your
"build the machine so the theorems become easy" — worked faster than
I expected: within the day, the movement core and both first
theorems were mechanized, and the streaming statement went through
in its strong form (the exact left-to-right visit list, not just a
length bound). I take this as early evidence for the roadmap's bet
that the trunk is cheap and the berries are real. The next letter
will probably be about zip, where the write head first has to earn
its weight — the question you left open at [72], and the seam where
the alloc-less machine touches the machine with allocation that you
pointed at as pleasingly close to real hardware.

Met vriendelijke groet,
Claude
