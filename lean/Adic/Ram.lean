import Adic.Copy

namespace Adic.Dyadic

abbrev RamAddress (s : Nat) := Path s
abbrev RamWord (v : Nat) := Tree v
abbrev RamMemory (s v : Nat) := Tree (v + s)

def addressToPath (address : RamAddress s) : Path s := address

def wordAt : (s : Nat) → RamMemory s v → RamAddress s → RamWord v
  | 0, memory, .nil => memory
  | s + 1, (left, _), .cons false path => wordAt s left path
  | s + 1, (_, right), .cons true path => wordAt s right path

def writeWord : (s : Nat) → RamMemory s v → RamAddress s → RamWord v → RamMemory s v
  | 0, _, .nil, word => word
  | s + 1, (left, right), .cons false path, word =>
      (writeWord s left path word, right)
  | s + 1, (left, right), .cons true path, word =>
      (left, writeWord s right path word)

def leavesUnderPath : (s : Nat) → RamMemory s v → Path s → List Bool
  | 0, memory, .nil => memory.leafBits
  | s + 1, (left, _), .cons false path => leavesUnderPath s left path
  | s + 1, (_, right), .cons true path => leavesUnderPath s right path

theorem addressToPath_correct (memory : RamMemory s v) (address : RamAddress s) :
    leavesUnderPath s memory (addressToPath address) = (wordAt s memory address).leafBits := by
  induction s with
  | zero => cases address; rfl
  | succ s ih =>
      obtain ⟨left, right⟩ := memory
      cases address with
      | cons bit path => cases bit <;> exact ih _ path

theorem ramWord_width (memory : RamMemory s v) (address : RamAddress s) :
    (wordAt s memory address).leafBits.length = 2 ^ v :=
  Tree.leafBits_length _

theorem ramAddress_count : (Path.all s).length = 2 ^ s := Path.all_length s

theorem ramLayout_grade (s v : Nat) : v + s = s + v := Nat.add_comm v s

namespace Path

def snoc : (n : Nat) → Path n → Bool → Path (n + 1)
  | 0, .nil, bit => .cons bit .nil
  | n + 1, .cons bit tail, last => .cons bit (snoc n tail last)

def init : (n : Nat) → Path (n + 1) → Path n
  | 0, .cons _ .nil => .nil
  | n + 1, .cons bit tail => .cons bit (init n tail)

def shiftLeft : (n : Nat) → Path n → Bool → Path n
  | 0, .nil, _ => .nil
  | n + 1, .cons _ tail, bit => snoc n tail bit

def shiftRight : (n : Nat) → Path n → Path n
  | 0, .nil => .nil
  | n + 1, path => .cons false (init n path)

def fromList : (bits : List Bool) → Path bits.length
  | [] => .nil
  | bit :: bits => .cons bit (fromList bits)

@[simp] theorem toList_fromList (bits : List Bool) : (fromList bits).toList = bits := by
  induction bits with
  | nil => rfl
  | cons bit bits ih => simp [fromList, Path.toList, ih]

theorem toList_injective : Function.Injective (@toList n) := by
  intro left right heq
  induction n with
  | zero => cases left; cases right; rfl
  | succ n ih =>
      cases left with
      | cons bit tail =>
          cases right with
          | cons other rest =>
              simp only [toList, List.cons.injEq] at heq
              obtain ⟨hbit, htail⟩ := heq
              subst other
              rw [ih htail]

@[simp] theorem toList_snoc (path : Path n) (bit : Bool) :
    (snoc n path bit).toList = path.toList ++ [bit] := by
  induction n generalizing bit with
  | zero => cases path; rfl
  | succ n ih =>
      cases path with
      | cons first tail => simp [snoc, Path.toList, ih]

@[simp] theorem toList_init (path : Path (n + 1)) :
    (init n path).toList = path.toList.dropLast := by
  induction n with
  | zero => cases path with
      | cons bit tail => cases tail <;> rfl
  | succ n ih =>
      cases path with
      | cons bit tail =>
          cases tail with
          | cons next rest => simp [init, Path.toList, ih]

@[simp] theorem toList_shiftLeft (path : Path (n + 1)) (bit : Bool) :
    (shiftLeft (n + 1) path bit).toList = path.toList.tail ++ [bit] := by
  cases path
  simp [shiftLeft, toList_snoc, Path.toList]

@[simp] theorem toList_shiftRight (path : Path (n + 1)) :
    (shiftRight (n + 1) path).toList = false :: path.toList.dropLast := by
  simp [shiftRight, Path.toList, toList_init]

end Path

structure RamConfig (s v : Nat) where
  memory : RamMemory s v
  address : RamAddress s
  accumulator : RamWord v

inductive RamInstruction (s : Nat) where
  | setAddress (address : RamAddress s)
  | load
  | store
  -- Word-RAM shifts are unit operations; the depth register below gives their
  -- finite-tree interpretation a defined root/leaf boundary.
  | shiftLeft (bit : Bool)
  | shiftRight
  deriving Repr

abbrev RamProgram (s : Nat) := List (RamInstruction s)

def ramStep (instruction : RamInstruction s) (config : RamConfig s v) : RamConfig s v :=
  match instruction with
  | .setAddress address => { config with address }
  | .load => { config with accumulator := wordAt s config.memory config.address }
  | .store => { config with
      memory := writeWord s config.memory config.address config.accumulator }
  | .shiftLeft bit => { config with address := Path.shiftLeft s config.address bit }
  | .shiftRight => { config with address := Path.shiftRight s config.address }

def runRam : RamProgram s → RamConfig s v → RamConfig s v
  | [], config => config
  | instruction :: program, config => runRam program (ramStep instruction config)

def ramCost (program : RamProgram s) : Nat := program.length

def zeroAddress : (s : Nat) → RamAddress s
  | 0 => .nil
  | s + 1 => .cons false (zeroAddress s)

def repeatWord : (s : Nat) → RamWord v → RamMemory s v
  | 0, word => word
  | s + 1, word => (repeatWord s word, repeatWord s word)

structure RamPointer (n : Nat) where
  address : RamAddress n
  depth : Fin (n + 1)

def setPointer (pointers : Fin k → RamPointer n) (pointer : Fin k) (value : RamPointer n) :
    Fin k → RamPointer n :=
  fun queried => if queried = pointer then value else pointers queried

structure RegisterRamConfig (n k : Nat) where
  memory : RamMemory n 0
  accumulator : Bool
  address : RamAddress n
  active : Fin k
  activeDepth : Fin (n + 1)
  pointers : Fin k → RamPointer n

def RegisterRamConfig.core (config : RegisterRamConfig n k) : RamConfig n 0 :=
  { memory := config.memory, address := config.address, accumulator := config.accumulator }

inductive RegisterRamInstruction (n k : Nat) where
  | core (instruction : RamInstruction n)
  | select (pointer : Fin k)
  | commit
  | constant (bit : Bool)

abbrev RegisterRamProgram (n k : Nat) := List (RegisterRamInstruction n k)

def registerStep : RegisterRamInstruction n k → RegisterRamConfig n k → Option (RegisterRamConfig n k)
  | .core (.shiftLeft bit), config =>
      if hdepth : config.activeDepth.val < n then
        some { config with
          address := Path.shiftLeft n config.address bit
          activeDepth := ⟨config.activeDepth.val + 1, by omega⟩ }
      else
        none
  | .core .shiftRight, config =>
      if hdepth : 0 < config.activeDepth.val then
        some { config with
          address := Path.shiftRight n config.address
          activeDepth := ⟨config.activeDepth.val - 1, by omega⟩ }
      else
        none
  | .core instruction, config =>
      let next := ramStep instruction config.core
      some { config with memory := next.memory, accumulator := next.accumulator, address := next.address }
  | .select pointer, config =>
      let selected := config.pointers pointer
      some { config with active := pointer, address := selected.address, activeDepth := selected.depth }
  | .commit, config =>
      some { config with
        pointers := setPointer config.pointers config.active
          { address := config.address, depth := config.activeDepth } }
  | .constant bit, config => some { config with accumulator := bit }

def runRegisterRam : RegisterRamProgram n k → RegisterRamConfig n k → Option (RegisterRamConfig n k)
  | [], config => some config
  | instruction :: program, config => do
      let next ← registerStep instruction config
      runRegisterRam program next

def registerRamCost (program : RegisterRamProgram n k) : Nat := program.length

def actionRamProgram (n : Nat) (action : AddressedOp k) : RegisterRamProgram n k :=
  match action.operation with
  | .up => [.select action.head, .core .shiftRight, .commit]
  | .down0 => [.select action.head, .core (.shiftLeft false), .commit]
  | .down1 => [.select action.head, .core (.shiftLeft true), .commit]
  | .read => [.select action.head, .core .load]
  | .write0 => [.constant false, .select action.head, .core .store]
  | .write1 => [.constant true, .select action.head, .core .store]

theorem actionRamProgram_cost (n : Nat) (action : AddressedOp k) :
    registerRamCost (actionRamProgram n action) ≤ 3 := by
  rcases action with ⟨head, operation⟩
  cases operation <;> simp [actionRamProgram, registerRamCost]

def pointerAddress (head : Head n) : RamAddress n :=
  cast (congrArg Path (by
    rw [List.length_append, List.length_replicate]
    calc
      head.1 + (headPath head).length = (headPath head).length + head.1 := Nat.add_comm _ _
      _ = n := headPath_length head))
    (Path.fromList (List.replicate head.1 false ++ headPath head))

def pointerOfHead (head : Head n) : RamPointer n :=
  { address := pointerAddress head
    depth := ⟨(headPath head).length, by
      have hlength := headPath_length head
      omega⟩ }

def registerEncode (active : Fin k) (config : ActionConfig n k) : RegisterRamConfig n k :=
  { memory := by simpa [RamMemory] using config.memory
    accumulator := false
    address := (pointerOfHead (config.heads active)).address
    active := active
    activeDepth := (pointerOfHead (config.heads active)).depth
    pointers := fun pointer => pointerOfHead (config.heads pointer) }

@[simp] theorem wordAt_repeatWord (address : RamAddress s) (word : RamWord v) :
    wordAt s (repeatWord s word) address = word := by
  induction s with
  | zero => cases address; rfl
  | succ s ih =>
      cases address with
      | cons bit path => cases bit <;> exact ih path

def Cursor.followPrefix : (path : Path depth) → Cursor total (remaining + depth) →
    Cursor total remaining
  | .nil, cursor => cursor
  | .cons false tail, cursor => followPrefix tail (.left cursor)
  | .cons true tail, cursor => followPrefix tail (.right cursor)

def ramWordCursor (address : RamAddress s) : Cursor ((v + s) + 1) v :=
  Cursor.followPrefix address (.left .root)

def accumulatorCursor (s v : Nat) : Cursor ((v + s) + 1) v :=
  Cursor.followPrefix (zeroAddress s) (.right .root)

def localOpOfMove : Move → LocalOp
  | .up => .up
  | .down0 => .down0
  | .down1 => .down1

def liftMoves (head : Fin k) (word : Word) : ActionWord k :=
  word.map fun move => addressed head (localOpOfMove move)

theorem runActions_liftMoves (word : Word) (head : Fin k) (config : ActionConfig n k) :
    runActions (liftMoves head word) config =
      (do
        let moved ← run word (config.heads head)
        pure { config with heads := setHead config.heads head moved }) := by
  induction word generalizing config with
  | nil => simp [liftMoves, runActions, run]
  | cons move word ih =>
      simp only [liftMoves, List.map_cons, runActions, run]
      cases hstep : step move (config.heads head) with
      | none =>
          cases move <;>
            simp [actionStep, moveSelected, addressed, localOpOfMove, hstep]
      | some moved =>
          have haction :
              actionStep (addressed head (localOpOfMove move)) config =
                some { config with heads := setHead config.heads head moved } := by
            cases move <;>
              simp [actionStep, moveSelected, addressed, localOpOfMove, hstep]
          rw [haction]
          simp
          change runActions (liftMoves head word)
              { memory := config.memory, heads := setHead config.heads head moved } = _
          rw [ih]
          simp [setHead_same]

def ascendPrefix : Path depth → Word
  | .nil => []
  | .cons _ tail => ascendPrefix tail ++ [.up]

@[simp] theorem ascendPrefix_length (path : Path depth) : (ascendPrefix path).length = depth := by
  induction path with
  | nil => rfl
  | cons bit tail ih => simp [ascendPrefix, ih]

theorem run_descend_prefix (path : Path depth) (cursor : Cursor total (remaining + depth)) :
    run (descend path) ⟨remaining + depth, cursor⟩ =
      some ⟨remaining, Cursor.followPrefix path cursor⟩ := by
  induction path with
  | nil => rfl
  | cons bit tail ih =>
      cases bit <;>
        simp [descend, run, step, moveDown0, moveDown1, Cursor.followPrefix, ih]

theorem run_ascend_prefix (path : Path depth) (cursor : Cursor total (remaining + depth)) :
    run (ascendPrefix path) ⟨remaining, Cursor.followPrefix path cursor⟩ =
      some ⟨remaining + depth, cursor⟩ := by
  induction path with
  | nil => rfl
  | cons bit tail ih =>
      cases bit <;>
        simp [ascendPrefix, run_append, Cursor.followPrefix, ih, run, step, moveUp] <;>
        omega

def excursion (sourcePath destinationPath : Path depth) (source : Tree remaining) :
    ActionWord 2 :=
  liftMoves copySourceHead (descend sourcePath) ++
  liftMoves copyDestinationHead (descend destinationPath) ++
  copyWord remaining source ++
  liftMoves copySourceHead (ascendPrefix sourcePath) ++
  liftMoves copyDestinationHead (ascendPrefix destinationPath)

theorem excursion_cost (sourcePath destinationPath : Path depth) (source : Tree remaining) :
    actionCost (excursion sourcePath destinationPath source) =
      4 * depth + copyCost remaining := by
  simp only [excursion, actionCost, List.length_append, liftMoves, List.length_map,
    ascendPrefix_length]
  rw [show (descend sourcePath).length = depth by exact cost_descend sourcePath,
    show (descend destinationPath).length = depth by exact cost_descend destinationPath,
    show (copyWord remaining source).length = copyCost remaining by exact copyWord_cost source]
  omega

theorem set_twoHeads_both (source destination : Cursor total oldRemaining)
    (source' destination' : Cursor total newRemaining) :
    setHead
        (setHead (twoHeads source destination) copySourceHead ⟨newRemaining, source'⟩)
        copyDestinationHead ⟨newRemaining, destination'⟩ =
      twoHeads source' destination' := by
  funext head
  rcases head with ⟨i, hi⟩
  cases i with
  | zero => simp [setHead, twoHeads, copySourceHead, copyDestinationHead]
  | succ i =>
      cases i with
      | zero => simp [setHead, twoHeads, copyDestinationHead]
      | succ i => omega

theorem run_excursion (sourcePath destinationPath : Path depth) (source : Tree remaining)
    (memory : Tree total) (sourceRoot destinationRoot : Cursor total (remaining + depth)) :
    runActions (excursion sourcePath destinationPath source)
        { memory, heads := twoHeads sourceRoot destinationRoot } =
      (do
        let memory' ← applyCopyWrites remaining source
          (Cursor.followPrefix destinationPath destinationRoot) memory
        pure { memory := memory', heads := twoHeads sourceRoot destinationRoot }) := by
  simp only [excursion, runActions_append]
  rw [runActions_liftMoves]
  simp only [twoHeads_source]
  rw [run_descend_prefix]
  simp
  rw [runActions_liftMoves]
  simp only
  have hdestination :
      setHead (twoHeads sourceRoot destinationRoot) copySourceHead
          ⟨remaining, Cursor.followPrefix sourcePath sourceRoot⟩ copyDestinationHead =
        ⟨remaining + depth, destinationRoot⟩ := by
    simp [setHead, twoHeads, copySourceHead, copyDestinationHead]
  rw [hdestination]
  rw [run_descend_prefix]
  simp
  rw [set_twoHeads_both]
  rw [run_copyWord_at]
  cases hwrites : applyCopyWrites remaining source
      (Cursor.followPrefix destinationPath destinationRoot) memory with
  | none => simp
  | some memory' =>
      simp
      rw [runActions_liftMoves]
      simp only [twoHeads_source]
      rw [run_ascend_prefix]
      simp
      rw [runActions_liftMoves]
      simp only
      have hdestinationUp :
          setHead
              (twoHeads (Cursor.followPrefix sourcePath sourceRoot)
                (Cursor.followPrefix destinationPath destinationRoot))
              copySourceHead ⟨remaining + depth, sourceRoot⟩ copyDestinationHead =
            ⟨remaining, Cursor.followPrefix destinationPath destinationRoot⟩ := by
        simp [setHead, twoHeads, copySourceHead, copyDestinationHead]
      rw [hdestinationUp]
      rw [run_ascend_prefix]
      simp
      exact set_twoHeads_both _ _ _ _

def wordContextFrom : (s : Nat) → TreeContext total (v + s) → RamMemory s v →
    RamAddress s → TreeContext total v
  | 0, parent, _, .nil => parent
  | s + 1, parent, (left, right), .cons false path =>
      wordContextFrom s (.left parent right) left path
  | s + 1, parent, (left, right), .cons true path =>
      wordContextFrom s (.right left parent) right path

def wordContext (memory : RamMemory s v) (address : RamAddress s) :
    TreeContext (v + s) v :=
  wordContextFrom s .root memory address

theorem wordContextFrom_cursor (parent : TreeContext total (v + s))
    (memory : RamMemory s v) (address : RamAddress s) :
    (wordContextFrom s parent memory address).cursor =
      Cursor.followPrefix address parent.cursor := by
  induction s with
  | zero => cases address; rfl
  | succ s ih =>
      obtain ⟨left, right⟩ := memory
      cases address with
      | cons bit path => cases bit <;> exact ih _ _ path

theorem wordContextFrom_plug (parent : TreeContext total (v + s))
    (memory : RamMemory s v) (address : RamAddress s) (word : RamWord v) :
    (wordContextFrom s parent memory address).plug word =
      parent.plug (writeWord s memory address word) := by
  induction s with
  | zero => cases address; rfl
  | succ s ih =>
      obtain ⟨left, right⟩ := memory
      cases address with
      | cons bit path => cases bit <;> exact ih _ _ path

theorem wordContext_plug_original (memory : RamMemory s v) (address : RamAddress s) :
    (wordContext memory address).plug (wordAt s memory address) = memory := by
  rw [wordContext, wordContextFrom_plug]
  change writeWord s memory address (wordAt s memory address) = memory
  induction s with
  | zero => cases address; rfl
  | succ s ih =>
      obtain ⟨left, right⟩ := memory
      cases address with
      | cons bit path =>
          cases bit with
          | false =>
              change (writeWord s left path (wordAt s left path), right) = (left, right)
              rw [ih left path]
          | true =>
              change (left, writeWord s right path (wordAt s right path)) = (left, right)
              rw [ih right path]

theorem writeWord_wordAt (memory : RamMemory s v) (address : RamAddress s) :
    writeWord s memory address (wordAt s memory address) = memory := by
  induction s with
  | zero => cases address; rfl
  | succ s ih =>
      obtain ⟨left, right⟩ := memory
      cases address with
      | cons bit path =>
          cases bit with
          | false =>
              change (writeWord s left path (wordAt s left path), right) = (left, right)
              rw [ih left path]
          | true =>
              change (left, writeWord s right path (wordAt s right path)) = (left, right)
              rw [ih right path]

theorem wordAt_writeWord_same (memory : RamMemory s v) (address : RamAddress s)
    (word : RamWord v) :
    wordAt s (writeWord s memory address word) address = word := by
  induction s with
  | zero => cases address; rfl
  | succ s ih =>
      obtain ⟨left, right⟩ := memory
      cases address with
      | cons bit path => cases bit <;> exact ih _ path

theorem applyCopyWrites_wordContextFrom (parent : TreeContext total (v + s))
    (memory : RamMemory s v) (address : RamAddress s) (word : RamWord v) :
    applyCopyWrites v word (Cursor.followPrefix address parent.cursor) (parent.plug memory) =
      some (parent.plug (writeWord s memory address word)) := by
  let context := wordContextFrom s parent memory address
  have hcursor : context.cursor = Cursor.followPrefix address parent.cursor :=
    wordContextFrom_cursor parent memory address
  have horiginal : context.plug (wordAt s memory address) = parent.plug memory := by
    rw [wordContextFrom_plug, writeWord_wordAt]
  rw [← hcursor, ← horiginal, applyCopyWrites_context, wordContextFrom_plug]

theorem applyCopyWrites_leftBank (memory scratch : RamMemory s v)
    (address : RamAddress s) (word : RamWord v) :
    applyCopyWrites v word (Cursor.followPrefix address (.left .root)) (memory, scratch) =
      some (writeWord s memory address word, scratch) := by
  simpa [TreeContext.cursor, TreeContext.plug] using
    applyCopyWrites_wordContextFrom
      (.left (.root : TreeContext ((v + s) + 1) ((v + s) + 1)) scratch)
      memory address word

theorem applyCopyWrites_rightBank (memory scratch : RamMemory s v)
    (address : RamAddress s) (word : RamWord v) :
    applyCopyWrites v word (Cursor.followPrefix address (.right .root)) (memory, scratch) =
      some (memory, writeWord s scratch address word) := by
  simpa [TreeContext.cursor, TreeContext.plug] using
    applyCopyWrites_wordContextFrom
      (.right memory (.root : TreeContext ((v + s) + 1) ((v + s) + 1)))
      scratch address word

def encodedConfig (config : RamConfig s v) (scratch : RamMemory s v) :
    ActionConfig ((v + s) + 1) 2 :=
  { memory := (config.memory, scratch), heads := twoHeads .root .root }

def ScratchRepresents (config : RamConfig s v) (scratch : RamMemory s v) : Prop :=
  wordAt s scratch (zeroAddress s) = config.accumulator

def simulatorStart (config : RamConfig s v) : ActionConfig ((v + s) + 1) 2 :=
  encodedConfig config (repeatWord s config.accumulator)

theorem simulatorStart_represents (config : RamConfig s v) :
    ScratchRepresents config (repeatWord s config.accumulator) := by
  exact wordAt_repeatWord (zeroAddress s) config.accumulator

def instructionWord (instruction : RamInstruction s) (config : RamConfig s v) :
    ActionWord 2 :=
  match instruction with
  | .setAddress _ => []
  | .shiftLeft _ => []
  | .shiftRight => []
  | .load =>
      excursion (.cons false config.address) (.cons true (zeroAddress s))
        (wordAt s config.memory config.address)
  | .store =>
      excursion (.cons true (zeroAddress s)) (.cons false config.address)
        config.accumulator

theorem instructionWord_cost (instruction : RamInstruction s) (config : RamConfig s v) :
    actionCost (instructionWord instruction config) ≤ 10 * (s + 2 ^ v) := by
  cases instruction with
  | setAddress address => simp [instructionWord, actionCost]
  | shiftLeft bit => simp [instructionWord, actionCost]
  | shiftRight => simp [instructionWord, actionCost]
  | load =>
      rw [instructionWord, excursion_cost]
      unfold copyCost
      have hpositive : 1 ≤ 2 ^ v := Nat.two_pow_pos v
      omega
  | store =>
      rw [instructionWord, excursion_cost]
      unfold copyCost
      have hpositive : 1 ≤ 2 ^ v := Nat.two_pow_pos v
      omega

theorem simulate_instruction (instruction : RamInstruction s) (config : RamConfig s v)
    (scratch : RamMemory s v) (hscratch : ScratchRepresents config scratch) :
    ∃ scratch',
      runActions (instructionWord instruction config) (encodedConfig config scratch) =
          some (encodedConfig (ramStep instruction config) scratch') ∧
        ScratchRepresents (ramStep instruction config) scratch' := by
  cases instruction with
  | setAddress address =>
      refine ⟨scratch, ?_, ?_⟩
      · simp [instructionWord, encodedConfig, ramStep, runActions]
      · simpa [ScratchRepresents, ramStep] using hscratch
  | shiftLeft bit =>
      refine ⟨scratch, ?_, ?_⟩
      · simp [instructionWord, encodedConfig, ramStep, runActions]
      · simpa [ScratchRepresents, ramStep] using hscratch
  | shiftRight =>
      refine ⟨scratch, ?_, ?_⟩
      · simp [instructionWord, encodedConfig, ramStep, runActions]
      · simpa [ScratchRepresents, ramStep] using hscratch
  | load =>
      let loaded := wordAt s config.memory config.address
      let scratch' := writeWord s scratch (zeroAddress s) loaded
      refine ⟨scratch', ?_, ?_⟩
      · change
          runActions
              (excursion (.cons false config.address) (.cons true (zeroAddress s)) loaded)
              ({ memory := (config.memory, scratch), heads := twoHeads .root .root } :
                ActionConfig ((v + s) + 1) 2) =
            some ({ memory := (config.memory, scratch'), heads := twoHeads .root .root } :
              ActionConfig ((v + s) + 1) 2)
        rw [run_excursion]
        change
          (do
            let memory' ← applyCopyWrites v loaded
              (Cursor.followPrefix (zeroAddress s) (.right .root))
              (config.memory, scratch)
            pure ({ memory := memory', heads := twoHeads .root .root } :
              ActionConfig ((v + s) + 1) 2)) =
            some ({ memory := (config.memory, scratch'), heads := twoHeads .root .root } :
              ActionConfig ((v + s) + 1) 2)
        rw [applyCopyWrites_rightBank]
        rfl
      · exact wordAt_writeWord_same scratch (zeroAddress s) loaded
  | store =>
      let memory' := writeWord s config.memory config.address config.accumulator
      refine ⟨scratch, ?_, ?_⟩
      · change
          runActions
              (excursion (.cons true (zeroAddress s)) (.cons false config.address)
                config.accumulator)
              ({ memory := (config.memory, scratch), heads := twoHeads .root .root } :
                ActionConfig ((v + s) + 1) 2) =
            some ({ memory := (memory', scratch), heads := twoHeads .root .root } :
              ActionConfig ((v + s) + 1) 2)
        rw [run_excursion]
        change
          (do
            let memory'' ← applyCopyWrites v config.accumulator
              (Cursor.followPrefix config.address (.left .root))
              (config.memory, scratch)
            pure ({ memory := memory'', heads := twoHeads .root .root } :
              ActionConfig ((v + s) + 1) 2)) =
            some ({ memory := (memory', scratch), heads := twoHeads .root .root } :
              ActionConfig ((v + s) + 1) 2)
        rw [applyCopyWrites_leftBank]
        rfl
      · simpa [ScratchRepresents, ramStep] using hscratch

def compileProgram : RamProgram s → RamConfig s v → ActionWord 2
  | [], _ => []
  | instruction :: program, config =>
      instructionWord instruction config ++ compileProgram program (ramStep instruction config)

theorem compileProgram_cost (program : RamProgram s) (config : RamConfig s v) :
    actionCost (compileProgram program config) ≤
      10 * ramCost program * (s + 2 ^ v) := by
  induction program generalizing config with
  | nil => simp [compileProgram, actionCost, ramCost]
  | cons instruction program ih =>
      simp only [compileProgram, actionCost, List.length_append, ramCost, List.length_cons]
      have hstep := instructionWord_cost instruction config
      have hrest := ih (ramStep instruction config)
      change (instructionWord instruction config).length ≤ _ at hstep
      change (compileProgram program (ramStep instruction config)).length ≤ _ at hrest
      simp only [ramCost] at hrest
      calc
        (instructionWord instruction config).length +
              (compileProgram program (ramStep instruction config)).length ≤
            10 * (s + 2 ^ v) + 10 * program.length * (s + 2 ^ v) :=
          Nat.add_le_add hstep hrest
        _ = 10 * program.length * (s + 2 ^ v) + 10 * (s + 2 ^ v) :=
          Nat.add_comm _ _
        _ = (10 * program.length + 10) * (s + 2 ^ v) := by
          exact (Nat.add_mul _ _ _).symm
        _ = 10 * (program.length + 1) * (s + 2 ^ v) := by
          congr 1

theorem simulate_program (program : RamProgram s) (config : RamConfig s v)
    (scratch : RamMemory s v) (hscratch : ScratchRepresents config scratch) :
    ∃ scratch',
      runActions (compileProgram program config) (encodedConfig config scratch) =
          some (encodedConfig (runRam program config) scratch') ∧
        ScratchRepresents (runRam program config) scratch' := by
  induction program generalizing config scratch with
  | nil =>
      exact ⟨scratch, by rfl, hscratch⟩
  | cons instruction program ih =>
      obtain ⟨middleScratch, hstep, hmiddle⟩ :=
        simulate_instruction instruction config scratch hscratch
      obtain ⟨finalScratch, hrest, hfinal⟩ :=
        ih (ramStep instruction config) middleScratch hmiddle
      refine ⟨finalScratch, ?_, ?_⟩
      · rw [compileProgram, runActions_append, hstep]
        simpa [runRam] using hrest
      · simpa [runRam] using hfinal

theorem ram_program_simulation (program : RamProgram s) (config : RamConfig s v) :
    ∃ scratch',
      runActions (compileProgram program config) (simulatorStart config) =
          some (encodedConfig (runRam program config) scratch') ∧
        ScratchRepresents (runRam program config) scratch' ∧
        actionCost (compileProgram program config) ≤
          10 * ramCost program * (s + 2 ^ v) := by
  obtain ⟨scratch, hexec, hrep⟩ :=
    simulate_program program config (repeatWord s config.accumulator)
      (simulatorStart_represents config)
  exact ⟨scratch, hexec, hrep, compileProgram_cost program config⟩

#print axioms addressToPath_correct
#print axioms run_excursion
#print axioms instructionWord_cost
#print axioms simulate_instruction
#print axioms compileProgram_cost
#print axioms ram_program_simulation

end Adic.Dyadic
