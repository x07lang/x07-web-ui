#!/usr/bin/env bash
set -euo pipefail

repo_root() {
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd
}

root="$(repo_root)"
cd "$root"

bash scripts/ci/check_phase2_host_safety.sh

version="$(tr -d '\n' < VERSION)"
pkg_dir="packages/std-web-ui/${version}"
tests_manifest="${pkg_dir}/tests/tests.json"

[[ -d "${pkg_dir}" ]] || { echo "missing package dir: ${pkg_dir}" >&2; exit 1; }
[[ -f "${tests_manifest}" ]] || { echo "missing tests manifest: ${tests_manifest}" >&2; exit 1; }
command -v x07 >/dev/null 2>&1 || { echo "x07 not found on PATH" >&2; exit 1; }
command -v x07c >/dev/null 2>&1 || { echo "x07c not found on PATH" >&2; exit 1; }

x07 test --manifest "${tests_manifest}" >/dev/null

worlds=(
  run-os
  run-os-sandboxed
  solve-fs
  solve-full
  solve-kv
  solve-pure
  solve-rr
)

while IFS= read -r -d '' module_path; do
  for world in "${worlds[@]}"; do
    x07c lint --world "${world}" --input "${module_path}" >/dev/null
  done
done < <(find "${pkg_dir}/modules" -type f -name '*.x07.json' -print0 | sort -z)
