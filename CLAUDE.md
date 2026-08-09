@AGENTS.md

Working with Mathijs (imported from composix, 2026-08-09):
- Roles: Claude carries overview + execution, Mathijs gives short taste
  calls — record them immediately (AIP or LOG), don't re-ask. Design
  questions go to him as prose in chat or a committed AIP draft with
  its path/URL — never interactive option-pickers.
- Complexity discipline: measure before restructuring; v0 means
  speculative compat gets deleted, not maintained.
- Development speed is a standing priority; correctness gates stay
  uncompromised.

Orchestrator notes (Claude only):
- Session start ritual: read `.dev/LOG.md` top entry — that's
  sufficient context; explore deeper only on demand.
- Mathijs decision queue lives in the LOG's "Open with Mathijs" line —
  surface it at session start, don't re-derive it.
- Delegation: implementation work goes to codex agents (luna for rote
  fan-out, terra for tight specs, sol for taste/decisions on the fly);
  Claude stays orchestrator/designer/reviewer. Micro-fix exception:
  work may be orchestrator-direct whenever the delegation prompt would
  be longer than the fix itself, with buffer.
- Worker discipline (herdr launch recipe, watcher + ~10-minute fallback
  heartbeat, steer/queue delivery) lives in the global context — follow
  it.
- Standing grants: none yet. Commit/push/merge autonomy for this repo
  is an open item with Mathijs, not inherited from composix.
