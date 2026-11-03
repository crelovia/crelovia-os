# KDE first UEFI boot smoke — Experiment 1

Date: 2026-11-03  
Status: **Workflow proposed, not yet run. A graphical login has not been demonstrated.**

## Baseline and scope

The [QCOW2 conversion experiment](https://github.com/crelovia/crelovia-os/actions/runs/41727291882) completed successfully. It checked that image-builder produced a disk with a valid QCOW2 format and nonzero virtual size. **It did not start QEMU or prove the disk boots.**

This second experiment uses the same `build/Containerfile.desktop-cleanup`, builds a fresh KDE container, converts it to QCOW2 on an ephemeral GitHub-hosted runner, starts QEMU with **OVMF UEFI**, captures unattended graphical frames, then destroys the VM with the runner.

## How to run

After reviewing and merging the feature PR:

1. In GitHub Actions, select **Experimental KDE UEFI boot smoke**.
2. Select **Run workflow** on branch `main`.
3. Review the workflow steps. Download the short-lived artifact **crelovia-uefi-boot-smoke-evidence** within three days and inspect the PNG frames and serial log. The artifact **does not include the disk image**.
4. Record the workflow run URL, converter image ID, image format, actual screenshot contents, and classification: **firmware screen**, **bootloader**, **kernel/systemd**, **SDDM**, **KDE**, or **unknown/error**.
5. If firmware or QEMU fails, record the exact failure; do not imply a login or desktop is working.

## Security and limitations

- GitHub-hosted **Ubuntu 24.04 ephemeral Linux** runner. This does not install anything on the user's Windows host or attach a host physical disk.
- Guest NIC disabled with `-nic none`, no shared drives/clipboard, no remote access. The virtual guest runs a newly generated QCOW2 only.
- The graphical screenshot and serial log are produced without embedded login credentials. Nonetheless, **Actions artifacts attached to a public repository may be accessible to others with repository access**, and public logs may be indexed. Review evidence before sharing screenshots containing unexpected data.
- Uses emulated QEMU TCG rather than assuming hardware virtualization is available. The timed observation window can end before a slow guest finishes booting; a non-boot observation is **inconclusive**.
- The firmware runs with temporary OVMF variables copied into the runner. The VM is stopped and disk disappears when the job ends.
- The workflow does not create a first-boot user, enable auto-login, or bypass existing system permissions.
- The workflow currently uses moving upstream container image tags (`quay.io/fedora/fedora-bootc:43`, `ghcr.io/osbuild/image-builder-cli:latest`); digest pinning, authenticity and repeatability checks remain release gates.
- QEMU graphical capture requires a working monitor socket and a framebuffer even in `-display none` mode. An absent screenshot indicates a test/harness issue, not necessarily a guest failure.
- **A green workflow does not certify an OS boot, working SDDM, KDE login, network security, or a production release.** A human must inspect the PNG frames and other evidence.
- Any implementation of a secure first-user enrollment flow requires a separate reviewable change. Do not embed a default password.

## Expected evidence

| Check | Before run | How established |
| --- | --- | --- |
| Container build | Not re-run | Rootful Podman step |
| QCOW2 creation | Previously verified in separate run | Image-builder and `qemu-img info` |
| UEFI firmware shown | Not tested | Captured framebuffer |
| Linux kernel reached | Not tested | Framebuffer or boot logs |
| SDDM graphical login shown | Not tested | Framebuffer |
| Authenticated KDE desktop | Out of scope | Later test-only user provisioning |
| Network and services | Out of scope | Deliberate disconnected NIC |

## References

- [ADR-0007 first VM plan](ADR-0007-FIRST-VM-BOOT-PLAN.md)
- [QEMU monitor/screendump documentation](https://www.qemu.org/docs/master/system/monitor)
- [GitHub-hosted runner capabilities](https://docs.github.com/en/actions/reference/runners/github-hosted-runners)
- [QEMU UEFI guidance](https://wiki.osdev.org/Unified_Extensible_Firmware_Interface)

Never treat a screenshot of the EFI shell or a partially rendered display as proof of successful KDE boot.
