#!/usr/bin/env bash
# Read-only Fedora RPM package/license metadata report; not a legal compliance verdict.
set -euo pipefail
out="${1:-/tmp/crelovia-license-report}"
mkdir -p "$out"
rpm -qa --qf '%{NAME}\t%{VERSION}-%{RELEASE}\t%{ARCH}\t%{LICENSE}\n' | LC_ALL=C sort > "$out/rpm-licenses.tsv"
{
 printf 'Generated UTC: '; date -u '+%Y-%m-%dT%H:%M:%SZ'
 printf 'RPM count: '; wc -l < "$out/rpm-licenses.tsv"
 printf 'Distinct RPM LICENSE expressions: '; cut -f4- "$out/rpm-licenses.tsv" | LC_ALL=C sort -u | wc -l
 printf 'Review patterns below are heuristics, NOT license findings.\n'
 grep -Ei '(GPLv2|GPL-2\.0-only|proprietary|commercial|unknown|noassertion)' "$out/rpm-licenses.tsv" | head -n 60 || true
} > "$out/summary.txt"
cat "$out/summary.txt"
