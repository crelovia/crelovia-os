# Crelovia runtime cleanup experiment

## Goal

Eliminate the bootc `nonempty-run-tmp` warning while preserving the successful KDE packaging from [run #1](https://github.com/crelovia/crelovia-os/actions/runs/39869732108).

## Prior evidence

- [Diagnostic run #4](https://github.com/crelovia/crelovia-os/actions/runs/39874739710) passed 12 lint checks, skipped 1, and retained 2 warnings.
- `/var` includes directories and files owned by Fedora system packages, notably PackageKit, psacct, plocate, and systemd.
- The Fedora bootc filesystem model makes `/var` persistent machine state, unlike `/run` and `/tmp`.

## Experiment

`build/Containerfile.desktop-runtime` is copied from the existing DNF-cleanup experiment and clears **only the contents** of `/run` and `/tmp` as a final build-time operation before package checks and lint.

The changes do not affect the original `build/Containerfile.desktop` or `build/Containerfile.desktop-cleanup`. We intentionally leave `/var` untouched until we understand and test its first-boot initialization requirements.

## Success criteria

- Fedora 43 KDE packages are still installed.
- Image builds successfully.
- `bootc container lint` no longer lists `nonempty-run-tmp`.
- Any other lint warnings are captured openly rather than hidden.

## Not yet proven

A working display manager, bootable qcow2 image, installer, account provisioning, user login, updates or rollback. Treat the experiment as a disposable CI container only.
