import Adic.Entropy

namespace Adic.Dyadic

def floorLogTotal (total : Nat) (counts : Fin k → Nat) : Nat :=
  finSum fun head => counts head * Nat.log2 (total / counts head)

def weightedCountTotal (counts : Fin k → Nat) (weights : Weights k) : Nat :=
  finSum fun head => counts head * weights head

theorem self_le_two_pow (value : Nat) : value ≤ 2 ^ value := by
  induction value with
  | zero => simp
  | succ value ih =>
      rw [Nat.pow_succ]
      have hpositive : 1 ≤ 2 ^ value := Nat.one_le_two_pow
      omega

theorem count_logDeficit_scaled (total count weight width : Nat)
    (hweight : weight ≤ width) :
    count * (Nat.log2 (total / count) - weight) * 2 ^ width ≤
      total * 2 ^ (width - weight) := by
  let depth := Nat.log2 (total / count)
  by_cases hratio : total / count = 0
  · simp [hratio]
  · by_cases hdeficit : weight ≤ depth
    · have hratioPower : 2 ^ depth ≤ total / count := by
        exact Nat.log2_self_le hratio
      have hcountPower : count * 2 ^ depth ≤ total := by
        calc
          count * 2 ^ depth ≤ count * (total / count) :=
            Nat.mul_le_mul_left count hratioPower
          _ = total / count * count := Nat.mul_comm _ _
          _ ≤ total := Nat.div_mul_le_self _ _
      have hbase : count * (depth - weight) * 2 ^ weight ≤ total := by
        calc
          count * (depth - weight) * 2 ^ weight ≤
              count * 2 ^ (depth - weight) * 2 ^ weight :=
            Nat.mul_le_mul_right (2 ^ weight)
              (Nat.mul_le_mul_left count (self_le_two_pow (depth - weight)))
          _ = count * (2 ^ (depth - weight) * 2 ^ weight) := by ac_rfl
          _ = count * 2 ^ depth := by rw [Nat.pow_sub_mul_pow 2 hdeficit]
          _ ≤ total := hcountPower
      have hscaled := Nat.mul_le_mul_right (2 ^ (width - weight)) hbase
      have hpower : 2 ^ weight * 2 ^ (width - weight) = 2 ^ width := by
        rw [Nat.mul_comm, Nat.pow_sub_mul_pow 2 hweight]
      change count * (depth - weight) * 2 ^ width ≤
        total * 2 ^ (width - weight)
      calc
        count * (depth - weight) * 2 ^ width =
            count * (depth - weight) *
              (2 ^ weight * 2 ^ (width - weight)) := by rw [hpower]
        _ =
            (count * (depth - weight) * 2 ^ weight) *
              2 ^ (width - weight) := by ac_rfl
        _ ≤ total * 2 ^ (width - weight) := hscaled
    · have hdepth : depth ≤ weight := Nat.le_of_not_ge hdeficit
      simp [depth, Nat.sub_eq_zero_of_le hdepth]

theorem kraft_logDeficit_bound (total : Nat) (counts : Fin k → Nat)
    (weights : Weights k) (hKraft : KraftOk weights) :
    finSum (fun head =>
      counts head * (Nat.log2 (total / counts head) - weights head)) ≤ total := by
  let width := maxWeight weights
  have hpoint : ∀ head,
      counts head * (Nat.log2 (total / counts head) - weights head) * 2 ^ width ≤
        total * 2 ^ (width - weights head) := by
    intro head
    exact count_logDeficit_scaled total (counts head) (weights head) width
      (weight_le_maxWeight weights head)
  have hmass : kraftMassAt width weights ≤ 2 ^ width := by
    exact hKraft
  have hscaled :
      finSum (fun head =>
          counts head * (Nat.log2 (total / counts head) - weights head)) *
          2 ^ width ≤ total * 2 ^ width := by
    calc
      finSum (fun head =>
          counts head * (Nat.log2 (total / counts head) - weights head)) *
          2 ^ width =
          finSum (fun head =>
            counts head * (Nat.log2 (total / counts head) - weights head) *
              2 ^ width) := (finSum_mul_right _ _).symm
      _ ≤ finSum (fun head => total * 2 ^ (width - weights head)) :=
        finSum_mono hpoint
      _ = total * kraftMassAt width weights := by
        rw [kraftMassAt, finSum_mul_left]
      _ ≤ total * 2 ^ width := Nat.mul_le_mul_left total hmass
  exact Nat.le_of_mul_le_mul_right hscaled (Nat.two_pow_pos width)

theorem kraft_floorLog_bound (total : Nat) (counts : Fin k → Nat)
    (weights : Weights k) (hKraft : KraftOk weights) :
    floorLogTotal total counts ≤ weightedCountTotal counts weights + total := by
  have hpoint : ∀ head,
      counts head * Nat.log2 (total / counts head) ≤
        counts head * weights head +
          counts head * (Nat.log2 (total / counts head) - weights head) := by
    intro head
    have hsplit : Nat.log2 (total / counts head) ≤
        weights head + (Nat.log2 (total / counts head) - weights head) := by
      omega
    calc
      counts head * Nat.log2 (total / counts head) ≤
          counts head *
            (weights head + (Nat.log2 (total / counts head) - weights head)) :=
        Nat.mul_le_mul_left _ hsplit
      _ = counts head * weights head +
          counts head * (Nat.log2 (total / counts head) - weights head) := by
        rw [Nat.mul_add]
  calc
    floorLogTotal total counts ≤
        finSum (fun head =>
          counts head * weights head +
            counts head * (Nat.log2 (total / counts head) - weights head)) :=
      finSum_mono hpoint
    _ = weightedCountTotal counts weights +
        finSum (fun head =>
          counts head * (Nat.log2 (total / counts head) - weights head)) := by
      rw [finSum_add]
      rfl
    _ ≤ weightedCountTotal counts weights + total :=
      Nat.add_le_add_left (kraft_logDeficit_bound total counts weights hKraft) _

theorem discrete_gibbs_log_sum (total : Nat) (counts : Fin k → Nat)
    (weights : Weights k) (htotal : finSum counts = total)
    (hKraft : KraftOk weights) :
    floorLogTotal total counts ≤ weightedCountTotal counts weights + total := by
  simpa only [htotal] using
    kraft_floorLog_bound (finSum counts) counts weights hKraft

theorem touchCost_entropy_lower (weights : Weights k) (touches : List (Fin k))
    (hKraft : KraftOk weights) :
    touches.length + empiricalFloorLogTotal touches ≤
      touchCost weights touches + touches.length := by
  have hGibbs := discrete_gibbs_log_sum touches.length (touchCount touches) weights
    (finSum_touchCount touches) hKraft
  rw [touchCost_counts]
  simp only [empiricalFloorLogTotal, floorLogTotal, weightedCountTotal] at hGibbs ⊢
  omega

theorem empiricalFloorLogTotal_le_touchCost (weights : Weights k)
    (touches : List (Fin k)) (hKraft : KraftOk weights) :
    empiricalFloorLogTotal touches ≤ touchCost weights touches := by
  have hlower := touchCost_entropy_lower weights touches hKraft
  omega

#print axioms kraft_logDeficit_bound
#print axioms discrete_gibbs_log_sum
#print axioms touchCost_entropy_lower
#print axioms empiricalFloorLogTotal_le_touchCost

end Adic.Dyadic
