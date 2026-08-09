namespace Adic.Dyadic

def Tree : Nat → Type
  | 0 => Bool
  | n + 1 => Tree n × Tree n

inductive Path : Nat → Type where
  | nil : Path 0
  | cons {n : Nat} (bit : Bool) (tail : Path n) : Path (n + 1)
  deriving DecidableEq, Repr

namespace Path

def toList : Path n → List Bool
  | .nil => []
  | .cons bit tail => bit :: tail.toList

def all : (n : Nat) → List (Path n)
  | 0 => [.nil]
  | n + 1 => (all n).map (.cons false) ++ (all n).map (.cons true)

@[simp] theorem toList_length (p : Path n) : p.toList.length = n := by
  induction p with
  | nil => rfl
  | cons bit tail ih => simp [toList, ih]

@[simp] theorem all_zero : all 0 = [.nil] := rfl

@[simp] theorem all_succ (n : Nat) :
    all (n + 1) = (all n).map (.cons false) ++ (all n).map (.cons true) := rfl

@[simp] theorem all_length (n : Nat) : (all n).length = 2 ^ n := by
  induction n with
  | zero => rfl
  | succ n ih =>
      simp [all, ih, Nat.pow_succ]
      omega

end Path

-- With read/write out of scope, a head needs the complete tree's shape zipper:
-- its remaining depth is the focus and these constructors are its breadcrumbs.
inductive Cursor (total : Nat) : Nat → Type where
  | root : Cursor total total
  | left {remaining : Nat} : Cursor total (remaining + 1) → Cursor total remaining
  | right {remaining : Nat} : Cursor total (remaining + 1) → Cursor total remaining
  deriving DecidableEq, Repr

namespace Cursor

def path : Cursor total remaining → List Bool
  | .root => []
  | .left parent => parent.path ++ [false]
  | .right parent => parent.path ++ [true]

def follow (p : Path remaining) (cursor : Cursor total remaining) : Cursor total 0 :=
  match p with
  | .nil => cursor
  | .cons false tail => follow tail (.left cursor)
  | .cons true tail => follow tail (.right cursor)

@[simp] theorem path_root : path (Cursor.root : Cursor n n) = [] := rfl

@[simp] theorem path_left (cursor : Cursor total (remaining + 1)) :
    path (.left cursor) = path cursor ++ [false] := rfl

@[simp] theorem path_right (cursor : Cursor total (remaining + 1)) :
    path (.right cursor) = path cursor ++ [true] := rfl

theorem path_follow (p : Path remaining) (cursor : Cursor total remaining) :
    path (follow p cursor) = path cursor ++ p.toList := by
  induction p with
  | nil => simp [follow, Path.toList]
  | cons bit tail ih =>
      cases bit <;> simp [follow, Path.toList, ih, List.append_assoc]

end Cursor

abbrev Head (n : Nat) := Sigma (Cursor n)

def rootHead (n : Nat) : Head n := ⟨n, .root⟩

inductive Move where
  | up
  | down0
  | down1
  deriving DecidableEq, Repr

abbrev Word := List Move

def cost (word : Word) : Nat := word.length

def moveUp : Head n → Option (Head n)
  | ⟨_, .root⟩ => none
  | ⟨remaining, .left parent⟩ => some ⟨remaining + 1, parent⟩
  | ⟨remaining, .right parent⟩ => some ⟨remaining + 1, parent⟩

def moveDown0 : Head n → Option (Head n)
  | ⟨0, _⟩ => none
  | ⟨remaining + 1, cursor⟩ => some ⟨remaining, .left cursor⟩

def moveDown1 : Head n → Option (Head n)
  | ⟨0, _⟩ => none
  | ⟨remaining + 1, cursor⟩ => some ⟨remaining, .right cursor⟩

def step (move : Move) (head : Head n) : Option (Head n) :=
  match move with
  | .up => moveUp head
  | .down0 => moveDown0 head
  | .down1 => moveDown1 head

def run : Word → Head n → Option (Head n)
  | [], head => some head
  | move :: word, head => do
      let next ← step move head
      run word next

def leafPosition : Head n → Option (List Bool)
  | ⟨0, cursor⟩ => some cursor.path
  | ⟨_ + 1, _⟩ => none

def visit (head : Head n) : List (List Bool) := (leafPosition head).toList

def runTrace : Word → Head n → Option (Head n × List (List Bool))
  | [], head => some (head, [])
  | move :: word, head => do
      let next ← step move head
      let (final, visits) ← runTrace word next
      pure (final, visit next ++ visits)

def leafVisits (word : Word) (head : Head n) : Option (List (List Bool)) := do
  let (_, visits) ← runTrace word head
  pure (visit head ++ visits)

def descend : Path n → Word
  | .nil => []
  | .cons false tail => .down0 :: descend tail
  | .cons true tail => .down1 :: descend tail

@[simp] theorem run_descend (p : Path remaining) (cursor : Cursor total remaining) :
    run (descend p) ⟨remaining, cursor⟩ = some ⟨0, cursor.follow p⟩ := by
  induction p with
  | nil => rfl
  | cons bit tail ih =>
      cases bit <;>
        simp [descend, run, step, moveDown0, moveDown1, Cursor.follow, ih]

@[simp] theorem cost_descend (p : Path n) : cost (descend p) = n := by
  unfold cost
  induction p with
  | nil => rfl
  | cons bit tail ih => cases bit <;> simp [descend, ih]

theorem random_access (p : Path n) :
    ∃ final : Head n,
      run (descend p) (rootHead n) = some final ∧
      leafPosition final = some p.toList ∧
      cost (descend p) = n := by
  refine ⟨⟨0, Cursor.follow p .root⟩, ?_, ?_, cost_descend p⟩
  · exact run_descend p .root
  · simp [leafPosition, Cursor.path_follow]

def euler : Nat → Word
  | 0 => []
  | n + 1 => [.down0] ++ euler n ++ [.up, .down1] ++ euler n ++ [.up]

@[simp] theorem cost_euler_zero : cost (euler 0) = 0 := rfl

theorem cost_euler_succ (n : Nat) : cost (euler (n + 1)) = 2 * cost (euler n) + 4 := by
  simp [euler, cost]
  omega

theorem cost_euler_closed (n : Nat) : cost (euler n) + 4 = 4 * 2 ^ n := by
  induction n with
  | zero => simp [cost_euler_zero]
  | succ n ih =>
      rw [cost_euler_succ]
      simp only [Nat.pow_succ]
      omega

theorem euler_length_bound (n : Nat) : cost (euler n) ≤ 4 * 2 ^ n := by
  have := cost_euler_closed n
  omega

def leavesBelow (cursor : Cursor total remaining) : List (List Bool) :=
  (Path.all remaining).map fun suffix => cursor.path ++ suffix.toList

@[simp] theorem leavesBelow_zero (cursor : Cursor total 0) :
    leavesBelow cursor = [cursor.path] := by
  simp [leavesBelow, Path.toList]

theorem leavesBelow_succ (cursor : Cursor total (remaining + 1)) :
    leavesBelow cursor = leavesBelow (.left cursor) ++ leavesBelow (.right cursor) := by
  simp [leavesBelow, List.map_append, List.map_map, Function.comp_def,
    Path.toList, Cursor.path_left, Cursor.path_right, List.append_assoc]

theorem runTrace_append (first second : Word) (head : Head n) :
    runTrace (first ++ second) head =
      (do
        let (middle, firstVisits) ← runTrace first head
        let (final, secondVisits) ← runTrace second middle
        pure (final, firstVisits ++ secondVisits)) := by
  induction first generalizing head with
  | nil =>
      simp only [List.nil_append, runTrace]
      cases hrun : runTrace second head <;> simp [hrun]
  | cons move first ih =>
      simp only [List.cons_append, runTrace]
      cases hstep : step move head with
      | none => simp
      | some next =>
          simp [ih]
          cases hrun : runTrace first next with
          | none => simp
          | some result =>
              obtain ⟨middle, firstVisits⟩ := result
              simp
              cases hsecond : runTrace second middle with
              | none => simp
              | some result =>
                  obtain ⟨final, secondVisits⟩ := result
                  simp

theorem run_append (first second : Word) (head : Head n) :
    run (first ++ second) head =
      (do
        let middle ← run first head
        run second middle) := by
  induction first generalizing head with
  | nil => simp [run]
  | cons move first ih =>
      simp only [List.cons_append, run]
      cases hstep : step move head with
      | none => simp
      | some next => simp [ih]

def postEulerVisits (cursor : Cursor total remaining) : List (List Bool) :=
  match remaining with
  | 0 => []
  | _ + 1 => leavesBelow cursor

theorem visit_append_postEuler (cursor : Cursor total remaining) :
    visit ⟨remaining, cursor⟩ ++ postEulerVisits cursor = leavesBelow cursor := by
  cases remaining with
  | zero => simp [visit, leafPosition, postEulerVisits]
  | succ remaining => simp [visit, leafPosition, postEulerVisits]

theorem runTrace_euler (cursor : Cursor total remaining) :
    runTrace (euler remaining) ⟨remaining, cursor⟩ =
      some (⟨remaining, cursor⟩, postEulerVisits cursor) := by
  induction remaining with
  | zero => rfl
  | succ remaining ih =>
      rw [euler]
      simp only [runTrace_append]
      simp [runTrace, step, moveUp, moveDown0, moveDown1, ih]
      cases remaining <;>
        simp [visit, leafPosition, postEulerVisits, leavesBelow_succ]

theorem run_euler (cursor : Cursor total remaining) :
    run (euler remaining) ⟨remaining, cursor⟩ = some ⟨remaining, cursor⟩ := by
  induction remaining with
  | zero => rfl
  | succ remaining ih =>
      rw [euler]
      simp only [run_append]
      simp [run, step, moveUp, moveDown0, moveDown1, ih]

def leftToRightLeaves (n : Nat) : List (List Bool) :=
  (Path.all n).map Path.toList

@[simp] theorem leftToRightLeaves_length (n : Nat) :
    (leftToRightLeaves n).length = 2 ^ n := by
  simp [leftToRightLeaves]

theorem euler_leaf_visits (n : Nat) :
    leafVisits (euler n) (rootHead n) =
      some (leftToRightLeaves n) := by
  simp [leafVisits, runTrace_euler, visit_append_postEuler, leavesBelow,
    leftToRightLeaves, rootHead]

theorem streaming (n : Nat) :
    cost (euler n) ≤ 4 * 2 ^ n ∧
    run (euler n) (rootHead n) = some (rootHead n) ∧
    leafVisits (euler n) (rootHead n) = some (leftToRightLeaves n) ∧
    (leftToRightLeaves n).length = 2 ^ n :=
  ⟨euler_length_bound n, run_euler .root, euler_leaf_visits n,
    leftToRightLeaves_length n⟩

#print axioms random_access
#print axioms streaming

end Adic.Dyadic
