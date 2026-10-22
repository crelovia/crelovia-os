# ADR-0001 — Experiment with Fedora bootc

Date: 2026-10-22
Status: **Accepted for experimentation only**

## Decision
Use the official Fedora 43 bootc OCI base as the first build experiment, without claiming that the container is a finished desktop OS. The initial Containerfile starts with `quay.io/fedora/fedora-bootc:43` and adds only project metadata plus bootc linting.

## Rationale
- Fedora's bootc base exists and supports deriving a bootable system from a Containerfile.
- KDE Plasma can be evaluated incrementally after the base build works.
- A container-first build definition gives a simple, inspectable starting point.

## Alternatives deferred
- A fully custom kernel and hardware driver stack: beyond project scope.
- ReactOS and native Windows ABI compatibility: not aligned with creator software reliability goals.
- Traditional package-by-package spin: revisit if image-based workflow proves unsuitable.

## Caveats and security
- Version tags are mutable: release-quality builds must pin audited digests.
- GitHub Action container builds are experiments and might fail because of runner/storage limits or upstream changes.
- No boot test, disk image, updater, GUI, or hardware compatibility has been demonstrated.
- The historic `osbuild/bootc-image-builder` repository was archived in June 2026; future disk conversion research targets `osbuild/image-builder`.
- Review repository workflow permissions and pin third-party actions to full SHAs before release-oriented CI.

## Evidence
- https://forge.fedoraproject.org/iot/base-images
- https://fedoramagazine.org/building-your-own-atomic-bootc-desktop/
- https://github.com/osbuild/bootc-image-builder
- https://osbuild.org/docs/developer-guide/projects/image-builder/usage/

## Next verification gate
Successfully build and lint the container in a disposable environment, then determine the KDE desktop package/service composition before attempting qcow2/ISO generation.
