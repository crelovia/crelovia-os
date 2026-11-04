#!/usr/bin/env bash
# DIAGNOSTIC-ONLY: collects strictly scoped service state without credentials.
# Never copy into a distributable image. Guest has no network adapter.
set -u
if [[ ! -c /dev/ttyS0 ]]; then
  exit 0
fi
exec > /dev/ttyS0 2>&1
export SYSTEMD_PAGER=cat
export SYSTEMD_COLORS=0
printf '\n=== CRELOVIA GRAPHICS DIAGNOSTICS START ===\n'
for phase in 1 2 3; do
  case "$phase" in
    1) sleep 10 ;;
    2) sleep 45 ;;
    3) sleep 90 ;;
  esac
  printf '\n=== DIAGNOSTIC PHASE %s ===\n' "$phase"
  printf '%s\n' 'Default target:'
  systemctl get-default 2>&1 || true
  printf '%s\n' 'Target / display-manager / SDDM state (selected properties):'
  for unit in graphical.target display-manager.service sddm.service plymouth-quit-wait.service; do
    echo "Unit: $unit"
    systemctl show "$unit" \
      -p LoadState -p ActiveState -p SubState -p Result \
      -p ExecMainCode -p ExecMainStatus --no-pager 2>&1 || true
  done
  printf '%s\n' 'Systemd pending jobs (selected, bounded output):'
  timeout 12s systemctl list-jobs --no-pager --no-legend 2>&1 | head -35 || true
  printf '%s\n' 'Startup ordering chain for graphical.target (bounded):'
  timeout 12s systemd-analyze critical-chain graphical.target --no-pager 2>&1 | head -60 || true
  printf '%s\n' 'Failed system units (bounded):'
  timeout 12s systemctl --failed --no-pager --plain 2>&1 | head -35 || true
  printf '%s\n' 'SDDM and Plymouth journal excerpts (last 50):'
  journalctl -b --no-pager -o short-monotonic -n 50 \
    -u sddm.service -u display-manager.service \
    -u plymouth-start.service -u plymouth-quit-wait.service 2>&1 || true
  printf '%s\n' 'Kernel DRM/framebuffer journal excerpts (last 35):'
  journalctl -b -k --no-pager -o short-monotonic -n 35 \
    -g 'drm|bochs|virtio_gpu|fbcon|simpledrm' 2>&1 || true
done
printf '\n=== CRELOVIA GRAPHICS DIAGNOSTICS END ===\n'
