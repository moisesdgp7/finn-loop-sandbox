---
name: cto-spec
description: Use when a raw product or engineering idea must become a build-ready Linear issue through the CTO/Finn-loop workflow; requires the user present and never runs unattended.
---

# CTO Spec

Turn a raw idea into a Linear issue complete enough that a build agent needs
nothing beyond the issue. Research the codebase, interview the user until the
behavior is unambiguous, draft the contract, confirm it, and file it.

## 1. Research before asking

Read the relevant code first. Find the files involved, nearby patterns, tests,
and constraints. Never ask the user something the codebase or connected tools
can answer.

## 2. Interview in rounds

Ask 1-4 questions per round, with concrete options and the recommended option
first. Ask only genuine product decisions:

- behavior forks: who sees it, what happens, and where it lives;
- scope boundaries and explicit exclusions;
- edge cases that change acceptance criteria;
- data, permissions, or migration decisions.

After each round, apply this confidence test:

> Could two different engineers read this spec and ship the same observable
> behavior?

If any fork remains, ask another round. Stop as soon as the test passes. Never
guess product decisions or add filler questions.

## 3. Resolve the Linear Project

Project routing is optional metadata and does not change the issue-body shape.

- If the user names a Project, search the team `TEAM` Projects and assign the
  exact unique match.
- If the name is ambiguous or missing, ask one concise routing question.
- Create a new Project only after explicit user confirmation.
- If the user chooses no Project, file the issue without one.

Do not block a clear small issue merely because it has no Project.

## 4. Draft the issue

Use exactly this shape:

```md
## Problem

What user or business problem does this solve? One or two sentences.

## Acceptance Criteria

- [ ] AC-1 - Observable, testable outcome one
- [ ] AC-2 - Observable, testable outcome two

## Non-goals

- NG-1 - What must NOT change in this task
- NG-2 - What is explicitly excluded or saved for later

## Relevant files

- path/to/file.ts - why it matters

## Test expectations

- What should be tested, manually or automatically

## How to verify

1. Numbered manual steps anyone can follow to confirm the work: where to go,
   what to do, and exactly what should happen. Cover every AC.
```

Rules:

- Give every acceptance criterion a stable `AC-N` id and every non-goal a
  stable `NG-N` id.
- Make every AC observable and testable.
- Resolve any AC/NG conflict with the user before filing.
- Size the issue to one day of agent work or less. Split larger work into an
  ordered chain of independently buildable issues.

## 5. Confirm and file

Show the full draft and get the user's approval. Then create the issue on team
`TEAM` through Linear, assigning the selected Project when applicable. Report
the exact issue identifier, URL, and Project assignment.

## Hard rule

Never apply `agent-ready`. The user applies it in Linear after a final read.
That label is the approval gate between a drafted idea and agent execution.
