# Repository Guide

## Build and test

- `bash scripts/ci/check_phase2_host_safety.sh`
- `bash scripts/ci/check_release_ready.sh`

## Release and publish workflow

- `VERSION` is the authoritative repo release version. Keep it aligned with the release tag `vX.Y.Z`.
- The published package version must exist at `packages/std-web-ui/X.Y.Z/` and match the release tag.
- For component compatibility, keep `releases/compat/X.Y.Z.json` on the supported core minor line with an upper bound. For the current line, use `x07_core: ">=0.1.58,<0.2.0"` instead of patch-only ranges.
- `scripts/ci/check_release_ready.sh` is the canonical release gate entry point. Keep repo-specific checks behind that wrapper instead of calling ad hoc phase scripts from workflows.
- The release workflow publishes the host bundle plus `x07.component.release@0.1.0` metadata.
- Registry publish uses the shared helper from `x07/scripts/release/publish-x07-package.sh`.
- GitHub Actions may not have `X07_REGISTRY_TOKEN`; in that case, publish `std-web-ui` locally with the shared helper and verify with `x07 pkg versions --refresh std-web-ui` or the registry API.
