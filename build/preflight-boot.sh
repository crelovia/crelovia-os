#!/usr/bin/env bash
# Read-only bootc KDE preflight — do not change service state or clean any files.
set -euo pipefail
section(){ printf '\n===== %s =====\n' "$1"; }
section "OS and bootc metadata"
cat /usr/lib/os-release 2>/dev/null || true
rpm -q bootc systemd plasma-desktop plasma-workspace kwin 2>&1 || true

section "Graphical login package inventory"
for p in sddm sddm-wayland-plasma plasma-workspace-wayland xorg-x11-server-Xorg; do
  rpm -q "$p" 2>&1 || true
done
section "Display manager unit locations and symlinks"
for p in /usr/lib/systemd/system/display-manager.service /etc/systemd/system/display-manager.service /usr/lib/systemd/system/sddm.service /usr/lib/systemd/system/graphical.target /etc/systemd/system/default.target; do
  ls -ld "$p" 2>&1 || true
  if test -L "$p"; then readlink "$p" || true; fi
done
section "Session files"
find /usr/share/wayland-sessions /usr/share/xsessions -maxdepth 1 -type f -print 2>/dev/null | sort || true
section "Systemd defaults and presets"
find /etc/systemd/system -maxdepth 2 -type l -print 2>/dev/null | sort | head -n 120 || true
grep -RHE '(^|[[:space:]])(enable|disable)[[:space:]].*(sddm|display-manager)' /usr/lib/systemd/system-preset /etc/systemd/system-preset 2>/dev/null || true
section "Service-owned directories / tmpfiles policy"
grep -RHE '^([[:space:]]*)StateDirectory=' /usr/lib/systemd/system /etc/systemd/system 2>/dev/null | grep -E 'sddm|cups|plocate|PackageKit|psacct|mariadb|openvpn|ipsec' | head -n 100 || true
for p in /var/account /var/cache/PackageKit /var/cache/app-info /var/lib/plocate/CACHEDIR.TAG /var/lib/systemd/catalog/database /var/lib/authselect/checksum; do
  if test -e "$p"; then printf '%s -> ' "$p"; rpm -qf "$p" || true; fi
done
section "Transient run entries (without cleaning runtime mounts)"
find /run -mindepth 1 -maxdepth 2 -printf '%y %p\n' 2>/dev/null | sort | head -n 120 || true
section "Mountinfo for /run and /tmp"
awk '$5 == "/run" || $5 ~ /^\/run\// || $5 == "/tmp" || $5 ~ /^\/tmp\// {print $5, $0}' /proc/self/mountinfo | head -n 90 || true
section "bootc container lint (warnings are evidence, not release clearance)"
bootc container lint
