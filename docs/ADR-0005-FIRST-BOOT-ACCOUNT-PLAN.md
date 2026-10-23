# ADR-0005 — First boot accounts and graphical target

Date: 2026-10-22
Status: **Investigation proposed; not implementation or production approval**

## Baseline

The [first graphical boot preflight](https://github.com/crelovia/crelovia-os/actions/runs/39878855037) confirmed Fedora 43 bootc, KDE Plasma 6.7.5, `sddm`, `sddm-wayland-plasma`, a Plasma Wayland session and the `display-manager.service` symlink. That was an unbooted container inspection, not a successful VM login.

The previous preflight did **not** establish the effective `default.target`. An absent `/etc/systemd/system/default.target` alone is insufficient: systemd can use a vendor default in `/usr/lib/systemd/system`.

## Current decision

Run a targeted *read-only* inventory of:
- effective systemd default-target candidates (including vendor symlink);
- SDDM display manager and session files;
- enrollment/first-boot setup packages and units;
- the count of non-system accounts by UID (no credentials or shadow contents);
- presence of potentially enabled network-facing services.

Do not assume default-user provisioning exists. Do not build a development image with a universal username/password or enable passwordless login.

## Safety boundaries for first VM boot

- Use UEFI virtual hardware in a disposable VM without raw disk passthrough.
- Keep host Windows storage and credentials outside the guest.
- Prefer offline/isolated guest networking until login and firewall policies are assessed.
- Choose a supported first-boot enrollment flow before enabling graphical login on public images; audit SELinux context and user home creation.
- Do not treat a green CI job or lint result as a real boot test.
- Avoid enabling network-facing services merely because a desktop package group includes them.

## Success criteria for next experiment

An actionable report distinguishing **present**, **missing**, and **not yet boot-tested** requirements. After its results, propose the smallest isolated fix. Preserve original Containerfile and known-good KDE builds.

## Next milestones

1. Validate first-user setup and the selected boot target in a disposable image.
2. Select and test current osbuild/image-builder conversion tooling.
3. Build qcow2 and boot under QEMU/UEFI.
4. Document login, reboot, networking, SELinux behavior and recovery.

## References

- https://bootc.dev/
- https://www.freedesktop.org/software/systemd/man/latest/systemd.special.html
- https://github.com/osbuild/image-builder
