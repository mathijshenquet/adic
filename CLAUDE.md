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
- Drive-progress (imported from composix 2026-08-09; activated
  standing by Mathijs same day). It grants *direction*-autonomy,
  never *decision*-autonomy: new design decisions stay joint, all
  work lands through the normal track/gate/merge discipline, and
  every launch is announced in chat as it starts.
  1. **Open ends first**: any accepted-AIP or recorded open end not
     implemented, in-flight, or explicitly slotted with a reason →
     implement or schedule it. Blockers are surfaced, never silently
     queued. Slots stay filled within capacity (binding constraints:
     shared axes at gate time + genuinely independent work items).
  2. **Dry → prospect once**: when no open ends remain, do ONE
     codebase/design sweep for unblockers and land findings as
     `aips/draft/` entries (linked to Mathijs by full GitHub URL).
     Drafts are the only output — prospecting never starts
     implementation on its own authority.
  - Idle-state: step 1 empty and step 2 already run since the last
    merge → the correct action is nothing; say so and wait. Every
    merge re-arms one sweep.
- Worker out-clause (Mathijs, 2026-08-09): every spec and every
  substantial prompt to a worker explicitly offers the out —
  "running into problems → say so and stop"; an honest
  wall/blocked report is a valued deliverable, never a failure.
  Never write a prompt that only defines success.
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
