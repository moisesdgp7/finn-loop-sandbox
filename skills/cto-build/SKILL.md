---
name: cto-build
description: Use when an approved agent-ready Linear issue must be implemented or an existing CTO-loop pull request has loop-changes-requested; one pass performs one bounded unit of work.
---

# CTO Build

One pass performs one unit of work: repair one existing PR or build one issue
end to end. Repeated runners invoke this skill once per iteration.

## 0. Preflight

Before changing Linear, GitHub, branches, or files:

- Confirm this is the intended GitHub repository and `origin` is reachable.
- Detect the default branch with
  `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`; never
  assume it is `main`.
- Require a clean working tree (`git status --porcelain` must be empty). If it
  is dirty, report the paths and end the pass.

Never stash, reset, overwrite, or commit unrelated work.

## 1. Review feedback first

List open PRs labeled `loop-changes-requested`:

```bash
gh pr list --state open --label loop-changes-requested --json number,title,headRefName,headRefOid,labels,updatedAt,url
```

Skip every PR carrying `needs-human-review`. If any safe PR remains, choose the
least recently updated one.

Read its linked Linear issue and latest `CTO-loop review of COMMIT_SHA`
verdict. Check out the existing branch, fix only the "Must fix before merge"
items, run the relevant checks, push to the same branch, remove
`loop-changes-requested`, and comment with the repair evidence. End the pass.

If a fix would cross an issue non-goal or require a product decision, comment
the exact conflict, add `needs-human-review`, remove
`loop-changes-requested`, and end the pass.

## 2. Pick

Using Linear, list issues on team `TEAM` that meet every condition:

- labeled `agent-ready`;
- unassigned;
- not labeled `blocked`;
- no unresolved blocker relation.

Sort by priority, then oldest first. If the queue is empty, say so and end the
pass. Do not invent work or pick a blocked issue.

## 3. Claim

Assign yourself and move the issue to the team's started workflow state,
preferring `In Progress`. Claim before reading deeply or writing code.

Re-fetch the issue immediately. If it is blocked, assigned to somebody else,
or no longer `agent-ready`, do not work it and return to step 2.

The assignee is a cooperative lock. Run only one builder loop per Linear team.

## 4. Read

Fetch the full issue, comments, and relations. Implement only its acceptance
criteria. Non-goals are binding. Compare every `AC-N` against every `NG-N`
before editing. Do not make unrelated changes or opportunistic refactors.

If an AC is ambiguous, conflicts with an NG, or depends on an unresolved
blocker, go to step 8. Never guess.

## 5. Build

- Fetch the latest default branch from `origin`.
- Create or resume `TEAM-NNN-short-slug`, using the real issue identifier.
- Follow the repository's existing style, architecture, and naming.
- Add or update tests when the change affects logic, data flow, permissions,
  integrations, or user-visible behavior.
- Preserve behavior outside the issue contract.

## 6. Verify

Run the project's relevant lint, typecheck, build, and narrowest useful tests.
All failures attributable to the change must be resolved before opening a PR.

If a broad check has an unrelated pre-existing failure, run the relevant
targeted check and disclose both results in the PR.

Review `git diff` and `git status` before shipping. Stop if the diff contains
unrelated work or generated secrets.

## 7. Ship

Push and open a PR whose description includes:

- what changed and why;
- `Closes TEAM-NNN`, using the real Linear issue identifier;
- a scope ledger with one evidence line per `AC-N`, one preservation line per
  `NG-N`, and `Other behavior changes: None`;
- numbered manual test steps matching what was built;
- automated checks and their results;
- risk: Low / Medium / High.

If `Other behavior changes: None` is false, stop and amend the Linear issue
before opening the PR.

Comment the PR URL on the Linear issue. Move it to the team's review state
when available; otherwise leave it started for the Linear-GitHub integration.
Never merge or enable auto-merge. End the pass.

## 8. Blocked

Comment one specific question a human can answer asynchronously, apply
`blocked`, and unassign yourself. Leave `agent-ready` in place because the
pick query excludes blocked issues.

State the exact decision, available options, and affected acceptance
criterion. End the pass so another iteration can pick different work.
