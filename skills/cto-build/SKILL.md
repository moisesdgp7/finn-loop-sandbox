---
name: cto-build
description: Build approved CTO-loop issues with Finn-loop discipline plus Engineering Guardrails and Superpowers. Use when the user asks for CTO Build, wants the next agent-ready Linear issue implemented, or wants a scoped coding task built with branch, PR, tests, verification evidence, and no merge.
---

# CTO Build

Implement one approved Linear issue end to end. This skill is based on Finn-loop build, with CTO-specific reinforcement from Engineering Guardrails and Superpowers.

One pass equals one unit of work: either fix review feedback on one PR or build one agent-ready issue.

## 0. Preflight

Before changing Linear, GitHub, branches, or files:

- confirm this is the intended GitHub repository and `origin` is reachable;
- detect the default branch with `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`;
- require a clean working tree with `git status --porcelain`;
- list open PRs labeled `loop-changes-requested` and fix those before new work;
- skip PRs labeled `needs-human-review`.

Do not stash, reset, overwrite, or commit unrelated work.

## 1. Pick and claim

Using Linear, pick the highest priority oldest issue on team `TEAM` that is:

- labeled `agent-ready`;
- unassigned;
- not labeled `blocked`;
- not blocked by unresolved relations.

Assign yourself and move it to `In Progress` before reading deeply or writing code. Re-fetch after claiming. If it is no longer safe to work, stop and return to the queue.

## 2. Read the contract

Fetch the full Linear issue including comments and relations.

Implement only the acceptance criteria. Non-goals are binding. Compare every `AC-N` against every `NG-N` before editing.

If the issue is ambiguous, conflicts with a non-goal, or needs a product decision, comment one specific question, apply `blocked`, unassign yourself, and stop.

## 3. Apply Engineering Guardrails

Use Engineering Guardrails as the default implementation discipline:

- inspect repository entry points, manifests, tests, CI, and nearby code before editing;
- preserve existing architecture and user-owned changes;
- make the smallest reliable change that satisfies the issue;
- avoid opportunistic refactors;
- derive tests and expected behavior from ACs, invariants, and independent reasoning;
- keep fresh evidence of commands, failures, fixes, and results;
- disclose verification limits instead of hiding them.

## 4. Select Superpowers by task type

Invoke Superpowers only when the task type calls for it:

| Task signal | Required Superpower |
| --- | --- |
| Feature or behavior change with logic | `superpowers:test-driven-development` |
| Bug, regression, flaky behavior, or unexpected failure | `superpowers:systematic-debugging` |
| Multi-step or architecture-sensitive work | `superpowers:writing-plans` |
| Risky branch work or parallel implementation | `superpowers:using-git-worktrees` |
| Before claiming done, committing, pushing, or opening PR | `superpowers:verification-before-completion` |

If a Superpower is not available in the current environment, continue with the same discipline manually and disclose the fallback in the PR.

## 5. Build

- Fetch the latest default branch from `origin`.
- Create or resume a branch named `TEAM-NNN-short-slug`.
- Implement the smallest coherent slice that satisfies the issue.
- Add or update tests when the change affects logic, data flow, permissions, integrations, or user-visible behavior.
- Preserve behavior outside the issue contract.

## 6. Verify

Run the project's relevant lint, typecheck, build, and narrowest useful tests. For docs or skill text, run skill validation and targeted content checks.

For CTO skill changes, validate each changed skill folder with:

```bash
python "C:/Users/Moises Gale/.codex/skills/.system/skill-creator/scripts/quick_validate.py" skills/cto-spec
python "C:/Users/Moises Gale/.codex/skills/.system/skill-creator/scripts/quick_validate.py" skills/cto-build
python "C:/Users/Moises Gale/.codex/skills/.system/skill-creator/scripts/quick_validate.py" skills/cto-review
```

Review `git diff` and `git status` before shipping. Stop if the diff contains unrelated work, generated secrets, production/VPS changes, or changes excluded by non-goals.

## 7. Ship

Push and open a PR. The PR body must include:

- what changed and why;
- `Closes TEAM-NNN`;
- a scope ledger with one evidence line per `AC-N`, one preservation line per `NG-N`, and `Other behavior changes: None`;
- manual test steps actually performed;
- automated checks and results;
- Superpowers/Guardrails used or explicitly not needed;
- CodeRabbit expectation for review: required, optional, or not applicable, with why;
- risk: Low / Medium / High.

Comment the PR URL on the Linear issue and move the issue to `In Review` when available.

Never merge, enable auto-merge, deploy, touch secrets, or change production/VPS systems unless a separate explicit issue authorizes that work.
