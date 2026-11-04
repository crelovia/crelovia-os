# Operation First Light — Graphical service journal probe (Run 3)

Date: 2026-11-03
Status: **Proposed. The diagnostic workflow has not been executed or validated on a booted guest.**

## Reason

Earlier boot tests reached the Linux serial `fedora login:` prompt, but screenshots became black without showing SDDM or KDE Plasma. The second run verified that this was reproducible and that static SDDM wiring exists; it did not produce the guest's runtime SDDM service state. The prior QEMU `info vga` monitor command is unsupported by the runner's QEMU version and must not be mistaken for useful VGA evidence.

## Design: temporary separate image and workflow

This PR introduces **only** the following experimental files:

- `build/Containerfile.desktop-serial-diag`: derives a *new* image from the unchanged `localhost/crelovia-kde-uefi:dev` baseline; copies a diagnostic script and systemd unit.
- `build/crelovia-graphical-diag.service`: a one-shot service enabled via a symlink **only in the derived test image**. Starts with systemd's `multi-user.target`, after journald, if the serial device exists.
- `build/diag-graphical-serial.sh`: sends small, targeted service properties and limited unit/kernel journal excerpts to `/dev/ttyS0` in three samples around 20, 80 and 140 seconds after the service starts.
- `.github/workflows/experimental-kde-graphical-serial.yml`: separate **manual** GitHub Actions workflow; converts the diagnostic image to QCOW2, boots it with software-emulated QEMU/OVMF, captures screenshots and serial logs, and uploads only non-disk evidence retained for three days.

The existing known-good container recipe, original first-boot workflow and Linux kernel packages are unchanged. The diagnostic script doesn't create accounts, change display configuration, modify the kernel command line, open networking, read shadow files, or embed credentials.

## After PR merge

1. On GitHub Actions, select **Experimental KDE graphical serial diagnostics**, branch `main`, then select **Run workflow**.
2. Confirm the initial build and image-builder conversion steps succeed. A failure in the diagnostic layer is a failed experiment, not a reason to modify the original image.
3. Download the short-lived **crelovia-graphical-serial-evidence** artifact and inspect `serial.log`, screenshots, and `qemu-monitor-info.txt`.
4. Search `serial.log` for `CRELOVIA GRAPHICS DIAGNOSTICS START` and numbered `DIAGNOSTIC PHASE` markers. If absent, **the diagnostic service may not have started** (or may have started too late or lacked access to the serial device). Do not assume SDDM was healthy.
5. For `sddm.service`, distinguish `LoadState`, `ActiveState`, `SubState`, `Result` and `ExecMainStatus`. Then read the limited SDDM/Plymouth journal and kernel DRM/framebuffer excerpts to decide on a specific next fix.

## Interpretations

| Evidence | Meaning |
| --- | --- |
| SDDM is active and screenshot contains login | Graphical greeter visible; no successful user login implied |
| SDDM is failed; journal includes a concrete error | Candidate service/configuration problem; investigate the exact failure |
| SDDM inactive or missing | May not have been enabled/activated, or unit naming differed; verify systemd targets |
| SDDM active but frames black | Focus next on Qt/Wayland/display/greeter logs and QEMU capture behavior |
| No diagnostic markers | Harness/service didn't report, or timed out; **inconclusive** |
| No serial output | Serial path/capture or guest boot problem; **inconclusive** |

## Safety and limits

- The diagnostic image is **not** Crelovia's release image. Never distribute or promote it to the standard build.
- The guest VM uses `-nic none`, no physical Windows disk passthrough, no guest shares, no default user/password, and no remote login.
- Logs are generated only from a disposable, unprovisioned test VM. Still **review logs before republishing or quoting them**, since journal output can unexpectedly contain information.
- The workflow uses floating upstream container tags; digest pinning and signing are future prerequisites for reproducible releases.
- Captures of systemd activity do not prove SDDM rendered a greeter or KDE Plasma started. A green Action reports that the experiment ran, not that the graphical desktop works.
- If a derived systemd unit fails to enable or the conversion reports bootc/SELinux issues, record the full error and repair the **diagnostic branch** without mutating the known-good baseline.

**Success criterion:** enough runtime evidence to choose a single narrow graphical startup fix, **not** a confirmed KDE session.

## Run 3 evidence review and instrumentation correction — 2026-11-04

A reviewer inspected the uploaded Run 3 ZIP (`crelovia-graphical-serial-evidence (1).zip`) including five captured frames, serial output and QEMU monitor data.

**Observed:** the diagnostic service emitted its START marker and **only PHASE 1** before the VM's capture window ended. That first sample reported `graphical.target`, `display-manager.service` and `sddm.service` as **inactive**, with `Result=success` for SDDM; no SDDM failure was demonstrated. The system logged bochs DRM/framebuffer initialization and reached `fedora login:` on the serial console. Later display captures were black; no greeter was verified.

**Instrumentation flaw:** the diagnostic unit was installed as a dependency of `multi-user.target`, with `Type=oneshot` and three delayed sampling intervals. systemd considers a `oneshot` start pending until the script exits. This can block completion of `multi-user.target` and consequently delay `graphical.target` and SDDM; the probe itself therefore contaminated the measurement.

**Correction in the follow-up PR:** change only the disposable diagnostic unit to `Type=simple` so systemd considers it started immediately, allowing boot-target progression while the sampling script runs. No changes to the KDE baseline, release image, usernames, networking, or image-builder configuration. The correction is **not yet boot-verified**.

**Next run interpretation:** Verify PHASE 1/2/3 markers; compare `graphical.target` and SDDM status across samples and screenshot timestamps. If `graphical.target` still does not activate after the probe is non-blocking, collect its dependency jobs and SDDM journal before changing graphical packages.
