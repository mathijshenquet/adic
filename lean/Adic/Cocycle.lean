import Adic.Dyadic

namespace Adic.Dyadic

def IsCocycle {n : Nat} (f : Word → Head n → Nat) : Prop :=
  (∀ head, f [] head = 0) ∧
    ∀ first second head middle,
      run first head = some middle →
      f (first ++ second) head = f first head + f second middle

def symCost (word : Word) : Nat := word.length

theorem cost_isCocycle : IsCocycle (fun word (_ : Head n) => cost word) := by
  constructor
  · intro head
    simp
  · intro first second head middle hrun
    simp [cost_append]

theorem symCost_isCocycle : IsCocycle (fun word (_ : Head n) => symCost word) := by
  constructor
  · intro head
    rfl
  · intro first second head middle hrun
    simp [symCost]

def Exchange {n : Nat} (f g : Word → Head n → Nat) (potential : Head n → Nat) : Prop :=
  ∀ word head final,
    run word head = some final →
    f word head + potential head = g word head + potential final

theorem exchange_append {f g : Word → Head n → Nat} {potential : Head n → Nat}
    (hf : IsCocycle f) (hg : IsCocycle g) (exchange : Exchange f g potential)
    (first second : Word) (head middle final : Head n)
    (hfirst : run first head = some middle) (hsecond : run second middle = some final) :
    f (first ++ second) head + potential head =
      g (first ++ second) head + potential final := by
  have hfcomp := hf.2 first second head middle hfirst
  have hgcomp := hg.2 first second head middle hfirst
  have efirst := exchange first head middle hfirst
  have esecond := exchange second middle final hsecond
  omega

def depth : Head n → Nat
  | ⟨_, cursor⟩ => cursor.path.length

theorem freeUp_exchange_step (move : Move) (head final : Head n)
    (hstep : step move head = some final) :
    2 * move.cost + depth head = 1 + depth final := by
  cases move <;> rcases head with ⟨remaining, cursor⟩
  · cases cursor with
    | root => simp [step, moveUp] at hstep
    | left parent =>
        simp [step, moveUp] at hstep
        subst final
        simp [Move.cost, depth, Cursor.path_left, List.length_append]
        omega
    | right parent =>
        simp [step, moveUp] at hstep
        subst final
        simp [Move.cost, depth, Cursor.path_right, List.length_append]
        omega
  · cases remaining with
    | zero => simp [step, moveDown0] at hstep
    | succ remaining =>
        simp [step, moveDown0] at hstep
        subst final
        simp [Move.cost, depth, Cursor.path_left, List.length_append]
        omega
  · cases remaining with
    | zero => simp [step, moveDown1] at hstep
    | succ remaining =>
        simp [step, moveDown1] at hstep
        subst final
        simp [Move.cost, depth, Cursor.path_right, List.length_append]
        omega

theorem freeUp_exchange (word : Word) (head final : Head n)
    (hrun : run word head = some final) :
    2 * cost word + depth head = symCost word + depth final := by
  induction word generalizing head with
  | nil =>
      simp only [run] at hrun
      cases hrun
      simp [symCost]
  | cons move word ih =>
      simp only [run] at hrun
      cases hstep : step move head with
      | none => simp [hstep] at hrun
      | some middle =>
          simp only [hstep] at hrun
          have hmove := freeUp_exchange_step move head middle hstep
          have htail := ih middle hrun
          simp [cost_cons, symCost] at htail ⊢
          omega

theorem freeUp_exchange_form :
    Exchange (fun word (_ : Head n) => 2 * cost word)
      (fun word (_ : Head n) => symCost word) depth := by
  intro word head final hrun
  exact freeUp_exchange word head final hrun

theorem freeUp_safety_bound (word : Word) (head final : Head n)
    (hrun : run word head = some final) :
    symCost word ≤ 2 * cost word + depth head := by
  have exchange := freeUp_exchange word head final hrun
  omega

#print axioms cost_isCocycle
#print axioms symCost_isCocycle
#print axioms exchange_append
#print axioms freeUp_exchange
#print axioms freeUp_exchange_form
#print axioms freeUp_safety_bound

end Adic.Dyadic
