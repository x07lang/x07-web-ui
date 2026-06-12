> [!IMPORTANT]
> **This repository is archived** (2026-06). X07 has refocused on its core: a deterministic, certifiable execution substrate for agent-written software. This repo (the reducer-based `std.web_ui.*` UI layer and browser host for X07) is no longer maintained — no feature work, no releases. The active surface is [`x07lang/x07`](https://github.com/x07lang/x07), `x07-mcp`, `x07-registry`, `x07-wasm-backend`, and `hardproof`. Rationale and roadmap: `x07/docs/roadmap.md`.

# x07-web-ui

Canonical reducer-based UI layer for X07.

This repo defines the `std.web_ui.*` package line, browser host, examples, and supporting contracts for writing X07 user interfaces as pure state machines with explicit effects.

**Start here:** [`examples/`](examples/) · [`x07lang/x07-wasm-backend`](https://github.com/x07lang/x07-wasm-backend) · [`x07lang/x07-device-host`](https://github.com/x07lang/x07-device-host) · [Agent Quickstart](https://x07lang.org/docs/getting-started/agent-quickstart)

## What This Repo Is For

Use `x07-web-ui` when you want to:

- build a browser UI in X07 with a pure reducer model
- keep UI behavior deterministic and replayable
- share the same reducer across browser, desktop, and mobile
- express effects as explicit data instead of hidden framework callbacks

## Quick Start

Install the WASM component and add the UI package:

```sh
x07up component add wasm
x07 pkg add std-web-ui@0.2.6 --sync
```

Then use the `x07-wasm` web UI flow:

```sh
x07-wasm web-ui build
x07-wasm web-ui serve
x07-wasm web-ui test
```

## What Lives Here

- `packages/std-web-ui/`: canonical `std.web_ui.*` package line
- `host/`: canonical browser host
- `examples/`: example reducers and traces
- `wit/`: UI-side contracts

## Execution Model

The UI reducer stays pure: `init` and `step` produce state plus effect requests. The host executes those effects and re-dispatches the results. That keeps the reducer deterministic while still supporting navigation, storage, HTTP, timers, and device-facing operations.

## How It Fits The X07 Ecosystem

- [`x07`](https://github.com/x07lang/x07) provides the language and toolchain
- `x07-web-ui` defines the reducer-side UI contract
- [`x07-wasm-backend`](https://github.com/x07lang/x07-wasm-backend) builds, serves, and tests browser and device outputs
- [`x07-device-host`](https://github.com/x07lang/x07-device-host) runs the same reducer on desktop and mobile

## License

Dual-licensed under [Apache 2.0](LICENSE-APACHE) and [MIT](LICENSE).
