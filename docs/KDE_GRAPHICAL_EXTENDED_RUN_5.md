# Operation First Light — Extended Graphical Boot Observation (Run 5)

Date: 2026-11-04  
Status: **PR proposed; manual workflow has not yet been run with these changes.**

## Evidence from Run 4

The experimental graphical-serial image successfully booted Linux and emitted a diagnostic startup marker and the first phase. At that sample `graphical.target` and `sddm.service` were inactive, but SDDM reported `Result=success`, not a service failure. The second and third diagnostic phase markers were not captured before the guest experiment ended. The virtual screen showed console startup messages, then black. No SDDM greeter or KDE session is proven.

**No evidence supports modifying or disabling firewalld or other security services as a fix.** Under QEMU TCG the guest progresses slowly, and the prior sample was too early to distinguish an ordering delay from a graphical failure.

## Changes and boundaries

- The diagnostic-only script now samples after about **10, 55 and 145 seconds from the time its unit starts** (not elapsed VM startup time). It captures selected `graphical.target`, display-manager, SDDM, Plymouth and DRM status and now also includes bounded `systemctl list-jobs`, `systemd-analyze critical-chain graphical.target`, and `systemctl --failed` outputs. Each added systemd query has a 12-second ceiling; results may be incomplete if systemd is slow.
- The **manual** `Experimental KDE graphical serial diagnostics` workflow collects frames around **60, 120, 180, 300, 450 and 600 seconds** after VM start. QEMU's safety timeout increases to 780 seconds, leaving time for snapshots and shutdown. The job still has an overall timeout.
- The workflow records whether `/dev/kvm` is accessible to the job user, but **does not enable KVM** in this run. Keeping TCG is intentional to preserve comparability with Runs 3/4. If acceleration is possible, test it later in an independently reviewed PR instead of silently switching CPU execution modes.
- Remove the unsupported QEMU `info vga` monitor command. Continue to collect limited `info status` and `info block` diagnostics and screenshot frames.
- Known-good Fedora/KDE container build configuration remains unchanged. The serial diagnostic unit remains `Type=simple` so it doesn't block `multi-user.target`.
- Guest NIC remains disabled, with no physical disk passthrough, shared credentials, embedded default account or bootable disk uploaded. Log screenshots/serial evidence are temporary artifacts held for three days.

## Run instructions

1. Merge this PR only after the required `validate` check passes; delete the feature branch.
2. In GitHub Actions select **Experimental KDE graphical serial diagnostics**, choose branch `main` and press **Run workflow**.
3. Download the short-lived `crelovia-graphical-serial-evidence` ZIP once finished. Review six PNG screenshots and `serial.log` (plus QEMU monitor output).
4. Look for `CRELOVIA GRAPHICS DIAGNOSTICS START` and **PHASE 1/2/3**. Distinguish **never started** from **started too late** or **truncated**.
5. If phases are available, compare SDDM `ActiveState` and `Result`, `graphical.target` state, pending jobs, critical chain and specific errors. Confirm the graphical screen visually; a green workflow alone is not a valid KDE boot claim.

## Outcome classification

- **Graphical greeter visibly shown:** SDDM graphics verified (not user login).
- **SDDM failed with concrete journal error:** target a minimal service/display correction in a separate PR.
- **Graphical target blocked with identifiable pending job:** determine dependency/source of the delay; do not disable protection services based on speculation.
- **SDDM active but screenshots remain black:** evaluate video/Qt/Wayland/greeter logs and capture mode.
- **Phases absent or still truncated:** mark harness inconclusive and consider an accelerated *isolated* VM test, not a claimed KDE defect.

Sources: [Run 3 diagnostic design](KDE_GRAPHICAL_SERIAL_DIAGNOSTIC_RUN_3.md), [first VM boot plan](ADR-0007-FIRST-VM-BOOT-PLAN.md).

No login, GPU hardware support, update/rollback, or network/firewall security is certified by this workflow.
