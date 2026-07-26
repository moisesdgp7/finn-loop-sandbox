---
name: cto-build
description: Use when an approved agent-ready Linear issue must be implemented or an existing CTO-loop pull request has loop-changes-requested; one pass performs one bounded unit of work.
---

# CTO Build

One pass performs one unit of work: repair one existing PR or build one issue
end to end. Repeated runners invoke this skill once per iteration.

## 0. Preflight

Before changing Linear, GitHub, branches, or files:

- Read `git remote get-url origin`, confirm it is reachable, and resolve that
  exact remote with
  `gh repo view ORIGIN_URL --json nameWithOwner,defaultBranchRef`.
- Use the returned `nameWithOwner` as the canonical current repository. Do not
  use another remote or an ambient GitHub repository.
- Detect the default branch with
  `defaultBranchRef.name`; never assume it is `main`.
- Require a clean working tree (`git status --porcelain` must be empty). If it
  is dirty, report the paths and end the pass.

Never stash, reset, overwrite, or commit unrelated work.

## 1. Repository routing gate

Before assigning an issue, changing its state, checking out a PR branch, or
editing files:

1. Fetch the issue's Linear Project and full Project description.
2. Parse exactly one line shaped
   `CTO GitHub repository: owner/repo`.
3. Require that route to exactly match the current repository's canonical
   `owner/repo`, comparing case-insensitively.

A candidate is eligible only when its configured route exactly matches the
current repository.

If the issue has no Project, the route is missing, malformed, or ambiguous, or
the configured route does not exactly match the current repository, do not
claim or modify the issue or PR. Skip it and report the issue identifier,
Project, expected repository when known, and current repository. Never infer
routing from the issue title, branch, or local folder.

Re-run this gate immediately before the first file edit and immediately before
every push. If routing changed, stop without pushing or changing Linear or
GitHub state and report the new routing evidence.

## 2. Review feedback first

List open PRs labeled `loop-changes-requested`:

```bash
gh pr list --state open --label loop-changes-requested --json number,title,headRefName,headRefOid,labels,updatedAt,url
```

Skip every PR carrying `needs-human-review`. Parse exactly one
`Closes TEAM-NNN` from each remaining PR body. A PR with zero or multiple
linked issues is ineligible: skip it without checkout, edits, comments, label
changes, or pushes. If any safe PR remains, choose the least recently updated
one.

Read its linked Linear issue and latest `CTO-loop review of COMMIT_SHA`
verdict. Apply the repository routing gate before selecting a repair. Check out
the existing branch, fix only the "Must fix before merge" items, run the
relevant checks, push to the same branch, remove `loop-changes-requested`, and
comment with the repair evidence. End the pass.

If a fix would cross an issue non-goal or require a product decision, comment
the exact conflict, add `needs-human-review`, remove
`loop-changes-requested`, and end the pass.

## 3. Pick

Using Linear, list issues on team `TEAM` that meet every condition:

- labeled `agent-ready`;
- unassigned;
- not labeled `blocked`;
- no unresolved blocker relation.

Apply the repository routing gate to every candidate before sorting or
claiming. Only candidates whose configured route exactly matches the current
repository are eligible. Sort eligible issues by priority, then oldest first.

If no eligible issue remains, report an empty routable queue plus the skipped
issue identifiers and routing reasons, then end the pass. Do not invent work,
pick a blocked issue, or claim an issue routed to another repository.

## 4. Claim

Assign yourself and move the issue to the team's started workflow state,
preferring `In Progress`. Record its previous state, then claim before reading
deeply or writing code.

Re-fetch the issue immediately. If it is blocked, assigned to somebody else,
no longer `agent-ready`, or its Project route no longer matches, do not work
it. When this pass made the assignment, unassign it and restore its previous
workflow state, then return to step 3.

The assignee is a cooperative lock. Run only one builder loop per Linear team.

## 5. Read

Fetch the full issue, comments, and relations. Implement only its acceptance
criteria. Non-goals are binding. Compare every `AC-N` against every `NG-N`
before editing. Do not make unrelated changes or opportunistic refactors.

If an AC is ambiguous, conflicts with an NG, or depends on an unresolved
blocker, go to step 9. Never guess.

## 6. Build

- Fetch the latest default branch from `origin`.
- Create or resume `TEAM-NNN-short-slug`, using the real issue identifier.
- Follow the repository's existing style, architecture, and naming.
- Add or update tests when the change affects logic, data flow, permissions,
  integrations, or user-visible behavior.
- Preserve behavior outside the issue contract.

## 7. Verify

Run the project's relevant lint, typecheck, build, and narrowest useful tests.
All failures attributable to the change must be resolved before opening a PR.

If a broad check has an unrelated pre-existing failure, run the relevant
targeted check and disclose both results in the PR.

Review `git diff` and `git status` before shipping. Stop if the diff contains
unrelated work or generated secrets.

## 8. Ship

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

## 9. Blocked

Comment one specific question a human can answer asynchronously, apply
`blocked`, and unassign yourself. Leave `agent-ready` in place because the
pick query excludes blocked issues.

State the exact decision, available options, and affected acceptance
criterion. End the pass so another iteration can pick different work.
