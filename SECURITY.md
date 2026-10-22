# Security Policy

## Current support status
Crelovia OS is **pre-alpha planning work**. There is no distributable operating system, supported release, security audit, or guaranteed vulnerability response time.

## Reporting potential vulnerabilities
**Do not open a public issue containing exploit details, credentials, personal information, or unpatched vulnerability instructions.**

Before public testing begins, maintainers intend to enable GitHub private vulnerability reporting under repository **Settings → Security → Private vulnerability reporting**, if available.

Until a private channel is configured, do not submit sensitive exploit details through public GitHub discussions, issues, or pull requests. Check the repository Security tab for the current reporting mechanism.

## Security principles
- Protect sensitive reports and coordinate disclosure.
- Track dependencies and minimize privileged components.
- Prefer auditable, reversible configuration.
- Treat third-party Workspace Packs, plugins, and scripts as untrusted.
- Never claim that this project prevents all malware, doxxing, swatting, or compromise.

## Scope
At this stage, issues in upstream Fedora, KDE, OBS, or other components should be reported to their respective maintainers using the project's reporting guidance. Crelovia-specific integration bugs can be tracked publicly only when they do not expose a live vulnerability.
