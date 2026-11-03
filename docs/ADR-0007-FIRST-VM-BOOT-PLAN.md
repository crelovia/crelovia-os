# ADR-0007 — First disposable bootc/KDE virtual machine image

Date: 2026-11-03  
Status: **Proposed and ready for a controlled experiment; neither image conversion nor graphical boot verified**

## Decision

Use the **current osbuild unified `image-builder`** (rather than starting a new workflow with the archived standalone `bootc-image-builder`) to create a QCOW2 disk image from the existing experimental Fedora bootc/KDE image. Run it only in a **disposable Linux build/virtualization environment**, then boot the resulting QCOW2 in a **UEFI virtual machine**, with no physical-disk passthrough. Preserve the previously validated KDE Containerfiles as a baseline.

The initial goal is to verify boot, graphical target/SDDM and login behavior, not to publish a release image.

## What is already known (static checks, not VM tests)

- Fedora 43 bootc container includes KDE Plasma 6.7.5, KWin and the SDDM/Wayland session.
- The vendor default target resolves to `graphical.target`; the display-manager symlink resolves to `sddm.service`.
- No interactive local account was provisioned in the inspected image.
- The first-boot preflight reported 12 passed, 1 skipped, 2 warnings (`nonempty-run-tmp`, `var-tmpfiles`).
- Enablement symlinks for sshd, Avahi and other services warrant a real boot-time network and firewall audit.
- **No QCOW2 conversion, user login or VM boot has yet been demonstrated.**

Evidence: [ADR-0005](ADR-0005-FIRST-BOOT-ACCOUNT-PLAN.md), [first boot preflight](FIRST_BOOT_PREFLIGHT.md).

## Safest staged experiment

### Gate A — Reproducible build-input and conversion preflight

1. Work in a separate disposable Linux VM/build host with adequate disk space, Podman, the unified osbuild `image-builder` and QEMU/OVMF available; do not install the experimental image onto the Windows host.
2. Build `build/Containerfile.desktop-cleanup` as a locally tagged disposable image, as in the existing preflight workflow. Record the full input base-image digest, tool versions, architecture, image digest, and unmodified build/lint results. Do not silently resolve linter warnings by deleting broad state paths.
3. Examine the installed `image-builder` version/help and supported bootc deployment variants. Check the source image supports its selected root filesystem/disk layout. The published upstream interface uses `image-builder build --bootc-ref <source-ref> ... qcow2` and supports `--bootc-variant`; validate the exact syntax against that pinned tool version before execution.
4. Select an image-building container/storage workflow compatible with the disposable Linux host. The converter may need elevated privileges and access to a local container store: **never** expose host Windows volumes, privileged GitHub tokens, production credentials, or untrusted mounts to a privileged builder.
5. Choose a restricted, repeatable **test-only** user-enrollment mechanism supported by the tool version. Never commit a password, private key, static login, or actual user's identity to source control. A locally generated credential must stay outside GitHub logs/artifacts and be destroyed with the VM; no generic default credential may ship.

**Gate A passes only if** QCOW2 conversion completes and the resulting artifact is inspected for correct format, architecture, capacity and absence of unintended secrets. A successful QCOW2 conversion is not a successful boot.

### Gate B — First offline UEFI boot

1. Create a disposable VM using QEMU/KVM or libvirt, OVMF/UEFI firmware and **only the disposable QCOW2 virtual disk**. No host disk passthrough, shared folders, clipboard bridge or removable drives. Keep the virtual NIC disconnected initially, or use an explicitly isolated virtual network.
2. Start the VM with a visible display and serial/console logging where supported; retain guest boot logs and basic device/firmware notes.
3. Record whether UEFI recognizes the disk, the bootloader/kernel load, systemd reaches the graphical target, SDDM appears and an authorized test user can log in to KDE Plasma Wayland.
4. If there is no login account or setup experience, record **blocked** rather than adding a reusable password to the source image. Use a separate approved one-off provisioning test before claiming graphical login success.
5. Do not mark this milestone complete based on a green container-build or preflight CI run.

### Gate C — Controlled runtime and recovery checks

- Check SELinux enforcement, home directory creation and contexts, service states, firewall, and network listeners **before** enabling any guest networking.
- Verify shutdown/reboot and inspect journal errors, desktop startup and initial resource usage.
- Take a fresh disposable snapshot/clone for update and rollback work; document exactly which layers were modified.
- Capture a reproducible report: base digest, image-builder version, command arguments excluding secrets, VM machine/firmware, screenshots (scrubbed), boot outcome and known failures.

## Explicit non-goals

- No Windows installation, repartitioning, physical disk modification, or host-volume passthrough.
- No first-boot password or privileged account embedded in a public Crelovia image.
- No new public download, release signing claims or production-ready installer.
- No assumption that the current build will actually reach KDE login.
- No broad deletion of `/run`, `/var` or systemd state to silence bootc lint warnings.

## Current research and references

- Unified [image-builder usage](https://osbuild.org/docs/developer-guide/projects/image-builder/usage/) (`image-builder build --bootc-ref ... qcow2`; check the installed version's flags).
- [bootc-image-builder deprecation/migration notice](https://osbuild.org/docs/bootc/deprecation-notice/): use the unified image-builder in new workflows.
- [Image-builder QCOW2 image definition](https://osbuild.org/docs/user-guide/image-descriptions/bootc/qcow2/).
- [Image-builder bootc configuration sources](https://osbuild.org/docs/developer-guide/projects/image-builder/advanced/bootc/sources-of-configuration/).
- [bootc documentation](https://bootc.dev/bootc/).

**Exit criterion for this ADR:** A reviewer accepts this isolation and verification plan, *not* that the first boot has happened. A subsequent PR/workflow must carry actual versioned conversion/boot evidence.
