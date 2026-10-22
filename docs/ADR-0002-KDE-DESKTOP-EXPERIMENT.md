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


## Experiment #1 results — 2026-10-22

- GitHub Actions run: https://github.com/crelovia/crelovia-os/actions/runs/39869732108
- Conclusion: success; duration 5m48s.
- Package validation: plasma-desktop 6.7.5-1.fc43, plasma-workspace 6.7.5-1.fc43, kwin 6.7.5-1.fc43, x86_64.
- Wayland Plasma session existence test passed.
- bootc lint: 11 passed, 1 skipped, **3 warnings**:
  1. `nonempty-run-tmp`: runtime paths under /run and /tmp (e.g. /run/cups and /run/dnf).
  2. `var-log`: DNF5 logs remained in /var/log.
  3. `var-tmpfiles`: generated /var state, including PackageKit caches and systemd-related data, without corresponding tmpfiles.d initialization rules.
- Important: a successful exit code does not imply an image free of warnings, a functioning display manager, or a bootable workstation.

## Next gate

Investigate the upstream-recommended bootc cleanup/reset approach for generated runtime and /var state. Verify that cleanup preserves mandatory systemd and package-owned initialization behavior; do not indiscriminately delete persistent directories. Re-run lint and require zero unexplained warnings before VM disk conversion.


## Cleanup experiment results — 2026-10-22

- Run: https://github.com/crelovia/crelovia-os/actions/runs/39872665099
- Result: build/diagnostics jobs succeeded, but bootc lint **still reported 3 warnings** (11 checks passed, 1 skipped).
- `nonempty-run-tmp` persisted with /run/cups, /run/hplip, /run/lock and other runtime directories. /run/dnf no longer appeared in the displayed sample.
- `var-log` improved from multiple DNF logs to one /var/log/dnf5.log. Suspected cause: `dnf clean all` runs *after* log removal and may recreate it; verify by changing cleanup ordering in another experiment.
- `var-tmpfiles` still reports ~60 candidate /var directories and non-directory /var files lacking appropriate tmpfiles declarations. These require categorized review, not blanket deletion.
- The workflow reports success even with bootc lint warnings; do not interpret it as release readiness.
- During package scripts, audit log connection errors were printed as ignored; they did not cause a failed build. Assess whether any affect the eventual booted environment.

Next: make DNF log cleanup last, inventory runtime and persistent state, and validate safe tmpfiles policy before proceeding to VM conversion.
