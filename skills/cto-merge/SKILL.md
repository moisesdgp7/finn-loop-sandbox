---
name: cto-merge
description: Safely merge CTO-loop pull requests after explicit human authorization. Use when the user asks for CTO Merge, authorizes merging an approved PR, or wants Codex to recheck GitHub labels, required checks, mergeability, linked Linear issue, then merge, sync main, comment evidence, and move Linear to Done.
---

# CTO Merge

Complete the CTO loop after review. This skill is a narrow merge-and-close workflow. It never decides that a PR should merge; it only executes an explicitly authorized merge after rechecking evidence.

## 1. Require current human authorization

Do not merge unless the user explicitly authorizes the merge in the current conversation.

Acceptable authorization examples:

```text
Autorizo mergear PR #12 si sigue aprobado.
Merge PR #12 and close the linked Linear issue if all gates pass.
Use cto-merge on PR #12; I authorize the merge.
```

If authorization is missing, ask for it and stop. Do not treat `loop-approved`, prior comments, issue status, or CI success as authorization.

## 2. Identify the PR and linked Linear issue

Fetch the PR body and parse exactly one linked Linear issue from:

```text
Closes TEAM-N
```

If no linked issue is found, or more than one linked issue is found, stop without merging and report the problem.

Fetch the Linear issue before merging. If the issue is missing, archived unexpectedly, canceled, or not the issue the user intended, stop without merging.

## 3. Recheck pre-merge gates

Immediately before merging, inspect the current PR head and evidence:

- PR is not draft;
- current head SHA is recorded in the merge evidence;
- label `loop-approved` is present;
- label `needs-human-review` is absent;
- label `loop-changes-requested` is absent;
- all required GitHub checks pass;
- mergeability is clean and mergeable;
- PR branch and base repository are the intended repository;
- local worktree is clean before syncing or switching branches.

Stop without merging if any gate fails, is pending, unknown, contradictory, or cannot be verified.

## 4. Merge

Use the repository's normal merge method when known. If no repository-specific method exists, prefer squash merge for CTO-loop PRs:

```powershell
gh pr merge PR_NUMBER --squash --delete-branch --subject "Short subject" --body "Closes TEAM-N"
```

Never enable auto-merge. Never merge a draft. Never merge a PR with `needs-human-review` or `loop-changes-requested`.

After merge, fetch and fast-forward local `main`:

```powershell
git fetch origin --prune
git switch main
git pull --ff-only origin main
```

If syncing local `main` fails after the PR already merged, report the merge result and exact sync failure. Do not reset, force-pull, or attempt destructive recovery.

## 5. Close Linear

After a successful merge:

1. Fetch the PR merge state and merge commit.
2. Comment on the linked Linear issue with:
   - PR URL;
   - merge commit;
   - final head SHA checked before merge;
   - required check result;
   - mergeability result;
   - explicit user authorization note.
3. Move the linked issue to `Done`.

If the PR merges but Linear cannot be updated, report:

- PR URL;
- merge commit if available;
- linked issue id;
- exact Linear update failure.

Do not retry destructive actions, create duplicate issues, or close a different issue.

## 6. Final report

Report:

- merged PR URL;
- merge commit;
- linked Linear issue and final state;
- whether local `main` synced;
- any residual risks or failed follow-up actions.

## 7. Skill validation

When changing this skill, validate it with:

```powershell
python "C:\Users\Moises Gale\.codex\skills\.system\skill-creator\scripts\quick_validate.py" skills/cto-merge
```

## Hard limits

- Never merge without explicit human authorization in the current conversation.
- Never enable auto-merge.
- Never deploy.
- Never touch production, VPS services, trading systems, or secrets.
- Never close unrelated Linear issues.
- Never infer approval from `loop-approved`; it is evidence only.
- Never use destructive git recovery commands unless a separate explicit user request authorizes them.
