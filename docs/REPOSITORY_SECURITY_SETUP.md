# Milestone 0 — Repository security setup

Status: **configuration instructions prepared; settings not verified or enabled by automation**.

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

- [ ] Private vulnerability reporting enabled in GitHub settings
- [ ] External/private reporting entry point verified
- [ ] Maintainer security notifications configured
- [ ] `main` rule enabled and tested
- [ ] Required `validate` status green on a PR
- [ ] Expected assistant contributions use feature-branch / PR workflow

Do not check these items without evidence. The remaining milestone tasks (license review and name/domain/trademark diligence) are independent.
