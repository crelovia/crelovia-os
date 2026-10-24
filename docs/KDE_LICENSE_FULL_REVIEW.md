# KDE RPM license metadata — full artifact review (Phase 1)

Date: 2026-10-24
Source: Uploaded `crelovia-kde-rpm-licenses.zip` from [GitHub Actions run 40140029006](https://github.com/crelovia/crelovia-os/actions/runs/40140029006). Archive contained `rpm-licenses.tsv` and `summary.txt`.

## Parsed evidence

- **1,969** valid four-column RPM metadata records (`name\tversion-release\tarch\tlicense`); **543** unique raw license expressions.
- **41** packages have `GPL-2.0-only` as the entire `LICENSE` expression; **285** package license expressions contain that substring somewhere. A mixed expression does not establish the license of each individual file.
- **171** expressions contain `LicenseRef` (nonstandard/referenced license metadata needing specific review).
- **24** expressions include `LicenseRef-Fedora-Firmware` (AMD, Intel, NVIDIA, wireless and other firmware packages). Firmware redistribution obligations are separate from Crelovia-authored GPL code.
- **82** expressions mention `OFL-1.1` (commonly fonts); **48** mention `GFDL` (often documentation); **26** mention `CC-BY-4.0`. These figures overlap.
- No case-insensitive substring matches for `SSPL`, `BUSL`, `CC-BY-NC`, or `CC-BY-ND` in the RPM `LICENSE` fields. This is **not** proof those issues cannot exist elsewhere in an image.
- Spot checks: `kernel` and `kernel-core` have complex mixed metadata including `GPL-2.0-only WITH Linux-syscall-note`; `sddm` reports `GPL-2.0-or-later`; `systemd` has `LGPL-2.1-or-later AND MIT AND GPL-2.0-or-later`; `qt6-qtbase` reports `LGPL-3.0-only OR GPL-3.0-only WITH Qt-GPL-exception-1.0`; KDE `dolphin` and `plasma-desktop` have mixed terms including GPL-2.0-only.
- No empty/obvious `unknown` or `NOASSERTION` license fields were found.

These are **package-level declarations**, not file-by-file SPDX analysis, source provenance review, proof of binary/source compliance, or a legal opinion.

## Interpretation

- A GPL-2.0-only command-line tool or kernel may be distributed *alongside* original GPL-3.0-or-later Crelovia code as a separate work under its original terms. Do not copy GPL-2.0-only code into a GPLv3-covered derivative without reviewing compatibility or obtaining permission.
- `AND`/`OR` license metadata can describe different files and alternative available terms, respectively; avoid labeling an entire package "incompatible" solely on substring matching.
- Preserve license/NOTICE materials; review firmware and media distribution permissions, the exact distro build contents, and Fedora trademark/remix requirements.
- `GPL-3.0-or-later` remains the maintainer's chosen **direction for project-owned code**, not a relicensing of any Fedora/KDE program.

## Follow-up gates

1. Confirm ownership and copyright for project-authored files and any reused examples.
2. Decide standalone documentation and creative-asset license scope; audit icons, font licenses, firmware and branding when image distribution begins.
3. Review specific `LicenseRef` meanings and document upstream notices/sources.
4. Establish complete image SBOM/manifest with pinned packages and source offer/access procedure for actual distribution.
5. Add GPL-3.0-or-later LICENSE/SPDX declarations **only after** source ownership and scope review.

Evidence of a successfully generated report is not full legal clearance.
