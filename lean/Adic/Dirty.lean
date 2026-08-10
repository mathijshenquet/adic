import Adic.Cocycle
import Adic.Machine

namespace Adic.Dyadic.Dirty

abbrev Word := List LocalOp

/-- A reachable one-head dirty observer state. Paths and marks are stored
focus-first; the root has no mark. Under `Fill = Leave = clean`, nodes outside
the active path are necessarily clean and need no runtime storage. -/
structure Config (n : Nat) where
  path : List Bool
  marks : List Bool
  deriving DecidableEq, Repr

abbrev DirtyConfig := Config

def root (n : Nat) : Config n := ⟨[], []⟩

def step (operation : LocalOp) (config : Config n) : Option (Config n) :=
  match operation with
  | .up =>
      match config.path, config.marks with
      | _ :: path, _ :: marks => some ⟨path, marks⟩
      | _, _ => none
  | .down0 =>
      if config.path.length < n then some ⟨false :: config.path, false :: config.marks⟩
      else none
  | .down1 =>
      if config.path.length < n then some ⟨true :: config.path, false :: config.marks⟩
      else none
  | .read =>
      if config.path.length = n then some config else none
  | .write0 =>
      if config.path.length = n then some ⟨config.path, config.marks.map fun _ => true⟩
      else none
  | .write1 =>
      if config.path.length = n then some ⟨config.path, config.marks.map fun _ => true⟩
      else none

def run : Word → Config n → Option (Config n)
  | [], config => some config
  | operation :: word, config => do
      let next ← step operation config
      run word next

def dirtyCharge (operation : LocalOp) (config : Config n) : Nat :=
  operation.cost +
    match operation, config.marks with
    | .up, true :: _ => 1
    | _, _ => 0

def dirtyCost : Word → Config n → Nat
  | [], _ => 0
  | operation :: word, config =>
      match step operation config with
      | none => 0
      | some next => dirtyCharge operation config + dirtyCost word next

def cleanCost (word : Word) : Nat :=
  (word.map LocalOp.cost).sum

@[simp] theorem cleanCost_nil : cleanCost [] = 0 := rfl

@[simp] theorem cleanCost_cons (operation : LocalOp) (word : Word) :
    cleanCost (operation :: word) = operation.cost + cleanCost word := rfl

@[simp] theorem cleanCost_append (first second : Word) :
    cleanCost (first ++ second) = cleanCost first + cleanCost second := by
  simp [cleanCost]

theorem run_append (first second : Word) (config : Config n) :
    run (first ++ second) config = (do
      let middle ← run first config
      run second middle) := by
  induction first generalizing config with
  | nil => rfl
  | cons operation first ih =>
      simp only [List.cons_append, run]
      cases hstep : step operation config <;> simp [ih]

theorem dirtyCost_append (first second : Word) (config middle : Config n)
    (hfirst : run first config = some middle) :
    dirtyCost (first ++ second) config =
      dirtyCost first config + dirtyCost second middle := by
  induction first generalizing config with
  | nil =>
      simp only [run] at hfirst
      cases hfirst
      simp [dirtyCost]
  | cons operation first ih =>
      simp only [run] at hfirst
      cases hstep : step operation config with
      | none => simp [hstep] at hfirst
      | some next =>
          simp only [hstep] at hfirst
          simp [dirtyCost, hstep, ih next hfirst, Nat.add_assoc]

/-- The state-parametric form of `Adic.Dyadic.IsCocycle`. -/
def IsCocycle (f : Word → Config n → Nat) : Prop :=
  (∀ config, f [] config = 0) ∧
    ∀ first second config middle,
      run first config = some middle →
      f (first ++ second) config = f first config + f second middle

theorem dirtyCost_isCocycle : IsCocycle (dirtyCost (n := n)) := by
  constructor
  · intro config
    rfl
  · exact dirtyCost_append

def downCount (word : Word) : Nat :=
  word.count .down0 + word.count .down1

theorem dirtyCharge_step_bound (operation : LocalOp) (config next : Config n)
    (hstep : step operation config = some next) :
    dirtyCharge operation config + next.marks.length ≤
      2 * operation.cost + config.marks.length := by
  cases operation <;> rcases config with ⟨path, marks⟩
  · cases path <;> cases marks <;> simp [step] at hstep
    rename_i bit path mark marks
    cases hstep
    cases mark <;> simp [dirtyCharge, LocalOp.cost] <;> omega
  · by_cases h : path.length < n <;>
      simp [step, h, dirtyCharge, LocalOp.cost] at hstep ⊢
    cases hstep
    change 1 + (false :: marks).length ≤ 2 + marks.length
    simp only [List.length_cons]
    omega
  · by_cases h : path.length < n <;>
      simp [step, h, dirtyCharge, LocalOp.cost] at hstep ⊢
    cases hstep
    change 1 + (false :: marks).length ≤ 2 + marks.length
    simp only [List.length_cons]
    omega
  · by_cases h : path.length = n <;>
      simp [step, h, dirtyCharge, LocalOp.cost] at hstep ⊢
    cases hstep
    simp
  · by_cases h : path.length = n <;>
      simp [step, h, dirtyCharge, LocalOp.cost] at hstep ⊢
    cases hstep
    simp
  · by_cases h : path.length = n <;>
      simp [step, h, dirtyCharge, LocalOp.cost] at hstep ⊢
    cases hstep
    simp

/-- Honest open-run bound: initial active depth is the unavoidable slack. -/
theorem dirtyCost_le_two_cleanCost_add_slack (word : Word) (config final : Config n)
    (hrun : run word config = some final) :
    dirtyCost word config ≤ 2 * cleanCost word + config.marks.length := by
  induction word generalizing config with
  | nil => simp [dirtyCost]
  | cons operation word ih =>
      simp only [run] at hrun
      cases hstep : step operation config with
      | none => simp [hstep] at hrun
      | some next =>
          simp only [hstep] at hrun
          have htail := ih next hrun
          have hlocal := dirtyCharge_step_bound operation config next hstep
          simp only [dirtyCost, hstep, cleanCost_cons]
          omega

theorem dirtyCost_le_two_cleanCost (word : Word) (final : Config n)
    (hrun : run word (root n) = some final) :
    dirtyCost word (root n) ≤ 2 * cleanCost word := by
  simpa [root] using dirtyCost_le_two_cleanCost_add_slack word (root n) final hrun

structure Prices where
  up : Nat
  down0 : Nat
  down1 : Nat
  read : Nat
  write0 : Nat
  write1 : Nat

def Prices.at (prices : Prices) : LocalOp → Nat
  | .up => prices.up
  | .down0 => prices.down0
  | .down1 => prices.down1
  | .read => prices.read
  | .write0 => prices.write0
  | .write1 => prices.write1

def letterCost (prices : Prices) (word : Word) (_ : Config n) : Nat :=
  (word.map prices.at).sum

/-- The state-parametric form of `Adic.Dyadic.Exchange`. -/
def Exchange (f g : Word → Config n → Nat) (potential : Config n → Nat) : Prop :=
  ∀ word config final,
    run word config = some final →
    f word config + potential config = g word config + potential final

theorem letterCost_counts (prices : Prices) (word : Word) (config : Config n) :
    letterCost prices word config =
      word.count .up * prices.up +
      word.count .down0 * prices.down0 +
      word.count .down1 * prices.down1 +
      word.count .read * prices.read +
      word.count .write0 * prices.write0 +
      word.count .write1 * prices.write1 := by
  induction word with
  | nil => simp [letterCost]
  | cons operation word ih =>
      change prices.at operation + letterCost prices word config = _
      rw [ih]
      cases operation <;> simp [Prices.at, Nat.add_mul] <;> omega

theorem letterCost_eq_of_counts (prices : Prices) (first second : Word)
    (hcounts : ∀ operation, first.count operation = second.count operation)
    (config₁ config₂ : Config n) :
    letterCost prices first config₁ = letterCost prices second config₂ := by
  rw [letterCost_counts, letterCost_counts]
  simp only [hcounts]

def downs0 (count : Nat) : Word := List.replicate count .down0

def downs1 (count : Nat) : Word := List.replicate count .down1

def ups (count : Nat) : Word := List.replicate count .up

def descended0 (n : Nat) : Config n :=
  ⟨List.replicate n false, List.replicate n false⟩

def dirtyDescended0 (n : Nat) : Config n :=
  ⟨List.replicate n false, List.replicate n true⟩

private theorem replicate_append_cons (count : Nat) (value : α) (tail : List α) :
    List.replicate count value ++ value :: tail =
      List.replicate (count + 1) value ++ tail := by
  induction count with
  | zero => rfl
  | succ count ih =>
      change value :: (List.replicate count value ++ value :: tail) =
        value :: (List.replicate (count + 1) value ++ tail)
      exact congrArg (List.cons value) ih

theorem run_downs0 (count : Nat) (path marks : List Bool)
    (hbound : path.length + count ≤ n) :
    run (downs0 count) (⟨path, marks⟩ : Config n) =
      some ⟨List.replicate count false ++ path,
        List.replicate count false ++ marks⟩ := by
  induction count generalizing path marks with
  | zero => simp [downs0, run]
  | succ count ih =>
      rw [show downs0 (count + 1) = .down0 :: downs0 count by
        simp [downs0, List.replicate_succ]]
      have hlt : path.length < n := by omega
      simp [run, step, hlt]
      rw [ih (false :: path) (false :: marks)]
      · simp only [replicate_append_cons]
      · simp only [List.length_cons]
        omega

theorem dirtyCost_downs0 (count : Nat) (path marks : List Bool)
    (hbound : path.length + count ≤ n) :
    dirtyCost (downs0 count) (⟨path, marks⟩ : Config n) = count := by
  induction count generalizing path marks with
  | zero => simp [downs0, dirtyCost]
  | succ count ih =>
      rw [show downs0 (count + 1) = .down0 :: downs0 count by
        simp [downs0, List.replicate_succ]]
      have hlt : path.length < n := by omega
      simp only [dirtyCost, step, hlt, ↓reduceIte, dirtyCharge, LocalOp.cost]
      rw [ih (false :: path) (false :: marks)]
      · omega
      · simp only [List.length_cons]
        omega

theorem run_ups (count : Nat) (path marks : List Bool) (pathBit mark : Bool) :
    run (ups count)
        (⟨List.replicate count pathBit ++ path,
          List.replicate count mark ++ marks⟩ : Config n) =
      some ⟨path, marks⟩ := by
  induction count with
  | zero => simp [ups, run]
  | succ count ih =>
      rw [show ups (count + 1) = .up :: ups count by
        simp [ups, List.replicate_succ]]
      simp only [List.replicate_succ, List.cons_append, run, step]
      simp
      exact ih

theorem dirtyCost_ups_clean (count : Nat) (path marks : List Bool) (pathBit : Bool) :
    dirtyCost (ups count)
        (⟨List.replicate count pathBit ++ path,
          List.replicate count false ++ marks⟩ : Config n) = 0 := by
  induction count with
  | zero => simp [ups, dirtyCost]
  | succ count ih =>
      rw [show ups (count + 1) = .up :: ups count by
        simp [ups, List.replicate_succ]]
      simp only [List.replicate_succ, List.cons_append, dirtyCost, step,
        dirtyCharge, LocalOp.cost, Nat.zero_add]
      exact ih

theorem dirtyCost_ups_dirty (count : Nat) (path marks : List Bool) (pathBit : Bool) :
    dirtyCost (ups count)
        (⟨List.replicate count pathBit ++ path,
          List.replicate count true ++ marks⟩ : Config n) = count := by
  induction count with
  | zero => simp [ups, dirtyCost]
  | succ count ih =>
      rw [show ups (count + 1) = .up :: ups count by
        simp [ups, List.replicate_succ]]
      simp only [List.replicate_succ, List.cons_append, dirtyCost, step,
        dirtyCharge, LocalOp.cost]
      rw [ih]
      omega

theorem run_write_clean (operation : LocalOp)
    (hwrite : operation = .write0 ∨ operation = .write1) :
    run [operation] (descended0 n) = some (dirtyDescended0 n) := by
  rcases hwrite with rfl | rfl <;>
    simp [run, step, descended0, dirtyDescended0]

theorem run_write_dirty (operation : LocalOp)
    (hwrite : operation = .write0 ∨ operation = .write1) :
    run [operation] (dirtyDescended0 n) = some (dirtyDescended0 n) := by
  rcases hwrite with rfl | rfl <;>
    simp [run, step, dirtyDescended0]

theorem dirtyCost_write_clean (operation : LocalOp)
    (hwrite : operation = .write0 ∨ operation = .write1) :
    dirtyCost [operation] (descended0 n) = 1 := by
  rcases hwrite with rfl | rfl <;>
    simp [dirtyCost, step, dirtyCharge, LocalOp.cost, descended0]

theorem dirtyCost_write_dirty (operation : LocalOp)
    (hwrite : operation = .write0 ∨ operation = .write1) :
    dirtyCost [operation] (dirtyDescended0 n) = 1 := by
  rcases hwrite with rfl | rfl <;>
    simp [dirtyCost, step, dirtyCharge, LocalOp.cost, dirtyDescended0]

def shortA (n : Nat) : Word :=
  downs0 n ++ (ups n ++ (downs0 n ++ [.write0, .write0]))

def shortB (n : Nat) : Word :=
  downs0 n ++ ([.write0] ++ (ups n ++ (downs0 n ++ [.write0])))

@[simp] theorem run_downs0_root (n : Nat) :
    run (downs0 n) (root n) = some (descended0 n) := by
  simpa [root, descended0] using
    run_downs0 (n := n) n ([] : List Bool) ([] : List Bool) (by simp)

@[simp] theorem dirtyCost_downs0_root (n : Nat) :
    dirtyCost (downs0 n) (root n) = n := by
  simpa [root] using
    dirtyCost_downs0 (n := n) n ([] : List Bool) ([] : List Bool) (by simp)

@[simp] theorem run_ups_descended0 (n : Nat) :
    run (ups n) (descended0 n) = some (root n) := by
  simpa [root, descended0] using
    run_ups (n := n) n ([] : List Bool) ([] : List Bool) false false

@[simp] theorem run_ups_dirtyDescended0 (n : Nat) :
    run (ups n) (dirtyDescended0 n) = some (root n) := by
  simpa [root, dirtyDescended0] using
    run_ups (n := n) n ([] : List Bool) ([] : List Bool) false true

@[simp] theorem dirtyCost_ups_descended0 (n : Nat) :
    dirtyCost (ups n) (descended0 n) = 0 := by
  simpa [descended0] using
    dirtyCost_ups_clean (n := n) n ([] : List Bool) ([] : List Bool) false

@[simp] theorem dirtyCost_ups_dirtyDescended0 (n : Nat) :
    dirtyCost (ups n) (dirtyDescended0 n) = n := by
  simpa [dirtyDescended0] using
    dirtyCost_ups_dirty (n := n) n ([] : List Bool) ([] : List Bool) false

theorem run_two_write0 (n : Nat) :
    run [.write0, .write0] (descended0 n) = some (dirtyDescended0 n) := by
  change run ([.write0] ++ [.write0]) (descended0 n) = some (dirtyDescended0 n)
  rw [run_append, run_write_clean .write0 (Or.inl rfl)]
  exact run_write_dirty .write0 (Or.inl rfl)

theorem dirtyCost_two_write0 (n : Nat) :
    dirtyCost [.write0, .write0] (descended0 n) = 2 := by
  change dirtyCost ([.write0] ++ [.write0]) (descended0 n) = 2
  rw [dirtyCost_append [.write0] [.write0] (descended0 n) (dirtyDescended0 n)
    (run_write_clean .write0 (Or.inl rfl))]
  rw [dirtyCost_write_clean .write0 (Or.inl rfl),
    dirtyCost_write_dirty .write0 (Or.inl rfl)]

theorem run_shortA (n : Nat) :
    run (shortA n) (root n) = some (dirtyDescended0 n) := by
  unfold shortA
  rw [run_append, run_downs0_root]
  simp
  rw [run_append, run_ups_descended0]
  simp
  rw [run_append, run_downs0_root]
  exact run_two_write0 n

theorem run_shortB (n : Nat) :
    run (shortB n) (root n) = some (dirtyDescended0 n) := by
  unfold shortB
  rw [run_append, run_downs0_root]
  simp
  change run ([.write0] ++ (ups n ++ (downs0 n ++ [.write0]))) (descended0 n) =
    some (dirtyDescended0 n)
  rw [run_append, run_write_clean .write0 (Or.inl rfl)]
  simp
  rw [run_append, run_ups_dirtyDescended0]
  simp
  rw [run_append, run_downs0_root]
  exact run_write_clean .write0 (Or.inl rfl)

theorem dirtyCost_shortA (n : Nat) :
    dirtyCost (shortA n) (root n) = 2 * n + 2 := by
  unfold shortA
  rw [dirtyCost_append (downs0 n) _ (root n) (descended0 n) (run_downs0_root n)]
  rw [dirtyCost_append (ups n) _ (descended0 n) (root n) (run_ups_descended0 n)]
  rw [dirtyCost_append (downs0 n) _ (root n) (descended0 n) (run_downs0_root n)]
  rw [dirtyCost_two_write0]
  simp only [dirtyCost_downs0_root, dirtyCost_ups_descended0]
  omega

theorem dirtyCost_shortB (n : Nat) :
    dirtyCost (shortB n) (root n) = 3 * n + 2 := by
  unfold shortB
  rw [dirtyCost_append (downs0 n) _ (root n) (descended0 n) (run_downs0_root n)]
  rw [dirtyCost_append [.write0] _ (descended0 n) (dirtyDescended0 n)
    (run_write_clean .write0 (Or.inl rfl))]
  rw [dirtyCost_append (ups n) _ (dirtyDescended0 n) (root n)
    (run_ups_dirtyDescended0 n)]
  rw [dirtyCost_append (downs0 n) _ (root n) (descended0 n) (run_downs0_root n)]
  simp only [dirtyCost_downs0_root, dirtyCost_ups_dirtyDescended0]
  rw [dirtyCost_write_clean .write0 (Or.inl rfl)]
  omega

theorem short_letter_counts (n : Nat) (operation : LocalOp) :
    (shortA n).count operation = (shortB n).count operation := by
  cases operation <;> simp [shortA, shortB, downs0, ups] <;> omega

def descended1 (n : Nat) : Config n :=
  ⟨List.replicate n true, List.replicate n false⟩

def dirtyDescended1 (n : Nat) : Config n :=
  ⟨List.replicate n true, List.replicate n true⟩

theorem run_downs1 (count : Nat) (path marks : List Bool)
    (hbound : path.length + count ≤ n) :
    run (downs1 count) (⟨path, marks⟩ : Config n) =
      some ⟨List.replicate count true ++ path,
        List.replicate count false ++ marks⟩ := by
  induction count generalizing path marks with
  | zero => simp [downs1, run]
  | succ count ih =>
      rw [show downs1 (count + 1) = .down1 :: downs1 count by
        simp [downs1, List.replicate_succ]]
      have hlt : path.length < n := by omega
      simp [run, step, hlt]
      rw [ih (true :: path) (false :: marks)]
      · simp only [replicate_append_cons]
      · simp only [List.length_cons]
        omega

theorem dirtyCost_downs1 (count : Nat) (path marks : List Bool)
    (hbound : path.length + count ≤ n) :
    dirtyCost (downs1 count) (⟨path, marks⟩ : Config n) = count := by
  induction count generalizing path marks with
  | zero => simp [downs1, dirtyCost]
  | succ count ih =>
      rw [show downs1 (count + 1) = .down1 :: downs1 count by
        simp [downs1, List.replicate_succ]]
      have hlt : path.length < n := by omega
      simp only [dirtyCost, step, hlt, ↓reduceIte, dirtyCharge, LocalOp.cost]
      rw [ih (true :: path) (false :: marks)]
      · omega
      · simp only [List.length_cons]
        omega

@[simp] theorem run_downs1_root (n : Nat) :
    run (downs1 n) (root n) = some (descended1 n) := by
  simpa [root, descended1] using
    run_downs1 (n := n) n ([] : List Bool) ([] : List Bool) (by simp)

@[simp] theorem dirtyCost_downs1_root (n : Nat) :
    dirtyCost (downs1 n) (root n) = n := by
  simpa [root] using
    dirtyCost_downs1 (n := n) n ([] : List Bool) ([] : List Bool) (by simp)

theorem run_write_clean1 (operation : LocalOp)
    (hwrite : operation = .write0 ∨ operation = .write1) :
    run [operation] (descended1 n) = some (dirtyDescended1 n) := by
  rcases hwrite with rfl | rfl <;>
    simp [run, step, descended1, dirtyDescended1]

theorem dirtyCost_write_clean1 (operation : LocalOp)
    (hwrite : operation = .write0 ∨ operation = .write1) :
    dirtyCost [operation] (descended1 n) = 1 := by
  rcases hwrite with rfl | rfl <;>
    simp [dirtyCost, step, dirtyCharge, LocalOp.cost, descended1]

@[simp] theorem run_ups_dirtyDescended1 (n : Nat) :
    run (ups n) (dirtyDescended1 n) = some (root n) := by
  simpa [root, dirtyDescended1] using
    run_ups (n := n) n ([] : List Bool) ([] : List Bool) true true

@[simp] theorem dirtyCost_ups_dirtyDescended1 (n : Nat) :
    dirtyCost (ups n) (dirtyDescended1 n) = n := by
  simpa [dirtyDescended1] using
    dirtyCost_ups_dirty (n := n) n ([] : List Bool) ([] : List Bool) true

def isolatedTrip0 (n : Nat) (write : LocalOp) : Word :=
  downs0 n ++ ([write] ++ ups n)

def isolatedTrip1 (n : Nat) (write : LocalOp) : Word :=
  downs1 n ++ ([write] ++ ups n)

theorem run_isolatedTrip0 (n : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    run (isolatedTrip0 n write) (root n) = some (root n) := by
  unfold isolatedTrip0
  rw [run_append, run_downs0_root]
  simp
  change run ([write] ++ ups n) (descended0 n) = some (root n)
  rw [run_append, run_write_clean write hwrite]
  exact run_ups_dirtyDescended0 n

theorem run_isolatedTrip1 (n : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    run (isolatedTrip1 n write) (root n) = some (root n) := by
  unfold isolatedTrip1
  rw [run_append, run_downs1_root]
  simp
  change run ([write] ++ ups n) (descended1 n) = some (root n)
  rw [run_append, run_write_clean1 write hwrite]
  exact run_ups_dirtyDescended1 n

theorem dirtyCost_isolatedTrip0 (n : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    dirtyCost (isolatedTrip0 n write) (root n) = 2 * n + 1 := by
  unfold isolatedTrip0
  rw [dirtyCost_append (downs0 n) _ (root n) (descended0 n) (run_downs0_root n)]
  rw [dirtyCost_append [write] _ (descended0 n) (dirtyDescended0 n)
    (run_write_clean write hwrite)]
  rw [dirtyCost_downs0_root, dirtyCost_write_clean write hwrite,
    dirtyCost_ups_dirtyDescended0]
  omega

theorem dirtyCost_isolatedTrip1 (n : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    dirtyCost (isolatedTrip1 n write) (root n) = 2 * n + 1 := by
  unfold isolatedTrip1
  rw [dirtyCost_append (downs1 n) _ (root n) (descended1 n) (run_downs1_root n)]
  rw [dirtyCost_append [write] _ (descended1 n) (dirtyDescended1 n)
    (run_write_clean1 write hwrite)]
  rw [dirtyCost_downs1_root, dirtyCost_write_clean1 write hwrite,
    dirtyCost_ups_dirtyDescended1]
  omega

def repeatWord : Nat → Word → Word
  | 0, _ => []
  | count + 1, word => word ++ repeatWord count word

theorem run_repeatWord_closed (count : Nat) (word : Word) (config : Config n)
    (hclosed : run word config = some config) :
    run (repeatWord count word) config = some config := by
  induction count with
  | zero => rfl
  | succ count ih =>
      simp only [repeatWord, run_append, hclosed]
      simpa using ih

theorem dirtyCost_repeatWord_closed (count : Nat) (word : Word) (config : Config n)
    (hclosed : run word config = some config) :
    dirtyCost (repeatWord count word) config = count * dirtyCost word config := by
  induction count with
  | zero => simp [repeatWord, dirtyCost]
  | succ count ih =>
      rw [repeatWord, dirtyCost_append word _ config config hclosed, ih]
      rw [Nat.add_mul]
      simp
      ac_rfl

theorem count_repeatWord (count : Nat) (word : Word) (operation : LocalOp) :
    (repeatWord count word).count operation = count * word.count operation := by
  induction count with
  | zero => simp [repeatWord]
  | succ count ih =>
      rw [repeatWord, List.count_append, ih, Nat.add_mul]
      simp
      ac_rfl

def blockLeaves (k : Nat) : Nat := 2 ^ (k + 1)

def sparsePass (n k : Nat) (write : LocalOp) : Word :=
  repeatWord (2 ^ k) (isolatedTrip0 n write) ++
    repeatWord (2 ^ k) (isolatedTrip1 n write)

def sparseWalk (n k : Nat) : Word :=
  sparsePass n k .write1 ++ sparsePass n k .write0

theorem run_sparsePass (n k : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    run (sparsePass n k write) (root n) = some (root n) := by
  unfold sparsePass
  rw [run_append]
  have htrip0 := run_isolatedTrip0 n write hwrite
  have htrip1 := run_isolatedTrip1 n write hwrite
  rw [run_repeatWord_closed _ _ _ htrip0]
  exact run_repeatWord_closed _ _ _ htrip1

theorem run_sparseWalk (n k : Nat) :
    run (sparseWalk n k) (root n) = some (root n) := by
  unfold sparseWalk
  rw [run_append, run_sparsePass n k .write1 (Or.inr rfl)]
  exact run_sparsePass n k .write0 (Or.inl rfl)

theorem dirtyCost_sparsePass (n k : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    dirtyCost (sparsePass n k write) (root n) =
      blockLeaves k * (2 * n + 1) := by
  unfold sparsePass
  have htrip0 := run_isolatedTrip0 n write hwrite
  rw [dirtyCost_append _ _ _ _
    (run_repeatWord_closed (2 ^ k) _ _ htrip0)]
  rw [dirtyCost_repeatWord_closed _ _ _ htrip0,
    dirtyCost_isolatedTrip0 n write hwrite]
  have htrip1 := run_isolatedTrip1 n write hwrite
  rw [dirtyCost_repeatWord_closed _ _ _ htrip1,
    dirtyCost_isolatedTrip1 n write hwrite]
  unfold blockLeaves
  rw [Nat.pow_succ]
  calc
    2 ^ k * (2 * n + 1) + 2 ^ k * (2 * n + 1) =
        2 * (2 ^ k * (2 * n + 1)) := by omega
    _ = 2 ^ k * 2 * (2 * n + 1) := by ac_rfl

/-- `m = 2^(k+1)` isolated depth-`n` trips in each of the write and erase passes. -/
theorem dirtyCost_sparseWalk (n k : Nat) :
    dirtyCost (sparseWalk n k) (root n) =
      2 * blockLeaves k * (2 * n + 1) := by
  unfold sparseWalk
  rw [dirtyCost_append _ _ _ _ (run_sparsePass n k .write1 (Or.inr rfl)),
    dirtyCost_sparsePass n k .write1 (Or.inr rfl),
    dirtyCost_sparsePass n k .write0 (Or.inl rfl)]
  calc
    blockLeaves k * (2 * n + 1) + blockLeaves k * (2 * n + 1) =
        2 * (blockLeaves k * (2 * n + 1)) := by omega
    _ = 2 * blockLeaves k * (2 * n + 1) := by ac_rfl

theorem dirtyCost_sparseWalk_expanded (n k : Nat) :
    dirtyCost (sparseWalk n k) (root n) =
      4 * blockLeaves k * n + 2 * blockLeaves k := by
  rw [dirtyCost_sparseWalk, Nat.mul_add, Nat.mul_one]
  ac_rfl

theorem sparseWalk_count (n k : Nat) (operation : LocalOp) :
    (sparseWalk n k).count operation =
      match operation with
      | .up => 2 * blockLeaves k * n
      | .down0 => blockLeaves k * n
      | .down1 => blockLeaves k * n
      | .read => 0
      | .write0 => blockLeaves k
      | .write1 => blockLeaves k := by
  cases operation with
  | up =>
      simp [sparseWalk, sparsePass, count_repeatWord, isolatedTrip0, isolatedTrip1,
        downs0, downs1, ups, blockLeaves, Nat.pow_succ, List.count_replicate]
      calc
        2 ^ k * n + (2 ^ k * n + (2 ^ k * n + 2 ^ k * n)) =
            4 * (2 ^ k * n) := by omega
        _ = 2 * (2 ^ k * 2) * n := by
          rw [show (4 : Nat) = 2 * 2 by decide]
          ac_rfl
  | down0 =>
      simp [sparseWalk, sparsePass, count_repeatWord, isolatedTrip0, isolatedTrip1,
        downs0, downs1, ups, blockLeaves, Nat.pow_succ, List.count_replicate]
      calc
        2 ^ k * n + 2 ^ k * n = 2 * (2 ^ k * n) := by omega
        _ = 2 ^ k * 2 * n := by ac_rfl
  | down1 =>
      simp [sparseWalk, sparsePass, count_repeatWord, isolatedTrip0, isolatedTrip1,
        downs0, downs1, ups, blockLeaves, Nat.pow_succ, List.count_replicate]
      calc
        2 ^ k * n + 2 ^ k * n = 2 * (2 ^ k * n) := by omega
        _ = 2 ^ k * 2 * n := by ac_rfl
  | read =>
      simp [sparseWalk, sparsePass, count_repeatWord, isolatedTrip0, isolatedTrip1,
        downs0, downs1, ups, List.count_replicate]
  | write0 =>
      simp [sparseWalk, sparsePass, count_repeatWord, isolatedTrip0, isolatedTrip1,
        downs0, downs1, ups, blockLeaves, Nat.pow_succ, List.count_replicate]
      omega
  | write1 =>
      simp [sparseWalk, sparsePass, count_repeatWord, isolatedTrip0, isolatedTrip1,
        downs0, downs1, ups, blockLeaves, Nat.pow_succ, List.count_replicate]
      omega

def densePass : Nat → LocalOp → Word
  | 0, write => [write]
  | remaining + 1, write =>
      [.down0] ++ (densePass remaining write ++
        ([.up, .down1] ++ (densePass remaining write ++ [.up])))

theorem densePass_count_down0 (remaining : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    (densePass remaining write).count .down0 = 2 ^ remaining - 1 := by
  rcases hwrite with rfl | rfl <;> induction remaining with
  | zero => simp [densePass]
  | succ remaining ih =>
      simp [densePass, ih, Nat.pow_succ]
      have hp : 1 ≤ 2 ^ remaining := Nat.one_le_two_pow
      omega

theorem densePass_count_down1 (remaining : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    (densePass remaining write).count .down1 = 2 ^ remaining - 1 := by
  rcases hwrite with rfl | rfl <;> induction remaining with
  | zero => simp [densePass]
  | succ remaining ih =>
      simp [densePass, ih, Nat.pow_succ]
      have hp : 1 ≤ 2 ^ remaining := Nat.one_le_two_pow
      omega

theorem densePass_count_up (remaining : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    (densePass remaining write).count .up = 2 * (2 ^ remaining - 1) := by
  rcases hwrite with rfl | rfl <;> induction remaining with
  | zero => simp [densePass]
  | succ remaining ih =>
      simp [densePass, ih, Nat.pow_succ]
      have hp : 1 ≤ 2 ^ remaining := Nat.one_le_two_pow
      omega

theorem densePass_count_write_self (remaining : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    (densePass remaining write).count write = 2 ^ remaining := by
  rcases hwrite with rfl | rfl <;> induction remaining with
  | zero => simp [densePass]
  | succ remaining ih =>
      simp [densePass, ih, Nat.pow_succ]
      omega

theorem densePass_count_write_other (remaining : Nat) :
    (densePass remaining .write0).count .write1 = 0 ∧
      (densePass remaining .write1).count .write0 = 0 := by
  induction remaining with
  | zero => simp [densePass]
  | succ remaining ih => simp [densePass, ih]

theorem densePass_count_read (remaining : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    (densePass remaining write).count .read = 0 := by
  rcases hwrite with rfl | rfl <;> induction remaining with
  | zero => simp [densePass]
  | succ remaining ih => simp [densePass, ih]

theorem run_densePass (remaining : Nat) (path marks : List Bool) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1)
    (hdepth : path.length + remaining = n) :
    run (densePass remaining write) (⟨path, marks⟩ : Config n) =
      some ⟨path, marks.map fun _ => true⟩ := by
  induction remaining generalizing path marks with
  | zero =>
      have hp : path.length = n := by omega
      rcases hwrite with rfl | rfl <;>
        simp [densePass, run, step, hp]
  | succ remaining ih =>
      have hlt : path.length < n := by omega
      have hchild : (false :: path).length + remaining = n := by
        simp only [List.length_cons]
        omega
      have hleft := ih (false :: path) (false :: marks) hchild
      have hrightDepth : (true :: path).length + remaining = n := by
        simp only [List.length_cons]
        omega
      have hright := ih (true :: path) (false :: marks.map fun _ => true) hrightDepth
      simp only [densePass, run_append]
      have hdown : run [.down0] (⟨path, marks⟩ : Config n) =
          some ⟨false :: path, false :: marks⟩ := by
        simp [run, step, hlt]
      rw [hdown]
      simp
      rw [hleft]
      simp
      have hmiddle :
          run [.up, .down1]
              (⟨false :: path, true :: marks.map fun _ => true⟩ : Config n) =
            some ⟨true :: path, false :: marks.map fun _ => true⟩ := by
        simp [run, step, hlt]
      rw [hmiddle]
      simp
      rw [hright]
      simp [run, step, List.map_map]

def denseExact : Nat → Nat
  | 0 => 1
  | remaining + 1 => 2 * denseExact remaining + 4

theorem denseExact_closed (remaining : Nat) :
    denseExact remaining = 5 * 2 ^ remaining - 4 := by
  induction remaining with
  | zero => rfl
  | succ remaining ih =>
      rw [denseExact, ih, Nat.pow_succ]
      have hpow : 1 ≤ 2 ^ remaining := Nat.one_le_two_pow
      omega

theorem dirtyCost_densePass (remaining : Nat) (path marks : List Bool)
    (write : LocalOp) (hwrite : write = .write0 ∨ write = .write1)
    (hdepth : path.length + remaining = n) :
    dirtyCost (densePass remaining write) (⟨path, marks⟩ : Config n) =
      denseExact remaining := by
  induction remaining generalizing path marks with
  | zero =>
      have hp : path.length = n := by omega
      rcases hwrite with rfl | rfl <;>
        simp [densePass, dirtyCost, step, dirtyCharge, LocalOp.cost, hp, denseExact]
  | succ remaining ih =>
      have hlt : path.length < n := by omega
      have hchild : (false :: path).length + remaining = n := by
        simp only [List.length_cons]
        omega
      have hrightDepth : (true :: path).length + remaining = n := by
        simp only [List.length_cons]
        omega
      let left : Config n := ⟨false :: path, false :: marks⟩
      let leftDirty : Config n := ⟨false :: path, true :: marks.map fun _ => true⟩
      let afterLeft : Config n := ⟨path, marks.map fun _ => true⟩
      let right : Config n := ⟨true :: path, false :: marks.map fun _ => true⟩
      let rightDirty : Config n := ⟨true :: path, true :: marks.map fun _ => true⟩
      let final : Config n := ⟨path, marks.map fun _ => true⟩
      have hdown : run [.down0] (⟨path, marks⟩ : Config n) = some left := by
        simp [left, run, step, hlt]
      have hleft : run (densePass remaining write) left = some leftDirty := by
        simpa [left, leftDirty] using
          run_densePass remaining (false :: path) (false :: marks) write hwrite hchild
      have hmiddle : run [.up, .down1] leftDirty = some right := by
        simp [leftDirty, right, run, step, hlt]
      have hright : run (densePass remaining write) right = some rightDirty := by
        simpa [right, rightDirty, List.map_map] using
          run_densePass remaining (true :: path) (false :: marks.map fun _ => true)
            write hwrite hrightDepth
      have hup : run [.up] rightDirty = some final := by
        simp [rightDirty, final, run, step]
      have cdown : dirtyCost [.down0] (⟨path, marks⟩ : Config n) = 1 := by
        simp [dirtyCost, step, dirtyCharge, LocalOp.cost, hlt]
      have cmiddle : dirtyCost [.up, .down1] leftDirty = 2 := by
        simp [dirtyCost, step, dirtyCharge, LocalOp.cost, hlt, leftDirty]
      have cup : dirtyCost [.up] rightDirty = 1 := by
        simp [dirtyCost, step, dirtyCharge, LocalOp.cost, rightDirty]
      unfold densePass
      rw [dirtyCost_append [.down0] _ _ left hdown]
      rw [dirtyCost_append (densePass remaining write) _ left leftDirty hleft]
      rw [dirtyCost_append [.up, .down1] _ leftDirty right hmiddle]
      rw [dirtyCost_append (densePass remaining write) _ right rightDirty hright]
      rw [cdown, ih (false :: path) (false :: marks) hchild,
        cmiddle, ih (true :: path) (false :: marks.map fun _ => true) hrightDepth, cup]
      simp only [denseExact]
      omega

theorem dirtyCost_densePass_closed (remaining : Nat) (path marks : List Bool)
    (write : LocalOp) (hwrite : write = .write0 ∨ write = .write1)
    (hdepth : path.length + remaining = n) :
    dirtyCost (densePass remaining write) (⟨path, marks⟩ : Config n) =
      5 * 2 ^ remaining - 4 := by
  rw [dirtyCost_densePass remaining path marks write hwrite hdepth, denseExact_closed]

def blockDepth (k : Nat) : Nat := k + 1

def blockEntry (n k : Nat) : Config n :=
  ⟨List.replicate (n - blockDepth k) false,
    List.replicate (n - blockDepth k) false⟩

def dirtyBlockEntry (n k : Nat) : Config n :=
  ⟨List.replicate (n - blockDepth k) false,
    List.replicate (n - blockDepth k) true⟩

def blockPass (n k : Nat) (write : LocalOp) : Word :=
  downs0 (n - blockDepth k) ++
    (densePass (blockDepth k) write ++ ups (n - blockDepth k))

def denseWalk (n k : Nat) : Word :=
  blockPass n k .write1 ++ blockPass n k .write0

theorem blockPass_count_down0 (n k : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    (blockPass n k write).count .down0 =
      n - blockDepth k + (blockLeaves k - 1) := by
  unfold blockPass
  rw [List.count_append, List.count_append,
    densePass_count_down0 (blockDepth k) write hwrite]
  simp [downs0, ups, List.count_replicate, blockDepth, blockLeaves]

theorem blockPass_count_down1 (n k : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    (blockPass n k write).count .down1 = blockLeaves k - 1 := by
  unfold blockPass
  rw [List.count_append, List.count_append,
    densePass_count_down1 (blockDepth k) write hwrite]
  simp [downs0, ups, List.count_replicate, blockDepth, blockLeaves]

theorem blockPass_count_up (n k : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    (blockPass n k write).count .up =
      n - blockDepth k + 2 * (blockLeaves k - 1) := by
  unfold blockPass
  rw [List.count_append, List.count_append,
    densePass_count_up (blockDepth k) write hwrite]
  simp [downs0, ups, List.count_replicate, blockDepth, blockLeaves]
  omega

theorem blockPass_count_read (n k : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    (blockPass n k write).count .read = 0 := by
  unfold blockPass
  rw [List.count_append, List.count_append,
    densePass_count_read (blockDepth k) write hwrite]
  simp [downs0, ups, List.count_replicate]

theorem blockPass_count_write_self (n k : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) :
    (blockPass n k write).count write = blockLeaves k := by
  unfold blockPass
  rw [List.count_append, List.count_append,
    densePass_count_write_self (blockDepth k) write hwrite]
  rcases hwrite with rfl | rfl <;>
    simp [downs0, ups, List.count_replicate, blockDepth, blockLeaves]

theorem blockPass_count_write_other (n k : Nat) :
    (blockPass n k .write0).count .write1 = 0 ∧
      (blockPass n k .write1).count .write0 = 0 := by
  unfold blockPass
  have hother := densePass_count_write_other (blockDepth k)
  constructor
  · rw [List.count_append, List.count_append, hother.1]
    simp [downs0, ups, List.count_replicate]
  · rw [List.count_append, List.count_append, hother.2]
    simp [downs0, ups, List.count_replicate]

theorem denseWalk_count (n k : Nat) (operation : LocalOp) :
    (denseWalk n k).count operation =
      match operation with
      | .up => 2 * (n - blockDepth k + 2 * (blockLeaves k - 1))
      | .down0 => 2 * (n - blockDepth k + (blockLeaves k - 1))
      | .down1 => 2 * (blockLeaves k - 1)
      | .read => 0
      | .write0 => blockLeaves k
      | .write1 => blockLeaves k := by
  unfold denseWalk
  rw [List.count_append]
  cases operation with
  | up =>
      rw [blockPass_count_up n k .write1 (Or.inr rfl),
        blockPass_count_up n k .write0 (Or.inl rfl)]
      simp only
      omega
  | down0 =>
      rw [blockPass_count_down0 n k .write1 (Or.inr rfl),
        blockPass_count_down0 n k .write0 (Or.inl rfl)]
      simp only
      omega
  | down1 =>
      rw [blockPass_count_down1 n k .write1 (Or.inr rfl),
        blockPass_count_down1 n k .write0 (Or.inl rfl)]
      simp only
      omega
  | read =>
      rw [blockPass_count_read n k .write1 (Or.inr rfl),
        blockPass_count_read n k .write0 (Or.inl rfl)]
  | write0 =>
      rw [(blockPass_count_write_other n k).2,
        blockPass_count_write_self n k .write0 (Or.inl rfl)]
      simp
  | write1 =>
      rw [blockPass_count_write_self n k .write1 (Or.inr rfl),
        (blockPass_count_write_other n k).1]
      simp

theorem run_enterBlock (n k : Nat) (_hblock : blockDepth k ≤ n) :
    run (downs0 (n - blockDepth k)) (root n) = some (blockEntry n k) := by
  simpa [root, blockEntry] using
    run_downs0 (n := n) (n - blockDepth k) ([] : List Bool) ([] : List Bool)
      (by simp)

theorem dirtyCost_enterBlock (n k : Nat) (_hblock : blockDepth k ≤ n) :
    dirtyCost (downs0 (n - blockDepth k)) (root n) = n - blockDepth k := by
  simpa [root] using
    dirtyCost_downs0 (n := n) (n - blockDepth k) ([] : List Bool) ([] : List Bool)
      (by simp)

theorem run_denseBlock (n k : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) (hblock : blockDepth k ≤ n) :
    run (densePass (blockDepth k) write) (blockEntry n k) =
      some (dirtyBlockEntry n k) := by
  have hdepth : (n - blockDepth k) + blockDepth k = n := Nat.sub_add_cancel hblock
  simpa [blockEntry, dirtyBlockEntry] using
    run_densePass (n := n) (blockDepth k) (List.replicate (n - blockDepth k) false)
      (List.replicate (n - blockDepth k) false) write hwrite (by simpa using hdepth)

theorem dirtyCost_denseBlock (n k : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) (hblock : blockDepth k ≤ n) :
    dirtyCost (densePass (blockDepth k) write) (blockEntry n k) =
      denseExact (blockDepth k) := by
  have hdepth : (n - blockDepth k) + blockDepth k = n := Nat.sub_add_cancel hblock
  simpa [blockEntry] using
    dirtyCost_densePass (n := n) (blockDepth k)
      (List.replicate (n - blockDepth k) false)
      (List.replicate (n - blockDepth k) false) write hwrite (by simpa using hdepth)

theorem run_exitDirtyBlock (n k : Nat) :
    run (ups (n - blockDepth k)) (dirtyBlockEntry n k) = some (root n) := by
  simpa [dirtyBlockEntry, root] using
    run_ups (n := n) (n - blockDepth k) ([] : List Bool) ([] : List Bool) false true

theorem dirtyCost_exitDirtyBlock (n k : Nat) :
    dirtyCost (ups (n - blockDepth k)) (dirtyBlockEntry n k) =
      n - blockDepth k := by
  simpa [dirtyBlockEntry] using
    dirtyCost_ups_dirty (n := n) (n - blockDepth k)
      ([] : List Bool) ([] : List Bool) false

theorem run_blockPass (n k : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) (hblock : blockDepth k ≤ n) :
    run (blockPass n k write) (root n) = some (root n) := by
  unfold blockPass
  rw [run_append, run_enterBlock n k hblock]
  simp
  rw [run_append, run_denseBlock n k write hwrite hblock]
  exact run_exitDirtyBlock n k

theorem dirtyCost_blockPass (n k : Nat) (write : LocalOp)
    (hwrite : write = .write0 ∨ write = .write1) (hblock : blockDepth k ≤ n) :
    dirtyCost (blockPass n k write) (root n) =
      2 * (n - blockDepth k) + denseExact (blockDepth k) := by
  unfold blockPass
  rw [dirtyCost_append _ _ _ _ (run_enterBlock n k hblock)]
  rw [dirtyCost_append _ _ _ _ (run_denseBlock n k write hwrite hblock)]
  rw [dirtyCost_enterBlock n k hblock, dirtyCost_denseBlock n k write hwrite hblock,
    dirtyCost_exitDirtyBlock]
  omega

theorem run_denseWalk (n k : Nat) (hblock : blockDepth k ≤ n) :
    run (denseWalk n k) (root n) = some (root n) := by
  unfold denseWalk
  rw [run_append, run_blockPass n k .write1 (Or.inr rfl) hblock]
  exact run_blockPass n k .write0 (Or.inl rfl) hblock

/-- Two dense Euler sweeps: write the `m = 2^(k+1)` block, then erase it. -/
theorem dirtyCost_denseWalk (n k : Nat) (hblock : blockDepth k ≤ n) :
    dirtyCost (denseWalk n k) (root n) =
      2 * (2 * (n - blockDepth k) + denseExact (blockDepth k)) := by
  unfold denseWalk
  rw [dirtyCost_append _ _ _ _ (run_blockPass n k .write1 (Or.inr rfl) hblock),
    dirtyCost_blockPass n k .write1 (Or.inr rfl) hblock,
    dirtyCost_blockPass n k .write0 (Or.inl rfl) hblock]
  omega

theorem dirtyCost_denseWalk_expanded (n k : Nat) (hblock : blockDepth k ≤ n) :
    dirtyCost (denseWalk n k) (root n) =
      4 * (n - blockDepth k) + 10 * blockLeaves k - 8 := by
  rw [dirtyCost_denseWalk n k hblock, denseExact_closed]
  change 2 * (2 * (n - blockDepth k) + (5 * blockLeaves k - 4)) = _
  have hm : 1 ≤ blockLeaves k := by
    unfold blockLeaves
    exact Nat.one_le_two_pow
  omega

def down0Deficit (n k : Nat) : Nat :=
  blockLeaves k * n - 2 * (n - blockDepth k + (blockLeaves k - 1))

def down1Deficit (n k : Nat) : Nat :=
  blockLeaves k * n - 2 * (blockLeaves k - 1)

def padding (n k : Nat) : Word :=
  repeatWord (down0Deficit n k) [.down0, .up] ++
    repeatWord (down1Deficit n k) [.down1, .up]

def paddedDenseWalk (n k : Nat) : Word :=
  denseWalk n k ++ padding n k

theorem run_cleanExcursion0 (n : Nat) (hn : 1 ≤ n) :
    run [.down0, .up] (root n) = some (root n) := by
  have hlt : 0 < n := by omega
  simp [run, step, root, hlt]

theorem run_cleanExcursion1 (n : Nat) (hn : 1 ≤ n) :
    run [.down1, .up] (root n) = some (root n) := by
  have hlt : 0 < n := by omega
  simp [run, step, root, hlt]

theorem dirtyCost_cleanExcursion0 (n : Nat) (hn : 1 ≤ n) :
    dirtyCost [.down0, .up] (root n) = 1 := by
  have hlt : 0 < n := by omega
  simp [dirtyCost, step, dirtyCharge, LocalOp.cost, root, hlt]

theorem dirtyCost_cleanExcursion1 (n : Nat) (hn : 1 ≤ n) :
    dirtyCost [.down1, .up] (root n) = 1 := by
  have hlt : 0 < n := by omega
  simp [dirtyCost, step, dirtyCharge, LocalOp.cost, root, hlt]

theorem run_padding (n k : Nat) (hn : 1 ≤ n) :
    run (padding n k) (root n) = some (root n) := by
  unfold padding
  rw [run_append,
    run_repeatWord_closed _ _ _ (run_cleanExcursion0 n hn)]
  exact run_repeatWord_closed _ _ _ (run_cleanExcursion1 n hn)

theorem dirtyCost_padding (n k : Nat) (hn : 1 ≤ n) :
    dirtyCost (padding n k) (root n) = down0Deficit n k + down1Deficit n k := by
  unfold padding
  rw [dirtyCost_append _ _ _ _
    (run_repeatWord_closed _ _ _ (run_cleanExcursion0 n hn))]
  rw [dirtyCost_repeatWord_closed _ _ _ (run_cleanExcursion0 n hn),
    dirtyCost_repeatWord_closed _ _ _ (run_cleanExcursion1 n hn),
    dirtyCost_cleanExcursion0 n hn, dirtyCost_cleanExcursion1 n hn]
  simp

theorem padding_count (n k : Nat) (operation : LocalOp) :
    (padding n k).count operation =
      match operation with
      | .up => down0Deficit n k + down1Deficit n k
      | .down0 => down0Deficit n k
      | .down1 => down1Deficit n k
      | .read | .write0 | .write1 => 0 := by
  cases operation <;>
    simp [padding, count_repeatWord] <;> omega

theorem run_paddedDenseWalk (n k : Nat) (hblock : blockDepth k ≤ n) :
    run (paddedDenseWalk n k) (root n) = some (root n) := by
  have hn : 1 ≤ n := by
    have : 1 ≤ blockDepth k := by simp [blockDepth]
    omega
  unfold paddedDenseWalk
  rw [run_append, run_denseWalk n k hblock]
  exact run_padding n k hn

theorem dirtyCost_paddedDenseWalk (n k : Nat) (hblock : blockDepth k ≤ n) :
    dirtyCost (paddedDenseWalk n k) (root n) =
      4 * (n - blockDepth k) + 10 * blockLeaves k - 8 +
        down0Deficit n k + down1Deficit n k := by
  have hn : 1 ≤ n := by
    have : 1 ≤ blockDepth k := by simp [blockDepth]
    omega
  unfold paddedDenseWalk
  rw [dirtyCost_append _ _ _ _ (run_denseWalk n k hblock),
    dirtyCost_denseWalk_expanded n k hblock, dirtyCost_padding n k hn]
  omega

theorem paddedDense_letter_counts (n k : Nat)
    (hdown0 : 2 * (n - blockDepth k + (blockLeaves k - 1)) ≤ blockLeaves k * n)
    (hdown1 : 2 * (blockLeaves k - 1) ≤ blockLeaves k * n)
    (operation : LocalOp) :
    (paddedDenseWalk n k).count operation = (sparseWalk n k).count operation := by
  unfold paddedDenseWalk
  rw [List.count_append, denseWalk_count, padding_count, sparseWalk_count]
  cases operation <;> simp only
  · unfold down0Deficit down1Deficit
    have htwice : 2 * blockLeaves k * n = 2 * (blockLeaves k * n) := by ac_rfl
    omega
  · unfold down0Deficit
    omega
  · unfold down1Deficit
    omega
  · rfl
  · omega

theorem dirtyCost_paddedDenseWalk_expanded (n k : Nat)
    (hblock : blockDepth k ≤ n)
    (hdown0 : 2 * (n - blockDepth k + (blockLeaves k - 1)) ≤ blockLeaves k * n)
    (hdown1 : 2 * (blockLeaves k - 1) ≤ blockLeaves k * n) :
    dirtyCost (paddedDenseWalk n k) (root n) =
      2 * blockLeaves k * n + 2 * (n - blockDepth k) +
        6 * blockLeaves k - 4 := by
  rw [dirtyCost_paddedDenseWalk n k hblock]
  unfold down0Deficit down1Deficit
  have hm : 1 ≤ blockLeaves k := by
    unfold blockLeaves
    exact Nat.one_le_two_pow
  have htwice : 2 * blockLeaves k * n = 2 * (blockLeaves k * n) := by ac_rfl
  omega

def witnessGrade (k : Nat) : Nat := 4 * blockLeaves k

theorem blockLeaves_ge_two (k : Nat) : 2 ≤ blockLeaves k := by
  unfold blockLeaves
  rw [Nat.pow_succ]
  have hp : 1 ≤ 2 ^ k := Nat.one_le_two_pow
  omega

private theorem index_le_two_pow (value : Nat) : value ≤ 2 ^ value := by
  induction value with
  | zero => simp
  | succ value ih =>
      rw [Nat.pow_succ]
      have hp : 1 ≤ 2 ^ value := Nat.one_le_two_pow
      omega

theorem blockDepth_le_blockLeaves (k : Nat) : blockDepth k ≤ blockLeaves k := by
  simpa [blockDepth, blockLeaves] using index_le_two_pow (k + 1)

/-- A concrete solvable padding regime with `m = n/4`; no asymptotic choice is hidden. -/
theorem witnessGrade_padding_bounds (k : Nat) :
    blockDepth k ≤ witnessGrade k ∧
      2 * (witnessGrade k - blockDepth k + (blockLeaves k - 1)) ≤
        blockLeaves k * witnessGrade k ∧
      2 * (blockLeaves k - 1) ≤ blockLeaves k * witnessGrade k := by
  have hm2 := blockLeaves_ge_two k
  have hblockSmall := blockDepth_le_blockLeaves k
  have hblock : blockDepth k ≤ witnessGrade k := by
    unfold witnessGrade
    omega
  refine ⟨hblock, ?_, ?_⟩
  · by_cases hk : k = 0
    · subst k
      decide
    · have hk1 : 1 ≤ k := Nat.one_le_iff_ne_zero.mpr hk
      have hm4 : 4 ≤ blockLeaves k := by
        change 2 ^ 2 ≤ 2 ^ (k + 1)
        exact Nat.pow_le_pow_right (by decide) (by omega)
      have hd : witnessGrade k - blockDepth k ≤ witnessGrade k := Nat.sub_le _ _
      have hrough :
          2 * (witnessGrade k - blockDepth k + (blockLeaves k - 1)) ≤
            10 * blockLeaves k := by
        unfold witnessGrade at hd ⊢
        omega
      have hcoeff : 10 ≤ 4 * blockLeaves k := by omega
      have hscaled := Nat.mul_le_mul_right (blockLeaves k) hcoeff
      have hproduct : 10 * blockLeaves k ≤ blockLeaves k * witnessGrade k := by
        unfold witnessGrade
        calc
          10 * blockLeaves k ≤ 4 * blockLeaves k * blockLeaves k := hscaled
          _ = blockLeaves k * (4 * blockLeaves k) := by ac_rfl
      exact Nat.le_trans hrough hproduct
  · have hcoeff : 2 ≤ 4 * blockLeaves k := by omega
    have hscaled := Nat.mul_le_mul_right (blockLeaves k) hcoeff
    have hleft : 2 * (blockLeaves k - 1) ≤ 2 * blockLeaves k := by omega
    unfold witnessGrade
    calc
      2 * (blockLeaves k - 1) ≤ 2 * blockLeaves k := hleft
      _ ≤ 4 * blockLeaves k * blockLeaves k := hscaled
      _ = blockLeaves k * (4 * blockLeaves k) := by ac_rfl

theorem canonical_sparse_dense_counts (k : Nat) (operation : LocalOp) :
    (paddedDenseWalk (witnessGrade k) k).count operation =
      (sparseWalk (witnessGrade k) k).count operation := by
  exact paddedDense_letter_counts (witnessGrade k) k
    (witnessGrade_padding_bounds k).2.1 (witnessGrade_padding_bounds k).2.2 operation

theorem canonical_sparse_cost (k : Nat) :
    dirtyCost (sparseWalk (witnessGrade k) k) (root (witnessGrade k)) =
      4 * blockLeaves k * witnessGrade k + 2 * blockLeaves k :=
  dirtyCost_sparseWalk_expanded (witnessGrade k) k

theorem canonical_paddedDense_cost (k : Nat) :
    dirtyCost (paddedDenseWalk (witnessGrade k) k) (root (witnessGrade k)) =
      2 * blockLeaves k * witnessGrade k +
        2 * (witnessGrade k - blockDepth k) + 6 * blockLeaves k - 4 := by
  exact dirtyCost_paddedDenseWalk_expanded (witnessGrade k) k
    (witnessGrade_padding_bounds k).1
    (witnessGrade_padding_bounds k).2.1 (witnessGrade_padding_bounds k).2.2

/-- Dirty write-back is a uniform nontrivial exchange class at every positive grade. -/
theorem dirty_not_cohomologous (n : Nat) (hn : 1 ≤ n) :
    ¬ ∃ (prices : Prices) (potential : Config n → Nat),
      Exchange (dirtyCost (n := n)) (letterCost prices) potential := by
  rintro ⟨prices, potential, exchange⟩
  have ha := exchange (shortA n) (root n) (dirtyDescended0 n) (run_shortA n)
  have hb := exchange (shortB n) (root n) (dirtyDescended0 n) (run_shortB n)
  have hletters := letterCost_eq_of_counts prices (shortA n) (shortB n)
    (short_letter_counts n) (root n) (root n)
  rw [dirtyCost_shortA] at ha
  rw [dirtyCost_shortB] at hb
  change letterCost prices (shortA n) (root n) =
    letterCost prices (shortB n) (root n) at hletters
  omega

#print axioms dirtyCost_isCocycle
#print axioms dirtyCost_le_two_cleanCost_add_slack
#print axioms dirtyCost_sparseWalk_expanded
#print axioms dirtyCost_denseWalk_expanded
#print axioms canonical_sparse_dense_counts
#print axioms canonical_sparse_cost
#print axioms canonical_paddedDense_cost
#print axioms dirty_not_cohomologous

end Adic.Dyadic.Dirty
