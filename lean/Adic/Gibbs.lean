import Adic.Entropy

namespace Adic.Dyadic

def floorLogTotal (total : Nat) (counts : Fin k → Nat) : Nat :=
  finSum fun head => counts head * Nat.log2 (total / counts head)

def distCountTotal (counts : Fin k → Nat) (dists : Dists k) : Nat :=
  finSum fun head => counts head * dists head

theorem self_le_two_pow (value : Nat) : value ≤ 2 ^ value := by
  induction value with
  | zero => simp
  | succ value ih =>
      rw [Nat.pow_succ]
      have hpositive : 1 ≤ 2 ^ value := Nat.one_le_two_pow
      omega

theorem count_logDeficit_scaled (total count dist width : Nat)
    (hdist : dist ≤ width) :
    count * (Nat.log2 (total / count) - dist) * 2 ^ width ≤
      total * 2 ^ (width - dist) := by
  let depth := Nat.log2 (total / count)
  by_cases hratio : total / count = 0
  · simp [hratio]
  · by_cases hdeficit : dist ≤ depth
    · have hratioPower : 2 ^ depth ≤ total / count := by
        exact Nat.log2_self_le hratio
      have hcountPower : count * 2 ^ depth ≤ total := by
        calc
          count * 2 ^ depth ≤ count * (total / count) :=
            Nat.mul_le_mul_left count hratioPower
          _ = total / count * count := Nat.mul_comm _ _
          _ ≤ total := Nat.div_mul_le_self _ _
      have hbase : count * (depth - dist) * 2 ^ dist ≤ total := by
        calc
          count * (depth - dist) * 2 ^ dist ≤
              count * 2 ^ (depth - dist) * 2 ^ dist :=
            Nat.mul_le_mul_right (2 ^ dist)
              (Nat.mul_le_mul_left count (self_le_two_pow (depth - dist)))
          _ = count * (2 ^ (depth - dist) * 2 ^ dist) := by ac_rfl
          _ = count * 2 ^ depth := by rw [Nat.pow_sub_mul_pow 2 hdeficit]
          _ ≤ total := hcountPower
      have hscaled := Nat.mul_le_mul_right (2 ^ (width - dist)) hbase
      have hpower : 2 ^ dist * 2 ^ (width - dist) = 2 ^ width := by
        rw [Nat.mul_comm, Nat.pow_sub_mul_pow 2 hdist]
      change count * (depth - dist) * 2 ^ width ≤
        total * 2 ^ (width - dist)
      calc
        count * (depth - dist) * 2 ^ width =
            count * (depth - dist) *
              (2 ^ dist * 2 ^ (width - dist)) := by rw [hpower]
        _ =
            (count * (depth - dist) * 2 ^ dist) *
              2 ^ (width - dist) := by ac_rfl
        _ ≤ total * 2 ^ (width - dist) := hscaled
    · have hdepth : depth ≤ dist := Nat.le_of_not_ge hdeficit
      simp [depth, Nat.sub_eq_zero_of_le hdepth]

theorem kraft_logDeficit_bound (total : Nat) (counts : Fin k → Nat)
    (dists : Dists k) (hKraft : KraftOk dists) :
    finSum (fun head =>
      counts head * (Nat.log2 (total / counts head) - dists head)) ≤ total := by
  let width := maxDist dists
  have hpoint : ∀ head,
      counts head * (Nat.log2 (total / counts head) - dists head) * 2 ^ width ≤
        total * 2 ^ (width - dists head) := by
    intro head
    exact count_logDeficit_scaled total (counts head) (dists head) width
      (dist_le_maxDist dists head)
  have hmass : kraftMassAt width dists ≤ 2 ^ width := by
    exact hKraft
  have hscaled :
      finSum (fun head =>
          counts head * (Nat.log2 (total / counts head) - dists head)) *
          2 ^ width ≤ total * 2 ^ width := by
    calc
      finSum (fun head =>
          counts head * (Nat.log2 (total / counts head) - dists head)) *
          2 ^ width =
          finSum (fun head =>
            counts head * (Nat.log2 (total / counts head) - dists head) *
              2 ^ width) := (finSum_mul_right _ _).symm
      _ ≤ finSum (fun head => total * 2 ^ (width - dists head)) :=
        finSum_mono hpoint
      _ = total * kraftMassAt width dists := by
        rw [kraftMassAt, finSum_mul_left]
      _ ≤ total * 2 ^ width := Nat.mul_le_mul_left total hmass
  exact Nat.le_of_mul_le_mul_right hscaled (Nat.two_pow_pos width)

theorem kraft_floorLog_bound (total : Nat) (counts : Fin k → Nat)
    (dists : Dists k) (hKraft : KraftOk dists) :
    floorLogTotal total counts ≤ distCountTotal counts dists + total := by
  have hpoint : ∀ head,
      counts head * Nat.log2 (total / counts head) ≤
        counts head * dists head +
          counts head * (Nat.log2 (total / counts head) - dists head) := by
    intro head
    have hsplit : Nat.log2 (total / counts head) ≤
        dists head + (Nat.log2 (total / counts head) - dists head) := by
      omega
    calc
      counts head * Nat.log2 (total / counts head) ≤
          counts head *
            (dists head + (Nat.log2 (total / counts head) - dists head)) :=
        Nat.mul_le_mul_left _ hsplit
      _ = counts head * dists head +
          counts head * (Nat.log2 (total / counts head) - dists head) := by
        rw [Nat.mul_add]
  calc
    floorLogTotal total counts ≤
        finSum (fun head =>
          counts head * dists head +
            counts head * (Nat.log2 (total / counts head) - dists head)) :=
      finSum_mono hpoint
    _ = distCountTotal counts dists +
        finSum (fun head =>
          counts head * (Nat.log2 (total / counts head) - dists head)) := by
      rw [finSum_add]
      rfl
    _ ≤ distCountTotal counts dists + total :=
      Nat.add_le_add_left (kraft_logDeficit_bound total counts dists hKraft) _

theorem discrete_gibbs_log_sum (total : Nat) (counts : Fin k → Nat)
    (dists : Dists k) (htotal : finSum counts = total)
    (hKraft : KraftOk dists) :
    floorLogTotal total counts ≤ distCountTotal counts dists + total := by
  simpa only [htotal] using
    kraft_floorLog_bound (finSum counts) counts dists hKraft

theorem touchCost_entropy_lower (dists : Dists k) (touches : List (Fin k))
    (hKraft : KraftOk dists) :
    touches.length + empiricalFloorLogTotal touches ≤
      touchCost dists touches + touches.length := by
  have hGibbs := discrete_gibbs_log_sum touches.length (touchCount touches) dists
    (finSum_touchCount touches) hKraft
  rw [touchCost_counts]
  simp only [empiricalFloorLogTotal, floorLogTotal, distCountTotal] at hGibbs ⊢
  omega

theorem empiricalFloorLogTotal_le_touchCost (dists : Dists k)
    (touches : List (Fin k)) (hKraft : KraftOk dists) :
    empiricalFloorLogTotal touches ≤ touchCost dists touches := by
  have hlower := touchCost_entropy_lower dists touches hKraft
  omega

#print axioms kraft_logDeficit_bound
#print axioms discrete_gibbs_log_sum
#print axioms touchCost_entropy_lower
#print axioms empiricalFloorLogTotal_le_touchCost

end Adic.Dyadic
