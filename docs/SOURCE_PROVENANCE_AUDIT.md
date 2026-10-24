# Crelovia OS — Source provenance audit (Phase 2)

Date: 2026-10-24
Status: **Evidence collection, NOT final copyright clearance**

## GitHub evidence

Inspected `main` via GitHub REST recursive Git tree, which returned **36 tracked blobs**, with no truncation in the response. Inspected the first 100 commit-history entries; this returned **68 commits**. All 68 entries list Git author **John Conley**, associated with GitHub account `JPConley01`. These are recorded commit metadata, not an independent proof of who created the underlying content, whether third-party work was copied, or whether AI-assisted work is protectable in every jurisdiction.

The first source inventory counted 31 files; five subsequent source files were added during licensing research: the KDE license inventory workflow, license report shell script, two RPM license result documents, and the source-side license inventory.

No authoritative GPL/CC licensing grant has been added yet.

## Tracked files and intended treatment

| File | Proposed scope | Required provenance check |
| --- | --- | --- |
| `.github/workflows/experimental-bootc-build.yml` | GPL-3.0-or-later project configuration | Authored actions/glue versus referenced third-party actions |
| `.github/workflows/experimental-first-boot-accounts.yml` | GPL-3.0-or-later | Same |
| `.github/workflows/experimental-kde-build.yml` | GPL-3.0-or-later | Same |
| `.github/workflows/experimental-kde-cleanup.yml` | GPL-3.0-or-later | Same |
| `.github/workflows/experimental-kde-license-inventory.yml` | GPL-3.0-or-later | Same |
| `.github/workflows/experimental-kde-preflight.yml` | GPL-3.0-or-later | Same |
| `.github/workflows/experimental-kde-runtime.yml` | GPL-3.0-or-later | Same |
| `.github/workflows/validate.yml` | GPL-3.0-or-later | Same |
| `build/Containerfile` | GPL-3.0-or-later for authored recipe | Review borrowed examples and Fedora image references |
| `build/Containerfile.desktop` | GPL-3.0-or-later for authored recipe | Same |
| `build/Containerfile.desktop-cleanup` | GPL-3.0-or-later for authored recipe | Same |
| `build/Containerfile.desktop-runtime` | GPL-3.0-or-later for authored recipe | Same |
| `build/crelovia-release-info` | GPL-3.0-or-later for project configuration | Confirm author |
| `build/diagnose-state.sh` | GPL-3.0-or-later for authored script | Inspect external shell snippets |
| `build/inspect-first-boot.sh` | GPL-3.0-or-later for authored script | Same |
| `build/preflight-boot.sh` | GPL-3.0-or-later for authored script | Same |
| `build/report-rpm-licenses.sh` | GPL-3.0-or-later for authored script | Same |
| `build/README.md` | CC BY-SA 4.0 as standalone documentation | Confirm author and embedded code |
| `CONTRIBUTING.md` | CC BY-SA 4.0 as standalone policy/documentation | Confirm author |
| `README.md` | CC BY-SA 4.0 as standalone documentation | Confirm author |
| `SECURITY.md` | CC BY-SA 4.0 as standalone policy/documentation | Confirm author; avoid exposing sensitive reports |
| `docs/ADR-0001-BOOTC-PROTOTYPE.md` | CC BY-SA 4.0 | Review external quoted text / samples |
| `docs/ADR-0002-KDE-DESKTOP-EXPERIMENT.md` | CC BY-SA 4.0 | Same |
| `docs/ADR-0003-RUNTIME-CLEANUP.md` | CC BY-SA 4.0 | Same |
| `docs/ADR-0004-BOOTC-STATE-INVESTIGATION.md` | CC BY-SA 4.0 | Same |
| `docs/ADR-0005-FIRST-BOOT-ACCOUNT-PLAN.md` | CC BY-SA 4.0 | Same |
| `docs/ADR-0006-GPLV3-COMPATIBILITY.md` | CC BY-SA 4.0 | Same |
| `docs/ARCHITECTURE.md` | CC BY-SA 4.0 | Same |
| `docs/FIRST_BOOT_PREFLIGHT.md` | CC BY-SA 4.0 | Same |
| `docs/KDE_LICENSE_FULL_REVIEW.md` | CC BY-SA 4.0 | Same |
| `docs/KDE_LICENSE_INVENTORY_RUN_1.md` | CC BY-SA 4.0 | Same |
| `docs/LICENSE_INVENTORY.md` | CC BY-SA 4.0 | Same |
| `docs/PROJECT_CHARTER.md` | CC BY-SA 4.0 | Same |
| `docs/REPOSITORY_SECURITY_SETUP.md` | CC BY-SA 4.0 | Same |
| `docs/ROADMAP.md` | CC BY-SA 4.0 | Same |
| `docs/TESTING.md` | CC BY-SA 4.0 | Same |

**Classification totals:** 17 proposed code/configuration files, 19 standalone documentation/policy files, 36 total. Classification alone does not relicense any file. Embedded executable snippets inside CC BY-SA documents deserve separate treatment when reused as software.

## Human verification gate

The maintainer should confirm:

1. Whether the project files were written within this Crelovia collaboration, and identify any verbatim code/text from outside authors, templates, documentation or repositories.
2. Whether contributions beyond the current Git author are present inside commits.
3. Whether the repository is being licensed by an individual holder or a duly authorized organization/other rights holder. Being the organization owner does not alone prove assignment of copyrights to the organization.
4. Whether AI-generated or AI-assisted portions contain sufficient human authorship/selection/editing to support asserted copyright claims in applicable jurisdictions. Do not assert AI output is always copyrighted or always public domain.
5. Whether files contain complete third-party attribution and redistribution rights.

**No author attestation is inferred from silence.** A recorded Git author or merged PR is supporting evidence, not clearance.

## Implementation plan after approval

- Add canonical unaltered GPLv3 text and CC BY-SA 4.0 text/official license references, clearly indicating scope and honoring Creative Commons attribution requirements.
- Add per-file SPDX headers only after checking each file. Document authoritative copyright holder and years; where authorship is uncertain, avoid unsupported notices.
- Update README, CONTRIBUTING, release metadata and license policy without asserting an image-wide GPL license.
- Require contributors to have rights to submit code/docs; no CLA or transfer implied.
- Preserve Fedora/KDE/firmware package license and notice obligations. Separate image redistribution compliance from repository code licensing.
- Verify CI and protected PR process before merging.

Sources:
- https://www.gnu.org/licenses/gpl-howto.html
- https://creativecommons.org/licenses/by-sa/4.0/
- https://www.copyright.gov/ai/
