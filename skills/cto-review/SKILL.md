---
name: cto-review
description: Review CTO-loop pull requests against Linear AC/NG, GitHub required checks, diff evidence, CodeRabbit findings, and CTO risk policy. Use when the user asks for CTO Review, direct PR review, merge-readiness assessment, or a Finn-loop style verdict with CodeRabbit-aware escalation.
---

# CTO Review

Review one open PR against its linked Linear issue and CTO risk policy. This skill is based on Finn-loop review, with CodeRabbit-aware evidence handling and an independent verification mindset.

This skill is read-only by default. Never merge, enable auto-merge, push commits, or submit a formal GitHub approval/request-changes review.

## 1. Find a PR needing review

List open PRs and skip drafts. For each PR, identify the current head SHA and latest CTO or Finn-loop verdict comment.

Review a PR when:

- it has no current verdict for the head SHA;
- new commits landed after the latest verdict;
- the user explicitly asks for direct CTO review.

## 2. Read the contract and diff

- Parse the linked Linear issue from `Closes TEAM-NNN` in the PR body.
- Fetch the full issue including comments and relations.
- Read the full PR diff and every changed file in context.
- Review only against the linked issue, required checks, security, scope, and maintainability risks introduced by the diff.

Every blocking finding must start with one of:

- `[AC-N]` - the PR does not satisfy that acceptance criterion.
- `[DEFECT]` - the implementation is broken while staying inside scope.
- `[SECURITY]` - a severe security issue blocks shipping.
- `[CI]` - a required GitHub check failed or is missing.
- `[SCOPE-CONFLICT AC-N <-> NG-N]` - fixing the issue requires violating a non-goal or product decision.
- `[CODERABBIT]` - CodeRabbit found a blocking issue that CTO Review confirms as material.

Do not block on unrelated improvements unless they are severe.

## 3. Check GitHub evidence

Inspect:

- PR head SHA;
- mergeability and merge state;
- required GitHub checks;
- labels;
- linked issue identifier and PR body scope ledger.

If required checks are pending or mergeability is unknown, report waiting and do not post a final verdict.

If there are no required checks for a code-bearing PR, escalate to human review.

## 4. Apply CodeRabbit evidence policy

Classify the PR:

CodeRabbit evidence is required when the PR changes:

- production code;
- tests;
- auth, security, permissions, payments, secrets, infra, CI, deployment, or release flow;
- architecture, shared modules, public APIs, data models, migrations, or integrations;
- any Medium or High risk issue.

CodeRabbit evidence is optional when the PR is:

- docs-only;
- comments-only;
- metadata-only;
- low-risk skill text or process documentation with no executable path;
- explicitly exempted by the Linear issue and PR body.

When required:

1. Look for CodeRabbit comments, summaries, or review output on the PR.
2. Read every actionable CodeRabbit finding.
3. Classify each as blocking, human decision, advisory, duplicate, stale, or out of scope.
4. If required CodeRabbit evidence is missing, do not automatically approve. Escalate to human review unless the user explicitly waives the requirement for this PR.

CodeRabbit is evidence, not authority. CTO Review owns the verdict; the human owns the merge.

## 5. Verdict

Post one comment:

```md
CTO review of COMMIT_SHA

CI: required checks passed | failed | pending | not configured
Mergeability: clean | conflicting | unknown
CodeRabbit: required-present | required-missing | optional-present | optional-missing | not applicable

## Review

Summary: one or two sentences.

## 1. Must fix before merge

None. | Findings.

## 2. Should fix soon

None. | Advisory findings.

## 3. Safe to merge

Yes - evidence is complete and a human still makes the merge decision.
No - changes requested.
No - human decision required.
```

Label policy:

- No must-fix and no escalation: add `loop-approved`; remove `loop-changes-requested`.
- Must-fix present: add `loop-changes-requested`; remove `loop-approved`.
- Scope conflict, missing required CodeRabbit evidence, no required CI for code-bearing PR, or unresolved product decision: add `needs-human-review`; remove both `loop-approved` and `loop-changes-requested`.

Preserve a pre-existing `needs-human-review` label unless the current review explicitly resolves that reason.

## 6. Hard limits

- Never merge or enable auto-merge.
- Never push commits to the PR branch.
- Never change labels without evidence tied to the current head SHA.
- Never treat CodeRabbit as a substitute for reading the Linear issue, diff, and required checks.
