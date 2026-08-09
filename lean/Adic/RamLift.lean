import Adic.Ram

namespace Adic.Dyadic

def normalizeRegister (head : Fin k) : RegisterRamProgram n k :=
  [.constant false, .select head]

theorem runRegisterRam_append (first second : RegisterRamProgram n k)
    (config : RegisterRamConfig n k) :
    runRegisterRam (first ++ second) config =
      (do
        let middle ← runRegisterRam first config
        runRegisterRam second middle) := by
  induction first generalizing config with
  | nil => simp [runRegisterRam]
  | cons instruction first ih =>
      simp only [List.cons_append, runRegisterRam]
      cases hstep : registerStep instruction config with
      | none => simp
      | some next => simp [ih]

@[simp] theorem registerRamCost_append (first second : RegisterRamProgram n k) :
    registerRamCost (first ++ second) =
      registerRamCost first + registerRamCost second := by
  simp [registerRamCost]

theorem normalizeRegister_correct (head : Fin k) (source : ActionConfig n k)
    (target : RegisterRamConfig n k) (hrep : RegisterRep source target) :
    runRegisterRam (normalizeRegister head) target = some (registerEncode head source) := by
  have hmemory : target.memory = asBitRamMemory n source.memory := by
    calc
      target.memory = asBitRamMemory n (bitMemory n target.memory) :=
        (asBitRamMemory_bitMemory target.memory).symm
      _ = asBitRamMemory n source.memory := congrArg (asBitRamMemory n) hrep.1
  have hpointers : target.pointers = fun pointer => pointerOfHead (source.heads pointer) := by
    funext pointer
    exact hrep.2 pointer
  simp [normalizeRegister, runRegisterRam, registerStep, registerEncode,
    hmemory, hpointers]

def normalizedActionRamProgram (n : Nat) (action : AddressedOp k) :
    RegisterRamProgram n k :=
  normalizeRegister action.head ++ actionRamProgram n action

theorem normalizedActionRamProgram_cost (n : Nat) (action : AddressedOp k) :
    registerRamCost (normalizedActionRamProgram n action) ≤ 5 := by
  rw [normalizedActionRamProgram, registerRamCost_append]
  have haction := actionRamProgram_cost n action
  simpa [normalizeRegister, registerRamCost] using Nat.add_le_add_left haction 2

theorem normalized_action_simulation (action : AddressedOp k)
    (source next : ActionConfig n k) (start : RegisterRamConfig n k)
    (hrep : RegisterRep source start) (hstep : actionStep action source = some next) :
    ∃ target,
      runRegisterRam (normalizedActionRamProgram n action) start = some target ∧
        RegisterRep next target ∧
          registerRamCost (normalizedActionRamProgram n action) ≤ 5 := by
  obtain ⟨_, hsimulate⟩ := (ram_action_simulation (n := n) (k := k))
  obtain ⟨target, hrun, htargetRep, _⟩ := hsimulate action source next hstep
  refine ⟨target, ?_, htargetRep, normalizedActionRamProgram_cost n action⟩
  rw [normalizedActionRamProgram, runRegisterRam_append]
  rw [normalizeRegister_correct action.head source start hrep]
  exact hrun

def compileActionWord (n : Nat) : ActionWord k → RegisterRamProgram n k
  | [] => []
  | action :: word => normalizedActionRamProgram n action ++ compileActionWord n word

def freeUpCount : ActionWord k → Nat
  | [] => 0
  | action :: word =>
      (match action.operation with | .up => 1 | _ => 0) + freeUpCount word

@[simp] theorem actionCost_add_freeUpCount_cons (action : AddressedOp k)
    (word : ActionWord k) :
    actionCost (action :: word) + freeUpCount (action :: word) =
      actionCost word + freeUpCount word + 1 := by
  rcases action with ⟨head, operation⟩
  cases operation <;> simp [freeUpCount, LocalOp.cost] <;> omega

theorem compileActionWord_cost (n : Nat) (word : ActionWord k) :
    registerRamCost (compileActionWord n word) ≤
      5 * (actionCost word + freeUpCount word) := by
  induction word with
  | nil => simp [compileActionWord, registerRamCost, actionCost, freeUpCount]
  | cons action word ih =>
      rw [compileActionWord, registerRamCost_append]
      have haction := normalizedActionRamProgram_cost n action
      rw [actionCost_add_freeUpCount_cons]
      omega

theorem compileActionWord_simulation (word : ActionWord k)
    (source final : ActionConfig n k) (start : RegisterRamConfig n k)
    (hrep : RegisterRep source start) (hrun : runActions word source = some final) :
    ∃ target,
      runRegisterRam (compileActionWord n word) start = some target ∧
        RegisterRep final target ∧
          registerRamCost (compileActionWord n word) ≤
            5 * (actionCost word + freeUpCount word) := by
  induction word generalizing source start with
  | nil =>
      simp only [runActions] at hrun
      injection hrun with equality
      subst source
      exact ⟨start, by simp [compileActionWord, runRegisterRam], hrep,
        by simp [compileActionWord, registerRamCost, actionCost, freeUpCount]⟩
  | cons action word ih =>
      simp only [runActions] at hrun
      cases hstep : actionStep action source with
      | none => simp [hstep] at hrun
      | some middle =>
          simp only [hstep] at hrun
          obtain ⟨ramMiddle, hactionRun, hmiddleRep, hactionCost⟩ :=
            normalized_action_simulation action source middle start hrep hstep
          obtain ⟨target, hwordRun, htargetRep, hwordCost⟩ :=
            ih middle ramMiddle hmiddleRep hrun
          refine ⟨target, ?_, htargetRep, compileActionWord_cost n (action :: word)⟩
          rw [compileActionWord, runRegisterRam_append, hactionRun]
          exact hwordRun

theorem ram_program_reverse_simulation :
    ∃ c, ∀ (word : ActionWord k) (source final : ActionConfig n k)
      (start : RegisterRamConfig n k),
      RegisterRep source start →
        runActions word source = some final →
          ∃ target,
            runRegisterRam (compileActionWord n word) start = some target ∧
              RegisterRep final target ∧
                registerRamCost (compileActionWord n word) ≤
                  c * (actionCost word + freeUpCount word) := by
  refine ⟨5, ?_⟩
  intro word source final start hrep hrun
  exact compileActionWord_simulation word source final start hrep hrun

#print axioms normalizeRegister_correct
#print axioms normalized_action_simulation
#print axioms compileActionWord_cost
#print axioms compileActionWord_simulation
#print axioms ram_program_reverse_simulation

end Adic.Dyadic
