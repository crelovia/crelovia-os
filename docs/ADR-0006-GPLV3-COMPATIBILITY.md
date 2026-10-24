# ADR-0006 — GPLv3 compatibility and licensing scope

Date: 2026-10-24
Status: **Proposed, pending component inventory, provenance check, and final license implementation**

## Project preference

The maintainer prefers **GNU GPL version 3** for original Crelovia OS source code so covered downstream distributed derivatives continue to provide their corresponding source. The maintainer **selected GPL-3.0-or-later on 2026-10-24** for original Crelovia code. That choice has not yet been implemented as a legal license grant in the repository. The Free Software Foundation recommends **GPL-3.0-or-later** for most original programs; choosing that option permits future versions at the recipient's option, which is a substantive choice.

This ADR records *direction*, not a declaration that every existing repository file is now GPLv3.

## Compatibility boundaries

| Other code or package | General GPLv3 assessment | Action |
| --- | --- | --- |
| Original Crelovia source written by authorized contributors | Can be licensed GPLv3 | Confirm author/ownership; add notices and full license text only after final version decision |
| MIT / Expat / ISC / permissive BSD components | Generally GPLv3-compatible | Preserve copyright, disclaimer and required notices |
| Apache License 2.0 components | Compatible when incorporated into a GPLv3-governed combined work; Apache source retains its original notices | Retain Apache license/NOTICE obligations; never claim Apache upstream has been relicensed |
| GPL-2.0-only source copied/linked into the *same covered work* | **Incompatible** with GPLv3-only combination | Do not copy/combine without specific permissions or redesign; distinguish GPL-2.0-or-later |
| GPL-2.0-or-later source | An applicable GPLv3 option is available | Verify the exact SPDX expression and any exceptions |
| LGPL components (versions/exception dependent) | Often compatible under LGPL conditions | Inspect license version, linkage, modifications, attribution and source obligations individually |
| Fedora Linux kernel and independent system packages | Coexistence as separate programs in one distribution does **not** mean Crelovia tools inherit their license, or that those packages become GPLv3 | Preserve package-specific licenses; satisfy distro/source distribution duties |
| KDE Plasma and KDE frameworks | Independent upstream works with individual licenses | Review package-specific license metadata rather than asserting one KDE-wide license |
| Artwork, logos, fonts, sounds, wallpapers | Not automatically covered by code license | Inventory authorship, decide asset policy, review embedded marks and redistributability |
| Crelovia project name and marks | Trademark permissions are separate from GPL | Review name clearance and establish an appropriate trademark policy |

**Important:** Whether two components make one derivative/combined work or a mere aggregation can be fact-dependent, especially for plugins, linked libraries, or tightly integrated services. Do not equate "same operating system image" with "single GPLv3 work."

## Observed repository scope at this decision

Reviewed `README.md`, `docs/PROJECT_CHARTER.md`, `docs/ARCHITECTURE.md`, and `build/Containerfile`. The image presently begins from `quay.io/fedora/fedora-bootc:43`. Its OCI license label is `NOASSERTION`, which is appropriate while the layered image license inventory remains incomplete. Existing documents say licensing is pending.

The reviewed subset is **not** a full file-by-file or RPM inventory. An automated distro package SPDX inventory and separately authored file provenance review are required before distributing installers, ISOs, or images. In particular, a distro image's component licenses cannot be overwritten by a repository-wide GPL declaration.

## Distribution and attribution work

1. GPL-3.0-or-later selected for original code; confirm the copyright holders/years for individual files and approve exact license scope.
2. Inventory all authored files and third-party snippets in the repo; mark provenance and exceptions. Do not assert copyright over content with uncertain ownership.
3. Add an unmodified authoritative full GNU GPL text, per-file `SPDX-License-Identifier` plus copyright attribution where applicable, and a scope description distinguishing Crelovia code from dependencies and assets.
4. Inventory `rpm -qa --qf '%{NAME}\t%{LICENSE}\n'` in the build and preserve upstream licensing obligations. This RPM query format may include legacy or non-SPDX strings; review manually rather than treating it as an automated compliance verdict.
5. Inventory KDE, kernel, bootc, install tooling, bundled graphics, fonts, audio, and special exceptions. Document source access/offers as legally applicable to actual redistribution.
6. Review Fedora remix trademark rules and Crelovia branding before externally distributing derivative images.
7. For future contributors, publish contribution terms compatible with project license. Do not silently require copyright assignment or a CLA.
8. Review GPLv3 sections concerning corresponding source and, where applicable, installation information for consumer devices; these details matter when shipping binaries/hardware.

## Review references (upstream authoritative guidance)

- GNU GPL compatibility FAQ: https://www.gnu.org/licenses/gpl-faq.en.html
- GNU compatibility analysis: https://www.gnu.org/licenses/license-compatibility.en.html
- GNU recommendation: https://www.gnu.org/licenses/license-recommendations.html
- GNU license-application instructions: https://www.gnu.org/licenses/gpl-howto.en.html
- Apache's GPL compatibility note: https://www.apache.org/licenses/GPL-compatibility
- Fedora Remix guidance: https://fedoraproject.org/wiki/Remix
- Fedora distribution licensing overview: https://fedoraproject.org/wiki/Legal:Distribution

## Decision gate

**Do not yet add a blanket GPLv3 LICENSE file, alter OCI image license labels, or mark Milestone 0 license review complete.** The version option is selected; finalize file authorship inventory, image package inventory and exceptions first. This is engineering planning, not legal advice.
