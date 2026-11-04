# Operation Bigger Pants — KVM runner capacity gate (PR #21)

Date: 2026-11-04
Status: **Proposed, not yet run. KVM was confirmed in run #1, but no guest was booted.**

## Grounded failure

[GitHub Actions Run 41924210588](https://github.com/crelovia/crelovia-os/actions/runs/41924210588) passed the **KVM initialization probe** on `ubuntu-24.04`, then failed while committing the Fedora KDE image layer:

```text
processing tar file(write /usr/bin/mariadb-backup: no space left on device)
```

The build, rather than KVM, ran out of storage. No QCOW2 conversion or boot was attempted. The actual peak disk usage was **not measured**. Image dependencies and upstream floating tags can change requirements.

## What this PR does

- Adds an explicit manual `runner_label` choice to **Experimental KDE KVM-accelerated first light**: standard `ubuntu-24.04` (the default), or `crelovia-kvm-large` (a dedicated, **not currently confirmed to exist** larger runner label).
- Requires **at least 22 GiB free on root storage before image build** and **at least 20 GiB free in the rootful Podman storage filesystem after installing prerequisites**. These are conservative, **provisional planning thresholds**, not proof that conversion will fit. An ordinary 14-GB runner is expected to fail early.
- Reports disk capacity at key stages. Does **not** delete `/opt`, `/usr`, SDKs, tool caches, existing host volumes, or other preinstalled system resources.
- Keeps the previously verified KVM initialization check and isolated, non-networked guest test unchanged. No Windows host disk or password changes.

## Important: runner provisioning and costs

GitHub's standard public-repository Linux runner has a **14-GB SSD**, while larger GitHub-hosted runners can offer significantly more disk. **Larger runners require a suitable GitHub organization plan and configuration, and they may bill for compute.** Creating this PR **does not** create a paid runner or enable billing.

Before selecting `crelovia-kvm-large` in the manual workflow:

1. Verify your organization is eligible for GitHub-managed **larger runners**, review pricing and spending caps, and explicitly approve any expense.
2. Provision an **ephemeral, GitHub-hosted Ubuntu x64 larger runner** with at least 75 GB SSD and an exact custom runner label `crelovia-kvm-large` in the repository/organization runner settings; confirm this label is actually available to `crelovia/crelovia-os`. Do **not** attach a persistent self-hosted personal desktop or a privileged machine with private data to a public repository.
3. Confirm that KVM works on the chosen runner; larger disk space does **not** automatically guarantee nested virtualization. The job's KVM probe is still required.
4. Only then manually dispatch the KVM workflow with `runner_label = crelovia-kvm-large`.

If the organization cannot provision such a runner, **do not select that option**: the job would remain queued without a matching runner. Instead, revisit a dedicated disposable Linux VM test environment under an approved budget and security policy.

## Next run interpretations

- **DISK_BUDGET_UNAVAILABLE**: insufficient free root or Podman storage; no build attempted.
- **KVM_UNAVAILABLE**: disk gate passed, but virtualization is unavailable.
- **KDE build or conversion failure**: capture logs and free-space report; do not alter the KDE image merely to hide space issues.
- **QCOW2 converted and VM ran**: inspect serial diagnostics and screenshots before any claim of SDDM or KDE success.

References:
- https://docs.github.com/en/actions/how-tos/write-workflows/choose-where-workflows-run/choose-the-runner-for-a-job
- https://docs.github.com/en/actions/reference/runners/larger-runners

No Crelovia release artifact is produced or uploaded by this experiment.
