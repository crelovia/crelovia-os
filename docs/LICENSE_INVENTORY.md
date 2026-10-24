# Crelovia OS — Licensing and ownership inventory

Date: 2026-10-24. Status: **Provisional: audit, not license grant**.
Selected direction: **GPL-3.0-or-later for original Crelovia source**.

## Git repository inventory

Inspected recursive Git tree for `main` (not truncated) and fetched all 31 tracked files. A simple source-text scan found **zero** `SPDX-License-Identifier:` declarations and no root `LICENSE` file. That is not proof of ownership, originality, or absence of copied code.

| Group | Count | Scope and ownership status |
| --- | ---: | --- |
| `.github/workflows/*.yml` | 7 | Project-authored workflow configuration; verify commit history and copied examples |
| `build/Containerfile*` | 4 | Project-layer recipes based on third-party Fedora packages; do not relicense RPMs |
| `build/*.sh` | 3 | Project diagnostics; verify authors and any reused snippets |
| `build/crelovia-release-info` | 1 | Project configuration; author verification pending |
| `build/README.md` | 1 | Project docs; determine documentation-license scope |
| `README.md`, `CONTRIBUTING.md`, `SECURITY.md` | 3 | Project docs/policies; verify authorship |
| `docs/*.md` | 12 | Decision records, roadmap, guidance; verify authorship and external quotations |
| **Total** | **31** | No original files yet formally licensed |

No media, fonts, artwork or binary blobs were present among those *tracked repository files*. **Fedora/KDE RPMs in the built image absolutely contain many separately licensed resources.**

## Upstream / distribution boundaries

- Image base is `quay.io/fedora/fedora-bootc:43`, with experimental `dnf group install kde-desktop-environment`. The full Fedora/KDE package license inventory remains pending actual image build.
- Merely invoking Podman, DNF, bootc, and GitHub's `actions/checkout@v6` does not automatically incorporate their source code into original Crelovia code; bundled and distributed components require separate compliance.
- GPL-3.0-or-later is the intended license **only for properly owned original project code**. Copyright notices, source provision, license exceptions, embedded media, trademarks, and Fedora remix requirements must be handled separately.
- The initial scan does not detect all third-party snippets or all license notices; human provenance review is mandatory.

## Ownership decisions still needed

1. Verify author/rights-holder and any copied snippets for each authored file using commit history and contributor confirmation. Do not assume a GitHub username alone conveys copyright ownership; AI-assisted code may require jurisdiction-specific assessment.
2. Selected: CC BY-SA 4.0 for project-owned standalone documentation; identify mixed code/docs files and exceptions; assets/marks must be scoped separately.
3. Document contributor inbound license expectations without inventing a CLA or copyright assignment.
4. Review the actual Fedora KDE RPM metadata report and source distribution obligations before publishing any OS image.
5. Add an authoritative GNU GPL-3.0 license text and scoped copyright/SPDX markers **in a later review PR**, never blanket relicense upstream packages.

## RPM evidence workflow

The manually triggered `Experimental KDE component license inventory` workflow builds the prior known KDE recipe, collects a sorted TSV with RPM name, version/release, architecture and raw `LICENSE` field, and uploads the report as a short-lived Actions artifact. Entries require **manual review**; SPDX parsing or simple keywords cannot establish license compatibility. Record the workflow run ID and archive the reviewed findings.

## Decision gates

- [x] Intent selected: GPL-3.0-or-later for original code.
- [x] Enumerate all 31 tracked repo files.
- [x] Inspect existing file-level SPDX declarations (zero).
- [ ] Verify ownership and third-party excerpts.
- [ ] Execute and inspect Fedora/KDE package report.
- [ ] Documentation direction selected: CC BY-SA 4.0 for standalone original docs; mixed content and assets still need file-level review.
- [ ] Verify copyright notices and full GPL text before implementation.
- [ ] Review Fedora trademark/source supply duties before distributing images.

See [ADR-0006](ADR-0006-GPLV3-COMPATIBILITY.md).

## Documentation licensing decision — 2026-10-24

The maintainer selected **CC BY-SA 4.0** for Crelovia-authored *standalone documentation* and **GPL-3.0-or-later** for Crelovia-authored source code. The choice is subject to verifying the right to grant each license and defining file-by-file scope.

- Standalone explanatory Markdown (e.g. guides, project charter and ADRs), if originally authored and cleared, is intended for CC BY-SA 4.0.
- Scripts, workflow YAML, Containerfiles and other executable/build configuration, if authored and cleared, are intended for GPL-3.0-or-later.
- Markdown containing substantial executable code may require dual notices or separately licensed code samples. Don't automatically treat embedded code as licensed for copying into software merely because the prose is CC BY-SA.
- Third-party quotations, logos, brands, screenshots, fonts, art, firmware and upstream package contents do **not** receive a new Crelovia license merely from proximity or repository inclusion.
- CC BY-SA 4.0 requires attribution, license notice, indication of changes, and sharing adapted documentation under compatible terms when distributed. It does **not** stop commercial reuse.
- Neither license direction has been implemented by adding authoritative license texts or copyright declarations. Document ownership, exceptions, and file classifications first.

References: https://creativecommons.org/licenses/by-sa/4.0/ and https://www.gnu.org/licenses/gpl-3.0.html
