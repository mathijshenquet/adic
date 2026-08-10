import Adic.Gibbs

namespace Adic.Dyadic

/-- Kraft mass after grouping `b` binary levels into one macro-level. -/
def blockKraftMassAt (b width : Nat) (dists : Dists h) : Nat :=
  finSum fun head => 2 ^ (b * (width - dists head))

def BlockKraftOk (b : Nat) (dists : Dists h) : Prop :=
  blockKraftMassAt b (maxDist dists) dists ≤ 2 ^ (b * maxDist dists)

def expMomentCost (a : Nat) (counts dists : Dists h) : Nat :=
  finSum fun head => counts head * 2 ^ (a * dists head)

/-- The cumulative price through macro-distance `dist`, including level zero. -/
def blockTravel (a : Nat) : Nat → Nat
  | 0 => 1
  | dist + 1 => blockTravel a dist + 2 ^ (a * (dist + 1))

def blockTravelCost (a : Nat) (counts dists : Dists h) : Nat :=
  finSum fun head => counts head * blockTravel a (dists head)

theorem blockKraftOk_iff (b : Nat) (dists : Dists h) :
    BlockKraftOk b dists ↔
      blockKraftMassAt b (maxDist dists) dists ≤ 2 ^ (b * maxDist dists) := by
  rfl

theorem blockKraft_shift (b width shift : Nat) (dists : Dists h)
    (hwidth : ∀ head, dists head ≤ width) :
    blockKraftMassAt b (width + shift) dists =
      2 ^ (b * shift) * blockKraftMassAt b width dists := by
  unfold blockKraftMassAt
  rw [← finSum_mul_left]
  apply finSum_congr
  intro head
  have hd := hwidth head
  have hsub : width + shift - dists head = (width - dists head) + shift := by
    omega
  rw [hsub, Nat.mul_add, Nat.pow_add]
  ac_rfl

theorem blockTravel_geometric {a dist : Nat} (_ : 0 < a) :
    (2 ^ a - 1) * blockTravel a dist + 1 = 2 ^ (a * (dist + 1)) := by
  induction dist with
  | zero =>
      have hpositive : 1 ≤ 2 ^ a := Nat.one_le_two_pow
      simp [blockTravel]
      omega
  | succ dist ih =>
      have hpow : 2 ^ (a * (dist + 1 + 1)) =
          2 ^ (a * (dist + 1)) * 2 ^ a := by
        rw [show dist + 1 + 1 = (dist + 1) + 1 by omega,
          Nat.mul_succ, Nat.pow_add]
      calc
        (2 ^ a - 1) * blockTravel a (dist + 1) + 1 =
            ((2 ^ a - 1) * blockTravel a dist + 1) +
              (2 ^ a - 1) * 2 ^ (a * (dist + 1)) := by
                rw [blockTravel, Nat.mul_add]
                omega
        _ = 2 ^ (a * (dist + 1)) +
              (2 ^ a - 1) * 2 ^ (a * (dist + 1)) := by rw [ih]
        _ =
            (1 + (2 ^ a - 1)) * 2 ^ (a * (dist + 1)) := by
              rw [Nat.add_mul]
              simp only [Nat.one_mul]
        _ = 2 ^ (a * (dist + 1)) * 2 ^ a := by
              have hpositive : 1 ≤ 2 ^ a := Nat.one_le_two_pow
              have hone : 1 + (2 ^ a - 1) = 2 ^ a := by omega
              rw [hone, Nat.mul_comm]
        _ = 2 ^ (a * (dist + 1 + 1)) := hpow.symm

private theorem blockTravel_pointwise {a count dist : Nat} (ha : 0 < a) :
    (2 ^ a - 1) * (count * blockTravel a dist) + count =
      2 ^ a * (count * 2 ^ (a * dist)) := by
  have hgeom := blockTravel_geometric (a := a) (dist := dist) ha
  have hpow : 2 ^ (a * (dist + 1)) = 2 ^ (a * dist) * 2 ^ a := by
    rw [Nat.mul_succ, Nat.pow_add]
  rw [hpow] at hgeom
  calc
    (2 ^ a - 1) * (count * blockTravel a dist) + count =
        count * ((2 ^ a - 1) * blockTravel a dist + 1) := by
          rw [Nat.mul_add, Nat.mul_one]
          ac_rfl
    _ = count * (2 ^ (a * dist) * 2 ^ a) := by rw [hgeom]
    _ = 2 ^ a * (count * 2 ^ (a * dist)) := by ac_rfl

theorem blockTravelCost_moment_identity {a : Nat} (ha : 0 < a)
    (counts dists : Dists h) :
    (2 ^ a - 1) * blockTravelCost a counts dists + finSum counts =
      2 ^ a * expMomentCost a counts dists := by
  unfold blockTravelCost expMomentCost
  rw [← finSum_mul_left, ← finSum_add, ← finSum_mul_left]
  apply finSum_congr
  intro head
  exact blockTravel_pointwise ha

/-- The least natural `u` whose `r`-th power is at least `value`.
The bounded search is sufficient because `value ≤ value ^ r` for `r > 0`. -/
def ceilRoot (r value : Nat) : Nat :=
  ((List.range (value + 1)).find? fun u => decide (value ≤ u ^ r)).getD 0

def floorRoot (r value : Nat) : Nat := ceilRoot r (value + 1) - 1

theorem le_ceilRoot_pow {r value : Nat} (hr : 0 < r) :
    value ≤ ceilRoot r value ^ r := by
  unfold ceilRoot
  generalize hfind : (List.range (value + 1)).find?
    (fun u => decide (value ≤ u ^ r)) = found
  cases found with
  | none =>
      have hnone := (List.find?_eq_none.mp hfind) value
        (List.mem_range.mpr (Nat.lt_succ_self value))
      have hself : value ≤ value ^ r :=
        Nat.le_self_pow (Nat.ne_of_gt hr) value
      have : ¬ value ≤ value ^ r := by
        simpa only [Bool.not_eq_true, decide_eq_true_eq] using hnone
      exact False.elim (this hself)
  | some root =>
      simp only [Option.getD_some]
      exact of_decide_eq_true (List.find?_range_eq_some.mp hfind).1

theorem ceilRoot_minimal {r value candidate : Nat} (hr : 0 < r) :
    ceilRoot r value ≤ candidate ↔ value ≤ candidate ^ r := by
  constructor
  · intro hroot
    exact Nat.le_trans (le_ceilRoot_pow hr)
      (Nat.pow_le_pow_left hroot r)
  · intro hcandidate
    unfold ceilRoot
    generalize hfind : (List.range (value + 1)).find?
      (fun u => decide (value ≤ u ^ r)) = found
    cases found with
    | none =>
        have hnone := (List.find?_eq_none.mp hfind) value
          (List.mem_range.mpr (Nat.lt_succ_self value))
        have hself : value ≤ value ^ r :=
          Nat.le_self_pow (Nat.ne_of_gt hr) value
        have : ¬ value ≤ value ^ r := by
          intro hle
          have htrue : decide (value ≤ value ^ r) = true :=
            decide_eq_true_eq.mpr hle
          rw [htrue] at hnone
          simp at hnone
        exact False.elim (this hself)
    | some root =>
        simp only [Option.getD_some]
        by_cases hroot : root ≤ candidate
        · exact hroot
        · have hless : candidate < root := Nat.lt_of_not_ge hroot
          have hfirst := (List.find?_range_eq_some.mp hfind).2.2 candidate hless
          have hnot : ¬ value ≤ candidate ^ r := by
            intro hle
            have htrue : decide (value ≤ candidate ^ r) = true :=
              decide_eq_true_eq.mpr hle
            rw [htrue] at hfirst
            simp at hfirst
          exact False.elim (hnot hcandidate)

theorem floorRoot_pow_le {r value : Nat} (hr : 0 < r) :
    floorRoot r value ^ r ≤ value := by
  unfold floorRoot
  by_cases hzero : ceilRoot r (value + 1) = 0
  · rw [hzero, Nat.zero_pow hr]
    exact Nat.zero_le _
  · have hnot : ¬ value + 1 ≤ (ceilRoot r (value + 1) - 1) ^ r := by
      intro hle
      have hminimal := (ceilRoot_minimal hr).2 hle
      omega
    have : (ceilRoot r (value + 1) - 1) ^ r ≤ value := by omega
    exact this

theorem lt_succ_floorRoot_pow {r value : Nat} (hr : 0 < r) :
    value < (floorRoot r value + 1) ^ r := by
  unfold floorRoot
  have hpositive : 0 < ceilRoot r (value + 1) := by
    by_cases hzero : ceilRoot r (value + 1) = 0
    · have hle := le_ceilRoot_pow (value := value + 1) hr
      rw [hzero] at hle
      rw [Nat.zero_pow hr] at hle
      omega
    · exact Nat.pos_of_ne_zero hzero
  have hsucc : ceilRoot r (value + 1) - 1 + 1 = ceilRoot r (value + 1) := by
    omega
  rw [hsucc]
  exact Nat.lt_of_lt_of_le (Nat.lt_succ_self value) (le_ceilRoot_pow hr)

theorem ceilRoot_le_floorRoot_add_one {r value : Nat} (hr : 0 < r) :
    ceilRoot r value ≤ floorRoot r value + 1 := by
  unfold floorRoot
  have hpositive : 0 < ceilRoot r (value + 1) := by
    by_cases hzero : ceilRoot r (value + 1) = 0
    · have hle := le_ceilRoot_pow (value := value + 1) hr
      rw [hzero] at hle
      rw [Nat.zero_pow hr] at hle
      omega
    · exact Nat.pos_of_ne_zero hzero
  have hmono : ceilRoot r value ≤ ceilRoot r (value + 1) := by
    apply (ceilRoot_minimal hr).2
    exact Nat.le_trans (Nat.le_succ value) (le_ceilRoot_pow hr)
  omega

theorem pow_le_pow_iff {exponent left right : Nat} (hexponent : 0 < exponent) :
    left ^ exponent ≤ right ^ exponent ↔ left ≤ right := by
  exact Nat.pow_le_pow_iff_left (Nat.ne_of_gt hexponent)

def escortFloor (a b count : Nat) : Nat := floorRoot (a + b) (count ^ b)

def escortCeil (a b count : Nat) : Nat := ceilRoot (a + b) (count ^ b)

def escortMass (a b : Nat) (counts : Dists h) : Nat :=
  finSum fun head => escortCeil a b (counts head)

def blockInverseFrequencyDist (b total share : Nat) : Nat :=
  ((List.range (total + 1)).find?
    fun dist => decide (total ≤ share * 2 ^ (b * dist))).getD 0

private theorem total_le_block_capacity (b total share : Nat)
    (hb : 0 < b) (hshare : 0 < share) :
    total ≤ share * 2 ^ (b * total) := by
  have hself : total ≤ 2 ^ total := self_le_two_pow total
  have hscale : total ≤ b * total := by
    simpa only [Nat.one_mul] using
      Nat.mul_le_mul_right total (show 1 ≤ b by omega)
  have hpower : 2 ^ total ≤ 2 ^ (b * total) :=
    Nat.pow_le_pow_right (by decide) hscale
  have hone : 1 ≤ share := hshare
  calc
    total ≤ 2 ^ total := hself
    _ ≤ 2 ^ (b * total) := hpower
    _ = 1 * 2 ^ (b * total) := by rw [Nat.one_mul]
    _ ≤ share * 2 ^ (b * total) :=
      Nat.mul_le_mul_right _ (show 1 ≤ share by omega)

theorem blockInverseFrequencyDist_spec {b total share : Nat}
    (hb : 0 < b) (hshare : 0 < share) :
    total ≤ share * 2 ^ (b * blockInverseFrequencyDist b total share) := by
  unfold blockInverseFrequencyDist
  generalize hfind : (List.range (total + 1)).find?
    (fun dist => decide (total ≤ share * 2 ^ (b * dist))) = found
  cases found with
  | none =>
      have hnone := (List.find?_eq_none.mp hfind) total
        (List.mem_range.mpr (Nat.lt_succ_self total))
      have hcapacity := total_le_block_capacity b total share hb hshare
      have : ¬ total ≤ share * 2 ^ (b * total) := by
        simpa only [Bool.not_eq_true, decide_eq_true_eq] using hnone
      exact False.elim (this hcapacity)
  | some dist =>
      simp only [Option.getD_some]
      exact of_decide_eq_true (List.find?_range_eq_some.mp hfind).1

theorem blockInverseFrequencyDist_minimal {b total share dist : Nat}
    (hb : 0 < b) (hshare : 0 < share) :
    blockInverseFrequencyDist b total share ≤ dist ↔
      total ≤ share * 2 ^ (b * dist) := by
  constructor
  · intro hdist
    have hcapacity := blockInverseFrequencyDist_spec (total := total) hb hshare
    have hexp : b * blockInverseFrequencyDist b total share ≤ b * dist :=
      Nat.mul_le_mul_left b hdist
    exact Nat.le_trans hcapacity
      (Nat.mul_le_mul_left share (Nat.pow_le_pow_right (by decide) hexp))
  · intro hcapacity
    unfold blockInverseFrequencyDist
    generalize hfind : (List.range (total + 1)).find?
      (fun e => decide (total ≤ share * 2 ^ (b * e))) = found
    cases found with
    | none =>
        have hnone := (List.find?_eq_none.mp hfind) total
          (List.mem_range.mpr (Nat.lt_succ_self total))
        have htotal := total_le_block_capacity b total share hb hshare
        have : ¬ total ≤ share * 2 ^ (b * total) := by
          simpa only [Bool.not_eq_true, decide_eq_true_eq] using hnone
        exact False.elim (this htotal)
    | some root =>
        simp only [Option.getD_some]
        by_cases hroot : root ≤ dist
        · exact hroot
        · have hless : dist < root := Nat.lt_of_not_ge hroot
          have hfirst := (List.find?_range_eq_some.mp hfind).2.2 dist hless
          have hnot : ¬ total ≤ share * 2 ^ (b * dist) := by
            intro hle
            have htrue : decide (total ≤ share * 2 ^ (b * dist)) = true :=
              decide_eq_true_eq.mpr hle
            rw [htrue] at hfirst
            simp at hfirst
          exact False.elim (hnot hcapacity)

def campbellDists (a b : Nat) (counts : Dists h) : Dists h :=
  fun head => blockInverseFrequencyDist b (escortMass a b counts)
    (escortCeil a b (counts head))

theorem escortCeil_pow {a b count : Nat} (ha : 0 < a) (hb : 0 < b) :
    count ^ b ≤ escortCeil a b count ^ (a + b) := by
  exact le_ceilRoot_pow (by omega)

theorem escortFloor_pow {a b count : Nat} (ha : 0 < a) (hb : 0 < b) :
    escortFloor a b count ^ (a + b) ≤ count ^ b := by
  exact floorRoot_pow_le (by omega)

/-- Aggregate paid macro crossings for the `t = 1/2` schedule through depth `n`.
At macro scale `e`, the price is `2^e` and there are `4^(n-e)` crossings. -/
def twoDimensionalSweep : Nat → Nat
  | 0 => 1
  | n + 1 => 4 * twoDimensionalSweep n + 2 ^ (n + 1)

theorem twoDimensionalSweep_closed (n : Nat) :
    twoDimensionalSweep n = 2 * 4 ^ n - 2 ^ n := by
  induction n with
  | zero => simp [twoDimensionalSweep]
  | succ n ih =>
      rw [twoDimensionalSweep, ih, Nat.pow_succ, Nat.pow_succ]
      have hpow : 2 ^ n ≤ 4 ^ n := by
        rw [show (4 : Nat) = 2 ^ 2 by decide, ← Nat.pow_mul]
        exact Nat.pow_le_pow_right (by decide) (by omega)
      omega

theorem twoDimensionalSweep_bound (n : Nat) :
    twoDimensionalSweep n ≤ 2 * 2 ^ (2 * n) := by
  rw [twoDimensionalSweep_closed]
  have hpow : 4 ^ n = 2 ^ (2 * n) := by
    rw [show (4 : Nat) = 2 ^ 2 by decide, ← Nat.pow_mul]
  rw [hpow]
  exact Nat.le_trans (Nat.sub_le _ _) (by omega)

def threeHeadCounts : Dists 3
  | 0 => 2
  | 1 => 1
  | 2 => 1

theorem threeHead_k2_escort : escortMass 1 2 threeHeadCounts = 4 := by decide

theorem threeHead_k2_dists : campbellDists 1 2 threeHeadCounts = fun _ => 1 := by
  funext head
  exact Fin.cases (by decide) (fun tail =>
    Fin.cases (by decide) (fun tail =>
      Fin.cases (by decide) (fun tail => Fin.elim0 tail) tail) tail) head

theorem threeHead_k2_kraft : BlockKraftOk 2 (campbellDists 1 2 threeHeadCounts) := by
  rw [threeHead_k2_dists]
  change 3 ≤ 4
  decide

theorem threeHead_k2_moment : expMomentCost 1 threeHeadCounts
    (campbellDists 1 2 threeHeadCounts) = 8 := by decide

theorem threeHead_k3_escort : escortMass 1 3 threeHeadCounts = 4 := by decide

theorem threeHead_k3_dists : campbellDists 1 3 threeHeadCounts = fun _ => 1 := by
  funext head
  exact Fin.cases (by decide) (fun tail =>
    Fin.cases (by decide) (fun tail =>
      Fin.cases (by decide) (fun tail => Fin.elim0 tail) tail) tail) head

theorem threeHead_k3_kraft : BlockKraftOk 3 (campbellDists 1 3 threeHeadCounts) := by
  rw [threeHead_k3_dists]
  change 3 ≤ 8
  decide

theorem threeHead_k3_moment : expMomentCost 1 threeHeadCounts
    (campbellDists 1 3 threeHeadCounts) = 8 := by decide

#print axioms blockTravelCost_moment_identity
#print axioms le_ceilRoot_pow
#print axioms ceilRoot_minimal
#print axioms blockInverseFrequencyDist_minimal
#print axioms twoDimensionalSweep_bound
#print axioms threeHead_k2_kraft
#print axioms threeHead_k3_kraft

end Adic.Dyadic
