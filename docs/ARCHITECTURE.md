# Architecture — Initial Proposal

Status: Proposal, not an implementation specification.

## Foundation
- **Base:** Fedora-family Linux with a preference for an image-based/atomic approach, pending technical validation.
- **Desktop:** KDE Plasma + Wayland, with a familiar default layout and extensive supported customization.
- **Audio:** PipeWire and WirePlumber.
- **Creative apps:** optional, tested native Linux software first; compatibility tools evaluated separately.
- **Security baseline:** upstream security updates, SELinux where supported, nftables/firewalld, LUKS disk encryption offered during installation, and least-privilege application access.
- **Updates:** evaluate atomic deployments and verified rollback on a real supported build; no automatic assurance before testing.

## Initial component boundaries
1. **Base image** — source-pinned upstream packages and build tooling.
2. **Default desktop profile** — documented KDE preferences and assets; reversible by user.
3. **Creator profiles** — opt-in application sets, no forced installs.
4. **Privacy controls** — explicit permissions, safe defaults, and auditable policy changes.
5. **Workspace Packs** — proposed declarative data format; never execute third-party scripts by default.
6. **Documentation and validation** — build, test, restore, security, hardware compatibility.

## Compatibility
A Linux distribution does not natively run all Windows software. Wine/Proton, virtual machines, remote PCs, and capture solutions may help. Video editing, DAW plugins, anti-cheat, and proprietary peripherals require per-product validation.

## Dual-PC streaming
A Windows or Linux gaming PC may supply video/audio through capture hardware or a network path to a Crelovia production PC. We will document device support, latency, network exposure, and failure recovery rather than assuming compatibility.

## Privacy threat model (starter)
- Accidental display of private windows and notifications.
- Malicious or overprivileged creator plugins and Workspace Packs.
- Account/stream credential theft and compromised update infrastructure.
- LAN attacks on remote stream-control services.
- Sensitive logs, screenshots, browser profiles, or metadata leaking.

No software can guarantee a user's physical safety or remove already-public personal information. Privacy features must make specific, testable claims.

## Design rules
- Avoid unnecessary proprietary services, forced accounts, and silent telemetry.
- Do not fork upstream components without a compelling maintenance justification.
- Document user-impacting default changes and a reversal path.
- Keep privileged code minimal; security features require testing and review.
