#!/usr/bin/env bash
set -euo pipefail

# Diagnostic only: inventory suspicious state in an experimental bootc image.
# This script does not mutate /var, /run, /tmp, or installed packages.
echo "=== Runtime /run entries (max depth 3) ==="
find /run /tmp -mindepth 1 -maxdepth 3 -printf '%y %p\n' 2>/dev/null | sort | head -n 250 || true
echo "=== /var dirs and files (max depth 4) ==="
find /var -mindepth 1 -maxdepth 4 -printf '%y %m %u:%g %p\n' 2>/dev/null | sort | head -n 400 || true
echo "=== /var package ownership samples ==="
for path in /var/account /var/cache/PackageKit /var/cache/app-info /var/lib/plocate/CACHEDIR.TAG /var/lib/systemd/catalog/database /var/lib/authselect/checksum; do
  if test -e "$path"; then
    printf '\n%s\n' "$path"
    rpm -qf "$path" || true
  fi
done
echo "=== Representative tmpfiles declarations ==="
find /usr/lib/tmpfiles.d /etc/tmpfiles.d -maxdepth 1 -type f -print 2>/dev/null | sort | head -n 130 || true
echo "=== Bootc lint ==="
bootc container lint || true
