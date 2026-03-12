# x07-web-ui

Canonical [X07](https://github.com/x07lang/x07) web UI contracts, stdlib packages, and browser host for running x07 UI reducers as pure state machines.

x07-web-ui is designed for **100% agentic coding** — an AI coding agent scaffolds, implements, tests, and ships a web UI app entirely on its own using structured contracts, deterministic replay, and machine-readable outputs. No human needs to write X07 by hand.

## Prerequisites

The [X07 toolchain](https://github.com/x07lang/x07) must be installed before using x07-web-ui. If you (or your agent) are new to X07, start with the **[Agent Quickstart](https://x07lang.org/docs/getting-started/agent-quickstart)** — it covers toolchain setup, project structure, and the workflow conventions an agent needs to be productive.

## What it includes

| Surface | Description |
|---------|-------------|
| **WIT contracts** (`wit/`) | `x07:web-ui@0.1.0` and `x07:web-ui@0.2.0` — JSON-bytes boundary with `init`/`step` dispatch/frame envelopes; the current device helpers expand the JSON contracts without a `0.3.0` WIT bump |
| **Stdlib package** (`packages/std-web-ui/0.2.4/`) | Canonical `std.web_ui.*` modules (tree, event, patch, effect, telemetry, builder-I/O helpers, and Tactics M0 audio/haptics device helpers) |
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
  - `x07 pkg add std-web-ui@0.2.4 --sync`
- Package publish line: `std-web-ui@0.2.4`
- [X07 Agent Quickstart](https://x07lang.org/docs/getting-started/agent-quickstart) — start here
- [X07 toolchain](https://github.com/x07lang/x07)
- [X07 website](https://x07lang.org)
- [WASM build tooling](https://github.com/x07lang/x07-wasm-backend) — `x07-wasm web-ui build/test/serve`

## License

Dual-licensed under [Apache 2.0](LICENSE-APACHE) and [MIT](LICENSE).
