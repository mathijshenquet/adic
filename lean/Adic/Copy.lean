import Adic.Zip

namespace Adic.Dyadic

def copySourceHead : Fin 2 := ⟨0, by omega⟩
def copyDestinationHead : Fin 2 := ⟨1, by omega⟩

def copyDescend (direction : Bool) : ActionWord 2 :=
  let operation := if direction then LocalOp.down1 else LocalOp.down0
  [addressed copySourceHead operation, addressed copyDestinationHead operation]

def copyAscend : ActionWord 2 :=
  [addressed copySourceHead .up, addressed copyDestinationHead .up]

def copyWord : (n : Nat) → Tree n → ActionWord 2
  | 0, source =>
      [addressed copySourceHead .read, writeBit copyDestinationHead source]
  | n + 1, (left, right) =>
      copyDescend false ++ copyWord n left ++ copyAscend ++
      copyDescend true ++ copyWord n right ++ copyAscend

def copyCost (n : Nat) : Nat := 6 * 2 ^ n - 4

theorem copyWord_shape_independent (source source' : Tree n) :
    actionShape (copyWord n source) = actionShape (copyWord n source') := by
  induction n with
  | zero =>
      cases source <;> cases source' <;> rfl
  | succ n ih =>
      obtain ⟨left, right⟩ := source
      obtain ⟨left', right'⟩ := source'
      simp only [copyWord, actionShape_append]
      rw [ih left left', ih right right']

theorem copyWord_cost (source : Tree n) : actionCost (copyWord n source) = copyCost n := by
  induction n with
  | zero =>
      cases source <;>
        simp [copyWord, actionCost, copyCost, LocalOp.cost, addressed, writeBit]
  | succ n ih =>
      obtain ⟨left, right⟩ := source
      simp only [copyWord, actionCost_append]
      rw [ih left, ih right]
      simp [copyDescend, copyAscend, actionCost, LocalOp.cost, addressed]
      unfold copyCost
      rw [Nat.pow_succ]
      have hpositive : 1 ≤ 2 ^ n := Nat.two_pow_pos n
      omega

theorem copyWord_linear_bound (source : Tree n) :
    actionCost (copyWord n source) ≤ 6 * 2 ^ n := by
  rw [copyWord_cost]
  exact Nat.sub_le _ _

def twoHeads (source destination : Cursor total n) : Fin 2 → Head total
  | ⟨0, _⟩ => ⟨n, source⟩
  | ⟨1, _⟩ => ⟨n, destination⟩

@[simp] theorem twoHeads_source (source destination : Cursor total n) :
    twoHeads source destination copySourceHead = ⟨n, source⟩ := rfl

@[simp] theorem twoHeads_destination (source destination : Cursor total n) :
    twoHeads source destination copyDestinationHead = ⟨n, destination⟩ := rfl

def applyCopyWrites : (n : Nat) → Tree n → Cursor total n → Tree total → Option (Tree total)
  | 0, source, destination, memory =>
      Tree.writeAt total memory destination.path source
  | n + 1, (left, right), destination, memory => do
      let afterLeft ← applyCopyWrites n left (Cursor.left destination) memory
      applyCopyWrites n right (Cursor.right destination) afterLeft

theorem applyCopyWrites_context (context : TreeContext total n)
    (source oldDestination : Tree n) :
    applyCopyWrites n source context.cursor (context.plug oldDestination) =
      some (context.plug source) := by
  induction n generalizing total with
  | zero =>
      exact TreeContext.writeAt_leaf context oldDestination source
  | succ n ih =>
      obtain ⟨sourceLeft, sourceRight⟩ := source
      obtain ⟨oldLeft, oldRight⟩ := oldDestination
      simp only [applyCopyWrites]
      change (do
        let afterLeft ← applyCopyWrites n sourceLeft
          (TreeContext.cursor (.left context oldRight))
          (TreeContext.plug (.left context oldRight) oldLeft)
        applyCopyWrites n sourceRight
          (TreeContext.cursor (.right sourceLeft context)) afterLeft) = _
      rw [ih (.left context oldRight) sourceLeft oldLeft]
      exact ih (.right sourceLeft context) sourceRight oldRight

theorem run_copyDescend (direction : Bool) (memory : Tree total)
    (source destination : Cursor total (n + 1)) :
    runActions (copyDescend direction) { memory, heads := twoHeads source destination } =
      some { memory := memory, heads := (twoHeads
        (if direction then Cursor.right source else Cursor.left source)
        (if direction then Cursor.right destination else Cursor.left destination)) } := by
  cases direction <;>
    simp [copyDescend, runActions, actionStep, moveSelected, twoHeads, addressed,
      copySourceHead, copyDestinationHead, step, moveDown0, moveDown1] <;>
    funext head <;>
    rcases head with ⟨i, hi⟩ <;>
    cases i with
    | zero => simp [setHead, twoHeads]
    | succ i =>
        cases i with
        | zero => simp [setHead, twoHeads]
        | succ i => omega

theorem run_copyAscend (memory : Tree total)
    (source destination : Cursor total (n + 1)) (direction : Bool) :
    runActions copyAscend
        { memory, heads := (twoHeads
          (if direction then Cursor.right source else Cursor.left source)
          (if direction then Cursor.right destination else Cursor.left destination)) } =
      some { memory := memory, heads := twoHeads source destination } := by
  cases direction <;>
    simp [copyAscend, runActions, actionStep, moveSelected, twoHeads, addressed,
      copySourceHead, copyDestinationHead, step, moveUp] <;>
    funext head <;>
    rcases head with ⟨i, hi⟩ <;>
    cases i with
    | zero => simp [setHead, twoHeads]
    | succ i =>
        cases i with
        | zero => simp [setHead, twoHeads]
        | succ i => omega

theorem run_copyWord_at (source : Tree n) (memory : Tree total)
    (sourceCursor destinationCursor : Cursor total n) :
    runActions (copyWord n source)
        { memory, heads := twoHeads sourceCursor destinationCursor } =
      (do
        let memory' ← applyCopyWrites n source destinationCursor memory
        pure { memory := memory', heads := twoHeads sourceCursor destinationCursor }) := by
  induction n generalizing total memory with
  | zero =>
      obtain ⟨readBit, hread⟩ :=
        Tree.readAt_exists memory sourceCursor.path (cursor_leaf_path_length sourceCursor)
      obtain ⟨afterWrite, hwrite⟩ :=
        Tree.writeAt_exists memory destinationCursor.path source
          (cursor_leaf_path_length destinationCursor)
      cases source <;>
        simp [copyWord, applyCopyWrites, runActions, actionStep, checkRead, readSelected,
          selectedLeaf, writeSelected, twoHeads, addressed, writeBit, copySourceHead,
          copyDestinationHead, leafPosition, hread, hwrite]
  | succ n ih =>
      obtain ⟨left, right⟩ := source
      simp only [copyWord, runActions_append]
      rw [run_copyDescend false]
      simp only [Bool.false_eq_true, if_false]
      simp
      rw [ih left]
      simp only [applyCopyWrites, Option.bind_eq_bind]
      cases hleft : applyCopyWrites n left (Cursor.left destinationCursor) memory with
      | none => simp
      | some afterLeft =>
          simp
          have hreturnLeft :
              runActions copyAscend
                { memory := afterLeft,
                  heads := twoHeads (Cursor.left sourceCursor)
                    (Cursor.left destinationCursor) } =
                some (ActionConfig.mk afterLeft
                  (twoHeads sourceCursor destinationCursor)) := by
            simpa using run_copyAscend afterLeft sourceCursor destinationCursor false
          rw [hreturnLeft]
          simp
          have hdescendRight :
              runActions (copyDescend true)
                { memory := afterLeft, heads := twoHeads sourceCursor destinationCursor } =
                some (ActionConfig.mk afterLeft
                  (twoHeads (Cursor.right sourceCursor)
                    (Cursor.right destinationCursor))) := by
            simpa using run_copyDescend true afterLeft sourceCursor destinationCursor
          rw [hdescendRight]
          simp
          rw [ih right]
          cases hright : applyCopyWrites n right (Cursor.right destinationCursor) afterLeft with
          | none => simp
          | some afterRight =>
              simp
              have hreturnRight :
                  runActions copyAscend
                    { memory := afterRight,
                      heads := twoHeads (Cursor.right sourceCursor)
                        (Cursor.right destinationCursor) } =
                    some (ActionConfig.mk afterRight
                      (twoHeads sourceCursor destinationCursor)) := by
                simpa using run_copyAscend afterRight sourceCursor destinationCursor true
              exact hreturnRight

def copyMemory (source destination : Tree n) : Tree (n + 1) :=
  (source, destination)

def copyHeads (n : Nat) : Fin 2 → Head (n + 1) :=
  twoHeads (.left .root) (.right .root)

def copyStart (source destination : Tree n) : ActionConfig (n + 1) 2 :=
  { memory := copyMemory source destination, heads := copyHeads n }

theorem copyWord_correct (source destination : Tree n) :
    runActions (copyWord n source) (copyStart source destination) =
      some (copyStart source source) := by
  unfold copyStart copyMemory copyHeads
  rw [run_copyWord_at]
  let context : TreeContext (n + 1) n :=
    .right source (.root : TreeContext (n + 1) (n + 1))
  change (do
    let memory' ← applyCopyWrites n source context.cursor (context.plug destination)
    pure ({ memory := memory', heads := twoHeads (.left .root) (.right .root) } :
      ActionConfig (n + 1) 2)) =
    some ({ memory := context.plug source, heads := twoHeads (.left .root) (.right .root) } :
      ActionConfig (n + 1) 2)
  rw [applyCopyWrites_context context source destination]
  rfl

def doublingCopyTotal : Nat → Nat
  | 0 => copyCost 0
  | c + 1 => doublingCopyTotal c + copyCost (c + 1)

theorem doublingCopyTotal_closed (c : Nat) :
    doublingCopyTotal c + 4 * (c + 1) + 6 = 6 * 2 ^ (c + 1) := by
  induction c with
  | zero => decide
  | succ c ih =>
      rw [doublingCopyTotal]
      unfold copyCost
      rw [Nat.pow_succ]
      have hpositive : 1 ≤ 2 ^ (c + 1) := Nat.two_pow_pos (c + 1)
      omega

theorem doublingCopyTotal_linear_bound (c : Nat) :
    doublingCopyTotal c ≤ 12 * 2 ^ c := by
  have hclosed := doublingCopyTotal_closed c
  rw [Nat.pow_succ] at hclosed
  omega

#print axioms copyWord_shape_independent
#print axioms copyWord_correct
#print axioms copyWord_cost
#print axioms copyWord_linear_bound
#print axioms doublingCopyTotal_closed
#print axioms doublingCopyTotal_linear_bound

end Adic.Dyadic
