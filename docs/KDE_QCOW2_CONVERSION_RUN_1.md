# KDE QCOW2 conversion experiment — Run 1

Date: 2026-11-03  
Status: **Workflow proposed; NOT YET EXECUTED.**

## Intent

Test converting the existing KDE experimental bootc container (using `build/Containerfile.desktop-cleanup`) into a disposable QCOW2. This experiment only tests conversion **and the QCOW2 file header**, not first boot, desktop or authentication.

Workflow: [Experimental KDE QCOW2 conversion](../.github/workflows/experimental-kde-qcow2.yml).

## Manual trigger

After the workflow PR is merged and required `validate` passes:

1. Open GitHub Actions → **Experimental KDE QCOW2 conversion**.
2. Choose **Run workflow**, branch `main`.
3. Inspect steps **Check isolated runner and disk budget**, **Build unmodified KDE experimental container**, **Convert**, and **Validate QCOW2 header**.
4. Record the workflow run URL, source image ID, builder image ID/version, resulting image format/size, and full failure message if any; do not share tokens or privileged system secrets.

**Running this workflow is a separate deliberate action.** It does not run on PRs or pushes.

## Constraints and anticipated failures

- Runs on an ephemeral GitHub-hosted `ubuntu-24.04` Linux runner and uses rootful Podman to build the source and `image-builder` to convert it. Privileged access is needed for filesystem construction; do not duplicate this workflow on a personal computer or untrusted self-hosted runner.
- Check for **at least 10 GiB free** before running; this is a minimal initial guard, not a guarantee of adequate space. A standard hosted runner may still exhaust storage. Do not delete unrelated runner/host directories to overcome this; use an appropriately sized **disposable** runner for future tests.
- Uses the **current unified osbuild `image-builder`** container and `--bootc-ref` with `--bootc-default-fs ext4` for Fedora, which may omit a default filesystem declaration.
- `ghcr.io/osbuild/image-builder-cli:latest` and `quay.io/fedora/fedora-bootc:43` have floating input references. The workflow records image IDs for this run; digest-pinning and improved provenance are prerequisites to calling the build reproducible.
- Rootful container storage is shared only **between the two containers on the same ephemeral runner**. No Windows host disks, account credentials, test passwords, host projects or production GitHub tokens are mounted into the privileged builder.
- The workflow **does not upload or publish** the generated QCOW2 or cache it as a release artifact; it disappears when the ephemeral runner is destroyed. This is intentional. No network-enabled VM is launched.
- Validation uses `qemu-img info` to inspect a generated `*.qcow2` and requires `format == qcow2` and a nonzero virtual size. Header validity does **not** prove the disk has bootable firmware, a correct partition layout or working KDE login.
- Any conversion error, timeout or runner-space failure is a real **failed experiment**, not a successful boot. Record it and adjust one variable in a follow-up PR.
- Some installed services (including SSH/Avahi) must be evaluated after actual guest boot and before enabling networking.
- Initial login provisioning is **not** implemented in this workflow; no shared/default password will be embedded.

## Expected outcomes

| Evidence | Pass condition | Before run |
| --- | --- | --- |
| Manual trigger | Workflow explicitly started | Not tested |
| KDE OCI build | Existing Containerfile builds with current upstream | Not tested |
| Image-builder conversion | Returns success and writes QCOW2 | Not tested |
| QCOW2 metadata | `qemu-img info` returns correct format and nonzero virtual size | Not tested |
| UEFI boot | Actual disposable VM reaches systemd | Out of scope |
| SDDM/KDE login | Human proves working graphical login | Out of scope |

## Follow-up

If conversion succeeds, open a **separate PR** describing how to securely transfer a test artifact to an isolated UEFI VM environment, decide on a strictly test-only login provisioning method, boot the disk, and capture guest evidence. Do not enable artifact downloads of unreviewed images or treat this as a public OS release.

References:
- https://osbuild.org/docs/developer-guide/projects/image-builder/usage/
- https://osbuild.org/docs/developer-guide/projects/image-builder/installation/
- https://osbuild.org/docs/user-guide/image-descriptions/bootc/qcow2/
- [ADR-0007](ADR-0007-FIRST-VM-BOOT-PLAN.md)
