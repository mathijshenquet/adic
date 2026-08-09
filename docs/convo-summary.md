# Dependently typed language over idealized computation models

## Kernidee

The proposed language has a dependently typed abstract layer above an intensional, machine-compilable concrete layer.
Concrete memory is a dyadic binary tree: `block_n` has `2^n` bits, and an aligned region is a subtree addressed by a bit path.
Path depth supplies the cost model, making random access logarithmic and streaming traversal cheap by construction.

Infinite abstract data is represented by uniform filtered families of finite concrete objects, through Ind-completion; coinductive data arises dually from limits.
The grade at which an element appears is its concrete representation size, so “size is log n” is structural rather than postulated.

The concrete core is a first-order linear capability calculus presented by a small signature `G`.
It separates duplicable register values from linear ownership capabilities, making locality and framing consequences of the symmetric monoidal structure.
The abstract layer contains dependent specifications, decode maps, invariants, and proofs, initially in Lean.

Correctness is “soundness by initiality plus adequacy”: interpret the finite generators and relations in a machine model, obtain the unique functor from the free model, and transport results through realizers/decode maps.
The first target is an idealized capability machine or toy ISA, not LLVM; LLVM is a later lax big-O model because UB, optimization, and physical costs obstruct exact semantics.

The intended user experience is ordinary direct-style code with optional complexity claims.
The frontend infers ownership, grades, layouts, and cursor placement; failed automation becomes Lean-level mathematical goals or program-shaped schedule witnesses, not raw categorical syntax.

## Verloop

- [0]–[3]: Recursive bit blocks, encodings of abstract data, and high-/low-level equivalence motivate the project. The discussion finds the extensional-collapse problem and requires restricted, costed morphisms; graded infinite data must be uniform to avoid non-uniform circuit families.

- [4]–[7]: The compilation architecture is fixed conceptually: finite presentation `G`, initial concrete model, and a target machine model. Machine code is further seen as a costed, partial, test-extended monoid action, with typed refinements and footprints derived above it.

- [8]–[13]: Allocation becomes a nominal capability machine over a forest of dyadic blocks. Opaque capabilities make framing intrinsic; finite antichains represent ranges. The conversation specifies `G`, its sorts, generators, laws, grade recursion, extensional equality, and cost filtration.

- [14]–[21]: A doubling vector tests the design. Its correctness comes from cofinality and List initiality; a focused cursor representation gives locality-sensitive traversal. Locality makes evaluation order significant, leading to CBPV and amortization-as-normalization.

- [22]–[35]: Splay trees and union-find test pointers and amortization. Arena indices reveal the real cost of pointer chasing and the loss of structural framing. Time credits, credited views, and a four-stratum automation/proof pipeline are developed; tagged capability slots recover structural ownership for root-down forests.

- [36]–[43]: Shared immutable state introduces duplicable read capabilities, permanent `freeze`, and write-once slots for lazy memoization. A path-copying red-black tree tests persistence. The language is positioned against Rust, and NLL is recast as a frontend elaboration pass.

- [44]–[51]: The concrete type theory and Lean architecture are made practical. Grades remain decidable indices, full value dependency stays in Lean, HOAS is rejected for the trusted core, and reflective free-SMC normalization is proposed. Stratum-4 UX must expose source-level math or schedules.

- [52]–[59]: Zip confirms that streaming is provably linear without an eviction model. Cursor pressure evolves from a register-file analogy into weighted cursors constrained by the Kraft inequality. The final question—whether zip’s wider write head deserves more weight—is unanswered [72]–[73].

## Beslissingen

- [1]: Concrete morphisms are restricted, intensional programs with costs; arbitrary finite-set functions would erase the machine model.

- [3]: Use uniform Ind-style graded families for infinite inductive data; a grade-indexed map must have a finite, uniform description.

- [5]: Keep `G` small and first-order, while obtaining dependent types from assemblies/presheaves over the concrete core; this avoids proving initiality for an entire new DTT.

- [5]: Verify a toy capability ISA first and treat real compilation as a lax, big-O-preserving interpretation; LLVM is unsuitable as the foundational model.

- [7]: Model the machine ground floor as a cost-graded, partial, test-extended monoid action with footprint-respecting refinements.

- [9]: Use opaque, unforgeable capabilities and a nominal forest machine for v1; authority, framing, and allocation equivariance follow from capability possession.

- [9]: Use never-reuse/bump allocation initially; reuse and revocation are deferred.

- [11]: Represent general regions as finite antichains of dyadic subtrees, quotienting a parent with the union of its children; this keeps range borrowing and disjointness syntactic.

- [11]: Use power-of-two-padded single-path layouts as the default realizer, but permit antichain/packed layouts; layout is a coding-map choice, not an abstract-type property.

- [11]: Start with lexically scoped borrows that linearly return their capability; NLL, shared borrowing, and fractional permissions are layers above it.

- [13]: Set `block_0 = bit`; use word-bounded, duplicable `val_n` and linear `own_n` capabilities.

- [13]: Separate extensional equality `≡` from cost witness `@`; extensionally equal implementations can have different costs.

- [13]: Use grade expressions built from `0`, `1`, `+`, and doubling, with uniform grade recursion. The v1 concrete core is total.

- [15]: Treat `Vec` as an Ind-object, not an initial object. Geometric capacity growth is extensionally correct by cofinality and cheap by telescoping copy cost.

- [17]: Make locality primitive through first-class linear zipper cursors rather than direct path reads/writes; tree-distance cost remains compositional.

- [17]: Use CBPV/explicit computation sequencing where locality-sensitive costs make order semantically relevant.

- [21]: Prove oblivious amortized bounds by normalizing a composite to a cheap representative, not by assigning every operation a cheaper worst-case cost.

- [23]: Add linear time credits/potential judgments for bounds that transfer cost across operations. Relative cost theorems need a separate relational logic and are out of scope.

- [25], [33]: Use four checking strata: AARA-style inference, richer templates, decidable annotated checking, then interactive Lean obligations. Failure should produce a precise goal, not rejection.

- [29]: Permit visible addresses only through a linear mount-table authority in v1; ambient C-style dereference would destroy syntactic framing.

- [31]: Add tagged linear capability slots (`swap_cap`) for ownership pointers in memory. They recover structural framing for descent-only forests, not graphs or sharing.

- [35]: Represent arena/predicate-level amortization with credited views `(capability, invariant, potential)`; union-find’s Ackermann mathematics is intentionally a stratum-4 case.

- [37]: Add duplicable read capabilities `rd`, permanent `freeze`, and write-once slots. Do not support unrestricted `rd -> own`; defer fractional permissions.

- [41], [43]: Treat NLL lifetimes as elaboration into lexical core borrows; certificates record the split/join placements.

- [43]–[45]: Build an ordinary surface language that elaborates to the core. Cursor placement is automatic, cost claims are optional, and checked claims refer to inspectable elaborated code.

- [45]: Use Lean as the ambient proof system and deep-embed the intensional concrete core. The frontend is untrusted but emits a certificate for a small checker.

- [47]–[49]: Keep trusted terms as intrinsically typed point-free free-SMC combinators, not HOAS. Named linear do-syntax is frontend notation; coherence is handled by normalization/reflection.

- [51]: Surface unresolved intensional-cost work as schedule/witness requests—traversal order, cursor parking, or fusion—not as raw `≡` goals.

- [55], [57]: Model cursor pressure as fast-state allocation with weighted cursors satisfying a Kraft/antichain capacity constraint, rather than a recursively accessed cursor tree.

## Open vragen

- What exact toy ISA, operational semantics, and adequacy/cost theorem should realize `G`? [5], [13]

- Must `join` guarantee physical adjacency, or is adjacency entirely a property of the selected realizer? [13]

- How should operations that are partial at each grade but total in the colimit be expressed: flags, focused states, effects, or richer sums? [15]

- How much temporal locality should be modeled? Cursors capture spatial locality and streaming, but not eviction, capacity reuse, thrashing, or ideal-cache cliffs. [17], [52], [57]

- How do credited views compose with linearity and the cost filtration, especially for global predicate-level invariants such as union-find? [25], [35]

- Can cursor-itinerary, memory-law, recursion, and free-SMC normalizers be made sufficiently practical and reflective? [13], [49]

- Which grade language permits useful recurrences and size inference while preserving decidable checking? `n·2^n`, logarithms, and multivariate constraints are immediate pressure points. [25], [43], [45]

- How should visible pointers behave across growth, movement, unmounting, and dangling references? The provisional v1 story invalidates stored pointers on grow. [29]

- How should shared, cyclic, upward-linked, or otherwise non-tree structures be verified when logical shape diverges from ownership shape? [31], [35]

- Can persistence and amortization be unified beyond write-once lazy memoization, and how should concurrent forcing/ownership transfer work? [37]

- Which deferred features are required for v1: fractional permissions, general recursion/partiality, traits, interior mutability, reuse/revocation, destruction, or concurrency? [13], [37], [41]

- What is the correct size-weighted Kraft accounting for cursor state, and should zip’s write head receive more fast-state weight because it writes twice the data? [57], [72]

## Volgende stappen

- Specify the v1 `G`: sorts, generators, relations, grade constraints, cost table, and nominal-forest toy machine, so the finite soundness check is explicit. [5], [13]

- Mechanize a minimal Lean slice—grades, `val`, `own`, split/join/read/write, equality, cost, FVec push, and its decode square—before adding cursors or advanced effects. [45], [47]

- Prototype reflective free-SMC normalization on a tiny pure fragment; this measures the main mechanization and proof-ergonomics risk. [49]

- Prove or refute the straight-line/cursor-itinerary normal-form theorem, which underwrites both optimization and amortization-as-normalization. [13], [17]

- Use FVec, streaming zip, quicksort or mergesort, and matrix transpose/layout as discriminating examples for the elaborator and locality model. [17], [43], [52]

- Add the cost pipeline incrementally: decidable annotated checking, then AARA/template automation, then explicit Lean holes. [25], [33]

- Build the surface elaborator only after the core stabilizes: NLL-style borrow placement, grade inference, layout selection, cursor coalescing, and certificate checking. [43], [45]

- Return to time credits and credited views with union-find; it is the decisive predicate-level potential and stratum-4 UX test. [35]

- Add `rd`, `freeze`, and write-once slots after the mutable core, then test a path-copying red-black tree and a scheduled/real-time queue. [37]

- Resolve weighted cursor accounting, including the write-head weighting question, before claiming fast-state or entropy theorems. [57], [72]
