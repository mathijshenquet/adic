# The dirty model: open questions (design inbox)

Draft (2026-08-10, Claude). Status: *direction endorsed* by Mathijs
(2026-08-10: the cocycles stay categorically clean and even yield
cohomology links — "heel mooi"); pricing details remain his call at
cache-v0 call 2. Sources: Expo 3 (cocycle framing + three badge
claims), cache-v0 §4b (dirty-up refinement; candidate in-machine
resolution of [72]).

Open questions, roughly ordered from mechanizable-now to design:

1. **The badge worklist** (Expo 3, ready once pricing is fixed):
   cost-as-functor on the action category with a finite
   generator × local-observation table; the free-up representative
   identity $2 \cdot \mathrm{cost}_{\mathrm{free}} =
   \mathrm{cost}_{\mathrm{sym}} + \delta\Phi$; the sparse–dense
   write asymmetry; the nontriviality conjecture (no $h +
   \delta\Phi$ decomposition — *bandwidth cannot be statically
   priced*), witness: $m$ isolated writes at $\Theta(m n)$ vs one
   dense $2^k$-block at $\Theta(2^k)$.
2. **ℕ-coefficients.** Coboundaries subtract; our costs live in ℕ.
   Expo 3's identity dodges this by the doubled form. What is the
   honest framework — cocycles valued in a preordered monoid,
   cohomologous-up-to-ℕ-combinations? Lean will force the choice;
   choosing well IS part of the design.
3. **Classify the local classes.** Cost tables read one local
   observation (a dirty bit per node). Which finite local tables
   give nontrivial classes? Is write-back *the* generator of the
   local $H^1$, or do others exist (warmth counters, generation
   tags)? "The cohomology of the machine" as a standalone object.
4. **Two trees, one cost.** Do dirty bits live only on the data
   tree, or also on fast state — evicting a *dirty mount*? Sharper:
   is the $1+d$ head surcharge itself the pullback of a data-tree
   cocycle along the mounting? A yes would unify B4's distance
   layer with the dirty layer into one cocycle story.
5. **Gauge choice for open runs.** Cohomology classes agree on
   closed walks; open runs differ by the boundary term. Is the
   canonical representative the *flush-inclusive* price
   $\mathrm{cost} + \delta(\text{dirty-count})$ — charge the dirty
   residue at the end — or the lazy one? This is cache-v0 §4b's
   commit reading and the operational face of [72].
6. **Interaction with level prices $c(\ell) \ne 1$.** Write-back
   under Euclidean pricing is bandwidth scaling in dimension $k$;
   the sparse/dense exponents shift accordingly. Folklore anchors:
   SSD/flash *write amplification* and the random-vs-sequential
   write gap are exactly dirty coalescing observed in the wild.
7. **Does the RAM correspondence survive?** Reverse simulation is
   ≤ 5·T under the clean model — does dirty pricing preserve a
   constant factor, or is the gap real (and then: is that the
   honest statement)?
8. **Write entropy.** Is there a Kraft/entropy theory for write
   streams — the write-side twin of the entropy theorem — and how
   does it meet the k-way cliff (phase 3)?
