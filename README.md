# Crelovia OS

**Your world. Your way.**

Crelovia OS is a new, community-oriented project exploring a **privacy-first, open-source desktop operating system for creators and everyday users**.

> **Status: Pre-alpha planning.** There is no installable Crelovia OS image yet. No features described below should be interpreted as shipped, audited, or production-ready. The project name is provisional pending domain and trademark clearance.

## Why Crelovia?

The goal is to make an approachable desktop that respects its users, supports demanding creative workflows, and remains highly customizable.

- **Familiar by default:** a comfortable desktop for people moving from Windows, with extensive user-driven customization.
- **Privacy by design:** no mandatory Crelovia account, ads, or Crelovia telemetry service; auditable defaults and meaningful permissions.
- **Creator-focused, not streamer-only:** video, music, art, software development, game development, and live production.
- **Community Workspace Packs:** a proposed way to share layouts and settings, with untrusted content safely reviewed before import.
- **Honest compatibility:** document which software and hardware work, and where Linux/Windows compatibility remains limited.
- **Reliable updates:** research image-based deployments, recovery, and rollback before recommending installation.

## Proposed technical foundation

| Area | Starting proposal |
| --- | --- |
| Distribution | Fedora-family Linux, ideally image-based/atomic (to be validated) |
| Desktop | KDE Plasma on Wayland |
| Audio | PipeWire and WirePlumber |
| Security | Upstream security controls, SELinux, firewall, opt-in disk encryption |
| Creative workflows | Optional creator profiles and tested native applications |
| Compatibility | Evaluate Wine/Proton, VMs, capture devices, and multi-PC setups |

Crelovia will build on existing upstream open-source work, not rewrite a kernel from scratch.

## Roadmap

- **Milestone 0 — Foundation:** governance, documentation, reproducible build research.
- **Milestone 0.1 — Bootable prototype:** documented, reproducible development image booting in a disposable VM with KDE Plasma.
- **Milestone 0.2 — Creator workflows:** audio/video/capture tests, optional profiles, preliminary workspace export.
- **Milestone 0.3 — Privacy and sharing:** tested threat-model-driven protections and safer Workspace Pack prototypes.

Read the [detailed roadmap](docs/ROADMAP.md).

## Documentation

- [Project charter](docs/PROJECT_CHARTER.md)
- [Initial architecture](docs/ARCHITECTURE.md)
- [Testing strategy](docs/TESTING.md)
- [Contribution guide](CONTRIBUTING.md)
- [Security policy](SECURITY.md)

## Participate

We welcome thoughtful discussion, testing, documentation, accessibility feedback, and eventually code contributions. Please read [CONTRIBUTING.md](CONTRIBUTING.md) first. **Never post vulnerabilities, credentials, or private personal information in public issues.**

## License and brand status

A license for original Crelovia code has not been selected; the upstream components will retain their applicable licenses. The repository being public does **not** automatically authorize redistribution of its original contents. We will settle licensing before accepting substantial source contributions.

The Crelovia name is also pending formal brand and domain checks.
