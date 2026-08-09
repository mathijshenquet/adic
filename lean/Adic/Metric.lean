import Adic.Dyadic

namespace Adic.Dyadic

def longestCommonPrefix : List Bool → List Bool → List Bool
  | left :: lefts, right :: rights =>
      if left = right then left :: longestCommonPrefix lefts rights else []
  | _, _ => []

def structuralDistance : List Bool → List Bool → Nat
  | [], right => right.length
  | left, [] => left.length
  | left :: lefts, right :: rights =>
      if left = right then structuralDistance lefts rights
      else lefts.length + rights.length + 2

theorem lcp_length_le_left (left right : List Bool) :
    (longestCommonPrefix left right).length ≤ left.length := by
  induction left generalizing right with
  | nil => simp [longestCommonPrefix]
  | cons bit left ih =>
      cases right with
      | nil => simp [longestCommonPrefix]
      | cons other right =>
          by_cases h : bit = other
          · simp [longestCommonPrefix, h, ih]
          · simp [longestCommonPrefix, h]

theorem lcp_length_le_right (left right : List Bool) :
    (longestCommonPrefix left right).length ≤ right.length := by
  induction left generalizing right with
  | nil => simp [longestCommonPrefix]
  | cons bit left ih =>
      cases right with
      | nil => simp [longestCommonPrefix]
      | cons other right =>
          by_cases h : bit = other
          · simp [longestCommonPrefix, h, ih]
          · simp [longestCommonPrefix, h]

theorem structuralDistance_lcp (left right : List Bool) :
    structuralDistance left right + 2 * (longestCommonPrefix left right).length =
      left.length + right.length := by
  induction left generalizing right with
  | nil => simp [structuralDistance, longestCommonPrefix]
  | cons bit left ih =>
      cases right with
      | nil => simp [structuralDistance, longestCommonPrefix]
      | cons other right =>
          by_cases h : bit = other
          · simp [structuralDistance, longestCommonPrefix, h]
            have := ih right
            omega
          · simp [structuralDistance, longestCommonPrefix, h]
            omega

theorem structuralDistance_eq_lcp_formula (left right : List Bool) :
    structuralDistance left right =
      left.length + right.length - 2 * (longestCommonPrefix left right).length := by
  have hleft := lcp_length_le_left left right
  have hright := lcp_length_le_right left right
  have heq := structuralDistance_lcp left right
  omega

theorem structuralDistance_append_edge (source target : List Bool) (bit : Bool) :
    structuralDistance (source ++ [bit]) target ≤ structuralDistance source target + 1 ∧
    structuralDistance source target ≤ structuralDistance (source ++ [bit]) target + 1 := by
  induction source generalizing target with
  | nil =>
      cases target with
      | nil => simp [structuralDistance]
      | cons other target =>
          cases bit <;> cases other <;> simp [structuralDistance] <;> omega
  | cons first source ih =>
      cases target with
      | nil => simp [structuralDistance]
      | cons other target =>
          cases first <;> cases other <;>
            simp [structuralDistance, ih] <;> omega

theorem structuralDistance_comm (left right : List Bool) :
    structuralDistance left right = structuralDistance right left := by
  induction left generalizing right with
  | nil => cases right <;> simp [structuralDistance]
  | cons bit left ih =>
      cases right with
      | nil => simp [structuralDistance]
      | cons other right =>
          by_cases h : bit = other
          · subst other
            simp [structuralDistance, ih]
          · have h' : ¬other = bit := by exact fun equality => h equality.symm
            simp [structuralDistance, h, h']
            omega

theorem structuralDistance_append_of_length_le (source target : List Bool) (bit : Bool)
    (hlength : target.length ≤ source.length) :
    structuralDistance (source ++ [bit]) target = structuralDistance source target + 1 := by
  induction source generalizing target with
  | nil =>
      have : target = [] := List.eq_nil_of_length_eq_zero (Nat.eq_zero_of_le_zero hlength)
      subst target
      simp [structuralDistance]
  | cons first source ih =>
      cases target with
      | nil => simp [structuralDistance]
      | cons other target =>
          have htail : target.length ≤ source.length := by simpa using hlength
          cases first <;> cases other <;>
            simp [structuralDistance, ih target htail] <;> omega

theorem structuralDistance_append_right_of_length_le (source target : List Bool) (bit : Bool)
    (hlength : source.length ≤ target.length) :
    structuralDistance source (target ++ [bit]) = structuralDistance source target + 1 := by
  rw [structuralDistance_comm source (target ++ [bit]),
    structuralDistance_append_of_length_le target source bit hlength,
    structuralDistance_comm target source]

theorem structuralDistance_append_both_of_eq_length
    (source target : List Bool) (sourceBit targetBit : Bool)
    (hlength : source.length = target.length)
    (hne : source ++ [sourceBit] ≠ target ++ [targetBit]) :
    structuralDistance (source ++ [sourceBit]) (target ++ [targetBit]) =
      structuralDistance source target + 2 := by
  induction source generalizing target with
  | nil =>
      have : target = [] := List.eq_nil_of_length_eq_zero hlength.symm
      subst target
      cases sourceBit <;> cases targetBit <;> simp_all [structuralDistance]
  | cons first source ih =>
      cases target with
      | nil => simp at hlength
      | cons other target =>
          have htail : source.length = target.length := by simpa using hlength
          cases first <;> cases other
          · have hneTail : source ++ [sourceBit] ≠ target ++ [targetBit] := by
              intro equality
              apply hne
              simpa using congrArg (List.cons false) equality
            simpa [structuralDistance] using ih target htail hneTail
          · simp [structuralDistance]
            omega
          · simp [structuralDistance]
            omega
          · have hneTail : source ++ [sourceBit] ≠ target ++ [targetBit] := by
              intro equality
              apply hne
              simpa using congrArg (List.cons true) equality
            simpa [structuralDistance] using ih target htail hneTail

def directedStructural : List Bool → List Bool → Nat
  | [], target => target.length
  | _ :: _, [] => 0
  | sourceBit :: source, targetBit :: target =>
      if sourceBit = targetBit then directedStructural source target else target.length + 1

theorem directedStructural_lcp (source target : List Bool) :
    directedStructural source target + (longestCommonPrefix source target).length =
      target.length := by
  induction source generalizing target with
  | nil => simp [directedStructural, longestCommonPrefix]
  | cons sourceBit source ih =>
      cases target with
      | nil => simp [directedStructural, longestCommonPrefix]
      | cons targetBit target =>
          by_cases h : sourceBit = targetBit
          · simp [directedStructural, longestCommonPrefix, h]
            have := ih target
            omega
          · simp [directedStructural, longestCommonPrefix, h]

theorem directedStructural_eq_lcp_formula (source target : List Bool) :
    directedStructural source target =
      target.length - (longestCommonPrefix source target).length := by
  have hlcp := lcp_length_le_right source target
  have heq := directedStructural_lcp source target
  omega

theorem directedStructural_append_source (source target : List Bool) (bit : Bool) :
    directedStructural (source ++ [bit]) target ≤ directedStructural source target ∧
      directedStructural source target ≤ directedStructural (source ++ [bit]) target + 1 := by
  induction source generalizing target with
  | nil =>
      cases target with
      | nil => simp [directedStructural]
      | cons targetBit target =>
          cases bit <;> cases targetBit <;> simp [directedStructural] <;> omega
  | cons sourceBit source ih =>
      cases target with
      | nil => simp [directedStructural]
      | cons targetBit target =>
          cases sourceBit <;> cases targetBit <;>
            simp [directedStructural, ih] <;> omega

theorem directedStructural_append_target_of_length_le (source target : List Bool)
    (bit : Bool) (hlength : source.length ≤ target.length) :
    directedStructural source (target ++ [bit]) = directedStructural source target + 1 := by
  induction source generalizing target with
  | nil => simp [directedStructural]
  | cons sourceBit source ih =>
      cases target with
      | nil => simp at hlength
      | cons targetBit target =>
          have htail : source.length ≤ target.length := by simpa using hlength
          cases sourceBit <;> cases targetBit <;>
            simp [directedStructural, ih target htail] <;> omega

theorem directedStructural_append_both_of_eq_length
    (source target : List Bool) (sourceBit targetBit : Bool)
    (hlength : source.length = target.length)
    (hne : source ++ [sourceBit] ≠ target ++ [targetBit]) :
    directedStructural (source ++ [sourceBit]) (target ++ [targetBit]) =
      directedStructural source target + 1 := by
  induction source generalizing target with
  | nil =>
      have : target = [] := List.eq_nil_of_length_eq_zero hlength.symm
      subst target
      cases sourceBit <;> cases targetBit <;> simp_all [directedStructural]
  | cons first source ih =>
      cases target with
      | nil => simp at hlength
      | cons other target =>
          have htail : source.length = target.length := by simpa using hlength
          cases first <;> cases other
          · have hneTail : source ++ [sourceBit] ≠ target ++ [targetBit] := by
              intro equality
              apply hne
              simpa using congrArg (List.cons false) equality
            simpa [directedStructural] using ih target htail hneTail
          · simp [directedStructural]
          · simp [directedStructural]
          · have hneTail : source ++ [sourceBit] ≠ target ++ [targetBit] := by
              intro equality
              apply hne
              simpa using congrArg (List.cons true) equality
            simpa [directedStructural] using ih target htail hneTail

theorem directedStructural_append_source_of_length_le
    (source target : List Bool) (bit : Bool) (hlength : target.length ≤ source.length) :
    directedStructural (source ++ [bit]) target = directedStructural source target := by
  induction source generalizing target with
  | nil =>
      have : target = [] := List.eq_nil_of_length_eq_zero (Nat.eq_zero_of_le_zero hlength)
      subst target
      simp [directedStructural]
  | cons sourceBit source ih =>
      cases target with
      | nil => simp [directedStructural]
      | cons targetBit target =>
          have htail : target.length ≤ source.length := by simpa using hlength
          cases sourceBit <;> cases targetBit <;>
            simp [directedStructural, ih target htail]

def headPath (head : Head n) : List Bool := head.2.path

def Cursor.reversePath : Cursor total remaining → List Bool
  | .root => []
  | .left parent => false :: parent.reversePath
  | .right parent => true :: parent.reversePath

@[simp] theorem Cursor.reversePath_length (cursor : Cursor total remaining) :
    cursor.reversePath.length + remaining = total := by
  induction cursor with
  | root => simp [reversePath]
  | left parent ih => simp [reversePath]; omega
  | right parent ih => simp [reversePath]; omega

theorem Cursor.path_eq_reversePath_reverse (cursor : Cursor total remaining) :
    cursor.path = cursor.reversePath.reverse := by
  induction cursor with
  | root => rfl
  | left parent ih => simp [Cursor.path, reversePath, ih]
  | right parent ih => simp [Cursor.path, reversePath, ih]

theorem Cursor.reversePath_injective (left right : Cursor total remaining)
    (heq : left.reversePath = right.reversePath) : left = right := by
  induction left with
  | root =>
      cases right with
      | root => rfl
      | left other => simp [reversePath] at heq
      | right other => simp [reversePath] at heq
  | left parent ih =>
      cases right with
      | root => simp [reversePath] at heq
      | left other =>
          simp [reversePath] at heq
          exact congrArg Cursor.left (ih other heq)
      | right other => simp [reversePath] at heq
  | right parent ih =>
      cases right with
      | root => simp [reversePath] at heq
      | left other => simp [reversePath] at heq
      | right other =>
          simp [reversePath] at heq
          exact congrArg Cursor.right (ih other heq)

theorem Cursor.path_injective (left right : Cursor total remaining)
    (heq : left.path = right.path) : left = right := by
  apply Cursor.reversePath_injective left right
  simpa [Cursor.path_eq_reversePath_reverse] using congrArg List.reverse heq

theorem headPath_length (head : Head n) : (headPath head).length + head.1 = n := by
  obtain ⟨remaining, cursor⟩ := head
  rw [headPath, Cursor.path_eq_reversePath_reverse, List.length_reverse]
  exact Cursor.reversePath_length cursor

theorem headPath_injective : Function.Injective (@headPath n) := by
  intro left right heq
  obtain ⟨leftRemaining, leftCursor⟩ := left
  obtain ⟨rightRemaining, rightCursor⟩ := right
  have hleft := headPath_length (n := n) ⟨leftRemaining, leftCursor⟩
  have hright := headPath_length (n := n) ⟨rightRemaining, rightCursor⟩
  have hlength := congrArg List.length heq
  change leftCursor.path.length + leftRemaining = n at hleft
  change rightCursor.path.length + rightRemaining = n at hright
  change leftCursor.path.length = rightCursor.path.length at hlength
  have hremaining : leftRemaining = rightRemaining := by
    omega
  subst rightRemaining
  have hcursor : leftCursor = rightCursor := by
    apply Cursor.path_injective
    change leftCursor.path = rightCursor.path at heq
    exact heq
  subst rightCursor
  rfl

def treeDistance (source target : Head n) : Nat :=
  (headPath source).length + (headPath target).length -
    2 * (longestCommonPrefix (headPath source) (headPath target)).length

theorem treeDistance_eq_structural (source target : Head n) :
    treeDistance source target = structuralDistance (headPath source) (headPath target) := by
  simpa [treeDistance] using
    (structuralDistance_eq_lcp_formula (headPath source) (headPath target)).symm

def directedDistance (source target : Head n) : Nat :=
  (headPath target).length -
    (longestCommonPrefix (headPath source) (headPath target)).length

theorem directedDistance_eq_structural (source target : Head n) :
    directedDistance source target =
      directedStructural (headPath source) (headPath target) := by
  simpa [directedDistance] using
    (directedStructural_eq_lcp_formula (headPath source) (headPath target)).symm

@[simp] theorem directedStructural_self (path : List Bool) :
    directedStructural path path = 0 := by
  induction path with
  | nil => rfl
  | cons bit path ih => simp [directedStructural, ih]

@[simp] theorem directedDistance_self (head : Head n) :
    directedDistance head head = 0 := by
  rw [directedDistance_eq_structural]
  exact directedStructural_self (headPath head)

@[simp] theorem structuralDistance_self (path : List Bool) :
    structuralDistance path path = 0 := by
  induction path with
  | nil => rfl
  | cons bit path ih => simp [structuralDistance, ih]

@[simp] theorem treeDistance_self (head : Head n) : treeDistance head head = 0 := by
  rw [treeDistance_eq_structural]
  exact structuralDistance_self (headPath head)

theorem step_directed_distance_bound (move : Move) (source next target : Head n)
    (hstep : step move source = some next) :
    directedDistance source target ≤ directedDistance next target + move.cost := by
  rw [directedDistance_eq_structural, directedDistance_eq_structural]
  cases move with
  | up =>
      cases source with
      | mk remaining cursor =>
          cases cursor with
          | root => simp [step, moveUp] at hstep
          | left parent =>
              simp [step, moveUp] at hstep
              subst next
              simpa [headPath, Move.cost] using
                (directedStructural_append_source parent.path (headPath target) false).1
          | right parent =>
              simp [step, moveUp] at hstep
              subst next
              simpa [headPath, Move.cost] using
                (directedStructural_append_source parent.path (headPath target) true).1
  | down0 =>
      cases source with
      | mk remaining cursor =>
          cases remaining with
          | zero => simp [step, moveDown0] at hstep
          | succ remaining =>
              simp [step, moveDown0] at hstep
              subst next
              simpa [headPath, Move.cost] using
                (directedStructural_append_source cursor.path (headPath target) false).2
  | down1 =>
      cases source with
      | mk remaining cursor =>
          cases remaining with
          | zero => simp [step, moveDown1] at hstep
          | succ remaining =>
              simp [step, moveDown1] at hstep
              subst next
              simpa [headPath, Move.cost] using
                (directedStructural_append_source cursor.path (headPath target) true).2

theorem movement_cost_lower_bound (word : Word) (source target : Head n)
    (hrun : run word source = some target) :
    directedDistance source target ≤ cost word := by
  induction word generalizing source with
  | nil =>
      simp [run] at hrun
      subst target
      simp
  | cons move word ih =>
      simp only [run] at hrun
      cases hstep : step move source with
      | none => simp [hstep] at hrun
      | some next =>
          have htail : run word next = some target := by simpa [hstep] using hrun
          have hlocal := step_directed_distance_bound move source next target hstep
          have hrest := ih next htail
          simp only [cost, List.map_cons, List.sum_cons]
          change directedDistance source target ≤ move.cost + cost word
          omega

theorem movement_cost_realizable (source target : Head n) :
    ∃ word : Word, run word source = some target ∧
      cost word = directedDistance source target := by
  generalize hmeasure : (headPath source).length + (headPath target).length = measure
  induction measure using Nat.strongRecOn generalizing source target with
  | ind measure ih =>
      by_cases heq : source = target
      · subst target
        exact ⟨[], rfl, by simp [cost]⟩
      rcases Nat.lt_trichotomy (headPath source).length (headPath target).length with
        hshallower | hequal | hdeeper
      · obtain ⟨targetRemaining, targetCursor⟩ := target
        cases targetCursor with
        | root => simp [headPath] at hshallower
        | left parent =>
            have hsmaller :
                (headPath source).length + parent.path.length < measure := by
              change (headPath source).length + (parent.path ++ [false]).length = measure at hmeasure
              simp at hmeasure
              omega
            obtain ⟨word, hrun, hcost⟩ :=
              ih _ hsmaller source ⟨targetRemaining + 1, parent⟩ rfl
            refine ⟨word ++ [.down0], ?_, ?_⟩
            · rw [run_append, hrun]
              simp [run, step, moveDown0]
            · have hlength : (headPath source).length ≤ parent.path.length := by
                change (headPath source).length < (parent.path ++ [false]).length at hshallower
                simp at hshallower
                omega
              have hdistance := directedStructural_append_target_of_length_le
                (headPath source) parent.path false hlength
              rw [directedDistance_eq_structural] at hcost ⊢
              change cost word = directedStructural (headPath source) parent.path at hcost
              change cost (word ++ [.down0]) =
                directedStructural (headPath source) (parent.path ++ [false])
              unfold cost at hcost ⊢
              simp [hcost, hdistance, Move.cost]
        | right parent =>
            have hsmaller :
                (headPath source).length + parent.path.length < measure := by
              change (headPath source).length + (parent.path ++ [true]).length = measure at hmeasure
              simp at hmeasure
              omega
            obtain ⟨word, hrun, hcost⟩ :=
              ih _ hsmaller source ⟨targetRemaining + 1, parent⟩ rfl
            refine ⟨word ++ [.down1], ?_, ?_⟩
            · rw [run_append, hrun]
              simp [run, step, moveDown1]
            · have hlength : (headPath source).length ≤ parent.path.length := by
                change (headPath source).length < (parent.path ++ [true]).length at hshallower
                simp at hshallower
                omega
              have hdistance := directedStructural_append_target_of_length_le
                (headPath source) parent.path true hlength
              rw [directedDistance_eq_structural] at hcost ⊢
              change cost word = directedStructural (headPath source) parent.path at hcost
              change cost (word ++ [.down1]) =
                directedStructural (headPath source) (parent.path ++ [true])
              unfold cost at hcost ⊢
              simp [hcost, hdistance, Move.cost]
      · obtain ⟨sourceRemaining, sourceCursor⟩ := source
        obtain ⟨targetRemaining, targetCursor⟩ := target
        cases sourceCursor with
        | root =>
            cases targetCursor with
            | root => exact False.elim (heq rfl)
            | left parent => simp [headPath] at hequal
            | right parent => simp [headPath] at hequal
        | left sourceParent =>
            cases targetCursor with
            | root => simp [headPath] at hequal
            | left targetParent =>
                have hsmaller : sourceParent.path.length + targetParent.path.length < measure := by
                  change (sourceParent.path ++ [false]).length +
                    (targetParent.path ++ [false]).length = measure at hmeasure
                  simp at hmeasure
                  omega
                obtain ⟨word, hrun, hcost⟩ := ih _ hsmaller
                  ⟨sourceRemaining + 1, sourceParent⟩
                  ⟨targetRemaining + 1, targetParent⟩ rfl
                refine ⟨.up :: word ++ [.down0], ?_, ?_⟩
                · simp [run, step, moveUp, run_append, hrun, moveDown0]
                · have hparents : sourceParent.path.length = targetParent.path.length := by
                    change (sourceParent.path ++ [false]).length =
                      (targetParent.path ++ [false]).length at hequal
                    simpa using hequal
                  have hpaths : sourceParent.path ++ [false] ≠
                      targetParent.path ++ [false] := by
                    intro equality
                    apply heq
                    apply headPath_injective
                    exact equality
                  have hdistance := directedStructural_append_both_of_eq_length
                    sourceParent.path targetParent.path false false hparents hpaths
                  rw [directedDistance_eq_structural] at hcost ⊢
                  change cost word = directedStructural sourceParent.path targetParent.path at hcost
                  change cost (.up :: word ++ [.down0]) =
                    directedStructural (sourceParent.path ++ [false])
                      (targetParent.path ++ [false])
                  unfold cost at hcost ⊢
                  simp [hcost, hdistance, Move.cost]
            | right targetParent =>
                have hsmaller : sourceParent.path.length + targetParent.path.length < measure := by
                  change (sourceParent.path ++ [false]).length +
                    (targetParent.path ++ [true]).length = measure at hmeasure
                  simp at hmeasure
                  omega
                obtain ⟨word, hrun, hcost⟩ := ih _ hsmaller
                  ⟨sourceRemaining + 1, sourceParent⟩
                  ⟨targetRemaining + 1, targetParent⟩ rfl
                refine ⟨.up :: word ++ [.down1], ?_, ?_⟩
                · simp [run, step, moveUp, run_append, hrun, moveDown1]
                · have hparents : sourceParent.path.length = targetParent.path.length := by
                    change (sourceParent.path ++ [false]).length =
                      (targetParent.path ++ [true]).length at hequal
                    simpa using hequal
                  have hpaths : sourceParent.path ++ [false] ≠
                      targetParent.path ++ [true] := by simp
                  have hdistance := directedStructural_append_both_of_eq_length
                    sourceParent.path targetParent.path false true hparents hpaths
                  rw [directedDistance_eq_structural] at hcost ⊢
                  change cost word = directedStructural sourceParent.path targetParent.path at hcost
                  change cost (.up :: word ++ [.down1]) =
                    directedStructural (sourceParent.path ++ [false])
                      (targetParent.path ++ [true])
                  unfold cost at hcost ⊢
                  simp [hcost, hdistance, Move.cost]
        | right sourceParent =>
            cases targetCursor with
            | root => simp [headPath] at hequal
            | left targetParent =>
                have hsmaller : sourceParent.path.length + targetParent.path.length < measure := by
                  change (sourceParent.path ++ [true]).length +
                    (targetParent.path ++ [false]).length = measure at hmeasure
                  simp at hmeasure
                  omega
                obtain ⟨word, hrun, hcost⟩ := ih _ hsmaller
                  ⟨sourceRemaining + 1, sourceParent⟩
                  ⟨targetRemaining + 1, targetParent⟩ rfl
                refine ⟨.up :: word ++ [.down0], ?_, ?_⟩
                · simp [run, step, moveUp, run_append, hrun, moveDown0]
                · have hparents : sourceParent.path.length = targetParent.path.length := by
                    change (sourceParent.path ++ [true]).length =
                      (targetParent.path ++ [false]).length at hequal
                    simpa using hequal
                  have hpaths : sourceParent.path ++ [true] ≠
                      targetParent.path ++ [false] := by simp
                  have hdistance := directedStructural_append_both_of_eq_length
                    sourceParent.path targetParent.path true false hparents hpaths
                  rw [directedDistance_eq_structural] at hcost ⊢
                  change cost word = directedStructural sourceParent.path targetParent.path at hcost
                  change cost (.up :: word ++ [.down0]) =
                    directedStructural (sourceParent.path ++ [true])
                      (targetParent.path ++ [false])
                  unfold cost at hcost ⊢
                  simp [hcost, hdistance, Move.cost]
            | right targetParent =>
                have hsmaller : sourceParent.path.length + targetParent.path.length < measure := by
                  change (sourceParent.path ++ [true]).length +
                    (targetParent.path ++ [true]).length = measure at hmeasure
                  simp at hmeasure
                  omega
                obtain ⟨word, hrun, hcost⟩ := ih _ hsmaller
                  ⟨sourceRemaining + 1, sourceParent⟩
                  ⟨targetRemaining + 1, targetParent⟩ rfl
                refine ⟨.up :: word ++ [.down1], ?_, ?_⟩
                · simp [run, step, moveUp, run_append, hrun, moveDown1]
                · have hparents : sourceParent.path.length = targetParent.path.length := by
                    change (sourceParent.path ++ [true]).length =
                      (targetParent.path ++ [true]).length at hequal
                    simpa using hequal
                  have hpaths : sourceParent.path ++ [true] ≠
                      targetParent.path ++ [true] := by
                    intro equality
                    apply heq
                    apply headPath_injective
                    exact equality
                  have hdistance := directedStructural_append_both_of_eq_length
                    sourceParent.path targetParent.path true true hparents hpaths
                  rw [directedDistance_eq_structural] at hcost ⊢
                  change cost word = directedStructural sourceParent.path targetParent.path at hcost
                  change cost (.up :: word ++ [.down1]) =
                    directedStructural (sourceParent.path ++ [true])
                      (targetParent.path ++ [true])
                  unfold cost at hcost ⊢
                  simp [hcost, hdistance, Move.cost]
      · obtain ⟨sourceRemaining, sourceCursor⟩ := source
        cases sourceCursor with
        | root => simp [headPath] at hdeeper
        | left parent =>
            have hsmaller : parent.path.length + (headPath target).length < measure := by
              change (parent.path ++ [false]).length + (headPath target).length = measure at hmeasure
              simp at hmeasure
              omega
            obtain ⟨word, hrun, hcost⟩ :=
              ih _ hsmaller ⟨sourceRemaining + 1, parent⟩ target rfl
            refine ⟨.up :: word, ?_, ?_⟩
            · simp [run, step, moveUp, hrun]
            · have hlength : (headPath target).length ≤ parent.path.length := by
                change (headPath target).length < (parent.path ++ [false]).length at hdeeper
                simp at hdeeper
                omega
              have hdistance := directedStructural_append_source_of_length_le
                parent.path (headPath target) false hlength
              rw [directedDistance_eq_structural] at hcost ⊢
              change cost word = directedStructural parent.path (headPath target) at hcost
              change cost (.up :: word) =
                directedStructural (parent.path ++ [false]) (headPath target)
              unfold cost at hcost ⊢
              simp [hcost, hdistance, Move.cost]
        | right parent =>
            have hsmaller : parent.path.length + (headPath target).length < measure := by
              change (parent.path ++ [true]).length + (headPath target).length = measure at hmeasure
              simp at hmeasure
              omega
            obtain ⟨word, hrun, hcost⟩ :=
              ih _ hsmaller ⟨sourceRemaining + 1, parent⟩ target rfl
            refine ⟨.up :: word, ?_, ?_⟩
            · simp [run, step, moveUp, hrun]
            · have hlength : (headPath target).length ≤ parent.path.length := by
                change (headPath target).length < (parent.path ++ [true]).length at hdeeper
                simp at hdeeper
                omega
              have hdistance := directedStructural_append_source_of_length_le
                parent.path (headPath target) true hlength
              rw [directedDistance_eq_structural] at hcost ⊢
              change cost word = directedStructural parent.path (headPath target) at hcost
              change cost (.up :: word) =
                directedStructural (parent.path ++ [true]) (headPath target)
              unfold cost at hcost ⊢
              simp [hcost, hdistance, Move.cost]

theorem root_to_leaf_distance (cursor : Cursor n 0) :
    directedDistance (rootHead n) ⟨0, cursor⟩ = n := by
  rw [directedDistance_eq_structural]
  have hlength := headPath_length (n := n) (⟨0, cursor⟩ : Head n)
  change cursor.path.length = n at hlength
  change directedStructural [] cursor.path = n
  simpa [directedStructural] using hlength

theorem random_access_optimal (p : Path n) (word : Word) (final : Head n)
    (hrun : run word (rootHead n) = some final)
    (hleaf : leafPosition final = some p.toList) : n ≤ cost word := by
  obtain ⟨remaining, cursor⟩ := final
  cases remaining with
  | zero =>
      rw [← root_to_leaf_distance cursor]
      exact movement_cost_lower_bound word (rootHead n) ⟨0, cursor⟩ hrun
  | succ remaining => simp [leafPosition] at hleaf

#print axioms movement_cost_lower_bound
#print axioms movement_cost_realizable
#print axioms random_access_optimal

end Adic.Dyadic
