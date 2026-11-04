# Operation First Light — KVM hardware-accelerated boot experiment (Run 6)

Date: 2026-11-04
Status: **Proposed. Not yet run. No claim that KVM or KDE is working on GitHub-hosted runners.**

## Why try this

The first five QEMU UEFI experiments established that Fedora Linux boots from our generated KDE bootc QCOW2, but a graphical SDDM screen has not appeared. Under software emulation (QEMU TCG), the boot timeline is unusually slow; the latest serial logs reported pending systemd jobs and a kernel clocksource watchdog delay. That is a reason to **test the performance hypothesis**, not evidence that firewalld, SDDM, or KDE is defective.

GitHub documents nested virtualization on GitHub-hosted runners as experimental and unsupported. The runner may lack `/dev/kvm` or expose it without usable permissions. Do not assume KVM is available based on CPU model, runner name, or a green static CI check.

## Experiment

**New manual workflow:** `Experimental KDE KVM-accelerated first light`  
**GitHub path:** `.github/workflows/experimental-kde-kvm-boot.yml`

- Keep the earlier TCG workflow completely unchanged for comparison.
- On GitHub-hosted ephemeral `ubuntu-24.04`, check basic resources, then install QEMU/Podman.
- **Before building the image**, require a character device `/dev/kvm`, check root can read/write it, and run a short QEMU `-machine q35,accel=kvm -cpu host -S` initialization probe. An intentional 5-second timeout (exit 124) indicates QEMU initialized and remained alive; an immediate failure is not a successful acceleration test.
- If the gate fails, **stop immediately**. Do not continue the expensive Fedora KDE image build; do not silently fall back to slow TCG or try to load/unload host kernel modules. A red check with explicit `KVM_UNAVAILABLE` in this case means the runner lacks a required capability, **not** that Crelovia failed to boot.
- If the gate passes, build the unchanged known-good KDE image, derive the unchanged diagnostic-only serial probe overlay, convert to temporary QCOW2, and start QEMU/OVMF with `accel=kvm` and host CPU settings.
- Keep the guest offline with `-nic none`; do not attach host disks, shares, passwords, user accounts, secrets, or production tokens. Do not upload the QCOW2.
- Capture guest frames at approximately 30, 60, 120, 180 and 240 seconds; collect existing bounded serial diagnostics for SDDM, Plymouth, graphical target and systemd pending jobs.
- Upload only time-limited evidence (`crelovia-kvm-graphical-evidence`), retained for three days. Review the logs/screenshots before making any graphical boot claims.

## Manual review procedure

1. Merge the feature PR after `validate` is green; then delete its branch.
2. Go to GitHub Actions → **Experimental KDE KVM-accelerated first light**, choose `main`, click **Run workflow**.
3. Inspect **Require functioning KVM before any image build** first. If it reports `KVM_UNAVAILABLE`, record the run URL and stop—no ZIP and no Crelovia image are expected.
4. If KVM passes and the job completes, download `crelovia-kvm-graphical-evidence` and review `serial.log` and the five screenshots. Look for `DIAGNOSTIC PHASE 1/2/3`, `graphical.target` activation, `sddm.service` state and actual greeter pixels.
5. If we see an SDDM greeter, record **graphical greeter observed** only; KDE login/session will still require secure test-only account provisioning and interactive verification.

## Interpretation

| Evidence | Classification |
| --- | --- |
| No `/dev/kvm` / failed acceleration gate | **Runner capability unavailable**; guest not attempted |
| KVM gate passes, image build/conversion fails | **Build or tooling failure** |
| KVM boots Linux, SDDM not running, pending jobs identify blocker | **Guest boot bottleneck**; investigate exact job |
| KVM boots Linux and SDDM reports failed | **SDDM failure candidate**; diagnose journal |
| SDDM active but video black | **Possible graphics/capture mismatch**; obtain targeted logs |
| SDDM greeter visible | **Graphical greeter verified**; not an authenticated desktop |
| Green workflow without human screenshot/log inspection | **Experiment completed, desktop not yet verified** |

## Alternative if GitHub lacks KVM

Use a **separate isolated Linux virtual or physical test host** with KVM enabled, ephemeral disks, and no personal host volume passthrough. Select a trusted supported environment before running privileged image-builder operations. No Windows host configuration is needed for this GitHub experiment.

## References

- https://docs.github.com/en/actions/concepts/runners/github-hosted-runners
- https://docs.github.com/en/actions/reference/runners/github-hosted-runners
- https://ubuntu.com/server/docs/how-to/virtualisation/enable-nested-virtualisation/
- [Previous extended TCG runbook](KDE_GRAPHICAL_EXTENDED_RUN_5.md)

No code change here certifies Crelovia for public distribution, security, or graphical login.
