---
name: cto-loop
description: Use when running a bounded Codex-native CTO/Finn-loop pass across Linear and GitHub, especially when repairing loop-changes-requested PRs, reviewing a fresh PR, claiming one agent-ready issue, or routing a verdict to the next safe phase.
---

# CTO Loop

Run one bounded coordination pass. Linear is the durable work queue; GitHub is the durable code, CI, diff, and review state. This skill coordinates the existing cto-build, cto-review, and cto-merge contracts; it does not replace them and it does not create a persistent scheduler by itself.

## Core contract

One pass performs exactly one unit of work and then stops:

```text
repair one PR
or review one PR
or build one issue
or report a stop condition
```

Use a Codex Goal for bounded continuation or Codex Automation for a time-based trigger. Do not call a Claude Code command, depend on Anthropic authentication, or describe a single sequential run as a persistent loop.

## 0. Preflight

Before changing Linear, GitHub, branches, or files:

1. Confirm the intended repository and reachable origin.
2. Detect the real default branch; never assume main.
3. Require git status --porcelain to be empty.
4. Confirm Linear team TEAM, GitHub labels, and the linked project when the issue has one.
5. Confirm there is no ambiguous ownership, duplicate PR, unresolved relation, or unsafe local state.

If any preflight check fails, record the exact blocker and stop. Never stash, reset, overwrite, or clean unrelated work.

## 1. Repair first

List open PRs labeled loop-changes-requested:

```bash
gh pr list --state open --label loop-changes-requested --json number,title,url,headRefName,headRefOid,labels,updatedAt
```

Exclude every PR labeled needs-human-review. If more than one safe repair PR remains, select the highest-priority linked Linear issue; otherwise select the oldest updatedAt. Stop on ambiguous ownership, repository, or issue linkage.

For the selected PR:

1. Read its linked Linear issue, latest verdict, comments, reviews, current head SHA, and complete diff.
2. Check out or resume the same PR branch.
3. Confirm the checked-out SHA matches the inspected head before editing.
4. Implement only the latest must-fix findings and preserve every NG-N.
5. Run the narrowest relevant checks plus the checks named by the review.
6. Push to the same PR branch and comment the changed files, checks, new SHA, and remaining limits.
7. Remove loop-changes-requested only after the repair is pushed; leave final approval to cto-review.

End the pass after one repair. Do not claim a new issue in the same pass.

## 2. Review one PR

If no safe repair exists, find one open, non-draft PR whose current head has no verdict. Use the existing cto-review contract:

- parse exactly one Closes TEAM-N link;
- fetch the full Linear issue and read AC/NG;
- inspect every changed file and the current SHA;
- verify required checks and mergeability;
- classify CodeRabbit only according to cto-review policy;
- post one verdict and apply the matching GitHub label.

Stop after reviewing one PR. Never push, merge, enable auto-merge, or submit a formal GitHub approval from this phase.

Route the verdict:

| Verdict | Next pass |
| --- | --- |
| loop-changes-requested | Repair the same PR first |
| needs-human-review | Stop until a human resolves the reason |
| loop-approved | Stop and request explicit human merge authorization |
| pending/unknown checks | Stop without a verdict |

## 3. Build one issue

Only when there are no safe repair PRs and no PR needing review, select one Linear issue that is:

- labeled agent-ready;
- unassigned;
- not labeled blocked;
- not blocked by unresolved relations;
- associated with the intended project when project routing is required.

Claim it and move it to In Progress before reading deeply. Re-fetch it immediately. Then follow cto-build exactly:

- implement only ACs;
- preserve NGs;
- create or resume one issue branch;
- run proportionate verification;
- open one PR with Closes TEAM-N;
- comment the PR URL on Linear;
- move the issue to review state when available.

End the pass after opening the PR. A later pass with fresh context reviews it.

## 4. Stop conditions and retry budget

Stop immediately when:

- the worktree is dirty or the repository is ambiguous;
- a PR or issue has ambiguous linkage or duplicate ownership;
- checks are pending, failed, or not verifiable;
- mergeability is unknown or conflicting;
- a fix would violate an NG-N or require a product decision;
- permissions, credentials, or external state are insufficient;
- risk is Medium/High and the required human or CodeRabbit gate is unresolved;
- a PR has received two repair rounds without approval.

After two failed repair rounds, leave the PR out of the repair queue with needs-human-review (or the repository's documented loop-stuck policy), explain the exact reason, and stop. Never retry indefinitely.

## 5. Codex runtime

This skill is a one-pass coordinator. Repeat it through Codex primitives:

- Interactive: invoke $cto-loop again after the handoff.
- Goal: define a bounded objective such as "continue until the queue is empty or a human gate stops the run; maximum 3 passes".
- Automation: schedule a prompt that invokes $cto-loop against the intended local project; re-check live Linear/GitHub state on every run.

The repeated runner must preserve one builder per Linear team, use fresh review context where possible, and stop when the queue is empty. It must not silently turn a bounded Goal into an unattended production worker.

## 6. Controlled repair-loop fixture

For the sandbox fixture TEAM-15 only:

1. Confirm the issue contract and agent-ready state.
2. Use one deliberately incomplete documentation PR limited to docs/cto-repair-loop-e2e.md.
3. Run cto-review and require an [AC-2] finding plus loop-changes-requested.
4. Run this skill in repair-first mode and modify the same branch and PR.
5. Run cto-review against the new SHA.
6. Stop at loop-approved; do not merge without a separate human authorization.

Do not use this fixture to test production behavior or to change the CTO skills being evaluated.

## Hard limits

- Never apply agent-ready to ordinary work; the human approval gate remains required.
- Never merge or enable auto-merge.
- Never bypass needs-human-review, required checks, conflicts, or the retry cap.
- Never create duplicate branches or PRs for one issue.
- Never touch production, VPS services, secrets, Hermes, Paperclip, Buzz, Slack, or unrelated repositories.
- Never report "loop completed" without listing the passes, states, SHAs, checks, verdicts, and stop condition.

## Handoff

End every pass with:

- pass type: repair, review, build, idle, or blocked;
- issue and PR identifiers;
- current Linear state and labels;
- current GitHub head SHA and labels;
- commands and checks with fresh results;
- exact next action or human gate;
- number of repair rounds used.
