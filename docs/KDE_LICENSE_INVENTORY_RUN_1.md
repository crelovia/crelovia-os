# KDE RPM license inventory — first observed results

Date: 2026-10-24
Status: **Evidence captured; compliance review ongoing**

## Run provenance

- [Successful GitHub Actions run #40140029006](https://github.com/crelovia/crelovia-os/actions/runs/40140029006) on `main`, 5m23s, workflow `Experimental KDE component license inventory`.
- Image built from experimental `build/Containerfile.desktop-cleanup` based on `quay.io/fedora/fedora-bootc:43` and Fedora's KDE desktop group.
- Logs report **1,969 RPM packages** and **543 distinct RPM license metadata expressions**.
- The completed workflow uploaded **one artifact**, `crelovia-kde-rpm-licenses` (28,218 bytes compressed; GitHub artifact ID 12578461825). Artifact expiration is governed by workflow retention (30 days).
- The entire artifact TSV has **not yet been retrieved or manually reviewed**. These notes are derived from the logged `summary.txt` excerpt, not a full dependency audit.

## Initial human-review candidates

Several RPM metadata fields include `GPL-2.0-only`: `btrfs-progs`, `chrony`, `alternatives`, `git-core`, `dracut`, and mixed-license KDE components such as `dolphin` and `akonadi-server`.

**No incompatibility or infringement is established by that fact alone.** Independent packages can coexist in the OS image without their upstream licenses being converted to GPL-3.0-or-later. Review any *copied, linked, or tightly combined* code case individually. RPM license fields may describe multiple files/subcomponents, alternatives and exceptions, and do not establish one single license choice for all of a package.

## Remaining checks before LICENSE implementation and image redistribution

1. Download and preserve artifact `crelovia-kde-rpm-licenses`; review full TSV and group expressions by SPDX operators/legacy expressions and LicenseRef strings.
2. Verify copyright provenance of the 31 source-repository files, including any third-party code excerpts.
3. Choose standalone documentation and artwork license treatment; retain third-party notices.
4. Check Fedora image/package source redistribution obligations and branding/trademark conditions.
5. Add exact GPL-3.0-or-later licensing scope and file-level declarations in a later PR, not by changing upstream license statements.
6. Make no legal compliance claim from a green diagnostic workflow.

## Nonblocking workflow notices

GitHub reports a Node.js 20 deprecation notice for `actions/upload-artifact@v4`, plus the `ubuntu-latest` migration notice. Both are maintenance concerns, not license findings. Do not change the workflow blindly until the supported upstream action/runtime and runner requirements are verified.
