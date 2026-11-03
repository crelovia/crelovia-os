# Operation First Light — Graphical boot diagnostics, Run 2

Date: 2026-11-03  
Status: **Proposed; second workflow run not yet performed.**

## Prior evidence

First boot workflow: https://github.com/crelovia/crelovia-os/actions/runs/41730144494

Review of the first evidence ZIP:

- UEFI/GRUB/Linux and systemd reached a serial `fedora login:` prompt.
- The serial log shows **bochs-drm initialized a virtual framebuffer** (including `fbcon`), but does not establish that SDDM launched or that a graphical session exists.
- Frame `frame-120.png` captured console/service boot activity. Frame `frame-180.png` was almost entirely black.
- The black frame is **inconclusive**. Possible explanations include a graphics mode switch, an idle display, missing/failing SDDM, or an issue with QEMU's screendump capture. No working KDE or SDDM login screen is verified.
- Prior Fedora image preflights indicated SDDM package presence and a systemd display-manager link, but static configuration is not a process/service state check.

## Changes in this run

Update the *existing*, manually dispatched **Experimental KDE UEFI boot smoke** workflow without changing its KDE Containerfile or disk image:

1. Before conversion, inspect graphical package versions, SDDM systemd unit text, target symlinks, session files and relevant display packages *inside the unbooted image*. No reads of private credentials or shadow files.
2. Continue to create the disposable QCOW2 as in the successful workflow.
3. Capture frames after approximately 60, 120, 180, 240 and 300 seconds (rather than only 120 and 180) using the QEMU monitor. Capture monitor responses to `info status`, `info vga` and `info block` at the same checkpoints.
4. Upload only the limited PNG screenshots, serial log, QEMU monitor text and QCOW2 metadata as a three-day artifact. Never upload the actual disk or firmware-variables file.

## What to do after merge

1. Go to **Actions → Experimental KDE UEFI boot smoke → Run workflow** on `main`.
2. Inspect the **Inspect SDDM and display configuration before conversion (read-only)** step. If SDDM is absent or the display-manager link is broken, record that; do not silently patch the experimental image.
3. After completion, download `crelovia-uefi-boot-smoke-evidence`. Compare all five PNG frames and the QEMU VGA status snapshots; inspect the serial log for a possible SDDM start/failure indication.
4. Categorize outcome: **Linux boot confirmed**, **SDDM visually confirmed**, **display black/inconclusive**, **firmware error**, or **capture failure**. A green workflow by itself does not prove KDE or graphical login.

## Interpretation and limitations

- `info vga` can show the emulated video configuration, **not** Linux's `systemctl status sddm`, KWin logs or DRM device access in userspace.
- Without a test-only login/provisioning route, the guest cannot provide privileged runtime SDDM journal logs through the existing serial login prompt. If static checks look correct but the display remains black, the following PR should design a **disposable, non-published diagnostic-only journal extraction mechanism** rather than guessing at SDDM/Wayland fixes.
- Guest networking remains disabled (`-nic none`); no host disk passthrough, shared folders, remote access or embedded default password.
- QEMU TCG software emulation may be slow. Five minutes of display observation does not exclude a slower boot.
- Upstream image tags still float; pinning and provenance remain open release requirements.
- The workflow's `validate` check only validates source; its manual run is a separate experiment.

## Success criterion

A grounded determination of **what the virtual display actually displayed over time**, plus static SDDM wiring, so we can choose the smallest subsequent experiment. **Do not mark KDE login as complete without an actual frame or other unambiguous evidence.**
