import Adic.Gibbs

namespace Adic.Dyadic

/-- Reset, then re-select, for every head at its newly assigned distance.
This is the reset-and-reselect canonicalization used by `RamLift`. -/
def remountCost (dists : Dists k) : Nat :=
  finSum fun head => 1 + dists head

def blockCost (block : List (Fin k)) : Nat :=
  remountCost (empiricalDists block) +
    touchCost (empiricalDists block) block

def adaptiveCost (blocks : List (List (Fin k))) : Nat :=
  (blocks.map blockCost).sum

def blockFloorLog (block : List (Fin k)) : Nat :=
  empiricalFloorLogTotal block

def totalBlockFloorLog (blocks : List (List (Fin k))) : Nat :=
  (blocks.map blockFloorLog).sum

def totalBlockLength (blocks : List (List (Fin k))) : Nat :=
  (blocks.map List.length).sum

def totalRemountCost (blocks : List (List (Fin k))) : Nat :=
  (blocks.map fun block => remountCost (empiricalDists block)).sum

theorem touchCost_empirical_entropy_bound_zero_safe
    (touches : List (Fin k)) :
    touchCost (empiricalDists touches) touches ≤
      empiricalFloorLogTotal touches + 2 * touches.length := by
  cases touches with
  | nil => simp [touchCost, empiricalFloorLogTotal]
  | cons touched rest =>
      have hnonempty : 0 < (touched :: rest).length := by simp
      have hpoint : ∀ head,
          touchCount (touched :: rest) head *
              inverseFrequencyDist (touched :: rest).length
                (touchCount (touched :: rest) head) ≤
            touchCount (touched :: rest) head *
              (Nat.log2 ((touched :: rest).length /
                touchCount (touched :: rest) head) + 1) := by
        intro head
        by_cases hzero : touchCount (touched :: rest) head = 0
        · simp [hzero]
        · exact Nat.mul_le_mul_left _
            (inverseFrequencyDist_le_log2_div_add_one hnonempty
              (Nat.pos_of_ne_zero hzero))
      rw [touchCost_empirical_exact]
      calc
        (touched :: rest).length + finSum (fun head =>
            touchCount (touched :: rest) head *
              inverseFrequencyDist (touched :: rest).length
                (touchCount (touched :: rest) head)) ≤
            (touched :: rest).length + finSum (fun head =>
              touchCount (touched :: rest) head *
                (Nat.log2 ((touched :: rest).length /
                  touchCount (touched :: rest) head) + 1)) :=
          Nat.add_le_add_left (finSum_mono hpoint) _
        _ = empiricalFloorLogTotal (touched :: rest) +
              2 * (touched :: rest).length := by
          rw [show (fun head => touchCount (touched :: rest) head *
              (Nat.log2 ((touched :: rest).length /
                touchCount (touched :: rest) head) + 1)) =
              (fun head =>
                touchCount (touched :: rest) head *
                    Nat.log2 ((touched :: rest).length /
                      touchCount (touched :: rest) head) +
                  touchCount (touched :: rest) head) by
            funext head
            rw [Nat.mul_add, Nat.mul_one]]
          rw [finSum_add, finSum_touchCount]
          simp [empiricalFloorLogTotal]
          omega

theorem adaptiveCost_entropy_upper (blocks : List (List (Fin k))) :
    adaptiveCost blocks ≤
      (blocks.map fun block =>
        blockFloorLog block + 2 * block.length).sum +
      totalRemountCost blocks := by
  induction blocks with
  | nil => simp [adaptiveCost, totalRemountCost]
  | cons block blocks ih =>
      unfold adaptiveCost totalRemountCost at ih ⊢
      simp only [List.map_cons, List.sum_cons]
      have hblock := touchCost_empirical_entropy_bound_zero_safe block
      simp only [blockCost, blockFloorLog] at ih ⊢
      omega

theorem adaptiveCost_entropy_rate (blocks : List (List (Fin k))) :
    adaptiveCost blocks ≤
      totalBlockFloorLog blocks + 2 * totalBlockLength blocks +
        totalRemountCost blocks := by
  have hsum :
      (blocks.map fun block =>
        blockFloorLog block + 2 * block.length).sum =
        totalBlockFloorLog blocks + 2 * totalBlockLength blocks := by
    induction blocks with
    | nil => simp [totalBlockFloorLog, totalBlockLength]
    | cons block blocks ih =>
        unfold totalBlockFloorLog totalBlockLength at ih ⊢
        simp only [List.map_cons, List.sum_cons]
        omega
  rw [← hsum]
  exact adaptiveCost_entropy_upper blocks

theorem touchCount_append (left right : List (Fin k)) (head : Fin k) :
    touchCount (left ++ right) head =
      touchCount left head + touchCount right head := by
  induction left with
  | nil => simp [touchCount]
  | cons touched left ih =>
      simp only [List.cons_append, touchCount]
      rw [ih]
      omega

@[simp] theorem touchCount_replicate (count : Nat) (touched head : Fin k) :
    touchCount (List.replicate count touched) head =
      if head = touched then count else 0 := by
  induction count with
  | zero => simp [touchCount]
  | succ count ih =>
      simp [List.replicate_succ, touchCount, ih]
      split <;> omega

def skewedFourBlock0 : List (Fin 4) := List.replicate 61 0 ++ [1, 2, 3]

def skewedFourBlock1 : List (Fin 4) := List.replicate 61 1 ++ [0, 2, 3]

def skewedFourBlock2 : List (Fin 4) := List.replicate 61 2 ++ [0, 1, 3]

def skewedFourBlock3 : List (Fin 4) := List.replicate 61 3 ++ [0, 1, 2]

def skewedFourBlocks : List (List (Fin 4)) :=
  [skewedFourBlock0, skewedFourBlock1,
    skewedFourBlock2, skewedFourBlock3]

def skewedFourTouches : List (Fin 4) := skewedFourBlocks.flatten

theorem skewedFour_blocks_kraft :
    ∀ block ∈ skewedFourBlocks, KraftOk (empiricalDists block) := by
  intro block hblock
  simp [skewedFourBlocks] at hblock
  rcases hblock with rfl | rfl | rfl | rfl
  all_goals
    exact empiricalDists_kraft _ (by decide) (by decide)

set_option maxRecDepth 10000 in
theorem skewedFour_adaptive_exact :
    adaptiveCost skewedFourBlocks = 664 := by
  decide +kernel

set_option maxRecDepth 10000 in
theorem skewedFour_floorLog :
    empiricalFloorLogTotal skewedFourTouches = 512 := by
  decide +kernel

theorem skewedFour_static_gibbs_lower (dists : Dists 4)
    (hKraft : KraftOk dists) :
    512 ≤ touchCost dists skewedFourTouches := by
  rw [← skewedFour_floorLog]
  exact empiricalFloorLogTotal_le_touchCost dists _ hKraft

private theorem distance_zero_impossible
    (first second third fourth width : Nat)
    (hmass :
      2 ^ (width - first) + 2 ^ (width - second) +
        2 ^ (width - third) + 2 ^ (width - fourth) ≤ 2 ^ width) :
    first ≠ 0 := by
  intro hzero
  rw [hzero] at hmass
  simp only [Nat.sub_zero] at hmass
  have hsecond : 0 < 2 ^ (width - second) := Nat.two_pow_pos _
  have hthird : 0 < 2 ^ (width - third) := Nat.two_pow_pos _
  have hfourth : 0 < 2 ^ (width - fourth) := Nat.two_pow_pos _
  omega

private theorem two_distance_one_impossible
    (first second third fourth width : Nat)
    (hfirst : first ≤ width)
    (hmass :
      2 ^ (width - first) + 2 ^ (width - second) +
        2 ^ (width - third) + 2 ^ (width - fourth) ≤ 2 ^ width) :
    ¬(first = 1 ∧ second = 1) := by
  rintro ⟨hfirstOne, hsecondOne⟩
  rw [hfirstOne] at hfirst
  rw [hfirstOne, hsecondOne] at hmass
  have hdouble := Nat.pow_sub_mul_pow 2 hfirst
  have hthird : 0 < 2 ^ (width - third) := Nat.two_pow_pos _
  have hfourth : 0 < 2 ^ (width - fourth) := Nat.two_pow_pos _
  simp only [Nat.pow_one] at hdouble
  omega

theorem fourDists_sum_lower (dists : Dists 4)
    (hKraft : KraftOk dists) :
    8 ≤ finSum dists := by
  by_cases hlarge : 8 ≤ finSum dists
  · exact hlarge
  have hsum : dists 0 + dists 1 + dists 2 + dists 3 < 8 := by
    have hraw := Nat.lt_of_not_ge hlarge
    simp only [finSum] at hraw
    simpa only [Nat.add_assoc,
      show (1 : Fin 4) = Fin.succ 0 by decide,
      show (2 : Fin 4) = Fin.succ (Fin.succ 0) by decide,
      show (3 : Fin 4) = Fin.succ (Fin.succ (Fin.succ 0)) by decide] using hraw
  let width := maxDist dists
  have hmass :
      2 ^ (width - dists 0) + 2 ^ (width - dists 1) +
        2 ^ (width - dists 2) + 2 ^ (width - dists 3) ≤ 2 ^ width := by
    simpa [KraftOk, kraftMassAt, finSum, width, Nat.add_assoc] using hKraft
  have hzero0 := distance_zero_impossible
    (dists 0) (dists 1) (dists 2) (dists 3) width hmass
  have hzero1 := distance_zero_impossible
    (dists 1) (dists 0) (dists 2) (dists 3) width (by
      simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using hmass)
  have hzero2 := distance_zero_impossible
    (dists 2) (dists 0) (dists 1) (dists 3) width (by
      simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using hmass)
  have hzero3 := distance_zero_impossible
    (dists 3) (dists 0) (dists 1) (dists 2) width (by
      simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using hmass)
  have h01 := two_distance_one_impossible
    (dists 0) (dists 1) (dists 2) (dists 3) width
      (dist_le_maxDist dists 0) hmass
  have h02 := two_distance_one_impossible
    (dists 0) (dists 2) (dists 1) (dists 3) width
      (dist_le_maxDist dists 0) (by
        simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using hmass)
  have h03 := two_distance_one_impossible
    (dists 0) (dists 3) (dists 1) (dists 2) width
      (dist_le_maxDist dists 0) (by
        simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using hmass)
  have h12 := two_distance_one_impossible
    (dists 1) (dists 2) (dists 0) (dists 3) width
      (dist_le_maxDist dists 1) (by
        simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using hmass)
  have h13 := two_distance_one_impossible
    (dists 1) (dists 3) (dists 0) (dists 2) width
      (dist_le_maxDist dists 1) (by
        simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using hmass)
  have h23 := two_distance_one_impossible
    (dists 2) (dists 3) (dists 0) (dists 1) width
      (dist_le_maxDist dists 2) (by
        simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using hmass)
  have hone :
      dists 0 = 1 ∨ dists 1 = 1 ∨ dists 2 = 1 ∨ dists 3 = 1 := by
    omega
  rcases hone with hone | hone | hone | hone
  · have hne1 : dists 1 ≠ 1 := fun h => h01 ⟨hone, h⟩
    have hne2 : dists 2 ≠ 1 := fun h => h02 ⟨hone, h⟩
    have hne3 : dists 3 ≠ 1 := fun h => h03 ⟨hone, h⟩
    have heq1 : dists 1 = 2 := by omega
    have heq2 : dists 2 = 2 := by omega
    have heq3 : dists 3 = 2 := by omega
    simp [width, maxDist, hone, heq1, heq2, heq3] at hmass
  · have hne0 : dists 0 ≠ 1 := fun h => h01 ⟨h, hone⟩
    have hne2 : dists 2 ≠ 1 := fun h => h12 ⟨hone, h⟩
    have hne3 : dists 3 ≠ 1 := fun h => h13 ⟨hone, h⟩
    have heq0 : dists 0 = 2 := by omega
    have heq2 : dists 2 = 2 := by omega
    have heq3 : dists 3 = 2 := by omega
    simp [width, maxDist, hone, heq0, heq2, heq3] at hmass
  · have hne0 : dists 0 ≠ 1 := fun h => h02 ⟨h, hone⟩
    have hne1 : dists 1 ≠ 1 := fun h => h12 ⟨h, hone⟩
    have hne3 : dists 3 ≠ 1 := fun h => h23 ⟨hone, h⟩
    have heq0 : dists 0 = 2 := by omega
    have heq1 : dists 1 = 2 := by omega
    have heq3 : dists 3 = 2 := by omega
    simp [width, maxDist, hone, heq0, heq1, heq3] at hmass
  · have hne0 : dists 0 ≠ 1 := fun h => h03 ⟨h, hone⟩
    have hne1 : dists 1 ≠ 1 := fun h => h13 ⟨h, hone⟩
    have hne2 : dists 2 ≠ 1 := fun h => h23 ⟨h, hone⟩
    have heq0 : dists 0 = 2 := by omega
    have heq1 : dists 1 = 2 := by omega
    have heq2 : dists 2 = 2 := by omega
    simp [width, maxDist, hone, heq0, heq1, heq2] at hmass

set_option maxRecDepth 10000 in
theorem skewedFour_touchCost (dists : Dists 4) :
    touchCost dists skewedFourTouches = 256 + 64 * finSum dists := by
  have hlength : skewedFourTouches.length = 256 := by decide +kernel
  have hcounts : ∀ head, touchCount skewedFourTouches head = 64 := by
    intro head
    refine Fin.cases (by decide +kernel) (fun tail => ?_) head
    refine Fin.cases (by decide +kernel) (fun tail => ?_) tail
    refine Fin.cases (by decide +kernel) (fun tail => ?_) tail
    refine Fin.cases (by decide +kernel) (fun tail => ?_) tail
    exact Fin.elim0 tail
  rw [touchCost_counts, hlength]
  have hweighted :
      finSum (fun head => touchCount skewedFourTouches head * dists head) =
        finSum (fun head => 64 * dists head) := by
    apply finSum_congr
    intro head
    rw [hcounts head]
  rw [hweighted, finSum_mul_left]

theorem skewedFour_static_lower (dists : Dists 4)
    (hKraft : KraftOk dists) :
    768 ≤ touchCost dists skewedFourTouches := by
  rw [skewedFour_touchCost]
  have hsum := fourDists_sum_lower dists hKraft
  omega

theorem adaptive_beats_static (dists : Dists 4)
    (hKraft : KraftOk dists) :
    adaptiveCost skewedFourBlocks < touchCost dists skewedFourTouches := by
  rw [skewedFour_adaptive_exact]
  exact Nat.lt_of_lt_of_le (by decide) (skewedFour_static_lower dists hKraft)

#print axioms adaptiveCost_entropy_upper
#print axioms adaptiveCost_entropy_rate
#print axioms skewedFour_adaptive_exact
#print axioms skewedFour_static_gibbs_lower
#print axioms skewedFour_static_lower
#print axioms adaptive_beats_static

end Adic.Dyadic
