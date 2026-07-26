---
name: cto-review
description: Use when an open CTO-loop pull request needs an independent verdict against its linked Linear contract, current diff, required GitHub checks, and mergeability.
---

# CTO Review

One pass reviews one PR. Repeated runners invoke this skill once per
iteration. Never merge or push code from the review phase.

## 1. Find a PR needing review

```bash
gh pr list --state open --json number,title,labels,isDraft,headRefOid,updatedAt,url
```

Skip drafts. For each PR, find the latest comment whose first line is
`CTO-loop review of COMMIT_SHA`.

Fetch the linked issue's current Linear Project and repository route before
deciding to skip. Skip a PR only when the recorded SHA, Project ID, and
repository route still match the live values and it already has
`loop-approved`, `loop-changes-requested`, or `needs-human-review`. Review it
again when the commit, Project, or route changed.

If nothing needs review, say so and end the pass.

## 2. Read the contract and code

- Parse exactly one linked issue identifier from `Closes TEAM-NNN` in the PR
  body and fetch the full Linear issue, comments, and relations.
- Treat a missing or ambiguous linked issue as a must-fix finding.
- Resolve the current repository from `git remote get-url origin` with
  `gh repo view ORIGIN_URL --json nameWithOwner --jq .nameWithOwner`.
- Fetch the issue's Linear Project and full Project description. Require
  exactly one `CTO GitHub repository: owner/repo` line and compare it
  case-insensitively with the current repository.
- Treat a missing Project, missing or ambiguous route, or repository mismatch
  as `[ROUTING]` and escalate to human review. Never infer the repository from
  a branch, issue title, or local folder.
- Read the full diff and every changed file in context.
- Review only against the linked issue: acceptance-criteria gaps, defects,
  broken data flow, unnecessary scope expansion, security problems, missing
  loading/error states, and code future agents will struggle to modify.
- Do not suggest unrelated improvements unless they are severe.

Start every must-fix finding with one of:

- `[AC-N]` - the PR does not satisfy that acceptance criterion;
- `[DEFECT]` - the implementation is broken within the approved scope;
- `[SECURITY]` - a severe security issue blocks shipping;
- `[CI]` - a required GitHub check failed.
- `[ROUTING]` - the Linear Project does not identify this repository exactly.

Non-goals are binding. If a fix would require behavior excluded by an `NG-N`,
record `[SCOPE-CONFLICT AC-N <-> NG-N]`, explain the contradiction, and
escalate to a human instead of prescribing code.

## 3. Check merge evidence

Inspect the current head, mergeability, and required checks:

```bash
gh pr view NUMBER --json headRefOid,mergeable,mergeStateStatus
gh pr checks NUMBER --required --json bucket,name,state,link
```

- If required checks are pending or mergeability is unknown, report waiting
  and end without posting a verdict or changing labels.
- Failed required checks are `[CI]` must-fix findings.
- A merge conflict is a `[DEFECT]` must-fix finding.
- If the repository has no required checks, escalate to human review and do
  not apply `loop-approved`.

Review the exact `headRefOid` used for the evidence. Re-fetch it immediately
before posting. If it changed, discard the review and retry on a future pass.

## 4. Post one verdict

Post one comment in this structure:

```md
CTO-loop review of COMMIT_SHA

Linear Project: PROJECT_ID | PROJECT_NAME
Repository route: owner/repo
CI: required checks passed | failed | not configured
Mergeability: clean | conflicting

## Review

Summary: one or two plain-language sentences on what this PR does.

## 1. Must fix before merge

None.

## 2. Should fix soon

None.

## 3. Safe to merge

Yes - automated review evidence is complete. A human still makes the merge decision.
```

Set labels from the verdict:

- No must-fix and no new escalation: add `loop-approved`; remove
  `loop-changes-requested`. Preserve a pre-existing `needs-human-review`
  because it may represent a separate human gate.
- Must-fix present: add `loop-changes-requested`; remove `loop-approved`.
- Scope conflict, routing failure, or no required CI: add
  `needs-human-review`; remove both `loop-approved` and
  `loop-changes-requested`; set Safe to merge to `No - human decision
  required.`

A human must resolve the escalation and remove `needs-human-review` before the
unchanged commit returns to the automated review queue.

## 5. Hard limits

- Never merge or enable auto-merge.
- Never push commits to the PR branch.
- Never approve or request changes through a formal GitHub review. Use one
  comment plus labels because GitHub rejects self-reviews.
- Treat `loop-approved` as evidence for a human, not merge authorization.
