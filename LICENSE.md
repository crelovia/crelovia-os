# Crelovia OS — Licensing scope

Crelovia is a distribution made of many independently licensed works. This repository contains the full texts of the project's **selected licensing terms**:

- [GNU General Public License version 3 or later](LICENSES/GPL-3.0-or-later.txt) (`GPL-3.0-or-later`) for **original Crelovia source code and build/configuration scripts** in this repository, to the extent that Crelovia contributors have rights to license them.
- [Creative Commons Attribution-ShareAlike 4.0 International](LICENSES/CC-BY-SA-4.0.txt) (`CC-BY-SA-4.0`) for **original standalone Crelovia project documentation** in this repository, to the extent that contributors have rights to license it.

## File categories

Generally, Crelovia-authored `.github/workflows/*.yml`, `build/*.sh`, `build/Containerfile*`, and `build/crelovia-release-info` belong to the **code/configuration** category.

Generally, Crelovia-authored `docs/*.md`, root `README.md`, `CONTRIBUTING.md`, `SECURITY.md`, and `build/README.md` belong to the **standalone documentation** category.

These are *categories*, not a claim of authorship over every word, snippet, package, or embedded item. Embedded code samples may require their own licensing assessment before reuse as software; third-party quotations and examples retain applicable rights and notices.

## Exclusions and third-party components

No project license purports to relicense the Linux kernel, Fedora bootc base image, KDE Plasma, system packages, firmware, fonts, artwork, media, third-party GitHub Actions, other copied material, or externally authored dependencies. Their respective terms and notices apply. A Crelovia-built OS image is **not** wholly licensed GPL-3.0-or-later simply because its original orchestration code is.

The Crelovia name, logos and other potential trademarks are not licensed by the GPL or CC BY-SA statements above. Branding rights and Fedora remix requirements must be addressed before distribution.

## Authorship, AI assistance and provenance

Project files have been created with significant AI assistance and human direction and review. Copyright eligibility and ownership depend on the specific human contribution and applicable law. These license notices neither claim that all AI-generated material is copyrightable nor create rights in third-party material. If the project lacks rights to license particular material, that material is not covered by a purported Crelovia license grant. Please report disputed provenance privately when appropriate.

No copyright transfer or contributor license agreement is implied. Future contributed material should be submitted with rights to distribute it under the appropriate project license and with any required attribution and notices.

## Implementation and release status

This policy records the selected licenses and supplies their complete texts. **Per-file SPDX header coverage, exhaustive provenance confirmation, source availability obligations for redistributed images, and branding clearance remain separate release-readiness tasks.** A source CI passing does not certify legal compliance.

- License source: [SPDX license text data](https://github.com/spdx/license-list-data)
- [Source provenance audit](docs/SOURCE_PROVENANCE_AUDIT.md)
- [KDE RPM license review](docs/KDE_LICENSE_FULL_REVIEW.md)

No bootable Crelovia release is published by this repository.
