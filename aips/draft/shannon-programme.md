# The Shannon programme: what the entropy theorem opens

Draft (2026-08-10, Claude, from a design conversation with Mathijs).
Status: roadmap material — no decisions taken, ordering suggested at
the end. Terminology follows the weight→distance rename (LOG
2026-08-10 eve; execution in flight on `track/distance-rename`).

## 1. The identification, made exact

Expo 2's entropy pair is not *like* Shannon's noiseless coding
theorem — it *is* that theorem, in machine clothing:

| coding theory                    | machine                            |
| -------------------------------- | ---------------------------------- |
| symbol                           | head                               |
| codeword length $\ell_i$         | distance $d_i$ (mount depth)       |
| Kraft $\sum 2^{-\ell_i} \le 1$   | a mounting exists (antichain)      |
| codebook                         | mounting                           |
| message                          | access sequence                    |
| Shannon–Fano $\lceil \log 1/p_i \rceil$ | achievability distances (receipt) |
| source-coding converse           | Gibbs lower bound (receipt)        |

The achievability assignment $d_i = \lceil \log 1/\hat p_i \rceil$
is literally the Shannon–Fano code of 1948. (Huffman would be the
exact integer optimum — gain strictly less than one level; worth a
one-line remark in Expo 2, not a target.)

Shannon's paper continues past this point in a famously deliberate
order. Each of his next moves has a machine analogue, and together
they read as a chapter order for the paper.

## 2. Which space does the machine live in? (the "distance" objection)

Objection (Mathijs): *distance* only reads honestly if you accept
exponentially much room at radius $d$ — no Euclidean space has
$2^d$ slots within distance $d$. Correct — and that space has a
name.

- **Unit level prices ($c \equiv 1$, the v0 model): hyperbolic
  geometry.** Exponential ball growth is *the* signature of
  hyperbolic space, and trees are its discrete archetype
  (0-hyperbolic in Gromov's sense). Kraft is the packing law of
  that geometry — "only so much fits nearby" is a true isoperimetric
  statement there, and the entropy theorem is native to it.
  Distance-as-depth is an *informational* metric: cost = address
  bits, the logarithm of any physical distance.
- **Level prices choose the geometry.** Price level crossings
  $c(\ell) = 2^{\ell/k}$ and the travel to depth $n$ telescopes to
  $\Theta(2^{n/k}) = \Theta(N^{1/k})$ for $N = 2^n$ leaves —
  polynomial ball growth $r^k$, i.e. $k$-dimensional Euclidean
  geometry. cache-v0 §2's stated variant $\alpha = 1/2$ (random
  access $\Theta(\sqrt N)$) is exactly $k = 2$: the mesh/VLSI
  metric, wire distance on a chip (Thompson's model); $k = 3$
  gives the $N^{1/3}$ of physical volume.
- So the price schedule is a **choice of ambient geometry**: v0
  prices the intrinsic information geometry (hyperbolic, cost =
  bits); physical machines live at $k = 2, 3$. "Distance" is the
  honest word in every case — only the volume-vs-radius law
  changes, and the machine states which law it plays under.
- **Verified with corrections (campbell-renyi report, 2026-08-10;
  see `aips/draft/campbell-renyi.md`):** under exponential prices
  $c(\ell) = 2^{t\ell}$ the *Rényi order claim survives*:
  $\alpha = 1/(1+t)$, with the optimal mount shares the escort
  distribution $r_i = p_i^\alpha / Z_\alpha$. Two repairs to the
  original slogan: the optimal distances are
  $d_i^* = \log_2 Z_\alpha - \alpha \log_2 p_i$ — the escort
  offset $\log_2 Z_\alpha$ is what makes Kraft tight, not
  optional — and the optimal *value* is affine in
  $2^{t H_\alpha}$ (Campbell's functional is the normalized log of
  the exponential moment, not raw travel). Kraft itself is
  untouched. For the 2D chip ($t = 1/2$): $\alpha = 2/3$. The
  dictionary extends: **level prices ↦ Rényi order**; Shannon
  entropy is the $c \equiv 1$ fiber. Also repaired there: at
  $c(\ell) = 2^\ell$ ($s = 1$) random access matches the tape but
  streaming does NOT (the dyadic sweep pays $\Theta(N \log N)$) —
  the tape identification holds for access, not for sweeps. The
  report carries the discrete/ℕ formulation (rational $t = a/b$
  via macro-levels), a six-rung Lean ladder (hard rung:
  denominator-cleared natural Hölder), and an honest *negative*
  verdict on the WBE metabolic rhyme (shallow — see its §8).

### Folklore anchors: how storage cost scales with size (2026-08-10)

Collected on Mathijs's question — the empirical/folklore scaling
laws the geometry section should be able to absorb or predict:

- **On-chip SRAM**: access time of a memory array grows like the
  square root of its area (decode + wordline/bitline flight; the
  wire-delay lore of Ho–Mai–Horowitz, and CACTI-style models) —
  $k = 2$, measured.
- **The hierarchy slope**: back-of-envelope L1→DRAM: capacity
  $\times \sim 10^6$, latency $\times \sim 10^2$ — log-log slope
  $\approx 0.3$–$0.5$, i.e. an *empirical ambient dimension
  between 2 and 3* (2D dies, 3D-ish packaging). Turned around:
  measuring the latency/capacity slope of a real machine estimates
  its dimension $s$ in the $c(\ell) = 2^{\ell/s}$ dial. This joins
  the empirical berry as a concrete measurement.
- **Rent's rule**: terminals vs gates $T = t\,g^p$ with empirical
  $p \approx 0.5$–$0.75$; wire-length models tie $p$ to layout
  dimension via $p = 1 - 1/d$. Rent's exponent is boundary/
  bisection scaling of real circuits — the hardware twin of the
  boundary spike (how much addressing crosses a subtree cut).
- **The physical endpoint (decorative)**: the Bekenstein/
  holographic bound says maximal storage in a region scales with
  boundary *area*, not volume — the ultimate storage law is the
  $k = 2$ variant. Area law, not volume law, at the bottom of
  physics.
- **The metabolic rhyme (desk — possibly numerology until
  derived)**: Kleiber's law $B \propto M^{3/4}$; West–Brown–
  Enquist derive the quarter powers from *optimal space-filling
  hierarchical supply trees* with invariant terminal units — an
  object structurally ours (a tree serving a $d$-volume under a
  budget). Their exponent shape $d/(d+1)$ at $d = 3$ coincides
  with our Rényi order $k/(k+1)$ at $k = 3$; both drop out of
  Lagrange over geometric tree levels. The mammal heartbeat
  invariant ($\sim 10^9$ per life, rate $\propto M^{-1/4}$ ×
  lifespan $\propto M^{1/4}$) is the amortized form. RESOLVED
  NEGATIVE (campbell-renyi report §8, 2026-08-10): the WBE
  optimization is not a Campbell problem after a change of
  variables — the exponent coincidence is shallow. Kept here as a
  closed question so it is not re-opened by accident.
- **Fractal dial**: $c(\ell) = 2^{\ell/s}$ realizes ball growth
  $r^s$ for any real $s > 0$ — non-integer $s$ is an honest
  fractal ambient dimension, $s \to \infty$ recovers the
  hyperbolic/informational case. Dimension is a continuous model
  parameter, and the folklore above estimates where real hardware
  sits on the dial.
- **Write-side folklore** (for the dirty model, see
  `aips/accepted/0005-dirty-cocycle.md`): SSD/flash write amplification and the
  random-vs-sequential write gap are dirty coalescing observed in
  the wild — the sparse–dense asymmetry is their theorem-shaped
  form.

## 3. Move 1 — sources with memory (entropy rate; the dynamic frontier)

Shannon's immediate next step: real sources are not i.i.d.; the
true compressibility is the entropy *rate*, below the marginal
entropy, the gap being predictability from context (Markov sources,
AEP/typical sequences).

Machine analogue: access sequences have locality and phases; static
mounting only reaches $n(1 + H(\hat p))$ — the marginal. The
machinery for beating it is already mechanized: re-mounting =
reset + re-select (target 3 canonicalization). Candidate theorem
(block adaptivity): re-mounting per block on a sequence with block
empirical entropies $H_j$ costs
$\sum_j n_j(1 + H_j) + O(\text{re-mount})$, which beats global $H$
whenever the source is nonstationary. This is precisely the
static→dynamic optimality trajectory of the BST literature
(Bent–Sleator–Tarjan → splay); the AEP analogue says almost every
sequence of a stationary ergodic access process costs
$\approx n(1 + H_{\text{rate}})$.

## 4. Move 2 — universal mounting (the post-Shannon lineage)

Shannon assumed known statistics; the field's next leap achieved
entropy *without* them (Lempel–Ziv, universal coding; for trees:
splay's static-optimality theorem). Machine analogue, the most
adic-native of the four: an **online re-mounting rule** (move-to-
front-style promotion in the fast-state tree) competitive with the
best static mounting in hindsight. cache-v0's promotion rules are
embryonically this — the machine's LZ. Candidate: online rule with
cost $\le c \cdot \text{OPT}_{\text{static}} + O(\cdot)$.

## 5. Move 3 — the machine is a unit-capacity channel

Shannon Part I defines noiseless capacity
$C = \lim \log N(T) / T$ — distinguishable signals per unit time.
For the machine, free-up (AIP-2 amendment) makes cost = address
bits acquired, so a cost budget $T$ reaches at most $2^T$ distinct
addresses: $N(T) = 2^T$, i.e. **$C = 1$ exactly — by
normalization, not by theorem.** Free-up was secretly the choice
to measure cost in channel bits.

Reading: *addressing is communication.* Touching head $i$
transmits its identity into the tree — the $d_i$-step walk is the
codeword being sent, the mounting is the codebook. Shannon's
fundamental ratio (max symbol rate = $C/H$) becomes: accesses per
unit cost $\to 1/(1 + H)$ — the mechanized entropy theorem *is*
the $C/H$ identity at $C = 1$, the $+1$ being per-symbol overhead
(the touch itself; a start bit). Separation-theorem reading:
program = source (statistics), geometry = channel (prices),
mounting = the code at their interface — "cost of an algorithm =
entropy of its access stream" is a separation statement.

On the *noisy* coding theorem: demoted after discussion (Mathijs
2026-08-10, "misschien is er niet echt iets op het noisy coding
theorem") — see §7 for the dividing line. The candidates all
dissolve on inspection: destination uncertainty is the *source*
(already the $H$; adaptively revealed destinations — pointer
chasing — are feedback/interaction, a different theory); hardware
faults would be a genuine BSC import (reliable addressing at
$n/(1 - H(\varepsilon))$) but a model variant we don't need;
contention between heads is real and coming (cache-v1 dynamic
mounting) but is *adversarial*, and its home theory is competitive
analysis (move 2), not capacity. The write-back cocycle's rhyme
with channels-with-memory (state breaks single-letter pricing) is
structural but generates no theorem here — the real theorem is the
cohomology nontriviality itself, which stands without Shannon.
A rhyme, not a target.

## 6. Move 4 — rate–distortion (bounded near-space)

Shannon's Part V: fidelity criteria. Machine analogue: Kraft is a
hard capacity, and once the fast-state tree has bounded depth you
cannot give everyone $d_i = \log 1/p_i$; minimum average travel
under a nearby-slots budget is a rate–distortion function, and
eviction is lossy compression of the working set. This is where
cache-v0 was already heading; the k-way cliff is plausibly the
distortion threshold in that picture.

## 7. The dividing line (the programme's honest thesis)

Sharpened in discussion (Mathijs 2026-08-10): the analogy is exact
on one half of information theory and decorative on the other, and
the line is principled.

- **The combinatorial / individual-sequence half transfers** —
  because it is not an analogy: codewords and mount-paths are the
  *same object* (prefix-free sets in the binary tree), and the
  theorems are counting statements. Our entropy pair is the
  individual-sequence form (empirical frequencies, no probability
  measure) — which is exactly why it mechanizes over ℕ with no
  measure theory. Moves 1, 2, 4 and §2's Campbell/Rényi live here.
- **The probabilistic half does not** — the noisy coding theorem's
  content is reliability against *exogenous* randomness via random
  block codes, and the deterministic machine has none. Adding
  randomness would be a modeling choice, not a discovery. Move 3
  survives only as the $C = 1$ normalization remark.

So the programme, honestly stated: **mechanize the combinatorial
half of information theory** — individual-sequence information
theory over the dyadic machine. This predicts which future imports
work: entropy rate on blocks, LZ/universal coding, the counting
side of rate–distortion — yes; capacity, random coding — no.

## 8. Suggested order

1. Move 1 (block-adaptive re-mounting = entropy rate): natural next
   theorem, building blocks mechanized.
2. Move 2 (universal mounting): most machine-native; feeds cache-v0
   directly.
3. Move 3's identity ($C = 1$, accesses per cost $= 1/(1+H)$): a
   free paragraph for Expo 2 / the paper — no new mechanization.
4. §2's geometry (level prices ↦ Rényi order): with cache-v0 v1
   ($c(\ell) \ne 1$).
