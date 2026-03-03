#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if ! command -v node >/dev/null 2>&1; then
  echo "node not found on PATH" >&2
  exit 1
fi

INDEX_HTML="${ROOT_DIR}/host/index.html"

grep -q "Content-Security-Policy" "${INDEX_HTML}"
grep -q "<script type=\\\"module\\\" src=\\\"\\./bootstrap\\.js\\\"></script>" "${INDEX_HTML}"

if grep -q "<script type=\\\"module\\\">" "${INDEX_HTML}"; then
  echo "inline module script is not allowed: ${INDEX_HTML}" >&2
  exit 1
fi

node --test "${ROOT_DIR}/host/tests/sanitize.test.mjs"

echo "phase2_host_safety: PASS"

