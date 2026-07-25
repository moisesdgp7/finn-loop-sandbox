---
name: cto-spec
description: Draft CTO-loop specs as Linear-ready issues. Use when the user asks for CTO Spec, CTO loop planning, a build-ready engineering issue, or wants a raw product/technical idea turned into acceptance criteria, non-goals, risk framing, test expectations, and a human approval gate before agent-ready.
---

# CTO Spec

Turn a raw request into a Linear issue that a CTO build agent can implement without guessing. This skill is based on Finn-loop spec, with additional CTO framing for risk, testability, integration boundaries, and future-agent maintainability.

## 1. Research before asking

Read only the context needed to define the task:

- relevant repository files and instructions;
- existing issue, PR, or design documents;
- nearby patterns, tests, CI, and deployment constraints when the task touches code;
- current git status when a repository is involved.

Do not ask the user questions that the codebase or connected tools can answer.

## 2. Interview in rounds

Ask 1-4 questions per round. Ask only product or architecture decisions that would change the issue contract.

Use concrete options and put the recommended option first. Cover these decision types when relevant:

- observable behavior and user impact;
- scope boundaries and explicit non-goals;
- data, permissions, security, or migration implications;
- integration boundaries with external systems;
- testability and verification expectations;
- rollback or operational risk for non-trivial changes.

After each round, apply this confidence test:

```text
Could two different engineers read this issue and ship the same observable behavior?
```

If not, ask another round. Never stop because the interview feels long. Stop as soon as the contract is clear.

## 3. Resolve Linear Project routing

Before drafting the final issue, determine whether the issue should be associated with a Linear Project.

If the user explicitly names a project:

1. Search existing Linear Projects in team `TEAM`.
2. Use an exact project name match when exactly one exists.
3. If there are multiple partial matches, no exact match, or any ambiguity, ask the user before assigning the issue to a Project.
4. Never create a new Linear Project without explicit user confirmation in the current conversation.

If the user does not mention a project, ask one concise routing question:

```text
Should this issue be associated with an existing/new Linear Project, or left without a Project?
```

If the user chooses an existing Project, search and confirm the match before filing. If the user chooses a new Project, create it only after explicit confirmation. If the user chooses no Project, file the issue without a Project and record that decision in the issue body.

Project routing is optional. Do not block a clear, small issue only because it has no Project.

## 4. Draft the issue

Use this shape exactly:

```md
## Problem

What user, business, or engineering problem does this solve? One or two sentences.

## Project Context

- Linear project: Project name, newly created Project name, or None.
- Decision source: User named existing Project / user confirmed new Project / user chose no Project.
- Why this belongs here: One sentence, or N/A when Linear project is None.

## Acceptance Criteria

- [ ] AC-1 - Observable, testable outcome one.
- [ ] AC-2 - Observable, testable outcome two.

## Non-goals

- NG-1 - What must not change in this task.
- NG-2 - What is explicitly excluded or saved for later.

## CTO Risk Framing

- Risk: Low / Medium / High.
- Why: The main engineering, security, data, operational, or product risk.
- Integration boundary: What systems, APIs, repos, or workflows this task may touch.
- Rollback / recovery: How a human would undo or contain a bad outcome, if applicable.

## Relevant files

- path/to/file.ext - Why it matters.

## Test expectations

- Manual and automated checks expected for this issue.
- Note when TDD, systematic debugging, or broader verification should be used by CTO Build.

## How to verify

1. Numbered manual steps anyone can follow.
2. Cover every AC.
```

Rules:

- Every acceptance criterion must have a stable `AC-N` id.
- Every non-goal must have a stable `NG-N` id.
- No AC may require violating an NG.
- Every issue must include `## Project Context`, even when `Linear project: None`.
- Size the issue to one day of agent work or less. Split larger work into ordered issues.
- Include CodeRabbit requirements only when the review policy should treat the future PR as risk-bearing.

## 5. Confirm and file

Show the full draft in chat and get the user's go-ahead before creating the Linear issue.

Create the issue on team `TEAM` only after approval. If a Project was selected or created, assign the issue to that Project when filing it. Report the issue identifier, URL, and Project assignment.

## Hard rule

Never apply `agent-ready`. The user applies it after a final read. That label is the human approval gate between "the issue exists" and "an agent may build it."
