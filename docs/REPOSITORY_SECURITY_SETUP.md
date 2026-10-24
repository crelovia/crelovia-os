# Milestone 0 — Repository security setup

Status: **private vulnerability reporting enabled and verified by repository maintainer on 2026-10-24**; branch protection and external reporter testing remain pending.

This is a maintainer checklist for the public `crelovia/crelovia-os` repository. The GitHub connector can edit repository files but does not expose settings for branch rules or private vulnerability reporting. **Do not mark roadmap checks complete merely because this document exists.**

## 1. Enable private vulnerability reporting

1. Open https://github.com/crelovia/crelovia-os/settings/security_analysis
2. Under repository **Settings → Security and quality → Advanced Security**, find **Private vulnerability reporting** and select **Enable**.
3. Visit https://github.com/crelovia/crelovia-os/security/advisories and confirm a private-report option is available to external researchers (ideally verify using a non-admin account or logged-out view).
4. Subscribe repository maintainers to GitHub security notifications and verify the alert destination.

Never copy vulnerability details into a public issue or CI log. Until enabled and independently verified, keep `SECURITY.md`'s caution in place.

Docs: https://docs.github.com/en/code-security/how-tos/report-and-fix-vulnerabilities/configure-vulnerability-reporting/configure-for-a-repository

## 2. Protect main

1. Open https://github.com/crelovia/crelovia-os/settings/rules or use **Settings → Branches → Add branch protection rule**.
2. Target `main` only; choose an **Active** ruleset/rule.
3. Require a **pull request** before merging, **status checks** before merge and **conversation resolution**.
4. Select the existing GitHub Actions required job **`validate`** from workflow **Validate source**; run this workflow successfully on a PR before expecting it to appear as selectable.
5. Disable force pushes and deletion of `main`. Avoid blanket bypass rules. Require at least one approval **when there is a second available reviewer**; otherwise an approval requirement can make a solo project impossible to merge without a bypass.
6. Test with a harmless PR: CI runs, status check is required, merge is blocked while checks fail and allowed when passing. Confirm direct pushes cannot bypass the rule.

**Important:** Our connected GitHub file-editing workflow currently writes to default `main`. Enforcing protection may block direct assistant file edits. Once branch protection is active, switch assistant work to named feature branches and PRs, and confirm connector permissions support that workflow before enforcing rules. Do not weaken the rule in order to make an automated commit succeed.

Docs: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches

## 3. Minimum source check

`.github/workflows/validate.yml` contains a `validate` job on push, PR and manual dispatch. It checks foundational metadata and Bash syntax for `build/*.sh`. **It does not build or boot an OS**, verify licenses, perform a security audit, or guarantee provenance.

Before requiring the job, confirm the latest `Validate source` run passes for the updated workflow and record its URL. If it fails, fix the problem before making it a required gate.

## Verification record (fill in when observed)

- [x] Private vulnerability reporting enabled in GitHub settings (2026-10-24 screenshots show **Disable** and repository settings saved; advisory creation page accessible to maintainer)
- [ ] External/private reporting entry point verified
- [ ] Maintainer security notifications configured
- [ ] `main` rule enabled and tested (positive and failing-CI PR behavior confirmed; direct-push/force-push/deletion restrictions not independently exercised)
- [x] Required `validate` status green on a PR ([PR #1](https://github.com/crelovia/crelovia-os/pull/1), merged after one successful check)
- [x] Expected assistant contributions use feature-branch / PR workflow ([PR #1](https://github.com/crelovia/crelovia-os/pull/1) created, validated and merged)

Do not check these items without evidence. The remaining milestone tasks (license review and name/domain/trademark diligence) are independent.

## Pull request workflow smoke test — 2026-10-24

This documentation-only change was prepared on `test/main-protection-pr-workflow` to verify the new `Protect Main` ruleset and the `validate` GitHub Actions requirement. This is a non-production test: confirm required checks on the PR before merging. Do not bypass branch rules to complete the test.

## Required-check negative control — 2026-10-24

- [PR #2](https://github.com/crelovia/crelovia-os/pull/2) used a disposable test branch with intentionally malformed Bash syntax in `build/ci-negative-control.sh`.
- GitHub Actions `Validate source / validate (pull_request)` failed, was labeled **Required**, and the merge action was disabled. This is evidence that the configured required status check blocks ordinary merging on failure.
- The deliberately broken file was subsequently deleted from the disposable branch, and the PR was closed **without merging**. Verified that `build/ci-negative-control.sh` does not exist on `main`.
- No direct push, force push or branch deletion attempt against `main` was made. Those controls should be verified separately without compromising the branch.

## Verified contribution workflow

1. Branch from `main`.
2. Commit focused changes to the feature branch.
3. Open a PR against `main`.
4. Require `validate` to pass; never bypass a failed check.
5. Merge using GitHub's PR UI, then delete the feature branch.
