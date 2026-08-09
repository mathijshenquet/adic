import Adic.Distance

namespace Adic.Dyadic

def touchCount {k : Nat} : List (Fin k) → Dists k
  | [] => fun _ => 0
  | touched :: rest => fun head =>
      (if head = touched then 1 else 0) + touchCount rest head

def touchCost (dists : Dists k) (touches : List (Fin k)) : Nat :=
  (touches.map fun head => 1 + dists head).sum

theorem finSum_mul_right (values : Fin k → Nat) (factor : Nat) :
    finSum (fun head => values head * factor) = finSum values * factor := by
  induction k with
  | zero => simp [finSum]
  | succ k ih =>
      simp only [finSum]
      rw [ih, Nat.add_mul]

theorem finSum_mul_left (factor : Nat) (values : Fin k → Nat) :
    finSum (fun head => factor * values head) = factor * finSum values := by
  rw [show (fun head => factor * values head) = (fun head => values head * factor) by
    funext head
    exact Nat.mul_comm _ _]
  rw [finSum_mul_right, Nat.mul_comm]

theorem finSum_touchCount (touches : List (Fin k)) :
    finSum (touchCount touches) = touches.length := by
  induction touches with
  | nil => simp [touchCount]
  | cons touched rest ih =>
      change finSum (fun head =>
        (if head = touched then 1 else 0) + touchCount rest head) =
          rest.length + 1
      rw [finSum_add]
      rw [finSum_single]
      omega

theorem touchCount_le_length (touches : List (Fin k)) (head : Fin k) :
    touchCount touches head ≤ touches.length := by
  induction touches with
  | nil => simp [touchCount]
  | cons touched rest ih =>
      simp only [touchCount, List.length_cons]
      split <;> omega

theorem finSum_touchCount_mul (dists : Dists k) (touches : List (Fin k)) :
    finSum (fun head => touchCount touches head * dists head) =
      (touches.map dists).sum := by
  induction touches with
  | nil => simp [touchCount]
  | cons touched rest ih =>
      change finSum (fun head =>
        ((if head = touched then 1 else 0) + touchCount rest head) * dists head) =
          dists touched + (rest.map dists).sum
      calc
        finSum (fun head =>
            ((if head = touched then 1 else 0) + touchCount rest head) * dists head) =
            finSum (fun head =>
              (if head = touched then dists head else 0) +
                touchCount rest head * dists head) := by
          apply finSum_congr
          intro head
          split <;> simp_all [Nat.add_mul]
        _ = finSum (fun head => if head = touched then dists head else 0) +
              finSum (fun head => touchCount rest head * dists head) :=
          finSum_add _ _
        _ = dists touched + (rest.map dists).sum := by
          rw [finSum_single, ih]

theorem touchCost_counts (dists : Dists k) (touches : List (Fin k)) :
    touchCost dists touches =
      touches.length + finSum (fun head => touchCount touches head * dists head) := by
  rw [finSum_touchCount_mul]
  induction touches with
  | nil => rfl
  | cons touched rest ih =>
      simp only [touchCost, List.map_cons, List.sum_cons, List.length_cons]
      change (rest.map fun head => 1 + dists head).sum =
        rest.length + (rest.map dists).sum at ih
      omega

def acquisitionTouches : ActionWord k → List (Fin k)
  | [] => []
  | operation :: word =>
      match operation.operation with
      | .up => acquisitionTouches word
      | _ => operation.head :: acquisitionTouches word

theorem distCost_eq_touchCost (dists : Dists k) (word : ActionWord k) :
    distCost dists word = touchCost dists (acquisitionTouches word) := by
  induction word with
  | nil => rfl
  | cons operation word ih =>
      rw [distCost_cons]
      rcases operation with ⟨head, operation⟩
      cases operation <;>
        simp [distOperationCost, acquisitionTouches, touchCost, ih]

/-- The exact natural ceiling of `log₂(total / count)` for positive inputs.
The predecessor quotient avoids truncating the ratio before taking the ceiling. -/
def inverseFrequencyDist (total count : Nat) : Nat :=
  if total ≤ count then 0 else Nat.log2 ((total - 1) / count) + 1

theorem inverseFrequencyDist_spec {total count : Nat}
    (htotal : 0 < total) (hcount : 0 < count) :
    total ≤ count * 2 ^ inverseFrequencyDist total count := by
  by_cases hsmall : total ≤ count
  · simp [inverseFrequencyDist, hsmall]
  · let quotient := (total - 1) / count
    have hquotient : 0 < quotient := by
      apply (Nat.le_div_iff_mul_le hcount).2
      simp only [Nat.one_mul]
      omega
    have hround := Nat.lt_div_mul_add (a := total - 1) hcount
    change total - 1 < quotient * count + count at hround
    have hpower := Nat.lt_log2_self (n := quotient)
    have htotalRound : total ≤ count * (quotient + 1) := by
      calc
        total ≤ quotient * count + count := by omega
        _ = count * (quotient + 1) := by
          rw [Nat.mul_add, Nat.mul_one, Nat.mul_comm count quotient]
    have hquotientPower : quotient + 1 ≤ 2 ^ (Nat.log2 quotient + 1) := by
      omega
    simp only [inverseFrequencyDist, hsmall, if_false]
    exact Nat.le_trans htotalRound (Nat.mul_le_mul_left count hquotientPower)

theorem inverseFrequencyDist_minimal {total count dist : Nat}
    (htotal : 0 < total) (hcount : 0 < count) :
    inverseFrequencyDist total count ≤ dist ↔ total ≤ count * 2 ^ dist := by
  constructor
  · intro hdist
    exact Nat.le_trans (inverseFrequencyDist_spec htotal hcount)
      (Nat.mul_le_mul_left count (Nat.pow_le_pow_right (by decide) hdist))
  · intro hcapacity
    by_cases hsmall : total ≤ count
    · simp [inverseFrequencyDist, hsmall]
    · let quotient := (total - 1) / count
      have hquotient : quotient ≠ 0 := by
        apply Nat.ne_of_gt
        apply (Nat.le_div_iff_mul_le hcount).2
        simp only [Nat.one_mul]
        omega
      have hfloor : quotient * count ≤ total - 1 :=
        Nat.div_mul_le_self _ _
      have hstrict : quotient < 2 ^ dist := by
        have hmul : quotient * count < 2 ^ dist * count := calc
          quotient * count ≤ total - 1 := hfloor
          _ < total := by omega
          _ ≤ count * 2 ^ dist := hcapacity
          _ = 2 ^ dist * count := Nat.mul_comm _ _
        exact Nat.lt_of_mul_lt_mul_right hmul
      have hlog : Nat.log2 quotient < dist :=
        (Nat.log2_lt hquotient).2 hstrict
      simpa [inverseFrequencyDist, hsmall, quotient] using hlog

theorem inverseFrequencyDist_le_log2_div_add_one {total count : Nat}
    (htotal : 0 < total) (hcount : 0 < count) :
    inverseFrequencyDist total count ≤ Nat.log2 (total / count) + 1 := by
  by_cases hsmall : total ≤ count
  · simp [inverseFrequencyDist, hsmall]
  · have hquotient : (total - 1) / count ≠ 0 := by
      apply Nat.ne_of_gt
      apply (Nat.le_div_iff_mul_le hcount).2
      simp only [Nat.one_mul]
      omega
    have hratio : total / count ≠ 0 := by
      apply Nat.ne_of_gt
      apply (Nat.le_div_iff_mul_le hcount).2
      simp only [Nat.one_mul]
      omega
    have hdivision : (total - 1) / count ≤ total / count :=
      Nat.div_le_div_right (Nat.sub_le total 1)
    have hlog : Nat.log2 ((total - 1) / count) ≤ Nat.log2 (total / count) := by
      apply (Nat.le_log2 hratio).2
      exact Nat.le_trans (Nat.log2_self_le hquotient) hdivision
    simp [inverseFrequencyDist, hsmall]
    omega

def empiricalDists (touches : List (Fin k)) : Dists k := fun head =>
  inverseFrequencyDist touches.length (touchCount touches head)

def empiricalFloorLogTotal (touches : List (Fin k)) : Nat :=
  finSum fun head =>
    touchCount touches head * Nat.log2 (touches.length / touchCount touches head)

theorem empiricalDists_kraft (touches : List (Fin k))
    (hnonempty : 0 < touches.length)
    (hpositive : ∀ head, 0 < touchCount touches head) :
    KraftOk (empiricalDists touches) := by
  let dists := empiricalDists touches
  let width := maxDist dists
  have hpoint : ∀ head,
      touches.length * 2 ^ (width - dists head) ≤
        touchCount touches head * 2 ^ width := by
    intro head
    have hfrequency := inverseFrequencyDist_spec hnonempty (hpositive head)
    have hdist : dists head ≤ width := dist_le_maxDist dists head
    have hscaled := Nat.mul_le_mul_right (2 ^ (width - dists head)) hfrequency
    calc
      touches.length * 2 ^ (width - dists head) ≤
          (touchCount touches head * 2 ^ dists head) *
            2 ^ (width - dists head) := hscaled
      _ = touchCount touches head * 2 ^ width := by
        rw [show (touchCount touches head * 2 ^ dists head) *
            2 ^ (width - dists head) =
              touchCount touches head *
                (2 ^ (width - dists head) * 2 ^ dists head) by ac_rfl]
        rw [Nat.pow_sub_mul_pow 2 hdist]
  have hscaledMass :
      touches.length * kraftMassAt width dists ≤ touches.length * 2 ^ width := by
    calc
      touches.length * kraftMassAt width dists =
          finSum (fun head =>
            touches.length * 2 ^ (width - dists head)) := by
        rw [kraftMassAt, finSum_mul_left]
      _ ≤ finSum (fun head => touchCount touches head * 2 ^ width) :=
        finSum_mono hpoint
      _ = finSum (touchCount touches) * 2 ^ width :=
        finSum_mul_right _ _
      _ = touches.length * 2 ^ width := by rw [finSum_touchCount]
  change kraftMassAt width dists ≤ 2 ^ width
  exact Nat.le_of_mul_le_mul_left hscaledMass hnonempty

theorem touchCost_empirical_exact (touches : List (Fin k)) :
    touchCost (empiricalDists touches) touches =
      touches.length + finSum (fun head =>
        touchCount touches head *
          inverseFrequencyDist touches.length (touchCount touches head)) := by
  exact touchCost_counts _ _

theorem touchCost_empirical_entropy_bound (touches : List (Fin k))
    (hnonempty : 0 < touches.length)
    (hpositive : ∀ head, 0 < touchCount touches head) :
    touchCost (empiricalDists touches) touches ≤
      empiricalFloorLogTotal touches + 2 * touches.length := by
  have hpoint : ∀ head,
      touchCount touches head *
          inverseFrequencyDist touches.length (touchCount touches head) ≤
        touchCount touches head *
          (Nat.log2 (touches.length / touchCount touches head) + 1) := by
    intro head
    exact Nat.mul_le_mul_left _
      (inverseFrequencyDist_le_log2_div_add_one hnonempty (hpositive head))
  rw [touchCost_empirical_exact]
  calc
    touches.length + finSum (fun head =>
        touchCount touches head *
          inverseFrequencyDist touches.length (touchCount touches head)) ≤
        touches.length + finSum (fun head =>
          touchCount touches head *
            (Nat.log2 (touches.length / touchCount touches head) + 1)) :=
      Nat.add_le_add_left (finSum_mono hpoint) _
    _ = empiricalFloorLogTotal touches + 2 * touches.length := by
      rw [show (fun head => touchCount touches head *
          (Nat.log2 (touches.length / touchCount touches head) + 1)) =
          (fun head =>
            touchCount touches head *
                Nat.log2 (touches.length / touchCount touches head) +
              touchCount touches head) by
        funext head
        rw [Nat.mul_add, Nat.mul_one]]
      rw [finSum_add, finSum_touchCount]
      simp [empiricalFloorLogTotal]
      omega

#print axioms touchCost_counts
#print axioms distCost_eq_touchCost
#print axioms inverseFrequencyDist_minimal
#print axioms empiricalDists_kraft
#print axioms touchCost_empirical_exact
#print axioms touchCost_empirical_entropy_bound

end Adic.Dyadic
