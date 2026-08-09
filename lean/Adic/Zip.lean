import Adic.Locality

namespace Adic.Dyadic

namespace Tree

def leafBits : {n : Nat} → Tree n → List Bool
  | 0, bit => [bit]
  | _ + 1, (left, right) => leafBits left ++ leafBits right

@[simp] theorem leafBits_length (tree : Tree n) : tree.leafBits.length = 2 ^ n := by
  induction n with
  | zero => rfl
  | succ n ih =>
      obtain ⟨left, right⟩ := tree
      simp only [leafBits, List.length_append, ih, Nat.pow_succ]
      omega

def falseTree : (n : Nat) → Tree n
  | 0 => false
  | n + 1 => (falseTree n, falseTree n)

end Tree

def alternate : List α → List α → List α
  | [], right => right
  | left, [] => left
  | x :: xs, y :: ys => x :: y :: alternate xs ys

theorem alternate_append (left₀ left₁ right₀ right₁ : List α)
    (hlength : left₀.length = right₀.length) :
    alternate (left₀ ++ left₁) (right₀ ++ right₁) =
      alternate left₀ right₀ ++ alternate left₁ right₁ := by
  induction left₀ generalizing right₀ with
  | nil =>
      have : right₀ = [] := List.eq_nil_of_length_eq_zero hlength.symm
      subst right₀
      rfl
  | cons x xs ih =>
      cases right₀ with
      | nil => simp at hlength
      | cons y ys =>
          simp only [List.length_cons, Nat.succ.injEq] at hlength
          simp [alternate, ih ys hlength]

def interleave : (n : Nat) → Tree n → Tree n → Tree (n + 1)
  | 0, a, b => (a, b)
  | n + 1, (a₀, a₁), (b₀, b₁) =>
      (interleave n a₀ b₀, interleave n a₁ b₁)

theorem leafBits_interleave (a b : Tree n) :
    Tree.leafBits (interleave n a b) = alternate a.leafBits b.leafBits := by
  induction n with
  | zero => rfl
  | succ n ih =>
      obtain ⟨a₀, a₁⟩ := a
      obtain ⟨b₀, b₁⟩ := b
      simp only [interleave, Tree.leafBits, ih]
      rw [alternate_append]
      exact Tree.leafBits_length a₀ |>.trans (Tree.leafBits_length b₀).symm

theorem interleave_grade_zero (a b : Tree 0) :
    Tree.leafBits (interleave 0 a b) = [a, b] := rfl

theorem interleave_grade_one (a₀ a₁ b₀ b₁ : Tree 0) :
    Tree.leafBits (interleave 1 (a₀, a₁) (b₀, b₁)) = [a₀, b₀, a₁, b₁] := rfl

def inputAHead : Fin 3 := ⟨0, by omega⟩
def inputBHead : Fin 3 := ⟨1, by omega⟩
def outputHead : Fin 3 := ⟨2, by omega⟩

def addressed (head : Fin k) (operation : LocalOp) : AddressedOp k :=
  ⟨head, operation⟩

def writeBit (head : Fin k) (bit : Bool) : AddressedOp k :=
  addressed head (if bit then .write1 else .write0)

inductive OperationShape where
  | up
  | down0
  | down1
  | read
  | write
  deriving DecidableEq, Repr

def operationShape : LocalOp → OperationShape
  | .up => .up
  | .down0 => .down0
  | .down1 => .down1
  | .read => .read
  | .write0 => .write
  | .write1 => .write

def actionShape (word : ActionWord k) : List (Fin k × OperationShape) :=
  word.map fun operation => (operation.head, operationShape operation.operation)

@[simp] theorem actionShape_append (first second : ActionWord k) :
    actionShape (first ++ second) = actionShape first ++ actionShape second := by
  simp [actionShape]

def descendAll (direction : Bool) : ActionWord 3 :=
  let operation := if direction then LocalOp.down1 else LocalOp.down0
  [addressed inputAHead operation, addressed inputBHead operation,
    addressed outputHead operation]

def ascendAll : ActionWord 3 :=
  [addressed inputAHead .up, addressed inputBHead .up, addressed outputHead .up]

def zipWord : (n : Nat) → Tree n → Tree n → ActionWord 3
  | 0, a, b =>
      [addressed inputAHead .read,
       addressed outputHead .down0,
       writeBit outputHead a,
       addressed outputHead .up,
       addressed inputBHead .read,
       addressed outputHead .down1,
       writeBit outputHead b,
       addressed outputHead .up]
  | n + 1, (a₀, a₁), (b₀, b₁) =>
      descendAll false ++ zipWord n a₀ b₀ ++ ascendAll ++
      descendAll true ++ zipWord n a₁ b₁ ++ ascendAll

def zipCost (n : Nat) : Nat := 12 * 2 ^ n - 6

theorem zipWord_shape_independent (a b a' b' : Tree n) :
    actionShape (zipWord n a b) = actionShape (zipWord n a' b') := by
  induction n with
  | zero =>
      cases a <;> cases b <;> cases a' <;> cases b' <;>
        rfl
  | succ n ih =>
      obtain ⟨a₀, a₁⟩ := a
      obtain ⟨b₀, b₁⟩ := b
      obtain ⟨a₀', a₁'⟩ := a'
      obtain ⟨b₀', b₁'⟩ := b'
      simp only [zipWord, actionShape_append]
      rw [ih a₀ b₀ a₀' b₀', ih a₁ b₁ a₁' b₁']

theorem zipWord_cost (a b : Tree n) : actionCost (zipWord n a b) = zipCost n := by
  induction n with
  | zero =>
      cases a <;> cases b <;>
        simp [zipWord, actionCost, zipCost, LocalOp.cost, addressed, writeBit]
  | succ n ih =>
      obtain ⟨a₀, a₁⟩ := a
      obtain ⟨b₀, b₁⟩ := b
      simp only [zipWord, actionCost_append]
      rw [ih a₀ b₀, ih a₁ b₁]
      simp [descendAll, ascendAll, actionCost, LocalOp.cost, addressed]
      unfold zipCost
      rw [Nat.pow_succ]
      have hpositive : 1 ≤ 2 ^ n := Nat.two_pow_pos n
      omega

theorem zipWord_linear_bound (a b : Tree n) :
    actionCost (zipWord n a b) ≤ 12 * 2 ^ n := by
  rw [zipWord_cost]
  exact Nat.sub_le _ _

def zipMemory (a b : Tree n) (output : Tree (n + 1)) : Tree (n + 2) :=
  ((a, b), output)

def threeHeads (inputA inputB : Cursor total n) (output : Cursor total (n + 1)) :
    Fin 3 → Head total
  | ⟨0, _⟩ => ⟨n, inputA⟩
  | ⟨1, _⟩ => ⟨n, inputB⟩
  | ⟨2, _⟩ => ⟨n + 1, output⟩

@[simp] theorem threeHeads_inputA (inputA inputB : Cursor total n)
    (output : Cursor total (n + 1)) :
    threeHeads inputA inputB output inputAHead = ⟨n, inputA⟩ := rfl

@[simp] theorem threeHeads_inputB (inputA inputB : Cursor total n)
    (output : Cursor total (n + 1)) :
    threeHeads inputA inputB output inputBHead = ⟨n, inputB⟩ := rfl

@[simp] theorem threeHeads_output (inputA inputB : Cursor total n)
    (output : Cursor total (n + 1)) :
    threeHeads inputA inputB output outputHead = ⟨n + 1, output⟩ := rfl

def zipHeads (n : Nat) : Fin 3 → Head (n + 2) :=
  threeHeads (.left (.left .root)) (.right (.left .root)) (.right .root)

def applyZipWrites : (n : Nat) → Tree n → Tree n → Cursor total (n + 1) →
    Tree total → Option (Tree total)
  | 0, a, b, output, memory => do
      let afterA ← Tree.writeAt total memory (Cursor.left output).path a
      Tree.writeAt total afterA (Cursor.right output).path b
  | n + 1, (a₀, a₁), (b₀, b₁), output, memory => do
      let afterLeft ← applyZipWrites n a₀ b₀ (Cursor.left output) memory
      applyZipWrites n a₁ b₁ (Cursor.right output) afterLeft

inductive TreeContext : (total remaining : Nat) → Type
  | root : TreeContext n n
  | left (parent : TreeContext total (n + 1)) (right : Tree n) : TreeContext total n
  | right (left : Tree n) (parent : TreeContext total (n + 1)) : TreeContext total n

namespace TreeContext

def cursor : TreeContext total remaining → Cursor total remaining
  | .root => .root
  | .left parent _ => .left parent.cursor
  | .right _ parent => .right parent.cursor

def plug : TreeContext total remaining → Tree remaining → Tree total
  | .root, tree => tree
  | .left parent rightTree, tree => parent.plug (tree, rightTree)
  | .right leftTree parent, tree => parent.plug (leftTree, tree)

theorem writeAt_plug (context : TreeContext total remaining) (tree tree' : Tree remaining)
    (path : List Bool) (bit : Bool)
    (hwrite : Tree.writeAt remaining tree path bit = some tree') :
    Tree.writeAt total (context.plug tree) (context.cursor.path ++ path) bit =
      some (context.plug tree') := by
  induction context generalizing path bit with
  | root => simpa [plug, cursor] using hwrite
  | @left total remaining parent rightTree ih =>
      have hpair : Tree.writeAt (remaining + 1) (tree, rightTree) (false :: path) bit =
          some (tree', rightTree) := by
        simp only [Tree.writeAt, hwrite]
        rfl
      change Tree.writeAt total (parent.plug (tree, rightTree))
        ((parent.cursor.path ++ [false]) ++ path) bit = some (parent.plug (tree', rightTree))
      simpa only [List.append_assoc] using
        ih (tree, rightTree) (tree', rightTree) (path := false :: path) (bit := bit) hpair
  | @right total remaining leftTree parent ih =>
      have hpair : Tree.writeAt (total + 1) (leftTree, tree) (true :: path) bit =
          some (leftTree, tree') := by
        simp only [Tree.writeAt, hwrite]
        rfl
      change Tree.writeAt remaining (parent.plug (leftTree, tree))
        ((parent.cursor.path ++ [true]) ++ path) bit = some (parent.plug (leftTree, tree'))
      simpa only [List.append_assoc] using
        ih (leftTree, tree) (leftTree, tree') (path := true :: path) (bit := bit) hpair

theorem writeAt_leaf (context : TreeContext total 0) (old bit : Bool) :
    Tree.writeAt total (context.plug old) context.cursor.path bit =
      some (context.plug bit) := by
  simpa using writeAt_plug context old bit [] bit (by rfl)

end TreeContext

theorem applyZipWrites_context (context : TreeContext total (n + 1))
    (a b : Tree n) (oldOutput : Tree (n + 1)) :
    applyZipWrites n a b context.cursor (context.plug oldOutput) =
      some (context.plug (interleave n a b)) := by
  induction n generalizing total with
  | zero =>
      obtain ⟨oldA, oldB⟩ := oldOutput
      simp only [applyZipWrites, interleave]
      change (do
        let afterA ← Tree.writeAt total (TreeContext.plug (.left context oldB) oldA)
          (TreeContext.cursor (.left context oldB)).path a
        Tree.writeAt total afterA (TreeContext.cursor (.right a context)).path b) = _
      rw [TreeContext.writeAt_leaf (.left context oldB) oldA a]
      exact TreeContext.writeAt_leaf (.right a context) oldB b
  | succ n ih =>
      obtain ⟨a₀, a₁⟩ := a
      obtain ⟨b₀, b₁⟩ := b
      obtain ⟨oldLeft, oldRight⟩ := oldOutput
      simp only [applyZipWrites, interleave]
      change (do
        let afterLeft ← applyZipWrites n a₀ b₀ (TreeContext.cursor (.left context oldRight))
          (TreeContext.plug (.left context oldRight) oldLeft)
        applyZipWrites n a₁ b₁ (TreeContext.cursor (.right (interleave n a₀ b₀) context))
          afterLeft) = _
      rw [ih (.left context oldRight) a₀ b₀ oldLeft]
      exact ih (.right (interleave n a₀ b₀) context) a₁ b₁ oldRight

theorem cursor_leaf_path_length (cursor : Cursor total 0) : cursor.path.length = total := by
  have hlength := headPath_length (⟨0, cursor⟩ : Head total)
  simpa [headPath] using hlength

@[simp] theorem setHead_shadow (heads : Fin k → Head n) (head : Fin k)
    (first second : Head n) :
    setHead (setHead heads head first) head second = setHead heads head second := by
  funext queried
  by_cases h : queried = head <;> simp [setHead, h]

@[simp] theorem setHead_self (heads : Fin k → Head n) (head : Fin k) :
    setHead heads head (heads head) = heads := by
  funext queried
  by_cases h : queried = head
  · subst queried
    simp [setHead]
  · simp [setHead, h]

@[simp] theorem setHead_threeHeads_output (inputA inputB : Cursor total n)
    (output : Cursor total (n + 1)) :
    setHead (threeHeads inputA inputB output) outputHead ⟨n + 1, output⟩ =
      threeHeads inputA inputB output := by
  exact setHead_self _ _

theorem run_descendAll (direction : Bool) (memory : Tree total)
    (inputA inputB : Cursor total (n + 1)) (output : Cursor total (n + 2)) :
    runActions (descendAll direction)
        { memory, heads := threeHeads inputA inputB output } =
      some { memory := memory, heads := (threeHeads
        (if direction then Cursor.right inputA else Cursor.left inputA)
        (if direction then Cursor.right inputB else Cursor.left inputB)
        (if direction then Cursor.right output else Cursor.left output)) } := by
  cases direction <;>
    simp [descendAll, runActions, actionStep, moveSelected, threeHeads,
      addressed, inputAHead, inputBHead, outputHead, step, moveDown0, moveDown1] <;>
    funext head <;>
    rcases head with ⟨i, hi⟩ <;>
    cases i with
    | zero => simp [setHead, threeHeads]
    | succ i =>
        cases i with
        | zero => simp [setHead, threeHeads]
        | succ i =>
            cases i with
            | zero => simp [setHead, threeHeads]
            | succ i => omega

theorem run_ascendAll (memory : Tree total)
    (inputA inputB : Cursor total (n + 1)) (output : Cursor total (n + 2))
    (direction : Bool) :
    runActions ascendAll
        { memory, heads := (threeHeads
          (if direction then Cursor.right inputA else Cursor.left inputA)
          (if direction then Cursor.right inputB else Cursor.left inputB)
          (if direction then Cursor.right output else Cursor.left output)) } =
      some { memory := memory, heads := threeHeads inputA inputB output } := by
  cases direction <;>
    simp [ascendAll, runActions, actionStep, moveSelected, threeHeads,
      addressed, inputAHead, inputBHead, outputHead, step, moveUp] <;>
    funext head <;>
    rcases head with ⟨i, hi⟩ <;>
    cases i with
    | zero => simp [setHead, threeHeads]
    | succ i =>
        cases i with
        | zero => simp [setHead, threeHeads]
        | succ i =>
            cases i with
            | zero => simp [setHead, threeHeads]
            | succ i => omega

theorem run_zipWord_at (a b : Tree n) (memory : Tree total)
    (inputA inputB : Cursor total n) (output : Cursor total (n + 1)) :
    runActions (zipWord n a b) { memory, heads := threeHeads inputA inputB output } =
      (do
        let memory' ← applyZipWrites n a b output memory
        pure { memory := memory', heads := threeHeads inputA inputB output }) := by
  induction n generalizing total memory with
  | zero =>
      obtain ⟨readA, hreadA⟩ :=
        Tree.readAt_exists memory inputA.path (cursor_leaf_path_length inputA)
      obtain ⟨afterA, hwriteA⟩ :=
        Tree.writeAt_exists memory (Cursor.left output).path a
          (cursor_leaf_path_length (Cursor.left output))
      obtain ⟨readB, hreadB⟩ :=
        Tree.readAt_exists afterA inputB.path (cursor_leaf_path_length inputB)
      obtain ⟨afterB, hwriteB⟩ :=
        Tree.writeAt_exists afterA (Cursor.right output).path b
          (cursor_leaf_path_length (Cursor.right output))
      have hwriteA' : Tree.writeAt total memory (output.path ++ [false]) a = some afterA := by
        simpa [Cursor.path] using hwriteA
      have hwriteB' : Tree.writeAt total afterA (output.path ++ [true]) b = some afterB := by
        simpa [Cursor.path] using hwriteB
      cases a <;> cases b <;>
        simp [zipWord, applyZipWrites, runActions, actionStep, checkRead, readSelected,
          selectedLeaf, writeSelected, moveSelected, threeHeads, addressed, writeBit,
          inputAHead, inputBHead, outputHead, leafPosition, Cursor.path, step, moveUp,
          moveDown0, moveDown1, hreadA, hwriteA', hreadB, hwriteB'] <;>
        simpa [outputHead] using setHead_threeHeads_output inputA inputB output
  | succ n ih =>
      obtain ⟨a₀, a₁⟩ := a
      obtain ⟨b₀, b₁⟩ := b
      simp only [zipWord, runActions_append]
      rw [run_descendAll false]
      simp only [Bool.false_eq_true, if_false]
      simp
      rw [ih a₀ b₀]
      simp only [applyZipWrites, Option.bind_eq_bind]
      cases hleft : applyZipWrites n a₀ b₀ (Cursor.left output) memory with
      | none => simp
      | some afterLeft =>
          simp
          have hreturnLeft :
              runActions ascendAll
                { memory := afterLeft,
                  heads := threeHeads (Cursor.left inputA) (Cursor.left inputB)
                    (Cursor.left output) } =
                some { memory := afterLeft, heads := threeHeads inputA inputB output } := by
            simpa using run_ascendAll afterLeft inputA inputB output false
          rw [hreturnLeft]
          simp
          have hdescendRight :
              runActions (descendAll true)
                { memory := afterLeft, heads := threeHeads inputA inputB output } =
                some (ActionConfig.mk afterLeft
                  (threeHeads (Cursor.right inputA) (Cursor.right inputB)
                    (Cursor.right output))) := by
            simpa using run_descendAll true afterLeft inputA inputB output
          rw [hdescendRight]
          simp
          rw [ih a₁ b₁]
          cases hright : applyZipWrites n a₁ b₁ (Cursor.right output) afterLeft with
          | none => simp
          | some afterRight =>
              simp
              have hreturnRight :
                  runActions ascendAll
                    { memory := afterRight,
                      heads := threeHeads (Cursor.right inputA) (Cursor.right inputB)
                        (Cursor.right output) } =
                    some { memory := afterRight, heads := threeHeads inputA inputB output } := by
                simpa using run_ascendAll afterRight inputA inputB output true
              exact hreturnRight

def zipStart (a b : Tree n) (output : Tree (n + 1) := Tree.falseTree (n + 1)) :
    ActionConfig (n + 2) 3 :=
  { memory := zipMemory a b output, heads := zipHeads n }

theorem zipWord_correct (a b : Tree n) (output : Tree (n + 1)) :
    runActions (zipWord n a b) (zipStart a b output) =
      some (zipStart a b (interleave n a b)) := by
  unfold zipStart zipMemory zipHeads
  rw [run_zipWord_at]
  let context : TreeContext (n + 2) (n + 1) :=
    .right (a, b) (.root : TreeContext (n + 2) (n + 2))
  change (do
    let memory' ← applyZipWrites n a b context.cursor (context.plug output)
    pure ({ memory := memory', heads := (threeHeads
      (.left (.left .root)) (.right (.left .root)) (.right .root)) } :
        ActionConfig (n + 2) 3)) =
    some ({ memory := context.plug (interleave n a b), heads := (threeHeads
      (.left (.left .root)) (.right (.left .root)) (.right .root)) } :
        ActionConfig (n + 2) 3)
  rw [applyZipWrites_context context a b output]
  rfl

#print axioms leafBits_interleave
#print axioms zipWord_shape_independent
#print axioms zipWord_correct
#print axioms zipWord_cost
#print axioms zipWord_linear_bound

end Adic.Dyadic
