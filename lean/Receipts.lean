import Adic
import Lean
import Lean.Data.Json
import Lean.PrettyPrinter
import Lean.Util.CollectAxioms

open Lean System

structure ReceiptPaths where
  manifest : FilePath
  output : FilePath

def findDefaultPaths : IO ReceiptPaths := do
  let fromRoot : ReceiptPaths :=
    { manifest := "expo/receipts-manifest.txt", output := "expo/receipts.json" }
  if ← fromRoot.manifest.pathExists then
    return fromRoot
  let fromLean : ReceiptPaths :=
    { manifest := "../expo/receipts-manifest.txt", output := "../expo/receipts.json" }
  if ← fromLean.manifest.pathExists then
    return fromLean
  throw <| IO.userError
    "cannot find expo/receipts-manifest.txt from the current directory"

def parseManifest (contents : String) : IO (Array String) := do
  let mut names := #[]
  for (line, index) in (contents.splitOn "\n").zipIdx do
    let entry := (line.splitOn "#").head!.trimAscii.copy
    if !entry.isEmpty then
      if names.contains entry then
        throw <| IO.userError s!"duplicate declaration on manifest line {index + 1}: {entry}"
      names := names.push entry
  if names.isEmpty then
    throw <| IO.userError "receipt manifest contains no declarations"
  return names

def fnv1a64 (text : String) : UInt64 :=
  text.toUTF8.data.foldl
    (fun hash byte => (hash ^^^ byte.toUInt64) * 1099511628211)
    14695981039346656037

def fixedHex (value : UInt64) : String :=
  let digits := String.ofList (Nat.toDigits 16 value.toNat)
  String.ofList (List.replicate (16 - digits.length) '0') ++ digits

def statementHash (statement : String) : String :=
  (fixedHex (fnv1a64 statement)).take 12 |>.copy

def receiptFor (env : Environment) (declaration : String) : IO Json := do
  let name := declaration.toName
  if name.isAnonymous then
    throw <| IO.userError s!"invalid declaration name in receipt manifest: {declaration}"
  let some info := env.find? name
    | throw <| IO.userError s!"unresolved declaration in receipt manifest: {declaration}"
  unless info matches .thmInfo _ do
    throw <| IO.userError s!"receipt declaration is not a theorem: {declaration}"
  let context : PPContext := {
    env
    mctx := {}
    lctx := {}
    opts := ({} : Options)
      |>.set `pp.all false
      |>.set `pp.notation true
      |>.set `pp.explicit false
      |>.set `pp.coercions true
    currNamespace := name.getPrefix
    openDecls := []
  }
  let (signature, axioms) ← context.runMetaM do
    let signature ← PrettyPrinter.ppSignature name
    let axioms ← collectAxioms name
    return (signature.fmt, axioms)
  let signatureText := signature.pretty 80
  unless signatureText.startsWith declaration do
    throw <| IO.userError s!"pretty-printer changed the declaration name: {declaration}"
  let signatureTail := signatureText.drop declaration.length |>.copy
  let statement := s!"theorem {name.getString!}{signatureTail}"
  let axiomNames := (axioms.map Name.toString).qsort (· < ·)
  return Json.mkObj [
    ("name", toJson declaration),
    ("statement", toJson statement),
    ("axioms", toJson axiomNames),
    ("hash", toJson (statementHash statement))
  ]

unsafe def generateReceipts (paths : ReceiptPaths) : IO Unit := do
  initSearchPath (← findSysroot)
  enableInitializersExecution
  let env ← importModules
    #[{ module := `Lean, isMeta := true }, { module := `Adic, isMeta := true }] {}
    (leakEnv := true) (loadExts := true)
  let manifest ← IO.FS.readFile paths.manifest
  let names ← parseManifest manifest
  let receipts ← names.mapM (receiptFor env)
  IO.FS.writeFile paths.output (Json.pretty (.arr receipts) 80 ++ "\n")
  IO.println s!"wrote {receipts.size} Lean receipts to {paths.output}"

unsafe def main (args : List String) : IO UInt32 := do
  try
    let paths ← match args with
      | [] => findDefaultPaths
      | [manifest, output] =>
          pure { manifest := ⟨manifest⟩, output := ⟨output⟩ }
      | _ => throw <| IO.userError "usage: receipts [MANIFEST OUTPUT]"
    generateReceipts paths
    return 0
  catch error =>
    IO.eprintln s!"receipts: {error}"
    return 1
