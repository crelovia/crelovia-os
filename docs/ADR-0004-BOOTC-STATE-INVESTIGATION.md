# ADR-0004 — Fedora bootc state model and first-boot investigation

Date: 2026-10-22
Status: Investigation completed; remediation and VM boot **not yet validated**

## Why this investigation

Our KDE desktop container assembled successfully (GitHub run [39869732108](https://github.com/crelovia/crelovia-os/actions/runs/39869732108)). Following narrow DNF log cleanup, subsequent runs still report `nonempty-run-tmp` and `var-tmpfiles` (most recently [39877362601](https://github.com/crelovia/crelovia-os/actions/runs/39877362601); 12 checks passed, 1 skipped, 2 warnings).

The prior blanket `rm -rf` approach failed because /run contains container-runtime mounts such as `/run/.containerenv` and stub DNS configuration. Continuing to guess and delete individual directories is not a sound strategy.

## Verified upstream semantics

1. **/usr** is managed as part of the OS image.
2. **/etc** is configuration state, with bootc-specific merging and persistence semantics.
3. **/var** is persistent machine-local state (similar to a container volume). Files in /var packaged into an image are initialized on initial deployment, not reliably replaced on subsequent updates. Service state directories should usually be created using `StateDirectory=` or systemd `tmpfiles.d`.
4. **/run and /tmp** are runtime paths and should not contain baked-in image content. Podman/Buildah can inject temporary mount paths during a container build.
5. A bootc lint *warning* is not necessarily a fatal build failure, but it is also not evidence of safe first boot.
6. The archived bootc-image-builder project migrated to osbuild/image-builder. Its current documentation describes `image-builder build --bootc-ref ... --bootc-default-fs ext4 qcow2`; for Fedora-based bootc images, a default filesystem may need to be specified.

## Relevant upstream issue

coreos/rpm-ostree issue [#5517](https://github.com/coreos/rpm-ostree/issues/5517) documents missing tmpfiles entries for `/var/account`, `/var/lib/plocate`, and related paths after modifying Fedora bootc-derived images. Crelovia observed some of these same paths.

This does **not** establish that every Crelovia warning is the same upstream bug. It makes a narrowly scoped package/tmpfiles investigation worthwhile.

## Crelovia-owned package evidence

From [diagnostic run #4](https://github.com/crelovia/crelovia-os/actions/runs/39874739710):
- /var/account — psacct
- /var/cache/PackageKit and /var/cache/app-info — PackageKit
- /var/lib/plocate/CACHEDIR.TAG — plocate
- /var/lib/systemd/catalog/database — systemd
- /var/lib/authselect/checksum — no RPM owning package reported; likely generated state, unproven

Treat the above as packages/state requiring triage, **not a deletion list**.

## Decisions for the next stage

**A. Freeze and preserve the successful KDE image definition** while developing a preflight/diagnostic branch.

**B. Stop recursive /run deletion experiments.** Compare build-layer contents with runtime-mounted paths and investigate whether the linter already excludes specific Buildah/Podman injections. Avoid deleting active mounts.

**C. Handle /var by ownership and persistence semantics.** Classify each warning as one of:
- ephemeral cache/log residue that should not ship;
- required persistent state needing an upstream-compatible tmpfiles rule or service StateDirectory;
- generated state that needs its own first-boot initialization method;
- an upstream issue best fixed upstream rather than masked locally.

**D. Preserve ownership, permissions and SELinux expectations.** Never auto-generate tmpfiles entries with hardcoded root:root defaults for every directory. Do not delete RPM-owned paths merely to obtain zero lint warnings.

**E. Explicit VM readiness gate.** Before producing or distributing a bootable image:
- review installed display manager and unit presets;
- set an appropriate graphical boot target only after confirming its dependencies;
- design safe first-login account provisioning without baked-in credentials;
- test SELinux labels and state directory recreation;
- prove VM UEFI boot, login, reboot, and recovery.

## Safe next experiment

Run a **read-only preflight** of the currently working KDE derived image. Capture:
- package ownership for listed /var entries;
- whether each directory has a corresponding systemd tmpfiles rule or unit StateDirectory;
- whether /run entries are bind mounts or image-layer content;
- display manager package and enabled service status;
- current bootc lint warnings.

Only after identifying the exact state contract should a new isolated Containerfile attempt fixes.

## Bootable disk-image tooling (research, not yet implemented)

Upstream osbuild/image-builder documentation describes this pattern:

```sh
sudo image-builder build --bootc-ref <LOCAL-BOOTC-IMAGE> --bootc-default-fs ext4 qcow2
```

Prerequisites: the referenced image must be present in the builder's container storage, and `image-builder` must be installed. This snippet is a **reference only**; the command has not been tested for Crelovia and is not a recommendation to run it on the Windows host or production storage.

## Upstream sources

- https://bootc.dev/bootc/filesystem.html
- https://ostreedev.github.io/ostree/var/
- https://bootc.dev/bootc/internals/bootc_lib/lints/index.html
- https://github.com/coreos/rpm-ostree/issues/5517
- https://github.com/bootc-dev/bootc/discussions/1994
- https://osbuild.org/docs/developer-guide/projects/image-builder/usage/
- https://github.com/osbuild/bootc-image-builder

## Current outcome

A grounded root-cause model and safe next plan. **No warning has been newly cleared by this investigation, no VM disk image has been produced, and no Crelovia desktop has yet booted.**
