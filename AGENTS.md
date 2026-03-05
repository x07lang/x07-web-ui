# Repository Guide

## Build and test

- `bash scripts/ci/check_phase2_host_safety.sh`

## Release and publish workflow

- `VERSION` is the authoritative repo release version. Keep it aligned with the release tag `vX.Y.Z`.
- The published package version must exist at `packages/std-web-ui/X.Y.Z/` and match the release tag.
- The release workflow publishes the host bundle plus `x07.component.release@0.1.0` metadata.
- Registry publish uses the shared helper from `x07/scripts/release/publish-x07-package.sh`.
- GitHub Actions may not have `X07_REGISTRY_TOKEN`; in that case, publish `std-web-ui` locally with the shared helper and verify with `x07 pkg versions --refresh std-web-ui` or the registry API.
