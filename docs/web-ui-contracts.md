# Web UI Contracts

This repo is the canonical home for:

- `std.web_ui.*` X07 modules (package: `std-web-ui@0.2.5`)
- `x07:web-ui` WIT packages
- the canonical browser host (JS)

## Contracts

### Core Wasm Contract

The browser host loads a core wasm module exporting `x07_solve_v2` and drives it with JSON bytes:

- input: `x07.web_ui.dispatch@0.1.0` (`UTF-8` JSON bytes)
- output: `x07.web_ui.frame@0.2.0` (`UTF-8` JSON bytes)

The host maintains `state` outside the wasm module and replays deterministically using captured traces.

### Component Contract

The delivery artifact is a wasm component exporting:

- `init() -> list<u8>`
- `step(list<u8>) -> list<u8>`

The browser runs the transpiled ESM output produced by `jco transpile`.

## Layout

- `packages/std-web-ui/0.2.5/`: canonical `std.web_ui.*` package
- `wit/`: canonical WIT packages
- `host/`: canonical browser host (ESM + HTML)
- `examples/`: small solve-pure apps that emit `x07.web_ui.*` frames

## Host snapshot (drift gate)

The canonical browser host assets are pinned by a snapshot contract:

- `host/host.snapshot.json`

CI validates:

- asset `sha256` + `bytes_len`
- computed `host_abi_hash` over `{abi_name, abi_version, bridge_protocol_version, assets[].{path,sha256}}`

Run locally:

```sh
bash scripts/ci/check_host_snapshot.sh
```

## Host usage

The browser host entry is `host/index.html`:

- entrypoint is `host/bootstrap.js` (loaded by `host/index.html`)
- reads `./app.manifest.json` when present for `apiPrefix`, `componentEsmUrl`, and `webUi` runtime limits such as `arenaCapBytes` / `maxOutputBytes`
- prefers `./transpiled/app.mjs` when present (component+ESM build)
- otherwise falls back to `./app.wasm` (core wasm build)

For backwards compatibility, `host/main.mjs` exists as a thin alias that loads `bootstrap.js`.

## HTTP Effects

When mounted with an API prefix, the host also:

- executes `x07.web_ui.effect.http.request` effects via `fetch`
- injects responses under `state.__x07_http.response`
- captures an `x07.app.trace@0.1.0` with combined UI + HTTP exchanges

## Browser Effects

The host also supports a minimal browser-side effect surface and injects results under reserved state keys:

- Storage: `x07.web_ui.effect.storage.*` → `state.__x07_storage`
- Navigation: `x07.web_ui.effect.nav.*` → `state.__x07_nav`
- Timers: `x07.web_ui.effect.timer.*` → `state.__x07_timer`
- Audio: `x07.web_ui.effect.device.audio.*` → `state.__x07_device.audio.result`
- Haptics: `x07.web_ui.effect.device.haptics.*` → `state.__x07_device.haptics.result`
- Clipboard: `x07.web_ui.effect.device.clipboard.*` → `state.__x07_device.clipboard.result`
- Files: `x07.web_ui.effect.device.files.*` → `state.__x07_device.files.result`
- Share: `x07.web_ui.effect.device.share.*` → `state.__x07_device.share.result`
- Drop events: browser drag/drop normalizes to reducer event `{ "type": "files.drop", "target": <key>, "items": [...] }`

## Capabilities And Policy Snapshot

When mounted with `capabilities` (x07.app.capabilities@0.2.0 shape), the host:

- always allows same-origin HTTP requests (keeps relative `/api/...` working)
- denies cross-origin `http(s)` fetch unless it matches `capabilities.network.allowlist[]`
- when running from a device bundle, can normalize `device.capabilities.json` `allow_hosts[]` plus `device.profile.json` `backend.base_url` into the host `allowlist[]` form

When mounted with `policySnapshotSha256`, the host includes it in the captured trace/incident metadata.

## Defense in depth

- CSP-from-capabilities: deployments can derive a CSP `connect-src` allowlist from `capabilities.network.allowlist[]` (plus `'self'`) so the browser blocks disallowed egress even if JS is compromised.
- WASI is not a sandbox: if you run WASI code outside `x07-wasm` (for example via Node), do not assume the runtime is a security sandbox for untrusted code.
