# Crelovia bootc build experiment

This directory starts a **minimal Fedora 43 bootc-derived container** to verify an upstream build path before adding a creator desktop. It is **not** an ISO, installer, KDE desktop, recovery image, or suitable daily-driver OS.

## Why bootc?
Fedora publishes bootable OCI base images; bootc supports image-based deployment and update workflows. We will evaluate the upstream image-based approach rather than maintaining a bespoke Linux kernel.

## Prerequisites
Use a disposable Linux VM with Podman installed. Do not run experimental installation commands against a personal disk. Building a bootc OCI container does not install an OS.

## Build (from repository root)
```sh
podman build --file build/Containerfile --tag localhost/crelovia-base:dev .
```

## Inspect and lint
```sh
podman run --rm localhost/crelovia-base:dev cat /usr/share/crelovia/release-info
podman run --rm --privileged localhost/crelovia-base:dev bootc container lint
```

The Containerfile also invokes the upstream linter during the build. Privileged linting may be needed under certain runtimes; do not widen privileges outside a trusted disposable build environment.

## What remains
- Resolve and lock a reviewed upstream image digest, recording it along with SBOM/provenance.
- Add and validate KDE Plasma, display manager, and related desktop services.
- Test the new `osbuild/image-builder` workflow for a qcow2 VM disk image.
- Boot that disk image in a disposable UEFI VM and run `docs/TESTING.md`.
- Verify update, rollback, support lifecycle, and release signing before publishing builds.

Do not distribute generated container artifacts as a finished Crelovia OS image.

## Sources
- Fedora bootc base images: https://forge.fedoraproject.org/iot/base-images
- Fedora Magazine bootc desktop example: https://fedoramagazine.org/building-your-own-atomic-bootc-desktop/
- Image Builder: https://osbuild.org/docs/developer-guide/projects/image-builder/usage/
- Archived bootc-image-builder migration: https://github.com/osbuild/bootc-image-builder
