# First-boot readiness preflight

This is a **read-only diagnostic experiment**. It does not create a disk image, enable a display manager, install an OS, write credentials, or modify a host filesystem.

## Run
Use GitHub Actions → [Experimental KDE boot readiness preflight](https://github.com/crelovia/crelovia-os/actions/workflows/experimental-kde-preflight.yml) → Run workflow (branch `main`).

## Inputs
Rebuilds the previously successful exploratory KDE image from `build/Containerfile.desktop-cleanup`, not the newer runtime-cleanup experiment, preserving an independently validated baseline.

## Evidence requested
- Detect whether SDDM and graphical login systemd units are present and enabled.
- List Wayland sessions and default-target links.
- Inspect `StateDirectory=` declarations, selected `/var` RPM ownership, tmpfiles-related policy context and `/run` mount entries.
- Report bootc lint warnings without hiding them.

## Interpretation
A successful workflow **does not prove graphical boot**. Missing login setup and `/var` initialization may require further isolated changes. Avoid assuming that systemd is PID 1 inside this container or trying to `systemctl start` services in CI.

## Decisions after collecting logs
1. Choose the first-boot SDDM and graphical target configuration only after confirming package/service presence.
2. Review state initialization rules and prefer upstream or `StateDirectory=` before any cleanup.
3. Determine an approved bootc-to-qcow2 image creation workflow, then test in a disposable UEFI VM with no host disk passthrough.
