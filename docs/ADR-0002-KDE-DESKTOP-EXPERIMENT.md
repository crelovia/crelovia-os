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

## Cleanup experiment #3 — 2026-10-22

Run: https://github.com/crelovia/crelovia-os/actions/runs/39873678620

- Result: success; 12 lint checks passed, 1 skipped, **2 warnings**.
- Reordering DNF cleanup so log files are removed **after** `dnf clean all` eliminated the `var-log` warning.
- Remaining: `nonempty-run-tmp` and `var-tmpfiles`.
- The `var-tmpfiles` diagnostic includes ~60 directory entries and additional non-directory files in `/var`. This is not permission to delete all of them. Identify upstream-owned state versus ephemeral build residue, and preserve first-boot initialization semantics.
- No bootable disk image or graphical login has been demonstrated yet.

**Next decision gate:** Inventory complete paths, ownership, and existing tmpfiles rules in a diagnostic workflow. Avoid broad deletions and do not suppress lint warnings merely to obtain a green status.

## Read-only filesystem inventory #4 — 2026-10-22

Run: https://github.com/crelovia/crelovia-os/actions/runs/39874739710

- Workflow succeeded in 5m26s; lint still reports **12 passed, 1 skipped, 2 warnings**: `nonempty-run-tmp` and `var-tmpfiles`.
- Package ownership samples via `rpm -qf`:
  - `/var/account` → `psacct-6.6.4-25.fc43`
  - `/var/cache/PackageKit` and `/var/cache/app-info` → `PackageKit-1.3.6-1.fc43`
  - `/var/lib/plocate/CACHEDIR.TAG` → `plocate-1.1.25-2.fc43`
  - `/var/lib/systemd/catalog/database` → `systemd-258.11-1.fc43`
  - `/var/lib/authselect/checksum` → no owning package reported (generated state; behavior needs review)
- Several systemd tmpfiles entries already exist, including CUPS, DNF, and HPLIP. Verify their scope against paths present in the build; existence alone does not clear bootc warnings.
- **No path was deleted by this inventory diagnostic.** Never broadly remove package-owned state to silence lint.

### Proposed next gate

Review the upstream bootc guidance on `/var` initialization, identify package-generated build residue vs required runtime state, and test an explicit, narrowly scoped cleanup in a new disposable build. Keep the known-good KDE container unchanged. Require actual bootc lint evidence, followed by VM boot tests.
