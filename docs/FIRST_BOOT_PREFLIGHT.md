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

## First observed results — 2026-10-22

- Run: https://github.com/crelovia/crelovia-os/actions/runs/39878855037
- Result: all workflow steps succeeded in 4m59s. Container assembled, and the read-only checks ran.
- Fedora 43; bootc 1.17.1; systemd 258.11; plasma-desktop/workspace/KWin 6.7.5.
- SDDM 0.21.0 and sddm-wayland-plasma 6.7.5 are installed.
- `/etc/systemd/system/display-manager.service` links to `/usr/lib/systemd/system/sddm.service`; a Plasma Wayland session file exists.
- `/etc/systemd/system/default.target` was absent; this **does not establish** the effective default target. Inspect vendor defaults and inherited image configuration.
- `plasma-workspace-wayland` and `xorg-x11-server-Xorg` did not resolve as installed package names; do not treat that as proof Wayland is missing, since the session and compositor were verified.
- bootc lint remained at 12 passed, 1 skipped and 2 warnings: `nonempty-run-tmp`, `var-tmpfiles`.
- Runtime mountinfo confirms that Podman injects `/run/.containerenv` and `/run/systemd/resolve/stub-resolv.conf`.
- Service enablement symlinks were found for `sshd.service`, `avahi-daemon.service`, `ModemManager.service`, and other components. Whether these services will actually run or listen in a booted VM **remains unknown** and must be audited with default firewall configuration before release.

### Next gate
1. Verify effective default systemd target using file inspection (not `systemctl` against an unbooted container).
2. Inventory login account provisioning and whether SDDM starts with usable credentials.
3. Choose a safe disposable VM disk-image conversion approach.
4. Use a disposable UEFI VM; no host-disk passthrough, no built-in default password.
5. Audit shipped services and network listeners after first boot.

**No graphical boot has yet occurred.**
