import Adic.Machine
import Adic.Metric

namespace Adic.Dyadic

namespace Tree

theorem readAt_exists (memory : Tree n) (path : List Bool) (hlength : path.length = n) :
    ∃ bit, readAt n memory path = some bit := by
  induction n generalizing path with
  | zero =>
      cases path with
      | nil => exact ⟨memory, rfl⟩
      | cons bit path => simp at hlength
  | succ n ih =>
      cases path with
      | nil => simp at hlength
      | cons bit path =>
          have htail : path.length = n := by simpa using hlength
          obtain ⟨left, right⟩ := memory
          cases bit with
          | false => exact ih left path htail
          | true => exact ih right path htail

theorem writeAt_exists (memory : Tree n) (path : List Bool) (bit : Bool)
    (hlength : path.length = n) :
    ∃ memory', writeAt n memory path bit = some memory' := by
  induction n generalizing path with
  | zero =>
      cases path with
      | nil => exact ⟨bit, rfl⟩
      | cons edge path => simp at hlength
  | succ n ih =>
      cases path with
      | nil => simp at hlength
      | cons edge path =>
          have htail : path.length = n := by simpa using hlength
          obtain ⟨left, right⟩ := memory
          cases edge with
          | false =>
              obtain ⟨left', hwrite⟩ := ih left path htail
              exact ⟨(left', right), by simp [writeAt, hwrite]⟩
          | true =>
              obtain ⟨right', hwrite⟩ := ih right path htail
              exact ⟨(left, right'), by simp [writeAt, hwrite]⟩

theorem readAt_after_writeAt_ne (memory : Tree n) (readPath writePath : List Bool)
    (bit : Bool) (hread : readPath.length = n) (hwrite : writePath.length = n)
    (hne : readPath ≠ writePath) :
    (do
      let memory' ← writeAt n memory writePath bit
      readAt n memory' readPath) = readAt n memory readPath := by
  induction n generalizing readPath writePath with
  | zero =>
      have hreadNil : readPath = [] := List.eq_nil_of_length_eq_zero hread
      have hwriteNil : writePath = [] := List.eq_nil_of_length_eq_zero hwrite
      exact False.elim (hne (hreadNil.trans hwriteNil.symm))
  | succ n ih =>
      cases readPath with
      | nil => simp at hread
      | cons readEdge readPath =>
          cases writePath with
          | nil => simp at hwrite
          | cons writeEdge writePath =>
              have hreadTail : readPath.length = n := by simpa using hread
              have hwriteTail : writePath.length = n := by simpa using hwrite
              obtain ⟨left, right⟩ := memory
              cases readEdge <;> cases writeEdge
              · have hneTail : readPath ≠ writePath := by
                  intro equality
                  apply hne
                  simpa using congrArg (List.cons false) equality
                obtain ⟨left', hleft⟩ := writeAt_exists left writePath bit hwriteTail
                have hind := ih left readPath writePath hreadTail hwriteTail hneTail
                simp [readAt, writeAt, hleft] at hind ⊢
                exact hind
              · obtain ⟨right', hright⟩ := writeAt_exists right writePath bit hwriteTail
                simp [readAt, writeAt, hright]
              · obtain ⟨left', hleft⟩ := writeAt_exists left writePath bit hwriteTail
                simp [readAt, writeAt, hleft]
              · have hneTail : readPath ≠ writePath := by
                  intro equality
                  apply hne
                  simpa using congrArg (List.cons true) equality
                obtain ⟨right', hright⟩ := writeAt_exists right writePath bit hwriteTail
                have hind := ih right readPath writePath hreadTail hwriteTail hneTail
                simp [readAt, writeAt, hright] at hind ⊢
                exact hind

theorem writeAt_commute_ne (memory : Tree n) (leftPath rightPath : List Bool)
    (leftBit rightBit : Bool) (hleft : leftPath.length = n)
    (hright : rightPath.length = n) (hne : leftPath ≠ rightPath) :
    (do
      let memory' ← writeAt n memory leftPath leftBit
      writeAt n memory' rightPath rightBit) =
    (do
      let memory' ← writeAt n memory rightPath rightBit
      writeAt n memory' leftPath leftBit) := by
  induction n generalizing leftPath rightPath with
  | zero =>
      have hleftNil : leftPath = [] := List.eq_nil_of_length_eq_zero hleft
      have hrightNil : rightPath = [] := List.eq_nil_of_length_eq_zero hright
      exact False.elim (hne (hleftNil.trans hrightNil.symm))
  | succ n ih =>
      cases leftPath with
      | nil => simp at hleft
      | cons leftEdge leftPath =>
          cases rightPath with
          | nil => simp at hright
          | cons rightEdge rightPath =>
              have hleftTail : leftPath.length = n := by simpa using hleft
              have hrightTail : rightPath.length = n := by simpa using hright
              obtain ⟨left, right⟩ := memory
              cases leftEdge <;> cases rightEdge
              · have hneTail : leftPath ≠ rightPath := by
                  intro equality
                  apply hne
                  simpa using congrArg (List.cons false) equality
                obtain ⟨afterLeft, hafterLeft⟩ :=
                  writeAt_exists left leftPath leftBit hleftTail
                obtain ⟨afterBoth, hafterBoth⟩ :=
                  writeAt_exists afterLeft rightPath rightBit hrightTail
                obtain ⟨afterRight, hafterRight⟩ :=
                  writeAt_exists left rightPath rightBit hrightTail
                obtain ⟨afterBoth', hafterBoth'⟩ :=
                  writeAt_exists afterRight leftPath leftBit hleftTail
                have hind := ih left leftPath rightPath hleftTail hrightTail hneTail
                simp [writeAt, hafterLeft, hafterBoth, hafterRight, hafterBoth'] at hind ⊢
                subst afterBoth'
                rfl
              · obtain ⟨left', hwriteLeft⟩ :=
                  writeAt_exists left leftPath leftBit hleftTail
                obtain ⟨right', hwriteRight⟩ :=
                  writeAt_exists right rightPath rightBit hrightTail
                simp [writeAt, hwriteLeft, hwriteRight]
              · obtain ⟨right', hwriteRight⟩ :=
                  writeAt_exists right leftPath leftBit hleftTail
                obtain ⟨left', hwriteLeft⟩ :=
                  writeAt_exists left rightPath rightBit hrightTail
                simp [writeAt, hwriteLeft, hwriteRight]
              · have hneTail : leftPath ≠ rightPath := by
                  intro equality
                  apply hne
                  simpa using congrArg (List.cons true) equality
                obtain ⟨afterLeft, hafterLeft⟩ :=
                  writeAt_exists right leftPath leftBit hleftTail
                obtain ⟨afterBoth, hafterBoth⟩ :=
                  writeAt_exists afterLeft rightPath rightBit hrightTail
                obtain ⟨afterRight, hafterRight⟩ :=
                  writeAt_exists right rightPath rightBit hrightTail
                obtain ⟨afterBoth', hafterBoth'⟩ :=
                  writeAt_exists afterRight leftPath leftBit hleftTail
                have hind := ih right leftPath rightPath hleftTail hrightTail hneTail
                simp [writeAt, hafterLeft, hafterBoth, hafterRight, hafterBoth'] at hind ⊢
                subst afterBoth'
                rfl

end Tree

def PrefixIncomparable (left right : List Bool) : Prop :=
  ¬left <+: right ∧ ¬right <+: left

def HeadInRegion (region : List Bool) (head : Head n) : Prop :=
  region <+: headPath head

theorem prefixes_of_same_path_comparable {left right path : List Bool}
    (hleft : left <+: path) (hright : right <+: path) :
    left <+: right ∨ right <+: left := by
  rcases Nat.le_total left.length right.length with hlength | hlength
  · left
    have htake : path.take right.length = right :=
      (List.prefix_iff_eq_take.mp hright).symm
    rw [← htake]
    exact List.prefix_take_iff.mpr ⟨hleft, hlength⟩
  · right
    have htake : path.take left.length = left :=
      (List.prefix_iff_eq_take.mp hleft).symm
    rw [← htake]
    exact List.prefix_take_iff.mpr ⟨hright, hlength⟩

theorem paths_ne_of_disjoint_regions {leftRegion rightRegion leftPath rightPath : List Bool}
    (hdisjoint : PrefixIncomparable leftRegion rightRegion)
    (hleft : leftRegion <+: leftPath) (hright : rightRegion <+: rightPath) :
    leftPath ≠ rightPath := by
  intro equality
  subst rightPath
  rcases prefixes_of_same_path_comparable hleft hright with h | h
  · exact hdisjoint.1 h
  · exact hdisjoint.2 h

@[simp] theorem setHead_same (heads : Fin k → Head n) (head : Fin k) (value : Head n) :
    setHead heads head value head = value := by
  simp [setHead]

@[simp] theorem setHead_ne (heads : Fin k → Head n) (head other : Fin k) (value : Head n)
    (hne : other ≠ head) : setHead heads head value other = heads other := by
  simp [setHead, hne]

theorem setHead_commute (heads : Fin k → Head n) (left right : Fin k)
    (leftValue rightValue : Head n) (hne : left ≠ right) :
    setHead (setHead heads left leftValue) right rightValue =
      setHead (setHead heads right rightValue) left leftValue := by
  funext queried
  by_cases hleft : queried = left
  · subst queried
    simp [setHead, hne]
  · by_cases hright : queried = right
    · subst queried
      simp [setHead, hleft]
    · simp [setHead, hleft, hright]

theorem leafPosition_some_headPath {head : Head n} {path : List Bool}
    (hleaf : leafPosition head = some path) : headPath head = path := by
  obtain ⟨remaining, cursor⟩ := head
  cases remaining with
  | zero => simpa [leafPosition, headPath] using Option.some.inj hleaf
  | succ remaining => simp [leafPosition] at hleaf

theorem leafPosition_some_length {head : Head n} {path : List Bool}
    (hleaf : leafPosition head = some path) : path.length = n := by
  have hpath := leafPosition_some_headPath hleaf
  have hlength := headPath_length head
  obtain ⟨remaining, cursor⟩ := head
  cases remaining with
  | zero =>
      change (headPath (⟨0, cursor⟩ : Head n)).length = n at hlength
      simpa [hpath] using hlength
  | succ remaining => simp [leafPosition] at hleaf

theorem moveSelected_commute (config : ActionConfig n k) (left right : Fin k)
    (leftMove rightMove : Move) (hne : left ≠ right) :
    (do
      let afterLeft ← moveSelected config left leftMove
      moveSelected afterLeft right rightMove) =
    (do
      let afterRight ← moveSelected config right rightMove
      moveSelected afterRight left leftMove) := by
  obtain ⟨memory, heads⟩ := config
  cases hleft : step leftMove (heads left) <;>
    cases hright : step rightMove (heads right) <;>
    simp [moveSelected, hleft, hright, setHead, hne, Ne.symm hne,
      setHead_commute]

theorem moveSelected_checkRead_commute (config : ActionConfig n k) (moving reading : Fin k)
    (move : Move) (hne : moving ≠ reading) :
    (do
      let afterMove ← moveSelected config moving move
      checkRead afterMove reading) =
    (do
      let afterRead ← checkRead config reading
      moveSelected afterRead moving move) := by
  obtain ⟨memory, heads⟩ := config
  cases hmove : step move (heads moving) with
  | none =>
      cases hleaf : leafPosition (heads reading) with
      | none => simp [moveSelected, checkRead, readSelected, selectedLeaf, hmove, hleaf]
      | some path =>
          cases hread : Tree.readAt n memory path <;>
            simp [moveSelected, checkRead, readSelected, selectedLeaf, hmove, hleaf, hread]
  | some moved =>
      cases hleaf : leafPosition (heads reading) with
      | none => simp [moveSelected, checkRead, readSelected, selectedLeaf, hmove, hleaf,
          setHead, Ne.symm hne]
      | some path =>
          cases hread : Tree.readAt n memory path <;>
            simp [moveSelected, checkRead, readSelected, selectedLeaf, hmove, hleaf,
              hread, setHead, Ne.symm hne]

theorem moveSelected_writeSelected_commute (config : ActionConfig n k)
    (moving writing : Fin k) (move : Move) (bit : Bool) (hne : moving ≠ writing) :
    (do
      let afterMove ← moveSelected config moving move
      writeSelected afterMove writing bit) =
    (do
      let afterWrite ← writeSelected config writing bit
      moveSelected afterWrite moving move) := by
  obtain ⟨memory, heads⟩ := config
  cases hmove : step move (heads moving) with
  | none =>
      cases hleaf : leafPosition (heads writing) with
      | none => simp [moveSelected, writeSelected, selectedLeaf, hmove, hleaf]
      | some path =>
          cases hwrite : Tree.writeAt n memory path bit <;>
            simp [moveSelected, writeSelected, selectedLeaf, hmove, hleaf, hwrite]
  | some moved =>
      cases hleaf : leafPosition (heads writing) with
      | none => simp [moveSelected, writeSelected, selectedLeaf, hmove, hleaf,
          setHead, Ne.symm hne]
      | some path =>
          cases hwrite : Tree.writeAt n memory path bit <;>
            simp [moveSelected, writeSelected, selectedLeaf, hmove, hleaf, hwrite,
              setHead, Ne.symm hne]

theorem checkRead_commute (config : ActionConfig n k) (left right : Fin k) :
    (do
      let afterLeft ← checkRead config left
      checkRead afterLeft right) =
    (do
      let afterRight ← checkRead config right
      checkRead afterRight left) := by
  cases hleft : readSelected config left <;>
    cases hright : readSelected config right <;>
    simp [checkRead, hleft, hright]

theorem checkRead_writeSelected_commute (config : ActionConfig n k)
    (reading writing : Fin k) (bit : Bool)
    (hpaths : headPath (config.heads reading) ≠ headPath (config.heads writing)) :
    (do
      let afterRead ← checkRead config reading
      writeSelected afterRead writing bit) =
    (do
      let afterWrite ← writeSelected config writing bit
      checkRead afterWrite reading) := by
  obtain ⟨memory, heads⟩ := config
  cases hreadLeaf : leafPosition (heads reading) with
  | none =>
      cases hwriteLeaf : leafPosition (heads writing) with
      | none => simp [checkRead, readSelected, writeSelected, selectedLeaf,
          hreadLeaf, hwriteLeaf]
      | some writePath =>
          cases hwrite : Tree.writeAt n memory writePath bit <;>
            simp [checkRead, readSelected, writeSelected, selectedLeaf,
              hreadLeaf, hwriteLeaf, hwrite]
  | some readPath =>
      cases hwriteLeaf : leafPosition (heads writing) with
      | none =>
          cases hread : Tree.readAt n memory readPath <;>
            simp [checkRead, readSelected, writeSelected, selectedLeaf,
              hreadLeaf, hwriteLeaf, hread]
      | some writePath =>
          have hne : readPath ≠ writePath := by
            intro equality
            apply hpaths
            rw [leafPosition_some_headPath hreadLeaf,
              leafPosition_some_headPath hwriteLeaf, equality]
          have hreadLength := leafPosition_some_length hreadLeaf
          have hwriteLength := leafPosition_some_length hwriteLeaf
          obtain ⟨memory', hwrite⟩ :=
            Tree.writeAt_exists memory writePath bit hwriteLength
          have hpreserved := Tree.readAt_after_writeAt_ne memory readPath writePath
            bit hreadLength hwriteLength hne
          cases hread : Tree.readAt n memory readPath with
          | none =>
              have hread' : Tree.readAt n memory' readPath = none := by
                simpa [hwrite, hread] using hpreserved
              simp [checkRead, readSelected, writeSelected, selectedLeaf, hreadLeaf,
                hwriteLeaf, hread, hwrite, hread']
          | some value =>
              have hread' : Tree.readAt n memory' readPath = some value := by
                simpa [hwrite, hread] using hpreserved
              simp [checkRead, readSelected, writeSelected, selectedLeaf, hreadLeaf,
                hwriteLeaf, hread, hwrite, hread']

theorem writeSelected_commute (config : ActionConfig n k) (left right : Fin k)
    (leftBit rightBit : Bool)
    (hpaths : headPath (config.heads left) ≠ headPath (config.heads right)) :
    (do
      let afterLeft ← writeSelected config left leftBit
      writeSelected afterLeft right rightBit) =
    (do
      let afterRight ← writeSelected config right rightBit
      writeSelected afterRight left leftBit) := by
  obtain ⟨memory, heads⟩ := config
  cases hleftLeaf : leafPosition (heads left) with
  | none =>
      cases hrightLeaf : leafPosition (heads right) with
      | none => simp [writeSelected, selectedLeaf, hleftLeaf, hrightLeaf]
      | some rightPath =>
          cases hright : Tree.writeAt n memory rightPath rightBit <;>
            simp [writeSelected, selectedLeaf, hleftLeaf, hrightLeaf, hright]
  | some leftPath =>
      cases hrightLeaf : leafPosition (heads right) with
      | none =>
          cases hleft : Tree.writeAt n memory leftPath leftBit <;>
            simp [writeSelected, selectedLeaf, hleftLeaf, hrightLeaf, hleft]
      | some rightPath =>
          have hne : leftPath ≠ rightPath := by
            intro equality
            apply hpaths
            rw [leafPosition_some_headPath hleftLeaf,
              leafPosition_some_headPath hrightLeaf, equality]
          have hleftLength := leafPosition_some_length hleftLeaf
          have hrightLength := leafPosition_some_length hrightLeaf
          obtain ⟨afterLeft, hafterLeft⟩ :=
            Tree.writeAt_exists memory leftPath leftBit hleftLength
          obtain ⟨afterBoth, hafterBoth⟩ :=
            Tree.writeAt_exists afterLeft rightPath rightBit hrightLength
          obtain ⟨afterRight, hafterRight⟩ :=
            Tree.writeAt_exists memory rightPath rightBit hrightLength
          obtain ⟨afterBoth', hafterBoth'⟩ :=
            Tree.writeAt_exists afterRight leftPath leftBit hleftLength
          have hcommute := Tree.writeAt_commute_ne memory leftPath rightPath
            leftBit rightBit hleftLength hrightLength hne
          simp [hafterLeft, hafterBoth, hafterRight, hafterBoth'] at hcommute
          subst afterBoth'
          simp [writeSelected, selectedLeaf, hleftLeaf, hrightLeaf,
            hafterLeft, hafterBoth, hafterRight, hafterBoth']

theorem actionStep_commute_of_distinct_positions
    (left right : AddressedOp k) (config : ActionConfig n k)
    (hheads : left.head ≠ right.head)
    (hpaths : headPath (config.heads left.head) ≠ headPath (config.heads right.head)) :
    (do
      let afterLeft ← actionStep left config
      actionStep right afterLeft) =
    (do
      let afterRight ← actionStep right config
      actionStep left afterRight) := by
  obtain ⟨leftHead, leftOperation⟩ := left
  obtain ⟨rightHead, rightOperation⟩ := right
  change leftHead ≠ rightHead at hheads
  change headPath (config.heads leftHead) ≠ headPath (config.heads rightHead) at hpaths
  cases leftOperation <;> cases rightOperation
  case up.up => simpa [actionStep] using moveSelected_commute config leftHead rightHead .up .up hheads
  case up.down0 => simpa [actionStep] using moveSelected_commute config leftHead rightHead .up .down0 hheads
  case up.down1 => simpa [actionStep] using moveSelected_commute config leftHead rightHead .up .down1 hheads
  case up.read => simpa [actionStep] using moveSelected_checkRead_commute config leftHead rightHead .up hheads
  case up.write0 => simpa [actionStep] using moveSelected_writeSelected_commute config leftHead rightHead .up false hheads
  case up.write1 => simpa [actionStep] using moveSelected_writeSelected_commute config leftHead rightHead .up true hheads
  case down0.up => simpa [actionStep] using moveSelected_commute config leftHead rightHead .down0 .up hheads
  case down0.down0 => simpa [actionStep] using moveSelected_commute config leftHead rightHead .down0 .down0 hheads
  case down0.down1 => simpa [actionStep] using moveSelected_commute config leftHead rightHead .down0 .down1 hheads
  case down0.read => simpa [actionStep] using moveSelected_checkRead_commute config leftHead rightHead .down0 hheads
  case down0.write0 => simpa [actionStep] using moveSelected_writeSelected_commute config leftHead rightHead .down0 false hheads
  case down0.write1 => simpa [actionStep] using moveSelected_writeSelected_commute config leftHead rightHead .down0 true hheads
  case down1.up => simpa [actionStep] using moveSelected_commute config leftHead rightHead .down1 .up hheads
  case down1.down0 => simpa [actionStep] using moveSelected_commute config leftHead rightHead .down1 .down0 hheads
  case down1.down1 => simpa [actionStep] using moveSelected_commute config leftHead rightHead .down1 .down1 hheads
  case down1.read => simpa [actionStep] using moveSelected_checkRead_commute config leftHead rightHead .down1 hheads
  case down1.write0 => simpa [actionStep] using moveSelected_writeSelected_commute config leftHead rightHead .down1 false hheads
  case down1.write1 => simpa [actionStep] using moveSelected_writeSelected_commute config leftHead rightHead .down1 true hheads
  case read.up => simpa [actionStep] using (moveSelected_checkRead_commute config rightHead leftHead .up hheads.symm).symm
  case read.down0 => simpa [actionStep] using (moveSelected_checkRead_commute config rightHead leftHead .down0 hheads.symm).symm
  case read.down1 => simpa [actionStep] using (moveSelected_checkRead_commute config rightHead leftHead .down1 hheads.symm).symm
  case read.read => simpa [actionStep] using checkRead_commute config leftHead rightHead
  case read.write0 => simpa [actionStep] using checkRead_writeSelected_commute config leftHead rightHead false hpaths
  case read.write1 => simpa [actionStep] using checkRead_writeSelected_commute config leftHead rightHead true hpaths
  case write0.up => simpa [actionStep] using (moveSelected_writeSelected_commute config rightHead leftHead .up false hheads.symm).symm
  case write0.down0 => simpa [actionStep] using (moveSelected_writeSelected_commute config rightHead leftHead .down0 false hheads.symm).symm
  case write0.down1 => simpa [actionStep] using (moveSelected_writeSelected_commute config rightHead leftHead .down1 false hheads.symm).symm
  case write0.read => simpa [actionStep] using (checkRead_writeSelected_commute config rightHead leftHead false hpaths.symm).symm
  case write0.write0 => simpa [actionStep] using writeSelected_commute config leftHead rightHead false false hpaths
  case write0.write1 => simpa [actionStep] using writeSelected_commute config leftHead rightHead false true hpaths
  case write1.up => simpa [actionStep] using (moveSelected_writeSelected_commute config rightHead leftHead .up true hheads.symm).symm
  case write1.down0 => simpa [actionStep] using (moveSelected_writeSelected_commute config rightHead leftHead .down0 true hheads.symm).symm
  case write1.down1 => simpa [actionStep] using (moveSelected_writeSelected_commute config rightHead leftHead .down1 true hheads.symm).symm
  case write1.read => simpa [actionStep] using (checkRead_writeSelected_commute config rightHead leftHead true hpaths.symm).symm
  case write1.write0 => simpa [actionStep] using writeSelected_commute config leftHead rightHead true false hpaths
  case write1.write1 => simpa [actionStep] using writeSelected_commute config leftHead rightHead true true hpaths

def RegionsInvariant (config : ActionConfig n k) (leftHead rightHead : Fin k)
    (leftRegion rightRegion : List Bool) : Prop :=
  HeadInRegion leftRegion (config.heads leftHead) ∧
    HeadInRegion rightRegion (config.heads rightHead)

theorem disjoint_subtree_commute (config : ActionConfig n k)
    (left right : AddressedOp k) (leftHead rightHead : Fin k)
    (leftRegion rightRegion : List Bool)
    (hleftHead : left.head = leftHead) (hrightHead : right.head = rightHead)
    (hheads : leftHead ≠ rightHead)
    (hdisjoint : PrefixIncomparable leftRegion rightRegion)
    (hinvariant : RegionsInvariant config leftHead rightHead leftRegion rightRegion) :
    runActions [left, right] config = runActions [right, left] config ∧
      actionCost [left, right] = actionCost [right, left] := by
  have hpaths : headPath (config.heads left.head) ≠ headPath (config.heads right.head) := by
    apply paths_ne_of_disjoint_regions hdisjoint
    · simpa [hleftHead] using hinvariant.1
    · simpa [hrightHead] using hinvariant.2
  constructor
  · simpa [runActions] using
      actionStep_commute_of_distinct_positions left right config
        (by
          intro equality
          apply hheads
          rw [← hleftHead, ← hrightHead]
          exact equality) hpaths
  · rfl

def ActionsCommute (left right : AddressedOp k) : Prop :=
  ∀ {n : Nat} (config : ActionConfig n k),
    runActions [left, right] config = runActions [right, left] config

theorem actionsCommute_symm {left right : AddressedOp k}
    (hcommute : ActionsCommute left right) : ActionsCommute right left := by
  intro n config
  exact (hcommute config).symm

theorem commute_action_across_word (pivot : AddressedOp k) (word : ActionWord k)
    (hcommute : ∀ operation ∈ word, ActionsCommute pivot operation)
    (config : ActionConfig n k) :
    runActions (pivot :: word) config = runActions (word ++ [pivot]) config := by
  induction word generalizing config with
  | nil => rfl
  | cons operation word ih =>
      have hpair : ActionsCommute pivot operation := hcommute operation (by simp)
      have htail : ∀ candidate ∈ word, ActionsCommute pivot candidate := by
        intro candidate hmember
        exact (hcommute candidate (by simp [hmember]) : ActionsCommute pivot candidate)
      calc
        runActions (pivot :: operation :: word) config =
            (do
              let middle ← runActions [pivot, operation] config
              runActions word middle) := by
                rw [← runActions_append]
                rfl
        _ = (do
              let middle ← runActions [operation, pivot] config
              runActions word middle) := by rw [(hpair : ActionsCommute pivot operation) config]
        _ = runActions (operation :: pivot :: word) config := by
              rw [← runActions_append]
              rfl
        _ = runActions (operation :: (word ++ [pivot])) config := by
              simp only [runActions]
              cases hstep : actionStep operation config with
              | none => simp
              | some next => simpa using ih htail next
        _ = runActions ((operation :: word) ++ [pivot]) config := rfl

inductive Interleaving : List α → List α → List α → Prop where
  | nil : Interleaving [] [] []
  | takeLeft : Interleaving left right merged →
      Interleaving (operation :: left) right (operation :: merged)
  | takeRight : Interleaving left right merged →
      Interleaving left (operation :: right) (operation :: merged)

theorem Interleaving.length {left right merged : List α}
    (hinterleaving : Interleaving left right merged) :
    merged.length = left.length + right.length := by
  induction hinterleaving with
  | nil => rfl
  | takeLeft hinterleaving ih => simp [ih]; omega
  | takeRight hinterleaving ih => simp [ih]; omega

theorem runActions_interleaving_eq_append
    {left right merged : ActionWord k} (hinterleaving : Interleaving left right merged)
    (hcommute : ∀ leftOp ∈ left, ∀ rightOp ∈ right, ActionsCommute leftOp rightOp)
    (config : ActionConfig n k) :
    runActions merged config = runActions (left ++ right) config := by
  induction hinterleaving generalizing config with
  | nil => rfl
  | @takeLeft left right merged operation hinterleaving ih =>
      simp only [runActions, List.cons_append]
      cases hstep : actionStep operation config with
      | none => simp
      | some next =>
          apply ih
          intro leftOp hleft rightOp hright
          exact hcommute leftOp (by simp [hleft]) rightOp hright
  | @takeRight left right merged operation hinterleaving ih =>
      have htail : ∀ leftOp ∈ left, ∀ rightOp ∈ right,
          ActionsCommute leftOp rightOp := by
        intro leftOp hleft rightOp hright
        exact hcommute leftOp hleft rightOp (by simp [hright])
      have hpivot : ∀ leftOp ∈ left, ActionsCommute operation leftOp := by
        intro leftOp hleft
        exact actionsCommute_symm (hcommute leftOp hleft operation (by simp))
      calc
        runActions (operation :: merged) config =
            (do
              let afterOperation ← actionStep operation config
              runActions (left ++ right) afterOperation) := by
                simp only [runActions]
                cases hstep : actionStep operation config with
                | none => simp
                | some next => simpa using ih htail next
        _ = runActions ((operation :: left) ++ right) config := rfl
        _ = (do
              let middle ← runActions (operation :: left) config
              runActions right middle) := by
                exact runActions_append (operation :: left) right config
        _ = (do
              let middle ← runActions (left ++ [operation]) config
              runActions right middle) := by
                rw [commute_action_across_word operation left hpivot config]
        _ = runActions (left ++ operation :: right) config := by
              rw [← runActions_append]
              simp

theorem interleaving_result_and_cost_invariant
    {left right first second : ActionWord k}
    (hfirst : Interleaving left right first) (hsecond : Interleaving left right second)
    (hcommute : ∀ leftOp ∈ left, ∀ rightOp ∈ right, ActionsCommute leftOp rightOp)
    (config : ActionConfig n k) :
    runActions first config = runActions second config ∧
      actionCost first = actionCost second := by
  constructor
  · rw [runActions_interleaving_eq_append hfirst hcommute config,
      runActions_interleaving_eq_append hsecond hcommute config]
  · unfold actionCost
    rw [hfirst.length, hsecond.length]

def PreservesInvariant (invariant : ActionConfig n k → Prop) (operation : AddressedOp k) : Prop :=
  ∀ config next, invariant config → actionStep operation config = some next → invariant next

def ActionsCommuteUnder (invariant : ActionConfig n k → Prop)
    (left right : AddressedOp k) : Prop :=
  ∀ config, invariant config → runActions [left, right] config = runActions [right, left] config

theorem commute_action_across_word_under
    (invariant : ActionConfig n k → Prop) (pivot : AddressedOp k) (word : ActionWord k)
    (hpreserve : ∀ operation ∈ word, PreservesInvariant invariant operation)
    (hcommute : ∀ operation ∈ word, ActionsCommuteUnder invariant pivot operation)
    (config : ActionConfig n k) (hinvariant : invariant config) :
    runActions (pivot :: word) config = runActions (word ++ [pivot]) config := by
  induction word generalizing config with
  | nil => rfl
  | cons operation word ih =>
      have hpair : ActionsCommuteUnder invariant pivot operation := hcommute operation (by simp)
      have hpreserveHead : PreservesInvariant invariant operation := hpreserve operation (by simp)
      have hpreserveTail : ∀ candidate ∈ word, PreservesInvariant invariant candidate := by
        intro candidate hmember
        exact hpreserve candidate (by simp [hmember])
      have hcommuteTail : ∀ candidate ∈ word,
          ActionsCommuteUnder invariant pivot candidate := by
        intro candidate hmember
        exact hcommute candidate (by simp [hmember])
      calc
        runActions (pivot :: operation :: word) config =
            (do
              let middle ← runActions [pivot, operation] config
              runActions word middle) := by
                rw [← runActions_append]
                rfl
        _ = (do
              let middle ← runActions [operation, pivot] config
              runActions word middle) := by rw [hpair config hinvariant]
        _ = runActions (operation :: pivot :: word) config := by
              rw [← runActions_append]
              rfl
        _ = runActions (operation :: (word ++ [pivot])) config := by
              simp only [runActions]
              cases hstep : actionStep operation config with
              | none => simp
              | some next =>
                  have hinvariantNext := hpreserveHead config next hinvariant hstep
                  simpa using ih hpreserveTail hcommuteTail next hinvariantNext
        _ = runActions ((operation :: word) ++ [pivot]) config := rfl

theorem runActions_interleaving_eq_append_under
    (invariant : ActionConfig n k → Prop)
    {left right merged : ActionWord k} (hinterleaving : Interleaving left right merged)
    (hpreserveLeft : ∀ operation ∈ left, PreservesInvariant invariant operation)
    (hpreserveRight : ∀ operation ∈ right, PreservesInvariant invariant operation)
    (hcommute : ∀ leftOp ∈ left, ∀ rightOp ∈ right,
      ActionsCommuteUnder invariant leftOp rightOp)
    (config : ActionConfig n k) (hinvariant : invariant config) :
    runActions merged config = runActions (left ++ right) config := by
  induction hinterleaving generalizing config with
  | nil => rfl
  | @takeLeft left right merged operation hinterleaving ih =>
      have hpreserveHead : PreservesInvariant invariant operation :=
        hpreserveLeft operation (by simp)
      simp only [runActions, List.cons_append]
      cases hstep : actionStep operation config with
      | none => simp
      | some next =>
          have hinvariantNext := hpreserveHead config next hinvariant hstep
          apply ih
          · intro candidate hmember
            exact hpreserveLeft candidate (by simp [hmember])
          · exact hpreserveRight
          · intro leftOp hleft rightOp hright
            exact hcommute leftOp (by simp [hleft]) rightOp hright
          · exact hinvariantNext
  | @takeRight left right merged operation hinterleaving ih =>
      have hpreserveHead : PreservesInvariant invariant operation :=
        hpreserveRight operation (by simp)
      have hpreserveRightTail : ∀ candidate ∈ right,
          PreservesInvariant invariant candidate := by
        intro candidate hmember
        exact hpreserveRight candidate (by simp [hmember])
      have hcommuteTail : ∀ leftOp ∈ left, ∀ rightOp ∈ right,
          ActionsCommuteUnder invariant leftOp rightOp := by
        intro leftOp hleft rightOp hright
        exact hcommute leftOp hleft rightOp (by simp [hright])
      have hpivot : ∀ leftOp ∈ left,
          ActionsCommuteUnder invariant operation leftOp := by
        intro leftOp hleft config hinvariant
        exact (hcommute leftOp hleft operation (by simp) config hinvariant).symm
      calc
        runActions (operation :: merged) config =
            (do
              let afterOperation ← actionStep operation config
              runActions (left ++ right) afterOperation) := by
                simp only [runActions]
                cases hstep : actionStep operation config with
                | none => simp
                | some next =>
                    have hinvariantNext := hpreserveHead config next hinvariant hstep
                    simpa using ih hpreserveLeft hpreserveRightTail hcommuteTail next hinvariantNext
        _ = runActions ((operation :: left) ++ right) config := rfl
        _ = (do
              let middle ← runActions (operation :: left) config
              runActions right middle) := runActions_append (operation :: left) right config
        _ = (do
              let middle ← runActions (left ++ [operation]) config
              runActions right middle) := by
                rw [commute_action_across_word_under invariant operation left
                  hpreserveLeft hpivot config hinvariant]
        _ = runActions (left ++ operation :: right) config := by
              rw [← runActions_append]
              simp

theorem interleaving_invariant_under
    (invariant : ActionConfig n k → Prop)
    {left right first second : ActionWord k}
    (hfirst : Interleaving left right first) (hsecond : Interleaving left right second)
    (hpreserveLeft : ∀ operation ∈ left, PreservesInvariant invariant operation)
    (hpreserveRight : ∀ operation ∈ right, PreservesInvariant invariant operation)
    (hcommute : ∀ leftOp ∈ left, ∀ rightOp ∈ right,
      ActionsCommuteUnder invariant leftOp rightOp)
    (config : ActionConfig n k) (hinvariant : invariant config) :
    runActions first config = runActions second config ∧
      actionCost first = actionCost second := by
  constructor
  · rw [runActions_interleaving_eq_append_under invariant hfirst hpreserveLeft
        hpreserveRight hcommute config hinvariant,
      runActions_interleaving_eq_append_under invariant hsecond hpreserveLeft
        hpreserveRight hcommute config hinvariant]
  · unfold actionCost
    rw [hfirst.length, hsecond.length]

theorem actionStep_preserves_other_head (operation : AddressedOp k)
    (config next : ActionConfig n k) (other : Fin k)
    (hne : operation.head ≠ other) (hstep : actionStep operation config = some next) :
    next.heads other = config.heads other := by
  obtain ⟨head, localOperation⟩ := operation
  change head ≠ other at hne
  cases localOperation
  case up =>
    cases hmove : step .up (config.heads head) with
    | none => simp [actionStep, moveSelected, hmove] at hstep
    | some moved =>
        simp [actionStep, moveSelected, hmove] at hstep
        subst next
        simp [setHead, hne.symm]
  case down0 =>
    cases hmove : step .down0 (config.heads head) with
    | none => simp [actionStep, moveSelected, hmove] at hstep
    | some moved =>
        simp [actionStep, moveSelected, hmove] at hstep
        subst next
        simp [setHead, hne.symm]
  case down1 =>
    cases hmove : step .down1 (config.heads head) with
    | none => simp [actionStep, moveSelected, hmove] at hstep
    | some moved =>
        simp [actionStep, moveSelected, hmove] at hstep
        subst next
        simp [setHead, hne.symm]
  case read =>
    cases hread : readSelected config head with
    | none => simp [actionStep, checkRead, hread] at hstep
    | some bit =>
        simp [actionStep, checkRead, hread] at hstep
        subst next
        rfl
  case write0 =>
    cases hleaf : selectedLeaf config head with
    | none => simp [actionStep, writeSelected, hleaf] at hstep
    | some path =>
        cases hwrite : Tree.writeAt n config.memory path false with
        | none => simp [actionStep, writeSelected, hleaf, hwrite] at hstep
        | some memory =>
            simp [actionStep, writeSelected, hleaf, hwrite] at hstep
            subst next
            rfl
  case write1 =>
    cases hleaf : selectedLeaf config head with
    | none => simp [actionStep, writeSelected, hleaf] at hstep
    | some path =>
        cases hwrite : Tree.writeAt n config.memory path true with
        | none => simp [actionStep, writeSelected, hleaf, hwrite] at hstep
        | some memory =>
            simp [actionStep, writeSelected, hleaf, hwrite] at hstep
            subst next
            rfl

def ConfinedOperation (operation : AddressedOp k) (head : Fin k)
    (region : List Bool) : Prop :=
  operation.head = head ∧
    ∀ {n : Nat} (config next : ActionConfig n k),
      HeadInRegion region (config.heads head) →
      actionStep operation config = some next →
      HeadInRegion region (next.heads head)

def ConfinedWord (word : ActionWord k) (head : Fin k) (region : List Bool) : Prop :=
  ∀ operation ∈ word, ConfinedOperation operation head region

theorem confinedLeft_preserves_regions
    (operation : AddressedOp k) (leftHead rightHead : Fin k)
    (leftRegion rightRegion : List Bool) (hheads : leftHead ≠ rightHead)
    (hconfined : ConfinedOperation operation leftHead leftRegion) :
    PreservesInvariant
      (fun config : ActionConfig n k =>
        RegionsInvariant config leftHead rightHead leftRegion rightRegion)
      operation := by
  intro config next hinvariant hstep
  constructor
  · exact hconfined.2 config next hinvariant.1 hstep
  · rw [actionStep_preserves_other_head operation config next rightHead
      (by
        intro equality
        apply hheads
        rw [← hconfined.1]
        exact equality) hstep]
    exact hinvariant.2

theorem confinedRight_preserves_regions
    (operation : AddressedOp k) (leftHead rightHead : Fin k)
    (leftRegion rightRegion : List Bool) (hheads : leftHead ≠ rightHead)
    (hconfined : ConfinedOperation operation rightHead rightRegion) :
    PreservesInvariant
      (fun config : ActionConfig n k =>
        RegionsInvariant config leftHead rightHead leftRegion rightRegion)
      operation := by
  intro config next hinvariant hstep
  constructor
  · rw [actionStep_preserves_other_head operation config next leftHead
      (by
        intro equality
        apply hheads
        rw [← equality, hconfined.1]) hstep]
    exact hinvariant.1
  · exact hconfined.2 config next hinvariant.2 hstep

theorem confined_pair_commutes_under_regions
    (left right : AddressedOp k) (leftHead rightHead : Fin k)
    (leftRegion rightRegion : List Bool) (hheads : leftHead ≠ rightHead)
    (hdisjoint : PrefixIncomparable leftRegion rightRegion)
    (hleft : ConfinedOperation left leftHead leftRegion)
    (hright : ConfinedOperation right rightHead rightRegion) :
    ActionsCommuteUnder
      (fun config : ActionConfig n k =>
        RegionsInvariant config leftHead rightHead leftRegion rightRegion)
      left right := by
  intro config hinvariant
  exact (disjoint_subtree_commute config left right leftHead rightHead leftRegion rightRegion
    hleft.1 hright.1 hheads hdisjoint hinvariant).1

theorem disjoint_subtree_interleaving
    {left right first second : ActionWord k}
    (leftHead rightHead : Fin k) (leftRegion rightRegion : List Bool)
    (hheads : leftHead ≠ rightHead)
    (hdisjoint : PrefixIncomparable leftRegion rightRegion)
    (hleft : ConfinedWord left leftHead leftRegion)
    (hright : ConfinedWord right rightHead rightRegion)
    (hfirst : Interleaving left right first) (hsecond : Interleaving left right second)
    (config : ActionConfig n k)
    (hinvariant : RegionsInvariant config leftHead rightHead leftRegion rightRegion) :
    runActions first config = runActions second config ∧
      actionCost first = actionCost second := by
  let invariant := fun candidate : ActionConfig n k =>
    RegionsInvariant candidate leftHead rightHead leftRegion rightRegion
  apply interleaving_invariant_under invariant hfirst hsecond
  · intro operation hmember
    exact confinedLeft_preserves_regions operation leftHead rightHead leftRegion rightRegion
      hheads (hleft operation hmember)
  · intro operation hmember
    exact confinedRight_preserves_regions operation leftHead rightHead leftRegion rightRegion
      hheads (hright operation hmember)
  · intro leftOp hleftMember rightOp hrightMember
    exact confined_pair_commutes_under_regions leftOp rightOp leftHead rightHead
      leftRegion rightRegion hheads hdisjoint (hleft leftOp hleftMember)
        (hright rightOp hrightMember)
  · exact hinvariant

#print axioms disjoint_subtree_commute
#print axioms disjoint_subtree_interleaving

end Adic.Dyadic
