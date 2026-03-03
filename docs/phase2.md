# Phase 2: Web UI MVP

This repo is the canonical home for:

- `std.web_ui.*` X07 modules (package: `std-web-ui@0.1.3`)
- `x07:web-ui` WIT packages
- the canonical browser host (JS)

## Contracts

### Core-wasm-first (Phase 2A)

The browser host loads a core wasm module exporting `x07_solve_v2` and drives it with JSON bytes:

- input: `x07.web_ui.dispatch@0.1.0` (`UTF-8` JSON bytes)
- output: `x07.web_ui.frame@0.1.0` (`UTF-8` JSON bytes)

The host maintains `state` outside the wasm module and replays deterministically using captured traces.

### Component path (Phase 2B)

The delivery artifact is a wasm component exporting:

- `init() -> list<u8>`
- `step(list<u8>) -> list<u8>`

The browser runs the transpiled ESM output produced by `jco transpile`.

## Layout

- `packages/std-web-ui/0.1.3/`: canonical `std.web_ui.*` package
- `wit/`: canonical WIT packages
- `host/`: canonical browser host (ESM + HTML)
- `examples/`: small solve-pure apps that emit `x07.web_ui.*` frames

## Host usage

The browser host entry is `host/index.html`:

- entrypoint is `host/bootstrap.js` (loaded by `host/index.html`)
- prefers `./transpiled/app.mjs` when present (component+ESM build)
- otherwise falls back to `./app.wasm` (core wasm build)

For backwards compatibility, `host/main.mjs` exists as a thin alias that loads `bootstrap.js`.

## Phase 3 extension: HTTP effects

When mounted with an API prefix, the host also:

- executes `x07.web_ui.effect.http.request` effects via `fetch`
- injects responses under `state.__x07_http.response`
- captures an `x07.app.trace@0.1.0` with combined UI + HTTP exchanges

## Phase 5 extension: browser effects

The host also supports a minimal browser-side effect surface and injects results under reserved state keys:

- Storage: `x07.web_ui.effect.storage.*` → `state.__x07_storage`
- Navigation: `x07.web_ui.effect.nav.*` → `state.__x07_nav`
- Timers: `x07.web_ui.effect.timer.*` → `state.__x07_timer`

## Phase 6 extension: capabilities + policy snapshot

When mounted with `capabilities` (x07.app.capabilities@0.1.0 shape), the host:

- always allows same-origin HTTP requests (keeps relative `/api/...` working)
- denies cross-origin `http(s)` fetch unless it matches `capabilities.network.allowlist[]`

When mounted with `policySnapshotSha256`, the host includes it in the captured trace/incident metadata.
