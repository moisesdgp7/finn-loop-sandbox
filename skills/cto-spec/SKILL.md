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

## 3. Resolve the Project and repository route

A repository-changing issue must have one Linear Project with one canonical
route in its description:

```text
CTO GitHub repository: owner/repo
```

This route identifies the GitHub repository, not a machine-specific checkout.
It does not change the issue-body shape.

- Detect the current repository, when available, from
  `git remote get-url origin`, then resolve that remote with
  `gh repo view ORIGIN_URL --json nameWithOwner --jq .nameWithOwner`.
- If the user names a Project, search team `TEAM` and require one exact match.
- Fetch the full Project description. Accept exactly one valid
  `CTO GitHub repository: owner/repo` line.
- If the route is missing and the current repository is known, propose that
  repository and get explicit confirmation before updating the Project.
- If the configured route and current repository differ, stop and ask which
  one is authoritative. Never silently replace the route.
- Create a new Linear Project only after explicit user confirmation.
- Do not create a repository. Repository provisioning is a separate,
  explicitly authorized setup action.

Administrative issues that do not change a repository may omit the Project
and route. A repository-changing issue is not build-ready until its Project
has a valid route.

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
the exact issue identifier, URL, Project assignment, and configured repository
route.

## Hard rule

Never apply `agent-ready`. The user applies it in Linear after a final read.
That label is the approval gate between a drafted idea and agent execution.
Never create or rename a GitHub repository from CTO Spec.
