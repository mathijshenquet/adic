import Adic.Dyadic

namespace Adic.Dyadic

namespace Tree

def readAt : (n : Nat) → Tree n → List Bool → Option Bool
  | 0, bit, [] => some bit
  | 0, _, _ :: _ => none
  | _ + 1, _, [] => none
  | n + 1, (left, _), false :: path => readAt n left path
  | n + 1, (_, right), true :: path => readAt n right path

def writeAt : (n : Nat) → Tree n → List Bool → Bool → Option (Tree n)
  | 0, _, [], bit => some bit
  | 0, _, _ :: _, _ => none
  | _ + 1, _, [], _ => none
  | n + 1, (left, right), false :: path, bit => do
      let left' ← writeAt n left path bit
      pure (left', right)
  | n + 1, (left, right), true :: path, bit => do
      let right' ← writeAt n right path bit
      pure (left, right')

end Tree

inductive LocalOp where
  | up
  | down0
  | down1
  | read
  | write0
  | write1
  deriving DecidableEq, Repr

structure AddressedOp (k : Nat) where
  head : Fin k
  operation : LocalOp
  deriving DecidableEq, Repr

structure ActionConfig (n k : Nat) where
  memory : Tree n
  heads : Fin k → Head n

def setHead (heads : Fin k → Head n) (head : Fin k) (value : Head n) : Fin k → Head n :=
  fun queried => if queried = head then value else heads queried

def selectedLeaf (config : ActionConfig n k) (head : Fin k) : Option (List Bool) :=
  leafPosition (config.heads head)

def readSelected (config : ActionConfig n k) (head : Fin k) : Option Bool := do
  let path ← selectedLeaf config head
  Tree.readAt n config.memory path

def checkRead (config : ActionConfig n k) (head : Fin k) : Option (ActionConfig n k) := do
  let _ ← readSelected config head
  pure config

def writeSelected (config : ActionConfig n k) (head : Fin k) (bit : Bool) :
    Option (ActionConfig n k) := do
  let path ← selectedLeaf config head
  let memory ← Tree.writeAt n config.memory path bit
  pure { config with memory }

def moveSelected (config : ActionConfig n k) (head : Fin k) (move : Move) :
    Option (ActionConfig n k) := do
  let moved ← step move (config.heads head)
  pure { config with heads := setHead config.heads head moved }

def actionStep (operation : AddressedOp k) (config : ActionConfig n k) :
    Option (ActionConfig n k) :=
  match operation.operation with
  | .up => moveSelected config operation.head .up
  | .down0 => moveSelected config operation.head .down0
  | .down1 => moveSelected config operation.head .down1
  | .read => checkRead config operation.head
  | .write0 => writeSelected config operation.head false
  | .write1 => writeSelected config operation.head true

abbrev ActionWord (k : Nat) := List (AddressedOp k)

def actionCost (word : ActionWord k) : Nat := word.length

def runActions : ActionWord k → ActionConfig n k → Option (ActionConfig n k)
  | [], config => some config
  | operation :: word, config => do
      let next ← actionStep operation config
      runActions word next

theorem runActions_append (first second : ActionWord k) (config : ActionConfig n k) :
    runActions (first ++ second) config =
      (do
        let middle ← runActions first config
        runActions second middle) := by
  induction first generalizing config with
  | nil => simp [runActions]
  | cons operation first ih =>
      simp only [List.cons_append, runActions]
      cases hstep : actionStep operation config with
      | none => simp
      | some next => simp [ih]

inductive Instruction (State : Type) (k : Nat) where
  | up (head : Fin k) (next : State)
  | down0 (head : Fin k) (next : State)
  | down1 (head : Fin k) (next : State)
  | read (head : Fin k) (onFalse onTrue : State)
  | write0 (head : Fin k) (next : State)
  | write1 (head : Fin k) (next : State)
  | halt

structure Program (k : Nat) where
  stateCount : Nat
  transition : Fin stateCount → Instruction (Fin stateCount) k

inductive Control (k : Nat) (program : Program k) where
  | running (state : Fin program.stateCount)
  | halted

structure Config (k : Nat) (program : Program k) (n : Nat) extends ActionConfig n k where
  control : Control k program

def Config.action (config : Config k program n) : ActionConfig n k :=
  config.toActionConfig

def Config.withAction (config : Config k program n) (action : ActionConfig n k) :
    Config k program n :=
  { memory := action.memory, heads := action.heads, control := config.control }

def executeInstruction (config : Config k program n)
    (instruction : Instruction (Fin program.stateCount) k) : Option (Config k program n) :=
  match instruction with
  | .up head next => do
      let action ← actionStep ⟨head, .up⟩ config.action
      pure { memory := action.memory, heads := action.heads, control := .running next }
  | .down0 head next => do
      let action ← actionStep ⟨head, .down0⟩ config.action
      pure { memory := action.memory, heads := action.heads, control := .running next }
  | .down1 head next => do
      let action ← actionStep ⟨head, .down1⟩ config.action
      pure { memory := action.memory, heads := action.heads, control := .running next }
  | .read head onFalse onTrue => do
      let bit ← readSelected config.action head
      pure { config with control := .running (if bit then onTrue else onFalse) }
  | .write0 head next => do
      let action ← actionStep ⟨head, .write0⟩ config.action
      pure { memory := action.memory, heads := action.heads, control := .running next }
  | .write1 head next => do
      let action ← actionStep ⟨head, .write1⟩ config.action
      pure { memory := action.memory, heads := action.heads, control := .running next }
  | .halt => some { config with control := .halted }

def machineStep (config : Config k program n) : Option (Config k program n) :=
  match config.control with
  | .halted => none
  | .running state => executeInstruction config (program.transition state)

def runFor : Nat → Config k program n → Option (Config k program n)
  | 0, config => some config
  | steps + 1, config => do
      let next ← machineStep config
      runFor steps next

def runUntilHalt : Nat → Config k program n → Option (Config k program n × Nat)
  | _, config@{ control := .halted, .. } => some (config, 0)
  | 0, { control := .running _, .. } => none
  | fuel + 1, config@{ control := .running _, .. } => do
      let next ← machineStep config
      let (final, cost) ← runUntilHalt fuel next
      pure (final, cost + 1)

end Adic.Dyadic
