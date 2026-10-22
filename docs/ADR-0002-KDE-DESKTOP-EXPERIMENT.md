# ADR-0002 — Isolated KDE Plasma package experiment

Date: 2026-10-22
Status: Proposed for validation, not yet proven

## Why separate?
The minimal Fedora 43 bootc image passed GitHub Actions twice. Its build definition stays unchanged. The KDE experiment lives in a second Containerfile and requires manual triggering.

## Test
Install the Fedora KDE desktop group in a derived Fedora 43 bootc container and check that Plasma Desktop, workspace, KWin, and a Wayland session entry are present. Run bootc container lint.

This confirms only dependency resolution and container image assembly, NOT whether graphical login or a full OS boots.

## Decision gate
- If the build fails, inspect package/group availability and dependency errors; do not copy uncertain changes into the stable build.
- If it passes, inspect the included login manager, systemd service enablement, account provisioning, and disk conversion tooling before attempting a disposable UEFI VM.
- No installer or physical disk deployment until VM boot and recovery are tested.

## Upstream references
- https://packages.fedoraproject.org/pkgs/plasma-desktop/plasma-desktop/
- https://fedoramagazine.org/building-your-own-atomic-bootc-desktop/
- https://fedoraproject.org/wiki/KDE

Note: Fedora package sets can change. The preliminary experiment uses Fedora 43 explicitly and does not lock full dependency digests.
