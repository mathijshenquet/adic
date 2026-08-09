import Adic.Zip

namespace Adic.Dyadic

abbrev Weights (k : Nat) := Fin k → Nat

def maxWeight : {k : Nat} → Weights k → Nat
  | 0, _ => 0
  | k + 1, weights =>
      max (weights 0) (maxWeight fun head : Fin k => weights head.succ)

theorem weight_le_maxWeight (weights : Weights k) (head : Fin k) :
    weights head ≤ maxWeight weights := by
  induction k with
  | zero => exact Fin.elim0 head
  | succ k ih =>
      refine Fin.cases ?_ (fun tail => ?_) head
      · exact Nat.le_max_left _ _
      · exact Nat.le_trans (ih (fun i => weights i.succ) tail) (Nat.le_max_right _ _)

def finSum : {k : Nat} → (Fin k → Nat) → Nat
  | 0, _ => 0
  | k + 1, values => values 0 + finSum fun head : Fin k => values head.succ

theorem finSum_congr {left right : Fin k → Nat} (h : ∀ head, left head = right head) :
    finSum left = finSum right := by
  induction k with
  | zero => rfl
  | succ k ih =>
      simp only [finSum]
      rw [h 0, ih (fun head => h head.succ)]

theorem finSum_add (left right : Fin k → Nat) :
    finSum (fun head => left head + right head) = finSum left + finSum right := by
  induction k with
  | zero => rfl
  | succ k ih =>
      simp only [finSum]
      rw [ih]
      omega

theorem finSum_eq_sum_ofFn (values : Fin k → Nat) :
    finSum values = (List.ofFn values).sum := by
  induction k with
  | zero => rfl
  | succ k ih =>
      simp [finSum, List.ofFn_succ, ih]

theorem finSum_mono {left right : Fin k → Nat} (h : ∀ head, left head ≤ right head) :
    finSum left ≤ finSum right := by
  induction k with
  | zero => simp [finSum]
  | succ k ih =>
      simp only [finSum]
      exact Nat.add_le_add (h 0) (ih fun head => h head.succ)

@[simp] theorem finSum_zero (k : Nat) : finSum (fun _ : Fin k => 0) = 0 := by
  induction k with
  | zero => rfl
  | succ k ih => simp [finSum, ih]

theorem finSum_single (values : Fin k → Nat) (selected : Fin k) :
    finSum (fun head => if head = selected then values head else 0) = values selected := by
  induction k with
  | zero => exact Fin.elim0 selected
  | succ k ih =>
      refine Fin.cases ?_ (fun tail => ?_) selected
      · have hne : ∀ head : Fin k, head.succ ≠ (0 : Fin (k + 1)) := Fin.succ_ne_zero
        simp [finSum, hne]
      · have hne : (0 : Fin (k + 1)) ≠ tail.succ := (Fin.succ_ne_zero tail).symm
        simp [finSum, hne, ih (fun head : Fin k => values head.succ) tail]

theorem dvd_finSum (divisor : Nat) (values : Fin k → Nat)
    (h : ∀ head, divisor ∣ values head) : divisor ∣ finSum values := by
  induction k with
  | zero => simp [finSum]
  | succ k ih =>
      simp only [finSum]
      exact Nat.dvd_add (h 0) (ih (fun head => values head.succ) fun head => h head.succ)

def kraftMassAt (width : Nat) (weights : Weights k) : Nat :=
  finSum fun head => 2 ^ (width - weights head)

def KraftOk (weights : Weights k) : Prop :=
  kraftMassAt (maxWeight weights) weights ≤ 2 ^ maxWeight weights

def ComesBefore (weights : Weights k) (left right : Fin k) : Prop :=
  weights left < weights right ∨
    weights left = weights right ∧ left.val < right.val

instance (weights : Weights k) (left right : Fin k) :
    Decidable (ComesBefore weights left right) := by
  unfold ComesBefore
  infer_instance

theorem comesBefore_irrefl (weights : Weights k) (head : Fin k) :
    ¬ComesBefore weights head head := by
  simp [ComesBefore]

theorem comesBefore_trans (weights : Weights k) {first second third : Fin k}
    (hfirst : ComesBefore weights first second)
    (hsecond : ComesBefore weights second third) :
    ComesBefore weights first third := by
  simp only [ComesBefore] at hfirst hsecond ⊢
  omega

theorem comesBefore_total (weights : Weights k) {left right : Fin k}
    (hne : left ≠ right) :
    ComesBefore weights left right ∨ ComesBefore weights right left := by
  have hval : left.val ≠ right.val := by
    intro equality
    exact hne (Fin.ext equality)
  simp only [ComesBefore]
  omega

def blockAt (width : Nat) (weights : Weights k) (head : Fin k) : Nat :=
  2 ^ (width - weights head)

def priorMass (width : Nat) (weights : Weights k) (selected : Fin k) : Nat :=
  finSum fun head => if ComesBefore weights head selected then blockAt width weights head else 0

theorem priorMass_add_block_le_mass (width : Nat) (weights : Weights k)
    (selected : Fin k) :
    priorMass width weights selected + blockAt width weights selected ≤
      kraftMassAt width weights := by
  let before : Fin k → Nat := fun head =>
    if ComesBefore weights head selected then blockAt width weights head else 0
  let singleton : Fin k → Nat := fun head =>
    if head = selected then blockAt width weights head else 0
  have hpoint : ∀ head, before head + singleton head ≤ blockAt width weights head := by
    intro head
    by_cases hbefore : ComesBefore weights head selected
    · have hne : head ≠ selected := by
        intro equality
        subst head
        exact comesBefore_irrefl weights selected hbefore
      simp [before, singleton, hbefore, hne]
    · by_cases heq : head = selected
      · subst head
        simp [before, singleton, comesBefore_irrefl]
      · simp [before, singleton, hbefore, heq]
  calc
    priorMass width weights selected + blockAt width weights selected =
        finSum before + finSum singleton := by
      simp [priorMass, before, singleton, finSum_single]
    _ = finSum (fun head => before head + singleton head) :=
      (finSum_add before singleton).symm
    _ ≤ finSum (blockAt width weights) := finSum_mono hpoint
    _ = kraftMassAt width weights := rfl

theorem priorMass_order (width : Nat) (weights : Weights k) {left right : Fin k}
    (hbefore : ComesBefore weights left right) :
    priorMass width weights left + blockAt width weights left ≤
      priorMass width weights right := by
  let throughLeft : Fin k → Nat := fun head =>
    (if ComesBefore weights head left then blockAt width weights head else 0) +
      (if head = left then blockAt width weights head else 0)
  let beforeRight : Fin k → Nat := fun head =>
    if ComesBefore weights head right then blockAt width weights head else 0
  have hpoint : ∀ head, throughLeft head ≤ beforeRight head := by
    intro head
    by_cases hhead : ComesBefore weights head left
    · have htrans := comesBefore_trans weights hhead hbefore
      have hne : head ≠ left := by
        intro equality
        subst head
        exact comesBefore_irrefl weights left hhead
      simp [throughLeft, beforeRight, hhead, htrans, hne]
    · by_cases heq : head = left
      · subst head
        simp [throughLeft, beforeRight, hbefore,
          comesBefore_irrefl weights left]
      · simp [throughLeft, beforeRight, hhead, heq]
  calc
    priorMass width weights left + blockAt width weights left =
        finSum (fun head =>
          if ComesBefore weights head left then blockAt width weights head else 0) +
          finSum (fun head => if head = left then blockAt width weights head else 0) := by
      simp [priorMass, finSum_single]
    _ = finSum throughLeft := by
      rw [finSum_add]
    _ ≤ finSum beforeRight := finSum_mono hpoint
    _ = priorMass width weights right := rfl

theorem block_dvd_priorMass (weights : Weights k) (selected : Fin k)
    (hwidth : weights selected ≤ width) :
    blockAt width weights selected ∣ priorMass width weights selected := by
  unfold priorMass
  apply dvd_finSum
  intro head
  by_cases hbefore : ComesBefore weights head selected
  · have hweight : weights head ≤ weights selected := by
      simp only [ComesBefore] at hbefore
      omega
    have hexponent : width - weights selected ≤ width - weights head := by omega
    simp [hbefore, blockAt]
    exact Nat.pow_dvd_pow 2 hexponent
  · simp [hbefore]

def pathValue : List Bool → Nat
  | [] => 0
  | bit :: tail => (if bit then 2 ^ tail.length else 0) + pathValue tail

theorem pathValue_lt_two_pow_length (path : List Bool) :
    pathValue path < 2 ^ path.length := by
  induction path with
  | nil => simp [pathValue]
  | cons bit tail ih =>
      cases bit <;> simp [pathValue, Nat.pow_succ] <;> omega

theorem pathValue_append (stem suffix : List Bool) :
    pathValue (stem ++ suffix) =
      pathValue stem * 2 ^ suffix.length + pathValue suffix := by
  induction stem with
  | nil => simp [pathValue]
  | cons bit stem ih =>
      cases bit <;>
        simp [pathValue, ih, List.length_append, Nat.pow_add, Nat.add_mul] <;>
        ac_rfl

def binaryPath : Nat → Nat → List Bool
  | 0, _ => []
  | width + 1, value =>
      if value < 2 ^ width then
        false :: binaryPath width value
      else
        true :: binaryPath width (value - 2 ^ width)

@[simp] theorem binaryPath_length (width value : Nat) :
    (binaryPath width value).length = width := by
  induction width generalizing value with
  | zero => rfl
  | succ width ih =>
      by_cases hvalue : value < 2 ^ width <;>
        simp [binaryPath, hvalue, ih]

theorem pathValue_binaryPath {width value : Nat} (hvalue : value < 2 ^ width) :
    pathValue (binaryPath width value) = value := by
  induction width generalizing value with
  | zero =>
      have : value = 0 := by simpa using hvalue
      subst value
      rfl
  | succ width ih =>
      by_cases hhigh : value < 2 ^ width
      · simp [binaryPath, hhigh, pathValue, ih hhigh]
      · have htail : value - 2 ^ width < 2 ^ width := by
          rw [Nat.pow_succ] at hvalue
          omega
        simp [binaryPath, hhigh, pathValue, ih htail]
        omega

theorem scaled_start_bounds_of_prefix {stem path : List Bool} (width : Nat)
    (hstemWidth : stem.length ≤ width) (hpathWidth : path.length ≤ width)
    (hprefix : stem <+: path) :
    pathValue stem * 2 ^ (width - stem.length) ≤
        pathValue path * 2 ^ (width - path.length) ∧
      pathValue path * 2 ^ (width - path.length) <
        pathValue stem * 2 ^ (width - stem.length) +
          2 ^ (width - stem.length) := by
  obtain ⟨suffix, rfl⟩ := List.prefix_iff_exists_eq_append.mp hprefix
  have hlength : stem.length + suffix.length ≤ width := by
    simpa using hpathWidth
  have hexponent : width - stem.length =
      (width - (stem.length + suffix.length)) + suffix.length := by
    omega
  have hstart :
      pathValue (stem ++ suffix) *
          2 ^ (width - (stem ++ suffix).length) =
        pathValue stem * 2 ^ (width - stem.length) +
          pathValue suffix * 2 ^ (width - (stem.length + suffix.length)) := by
    rw [pathValue_append, List.length_append, hexponent, Nat.pow_add]
    rw [Nat.add_mul]
    ac_rfl
  have hsuffix := pathValue_lt_two_pow_length suffix
  have hblock : 0 < 2 ^ (width - (stem.length + suffix.length)) :=
    Nat.two_pow_pos _
  have hscaled :
      pathValue suffix * 2 ^ (width - (stem.length + suffix.length)) <
        2 ^ suffix.length * 2 ^ (width - (stem.length + suffix.length)) :=
    Nat.mul_lt_mul_of_pos_right hsuffix hblock
  constructor
  · rw [hstart]
    exact Nat.le_add_right _ _
  · rw [hstart, hexponent, Nat.pow_add]
    simpa [Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm] using
      Nat.add_lt_add_left hscaled
        (pathValue stem *
          (2 ^ (width - (stem.length + suffix.length)) * 2 ^ suffix.length))

structure Mounting (weights : Weights k) where
  path : Fin k → List Bool
  length_path : ∀ head, (path head).length = weights head
  injective_path : Function.Injective path
  incomparable_path : ∀ {left right}, left ≠ right →
    PrefixIncomparable (path left) (path right)

def tailWith (selected : Bool) : List Bool → Option (List Bool)
  | [] => none
  | bit :: tail => if bit = selected then some tail else none

def tailsWith (selected : Bool) (paths : List (List Bool)) : List (List Bool) :=
  paths.filterMap (tailWith selected)

def pathMass (width : Nat) (paths : List (List Bool)) : Nat :=
  (paths.map fun path => 2 ^ (width - path.length)).sum

theorem tailsWith_pairwise (selected : Bool) {paths : List (List Bool)}
    (hpaths : paths.Pairwise PrefixIncomparable) :
    (tailsWith selected paths).Pairwise PrefixIncomparable := by
  apply hpaths.filterMap (tailWith selected)
  intro left right hdisjoint leftTail hleft rightTail hright
  cases left with
  | nil => simp [tailWith] at hleft
  | cons leftBit leftTail' =>
      cases right with
      | nil => simp [tailWith] at hright
      | cons rightBit rightTail' =>
          by_cases hleftBit : leftBit = selected <;>
            by_cases hrightBit : rightBit = selected <;>
            simp [tailWith, hleftBit, hrightBit] at hleft hright
          subst leftBit
          subst rightBit
          subst leftTail'
          subst rightTail'
          simpa [PrefixIncomparable] using hdisjoint

theorem tailsWith_depth (selected : Bool) {paths : List (List Bool)}
    (hdepth : ∀ path ∈ paths, path.length ≤ width + 1) :
    ∀ tail ∈ tailsWith selected paths, tail.length ≤ width := by
  intro tail htail
  obtain ⟨path, hpath, hselected⟩ := List.mem_filterMap.mp htail
  cases path with
  | nil => simp [tailWith] at hselected
  | cons bit rest =>
      by_cases hbit : bit = selected
      · simp [tailWith, hbit] at hselected
        subst rest
        have := hdepth (bit :: tail) hpath
        simp at this
        omega
      · simp [tailWith, hbit] at hselected

theorem pathMass_split (paths : List (List Bool))
    (hnonempty : ∀ path ∈ paths, path ≠ []) :
    pathMass (width + 1) paths =
      pathMass width (tailsWith false paths) +
        pathMass width (tailsWith true paths) := by
  induction paths with
  | nil => simp [pathMass, tailsWith]
  | cons path paths ih =>
      have hpath := hnonempty path (List.mem_cons_self)
      have hrest : ∀ item ∈ paths, item ≠ [] := by
        intro item hitem
        exact hnonempty item (List.mem_cons_of_mem path hitem)
      cases path with
      | nil => exact False.elim (hpath rfl)
      | cons bit tail =>
          cases bit
          · change 2 ^ ((width + 1) - (tail.length + 1)) + pathMass (width + 1) paths =
              (2 ^ (width - tail.length) + pathMass width (tailsWith false paths)) +
                pathMass width (tailsWith true paths)
            rw [ih hrest]
            rw [Nat.add_sub_add_right]
            omega
          · change 2 ^ ((width + 1) - (tail.length + 1)) + pathMass (width + 1) paths =
              pathMass width (tailsWith false paths) +
                (2 ^ (width - tail.length) + pathMass width (tailsWith true paths))
            rw [ih hrest]
            rw [Nat.add_sub_add_right]
            omega

theorem kraft_bound_paths (paths : List (List Bool))
    (hdepth : ∀ path ∈ paths, path.length ≤ width)
    (hpairwise : paths.Pairwise PrefixIncomparable) :
    pathMass width paths ≤ 2 ^ width := by
  induction width generalizing paths with
  | zero =>
      cases paths with
      | nil => simp [pathMass]
      | cons path rest =>
          have hpath : path = [] := by
            apply List.eq_nil_of_length_eq_zero
            have := hdepth path (List.mem_cons_self)
            omega
          subst path
          have hrest : rest = [] := by
            cases rest with
            | nil => rfl
            | cons item more =>
                have hdisjoint :=
                  (List.pairwise_cons.mp hpairwise).1 item (List.mem_cons_self)
                exact False.elim (hdisjoint.1 List.nil_prefix)
          subst rest
          simp [pathMass]
  | succ width ih =>
      cases paths with
      | nil => simp [pathMass]
      | cons path rest =>
          cases path with
          | nil =>
              have hrest : rest = [] := by
                cases rest with
                | nil => rfl
                | cons item more =>
                    have hdisjoint :=
                      (List.pairwise_cons.mp hpairwise).1 item (List.mem_cons_self)
                    exact False.elim (hdisjoint.1 List.nil_prefix)
              subst rest
              simp [pathMass]
          | cons bit tail =>
              let paths := (bit :: tail) :: rest
              have hnonempty : ∀ path ∈ paths, path ≠ [] := by
                intro item hitem
                rcases List.mem_cons.mp hitem with rfl | hitem
                · simp
                · intro hempty
                  subst item
                  have hdisjoint := (List.pairwise_cons.mp hpairwise).1 [] hitem
                  exact hdisjoint.2 List.nil_prefix
              have hleft := ih (tailsWith false paths)
                (tailsWith_depth false hdepth) (tailsWith_pairwise false hpairwise)
              have hright := ih (tailsWith true paths)
                (tailsWith_depth true hdepth) (tailsWith_pairwise true hpairwise)
              rw [pathMass_split paths hnonempty, Nat.pow_succ]
              omega

def canonicalMountPath (weights : Weights k) (head : Fin k) : List Bool :=
  binaryPath (weights head)
    (priorMass (maxWeight weights) weights head /
      blockAt (maxWeight weights) weights head)

@[simp] theorem canonicalMountPath_length (weights : Weights k) (head : Fin k) :
    (canonicalMountPath weights head).length = weights head := by
  simp [canonicalMountPath]

theorem canonicalMountPath_start (weights : Weights k) (hKraft : KraftOk weights)
    (head : Fin k) :
    pathValue (canonicalMountPath weights head) *
        blockAt (maxWeight weights) weights head =
      priorMass (maxWeight weights) weights head := by
  let width := maxWeight weights
  let block := blockAt width weights head
  let start := priorMass width weights head
  let code := start / block
  have hwidth : weights head ≤ width := weight_le_maxWeight weights head
  have hdvd : block ∣ start := block_dvd_priorMass weights head hwidth
  have hstart : code * block = start := by
    exact Nat.div_mul_cancel hdvd
  have hend : start + block ≤ 2 ^ width := by
    exact Nat.le_trans (priorMass_add_block_le_mass width weights head) hKraft
  have hblockPower : block * 2 ^ weights head = 2 ^ width := by
    exact Nat.pow_sub_mul_pow 2 hwidth
  have hmul : block * (code + 1) ≤ block * 2 ^ weights head := by
    calc
      block * (code + 1) = start + block := by
        rw [Nat.mul_add, Nat.mul_one, Nat.mul_comm block code, hstart]
      _ ≤ 2 ^ width := hend
      _ = block * 2 ^ weights head := hblockPower.symm
  have hblockPositive : 0 < block := by
    exact Nat.two_pow_pos _
  have hcode : code < 2 ^ weights head := by
    have := Nat.le_of_mul_le_mul_left hmul hblockPositive
    omega
  have hvalue : pathValue (canonicalMountPath weights head) = code := by
    exact pathValue_binaryPath hcode
  rw [hvalue]
  exact hstart

theorem canonicalMountPath_incomparable (weights : Weights k) (hKraft : KraftOk weights)
    {left right : Fin k} (hne : left ≠ right) :
    PrefixIncomparable (canonicalMountPath weights left)
      (canonicalMountPath weights right) := by
  have hleftWidth : weights left ≤ maxWeight weights := weight_le_maxWeight weights left
  have hrightWidth : weights right ≤ maxWeight weights := weight_le_maxWeight weights right
  have hleftStart := canonicalMountPath_start weights hKraft left
  have hrightStart := canonicalMountPath_start weights hKraft right
  rcases comesBefore_total weights hne with hbefore | hbefore
  · have horder := priorMass_order (maxWeight weights) weights hbefore
    constructor
    · intro hprefix
      have hbounds := scaled_start_bounds_of_prefix (maxWeight weights)
        (by simpa using hleftWidth) (by simpa using hrightWidth) hprefix
      simp only [canonicalMountPath_length] at hbounds
      rw [show 2 ^ (maxWeight weights - weights left) =
          blockAt (maxWeight weights) weights left by rfl,
        show 2 ^ (maxWeight weights - weights right) =
          blockAt (maxWeight weights) weights right by rfl,
        hleftStart, hrightStart] at hbounds
      omega
    · intro hprefix
      have hbounds := scaled_start_bounds_of_prefix (maxWeight weights)
        (by simpa using hrightWidth) (by simpa using hleftWidth) hprefix
      simp only [canonicalMountPath_length] at hbounds
      rw [show 2 ^ (maxWeight weights - weights left) =
          blockAt (maxWeight weights) weights left by rfl,
        show 2 ^ (maxWeight weights - weights right) =
          blockAt (maxWeight weights) weights right by rfl,
        hleftStart, hrightStart] at hbounds
      have hpositive : 0 < blockAt (maxWeight weights) weights left := Nat.two_pow_pos _
      omega
  · have horder := priorMass_order (maxWeight weights) weights hbefore
    constructor
    · intro hprefix
      have hbounds := scaled_start_bounds_of_prefix (maxWeight weights)
        (by simpa using hleftWidth) (by simpa using hrightWidth) hprefix
      simp only [canonicalMountPath_length] at hbounds
      rw [show 2 ^ (maxWeight weights - weights left) =
          blockAt (maxWeight weights) weights left by rfl,
        show 2 ^ (maxWeight weights - weights right) =
          blockAt (maxWeight weights) weights right by rfl,
        hleftStart, hrightStart] at hbounds
      have hpositive : 0 < blockAt (maxWeight weights) weights right := Nat.two_pow_pos _
      omega
    · intro hprefix
      have hbounds := scaled_start_bounds_of_prefix (maxWeight weights)
        (by simpa using hrightWidth) (by simpa using hleftWidth) hprefix
      simp only [canonicalMountPath_length] at hbounds
      rw [show 2 ^ (maxWeight weights - weights left) =
          blockAt (maxWeight weights) weights left by rfl,
        show 2 ^ (maxWeight weights - weights right) =
          blockAt (maxWeight weights) weights right by rfl,
        hleftStart, hrightStart] at hbounds
      omega

def mountingOfKraft {weights : Weights k} (hKraft : KraftOk weights) :
    Mounting weights := by
  refine {
    path := canonicalMountPath weights
    length_path := canonicalMountPath_length weights
    injective_path := ?_
    incomparable_path := canonicalMountPath_incomparable weights hKraft
  }
  intro left right equality
  by_cases heq : left = right
  · exact heq
  · have hdisjoint := canonicalMountPath_incomparable weights hKraft heq
    exact False.elim (hdisjoint.1 (equality ▸ List.prefix_refl _))

theorem pairwise_ofFn_of_ne (values : Fin k → α) (relation : α → α → Prop)
    (hrelation : ∀ {left right}, left ≠ right → relation (values left) (values right)) :
    (List.ofFn values).Pairwise relation := by
  induction k with
  | zero => simp
  | succ k ih =>
      rw [List.ofFn_succ, List.pairwise_cons]
      constructor
      · intro value hvalue
        obtain ⟨head, equality⟩ := List.mem_ofFn.mp hvalue
        subst value
        exact hrelation (Fin.succ_ne_zero head).symm
      · apply ih (fun head : Fin k => values head.succ)
        intro left right hne
        apply hrelation
        intro equality
        exact hne (Fin.succ_inj.mp equality)

theorem mounting_paths_pairwise {weights : Weights k} (mounting : Mounting weights) :
    (List.ofFn mounting.path).Pairwise PrefixIncomparable :=
  pairwise_ofFn_of_ne mounting.path PrefixIncomparable mounting.incomparable_path

theorem kraft_of_mounting {weights : Weights k} (mounting : Mounting weights) :
    KraftOk weights := by
  let paths := List.ofFn mounting.path
  have hdepth : ∀ path ∈ paths, path.length ≤ maxWeight weights := by
    intro path hpath
    obtain ⟨head, equality⟩ := List.mem_ofFn.mp hpath
    rw [← equality, mounting.length_path]
    exact weight_le_maxWeight weights head
  have hbound := kraft_bound_paths paths hdepth (mounting_paths_pairwise mounting)
  have hmass : pathMass (maxWeight weights) paths =
      kraftMassAt (maxWeight weights) weights := by
    rw [pathMass, List.map_ofFn, ← finSum_eq_sum_ofFn]
    apply finSum_congr
    intro head
    simp [mounting.length_path]
  rw [hmass] at hbound
  exact hbound

theorem kraft_iff_mounting (weights : Weights k) :
    KraftOk weights ↔
      ∃ paths : Fin k → List Bool,
        (∀ head, (paths head).length = weights head) ∧
          Function.Injective paths ∧
            ∀ {left right}, left ≠ right →
              PrefixIncomparable (paths left) (paths right) := by
  constructor
  · intro hKraft
    let mounting := mountingOfKraft hKraft
    exact ⟨mounting.path, mounting.length_path, mounting.injective_path,
      mounting.incomparable_path⟩
  · rintro ⟨paths, hlength, hinjective, hincomparable⟩
    exact kraft_of_mounting {
      path := paths
      length_path := hlength
      injective_path := hinjective
      incomparable_path := hincomparable
    }

def weightedCost (weights : Weights k) (word : ActionWord k) : Nat :=
  (word.map fun operation => 1 + weights operation.head).sum

@[simp] theorem weightedCost_nil (weights : Weights k) :
    weightedCost weights [] = 0 := rfl

@[simp] theorem weightedCost_cons (weights : Weights k) (operation : AddressedOp k)
    (word : ActionWord k) :
    weightedCost weights (operation :: word) =
      1 + weights operation.head + weightedCost weights word := rfl

@[simp] theorem weightedCost_append (weights : Weights k) (first second : ActionWord k) :
    weightedCost weights (first ++ second) =
      weightedCost weights first + weightedCost weights second := by
  simp [weightedCost]

theorem weightedCost_zero (word : ActionWord k) :
    weightedCost (fun _ => 0) word = actionCost word := by
  induction word with
  | nil => rfl
  | cons operation word ih =>
      simpa [actionCost, Nat.add_comm] using congrArg Nat.succ ih

theorem weightedCost_le_maxWeight (weights : Weights k) (word : ActionWord k) :
    weightedCost weights word ≤ (1 + maxWeight weights) * actionCost word := by
  induction word with
  | nil => simp [actionCost]
  | cons operation word ih =>
      have hhead : 1 + weights operation.head ≤ 1 + maxWeight weights :=
        Nat.add_le_add_left (weight_le_maxWeight weights operation.head) 1
      rw [weightedCost_cons]
      calc
        1 + weights operation.head + weightedCost weights word ≤
            (1 + maxWeight weights) +
              (1 + maxWeight weights) * actionCost word :=
          Nat.add_le_add hhead ih
        _ = (1 + maxWeight weights) * actionCost (operation :: word) := by
          simp [actionCost, Nat.mul_add, Nat.add_comm]

def weightedZipLeafCost (weights : Weights 3) : Nat :=
  8 + weights inputAHead + weights inputBHead + 6 * weights outputHead

def weightedZipNodeCost (weights : Weights 3) : Nat :=
  12 + 4 * (weights inputAHead + weights inputBHead + weights outputHead)

def weightedZipCost (weights : Weights 3) : Nat → Nat
  | 0 => weightedZipLeafCost weights
  | n + 1 => 2 * weightedZipCost weights n + weightedZipNodeCost weights

theorem weightedZipCost_closed (weights : Weights 3) (n : Nat) :
    weightedZipCost weights n =
      weightedZipLeafCost weights * 2 ^ n +
        weightedZipNodeCost weights * (2 ^ n - 1) := by
  induction n with
  | zero => simp [weightedZipCost]
  | succ n ih =>
      rw [weightedZipCost, ih, Nat.pow_succ]
      have hpositive : 1 ≤ 2 ^ n := Nat.two_pow_pos n
      have hsub : 2 ^ n * 2 - 1 = 2 * (2 ^ n - 1) + 1 := by omega
      rw [hsub]
      simp [Nat.mul_add, Nat.add_mul, Nat.mul_assoc, Nat.mul_comm,
        Nat.add_comm, Nat.add_left_comm]

theorem weighted_zipWord (weights : Weights 3) (a b : Tree n) :
    weightedCost weights (zipWord n a b) = weightedZipCost weights n := by
  induction n with
  | zero =>
      cases a <;> cases b <;>
        simp [zipWord, weightedCost, weightedZipCost, weightedZipLeafCost,
          inputAHead, inputBHead, outputHead, addressed, writeBit] <;> omega
  | succ n ih =>
      obtain ⟨a₀, a₁⟩ := a
      obtain ⟨b₀, b₁⟩ := b
      simp only [zipWord, weightedCost_append]
      rw [ih a₀ b₀, ih a₁ b₁]
      simp [descendAll, ascendAll, weightedCost, weightedZipCost,
        weightedZipNodeCost, inputAHead, inputBHead, outputHead, addressed] <;> omega

theorem weighted_zipWord_linear_bound (weights : Weights 3) (a b : Tree n) :
    weightedCost weights (zipWord n a b) ≤
      (1 + maxWeight weights) * 20 * 2 ^ n := by
  calc
    weightedCost weights (zipWord n a b) ≤
        (1 + maxWeight weights) * actionCost (zipWord n a b) :=
      weightedCost_le_maxWeight weights _
    _ ≤ (1 + maxWeight weights) * (20 * 2 ^ n) :=
      Nat.mul_le_mul_left _ (zipWord_linear_bound a b)
    _ = (1 + maxWeight weights) * 20 * 2 ^ n := by
      simp [Nat.mul_assoc]

def uniformThreeWeights : Weights 3 := fun _ => 2

theorem uniformThreeWeights_kraft : KraftOk uniformThreeWeights := by
  simp [KraftOk, kraftMassAt, maxWeight, uniformThreeWeights, finSum]

#print axioms weightedCost_append
#print axioms weightedCost_zero
#print axioms kraft_iff_mounting
#print axioms weighted_zipWord
#print axioms weightedZipCost_closed
#print axioms weighted_zipWord_linear_bound
#print axioms uniformThreeWeights_kraft

end Adic.Dyadic
