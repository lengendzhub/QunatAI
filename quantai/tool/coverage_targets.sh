#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LCOV_FILE="$ROOT_DIR/coverage/lcov.info"
OUT_DIR="$ROOT_DIR/coverage/targets"

if [[ ! -f "$LCOV_FILE" ]]; then
  echo "coverage/lcov.info not found. Run: flutter test --coverage"
  exit 1
fi

mkdir -p "$OUT_DIR"

extract_target() {
  local name="$1"
  local pattern="$2"
  local out="$OUT_DIR/${name}.lcov.info"

  awk -v p="$pattern" '
    /^SF:/ {keep = ($0 ~ p)}
    {if (keep) print $0}
  ' "$LCOV_FILE" > "$out"

  local lf
  local lh
  lf="$(awk -F: '/^LF:/ {sum += $2} END {print sum + 0}' "$out")"
  lh="$(awk -F: '/^LH:/ {sum += $2} END {print sum + 0}' "$out")"

  local pct="0.00"
  if [[ "$lf" -gt 0 ]]; then
    pct="$(awk -v h="$lh" -v f="$lf" 'BEGIN {printf "%.2f", (h/f)*100}')"
  fi

  cat > "$OUT_DIR/${name}.summary.txt" <<EOF
Target: $name
Pattern: $pattern
Lines Found (LF): $lf
Lines Hit (LH): $lh
Coverage: $pct%
Output: coverage/targets/${name}.lcov.info
EOF

  echo "[$name] LF=$lf LH=$lh Coverage=$pct%"
}

extract_target "broker" "^SF:.*lib/core/broker/"
extract_target "ict" "^SF:.*lib/core/analysis/"
extract_target "risk" "^SF:.*lib/core/risk/"
extract_target "providers" "^SF:.*lib/providers/"

echo "Coverage target files written under coverage/targets"
