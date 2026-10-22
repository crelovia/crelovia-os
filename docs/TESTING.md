# Developer Testing Plan

## Safety
Initial experiments belong in disposable VMs; do not install experimental images over an existing Windows system or personal data drive.

## Planned smoke test for milestone 0.1
1. Reproduce an image from documented inputs and record build output and hashes.
2. Boot VM in UEFI mode without modifying host drives.
3. Confirm login, KDE Plasma session, keyboard, mouse, scaling, and networking.
4. Verify audio input/output using virtual devices.
5. Verify software management and update behavior.
6. Demonstrate supported rollback/recovery after a deliberately broken test update.
7. Inspect default network listeners, permissions, and security enforcement state.
8. Reboot and ensure no unexpected persistent failure.
9. Publish failures and known limitations, not just successful results.

## Later hardware coverage
- NVIDIA and AMD GPU paths
- USB audio interfaces and MIDI
- Capture cards and webcams
- Multi-monitor and HDR limitations
- Steam/Proton where appropriate
- OBS + PipeWire with real recording tests
- Accessible input and display configurations

There is no implemented test automation yet.
