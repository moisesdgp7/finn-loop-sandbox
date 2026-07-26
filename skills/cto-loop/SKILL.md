---
name: cto-loop
description: Use when Codex should repeat CTO Build or CTO Review in bounded passes through a Goal, Automation, or supervised session.
---

# CTO Loop

Provide a thin Codex runner for the two independent Finn-loop workers. Linear
and GitHub remain the durable sources of truth. Worker policy lives only in
`cto-build` and `cto-review`.

## 1. Select one mode

Require exactly one mode:

- `build`: invoke `cto-build` once per pass;
- `review`: invoke `cto-review` once per pass.

If the request does not identify a mode, ask which one to run. Do not
automatically alternate build and review in the same context. A fresh review
pass should inspect a builder's PR independently.

## 2. Set a bound

Before repetition, require an explicit bound such as:

- one pass;
- a maximum number of passes;
- continue until the selected worker reports an empty queue;
- continue until a human gate or blocker stops the run.

Use a Codex Goal for bounded continuation or Automation for a scheduled
trigger. Re-read live Linear and GitHub state on every pass.

## 3. Run

For each pass:

1. Invoke the selected worker skill.
2. Preserve its complete result and evidence.
3. Stop immediately when it reports idle, blocked, waiting, human review, or
   another terminal condition.
4. Otherwise continue only while the declared bound allows another pass.

Do not reproduce or reinterpret worker selection, implementation, review,
label, retry, or verification rules inside this runner.

## 4. Handoff

Report:

- mode and passes completed;
- issues and PRs touched;
- resulting Linear and GitHub states;
- stop condition;
- exact next human action or next worker mode.

## Hard limits

- Never apply `agent-ready`.
- Never merge or enable auto-merge.
- Never invoke `cto-merge` automatically.
- Never turn a bounded run into an unattended persistent worker.
- Run only one build loop per Linear team.
