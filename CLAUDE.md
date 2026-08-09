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
- Drive progress (standing mode, Mathijs 2026-08-09): when a track
  lands and independently verifies green, merge and launch the next
  deliverable in roadmap order without asking — keep the trunk moving
  while Mathijs is away. Process problems get raised explicitly and
  promptly, never silently worked around. Taste calls still queue for
  Mathijs; progress never waits on ones that don't block it.
- Worker discipline (herdr launch recipe, watcher + ~10-minute fallback
  heartbeat, steer/queue delivery) lives in the global context — follow
  it. Heartbeat flow, made explicit: while any worker is in flight,
  keep BOTH a terminal-state watcher (`herdr agent wait --until done
  --until blocked --until idle`) and a ~10-min fallback timer armed;
  re-arm the fallback on every wake regardless of wake source; expect
  stale timers from earlier phases to fire (check which phase a timer
  belongs to before acting). Verify prompt landing with `agent wait
  --until working` (more reliable than the refusal check); expect the
  first prompt after `agent start` to be swallowed, and give `agent
  start` a >70s retry window while direnv builds a fresh devenv env.
- Standing grants (Mathijs, 2026-08-09): commit + push to main for
  AIP/docs/LOG work — Mathijs reads on GitHub, so conversation-driven
  doc updates should land there promptly without asking. Merge of
  code tracks: still per-instruction. Caution: gitsitter auto-pushes
  within seconds of a commit on main — check `git ls-remote` before
  amending, and never amend what the remote already has (unless
  deliberately rewriting, then `--force-with-lease`).
