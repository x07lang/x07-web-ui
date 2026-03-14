# x07-web-ui

`x07-web-ui` is the canonical UI layer for [X07](https://github.com/x07lang/x07). It contains the web UI contracts, `std.web_ui.*` packages, browser host, examples, and supporting docs for running x07 UI reducers as pure state machines.

The vision is that UI code should be as reliable for coding agents as backend code: one reducer model, explicit effects, deterministic replay, and the same application logic running across browser and device surfaces.

x07-web-ui is designed for **100% agentic coding**. An AI coding agent can scaffold, implement, test, and ship a web UI app using structured contracts and replay-friendly traces instead of fragile DOM scripting.

## How it fits into the x07 ecosystem

`x07-web-ui` is the UI-specific layer in the wider x07 app stack:

- **`x07`** is the language, package workflow, and main entrypoint.
- **`x07-web-ui`** defines the reducer model and UI-side standard library.
- **`x07-wasm-backend`** builds, serves, tests, and packages those reducers as browser and device artifacts.
- **`x07-device-host`** runs the same reducer inside desktop and mobile WebView shells.
- **`x07-platform`** can then supervise release, rollout, and incident handling for the packaged application.

If you want to build a user-facing app in x07, this repo is the canonical place where the UI contract lives.

## Prerequisites

The [X07 toolchain](https://github.com/x07lang/x07) must be installed before using x07-web-ui. If you (or your agent) are new to X07, start with the **[Agent Quickstart](https://x07lang.org/docs/getting-started/agent-quickstart)** — it covers toolchain setup, project structure, and the workflow conventions an agent needs to be productive.

## Practical usage

Use `x07-web-ui` when you want to:

- build a browser UI in x07 with a pure reducer model
- keep UI behavior deterministic and replayable in CI
- share the same reducer across browser, desktop, and mobile targets
- express side effects as explicit data instead of hidden framework callbacks

In standalone use, you pair this repo with `x07-wasm web-ui build/test/serve`.

As part of the full x07 ecosystem, the typical path is:

1. write the reducer against `std.web_ui.*`
2. build and test it with `x07-wasm`
3. package it for desktop/mobile with `x07-device-host`
4. release and supervise it with `x07-platform`

## What it includes

| Surface | Description |
|---------|-------------|
| **WIT contracts** (`wit/`) | `x07:web-ui@0.1.0` and `x07:web-ui@0.2.0` — JSON-bytes boundary with `init`/`step` dispatch/frame envelopes; the current device helpers expand the JSON contracts without a `0.3.0` WIT bump |
| **Stdlib package** (`packages/std-web-ui/0.2.6/`) | Canonical `std.web_ui.*` modules (tree, event, patch, effect, telemetry, builder-I/O helpers, and Tactics M0 audio/haptics device helpers) |
| **Browser host** (`host/`) | Canonical host (`index.html`, `app-host.mjs`) — loads wasm, normalizes DOM events, calls `init`/`step`, applies patches, captures transcripts |
| **Examples** | `web_ui_counter`, `web_ui_form` with deterministic trace fixtures |

## Effects

The UI reducer is a pure state machine (`init` + `step`). Side effects are expressed as data and executed by the host:

- **HTTP** (`std.web_ui.effects.http`): emits `x07.web_ui.effect.http.request` effects; host executes against an API prefix and captures `x07.app.trace@0.1.0`
- **Storage** (`std.web_ui.effects.storage`): local key-value storage effects; storage writes re-dispatch an acknowledgement at `state.__x07_storage.set.ok` without echoing the persisted payload back into reducer state
- **Navigation** (`std.web_ui.effects.nav`): navigation effects
- **Timer** (`std.web_ui.effects.timer`): timer/delay effects
- **Device permissions** (`std.web_ui.effects.device.permissions`): capability-aware runtime permission query/request helpers
- **Device capture/import/export** (`std.web_ui.effects.device.camera`, `std.web_ui.effects.device.files`): camera/photo capture, multi-file import, and save/export helpers that return normalized file items plus blob manifests
- **Device clipboard/share** (`std.web_ui.effects.device.clipboard`, `std.web_ui.effects.device.share`): clipboard read/write helpers plus text/file share builders
- **Device blobs** (`std.web_ui.effects.device.blobs`): blob metadata helpers for host-owned binary storage
- **Device audio/haptics** (`std.web_ui.effects.device.audio`, `std.web_ui.effects.device.haptics`): cue-based audio playback helpers plus normalized haptic trigger helpers
- **Device location** (`std.web_ui.effects.device.location`): one-shot foreground location helpers
- **Device notifications/events** (`std.web_ui.effects.device.notifications`, `std.web_ui.effects.device.events`): local notification helpers plus lifecycle/connectivity and normalized `files.drop` event predicates

## Architecture

The same `std.web_ui.*` reducer compiled to WASM runs everywhere:

- **Browser**: loaded directly by the canonical browser host
- **Desktop/mobile**: loaded inside a system WebView shell (`x07-device-host`) — same wasm artifact, same host contract
- **CI**: headless deterministic replay (transcript → assertions) via `x07-wasm web-ui test`

## Examples

- `examples/web_ui_counter/`
- `examples/web_ui_form/`
- Docs:
  - `docs/device-capabilities-and-permissions.md`
  - `docs/device-blob-manifests.md`

## Links

- Recommended install flow:
  - `x07up component add wasm`
  - `x07 pkg add std-web-ui@0.2.6 --sync`
- Package publish line: `std-web-ui@0.2.6`
- [X07 Agent Quickstart](https://x07lang.org/docs/getting-started/agent-quickstart) — start here
- [X07 toolchain](https://github.com/x07lang/x07)
- [X07 website](https://x07lang.org)
- [WASM build tooling](https://github.com/x07lang/x07-wasm-backend) — `x07-wasm web-ui build/test/serve`

## License

Dual-licensed under [Apache 2.0](LICENSE-APACHE) and [MIT](LICENSE).
