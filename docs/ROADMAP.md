# Crelovia OS — Roadmap

All plans are provisional. No release date is promised.

## Milestone 0: Foundation (current)
- [x] Create public GitHub organization and repository
- [x] Document mission and scope
- [x] Document initial architecture and test strategy
- [ ] Choose license(s) after dependency/legal review
- [ ] Establish branch protection and minimum CI checks
- [ ] Set up a controlled security-reporting channel
- [ ] Validate name, domain, and trademark clearance

## Milestone 0.1: Bootable developer prototype
- [ ] Choose supported Fedora base and image building approach
- [x] Create and successfully build a minimal Fedora bootc development container (GitHub Actions run 39868620806; 14 lint checks passed, 1 skipped)
- [ ] Pin and document reviewed upstream digests and reproducible build inputs
- [ ] Boot the image in a disposable VM
- [x] Build an experimental Fedora 43 bootc container containing KDE Plasma 6.7.5 and KWin (run 39869732108; packaging verified, not boot-tested)
- [ ] Resolve KDE image bootc lint warnings for runtime/tmp files, DNF logs, and /var initialization
- [ ] Launch KDE Plasma with familiar desktop defaults
- [ ] Verify basic networking, display, storage, audio, and updates
- [ ] Document rollback/recovery design and prove it in a VM
- [ ] Record build provenance and component licenses

**Exit criterion:** A different contributor can reproduce and boot a documented development image in a VM, and verify the basic smoke-test checklist.

## Milestone 0.2: Creator desktop
- [ ] Optional creator software profiles
- [ ] OBS and PipeWire workflow testing
- [ ] GPU and capture hardware compatibility matrix
- [ ] Multi-monitor and accessibility testing
- [ ] Workspace layout export/import proof of concept

## Milestone 0.3: Security and workspace sharing
- [ ] Threat model for public-facing creators
- [ ] Safer streaming preset with explicit source approval
- [ ] Workspace Pack format, schema validation, previews, and sandboxing rules
- [ ] Reproducible package/image validation and signed release design
- [ ] Independent review of privileged components

## Later
- Hardware testing on supported real PCs
- Convenient installer and recovery experience
- Public beta criteria, documentation, and governance
- Community publishing infrastructure only after abuse/supply-chain risks are addressed

No roadmap item should be advertised as implemented until tested and documented.
