#!/usr/bin/env bash
# Read-only checks performed in an unbooted experimental Crelovia container.
set -euo pipefail
section(){ printf '\n===== %s =====\n' "$1"; }

section "Default systemd boot target"
for path in /etc/systemd/system/default.target /usr/local/lib/systemd/system/default.target /usr/lib/systemd/system/default.target; do
  if [[ -L "$path" ]]; then printf '%s -> %s\n' "$path" "$(readlink "$path")";
  elif [[ -e "$path" ]]; then ls -ld "$path";
  else printf '%s (not present)\n' "$path"; fi
done

section "Display manager and Plasma session"
rpm -q sddm sddm-wayland-plasma plasma-desktop plasma-workspace kwin || true
for path in /etc/systemd/system/display-manager.service /usr/lib/systemd/system/sddm.service /usr/share/wayland-sessions/plasma.desktop; do
  ls -ld "$path" 2>&1 || true
done

section "First-user enrollment package presence (no passwords or shadow data)"
for package in initial-setup initial-setup-gui gnome-initial-setup systemd-firstboot accountsservice; do
  rpm -q "$package" 2>&1 || true
done
for service in initial-setup.service initial-setup-graphical.service systemd-firstboot.service; do
  for dir in /etc/systemd/system /usr/lib/systemd/system; do
    if [[ -e "$dir/$service" || -L "$dir/$service" ]]; then ls -ld "$dir/$service"; fi
  done
done
echo "Human interactive accounts (UID >= 1000, excluding nobody):"
awk -F: '$3 >= 1000 && $3 < 65534 {print "UID=" $3 " home=" $6 " shell=" $7}' /etc/passwd || true
echo "No /etc/shadow contents read or printed."

section "Selected package service presets (links only)"
for service in sshd.service avahi-daemon.service ModemManager.service firewalld.service NetworkManager.service; do
  matches=$(find /etc/systemd/system -type l -name "$service" -print 2>/dev/null | head -n 8 || true)
  if [[ -n "$matches" ]]; then printf '%s\n%s\n' "$service" "$matches"; else printf '%s: no enabled-unit link found\n' "$service"; fi
done

section "Bootc diagnostics"
bootc container lint
