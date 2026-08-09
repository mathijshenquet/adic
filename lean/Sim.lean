import Adic.Copy

namespace Adic.Dyadic

def sampleTree : (n : Nat) → Tree n
  | 0 => true
  | n + 1 => (sampleTree n, Tree.falseTree n)

def treeEqual : {n : Nat} → Tree n → Tree n → Bool
  | 0, left, right => (show Bool from left) == (show Bool from right)
  | _ + 1, (left₀, left₁), (right₀, right₁) =>
      treeEqual left₀ right₀ && treeEqual left₁ right₁

def fail (message : String) : IO Bool := do
  IO.eprintln s!"FAIL: {message}"
  pure false

def checkEulerCost (grade : Nat) : IO Bool := do
  let actual := cost (euler grade)
  let expected := 2 * (2 ^ grade - 1)
  if actual == expected then
    pure true
  else
    fail s!"grade {grade}: euler cost {actual} /= {expected}"

def checkZipCost (grade : Nat) : IO Bool := do
  let a := Tree.falseTree grade
  let b := sampleTree grade
  let actual := actionCost (zipWord grade a b)
  let expected := 12 * 2 ^ grade - 6
  if actual == expected then
    pure true
  else
    fail s!"grade {grade}: zip cost {actual} /= {expected}"

def checkCopyCost (grade : Nat) : IO Bool := do
  let source := sampleTree grade
  let actual := actionCost (copyWord grade source)
  let expected := 6 * 2 ^ grade - 4
  if actual == expected then
    pure true
  else
    fail s!"grade {grade}: copy cost {actual} /= {expected}"

def checkEulerRun (grade : Nat) : IO Bool := do
  match run (euler grade) (rootHead grade) with
  | some _ => pure true
  | none => fail s!"grade {grade}: euler run failed"

-- `zipWord_shape_independent` and `copyWord_shape_independent` prove that these
-- false/non-trivial representative inputs have the same cost as every same-grade input.
def checkZipRun (grade : Nat) : IO Bool := do
  let a := Tree.falseTree grade
  let b := sampleTree grade
  match runActions (zipWord grade a b) (zipStart a b) with
  | some final =>
      let expected := zipMemory a b (interleave grade a b)
      if treeEqual final.memory expected then
        pure true
      else
        fail s!"grade {grade}: zip output differs from interleave"
  | none => fail s!"grade {grade}: zip run failed"

def checkCopyRun (grade : Nat) : IO Bool := do
  let source := sampleTree grade
  let destination := Tree.falseTree grade
  match runActions (copyWord grade source) (copyStart source destination) with
  | some final =>
      if treeEqual final.memory (copyMemory source source) then
        pure true
      else
        fail s!"grade {grade}: copy destination differs from source"
  | none => fail s!"grade {grade}: copy run failed"

def checkGrade (grade runLimit : Nat) : IO Bool := do
  let eulerCostOk ← checkEulerCost grade
  let zipCostOk ← checkZipCost grade
  let copyCostOk ← checkCopyCost grade
  let a := Tree.falseTree grade
  let b := sampleTree grade
  let source := sampleTree grade
  IO.println s!"{grade}\t{cost (euler grade)}\t{actionCost (zipWord grade a b)}\t{actionCost (copyWord grade source)}"
  if grade ≤ runLimit then
    let eulerRunOk ← checkEulerRun grade
    let zipRunOk ← checkZipRun grade
    let copyRunOk ← checkCopyRun grade
    pure (eulerCostOk && zipCostOk && copyCostOk && eulerRunOk && zipRunOk && copyRunOk)
  else
    pure (eulerCostOk && zipCostOk && copyCostOk)

def checkAll (maxGrade runLimit : Nat) : IO Bool := do
  let mut ok := true
  for grade in List.range (maxGrade + 1) do
    ok := (← checkGrade grade runLimit) && ok
  pure ok

def parseMaxGrade : List String → Option Nat
  | [] => some 12
  | [argument] => argument.toNat?
  | _ => none

def runMain (arguments : List String) : IO UInt32 := do
  match parseMaxGrade arguments with
  | none =>
      IO.eprintln "usage: lake exe sim [max-grade]"
      pure 2
  | some maxGrade =>
      let runLimit := min maxGrade 10
      IO.println s!"grade\teuler\tzip\tcopy"
      let ok ← checkAll maxGrade runLimit
      if ok then
        IO.println s!"PASS: checked costs through grade {maxGrade}; ran words through grade {runLimit}."
        pure 0
      else
        pure 1

end Adic.Dyadic

def main (arguments : List String) : IO UInt32 :=
  Adic.Dyadic.runMain arguments
