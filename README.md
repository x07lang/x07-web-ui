# x07-web-ui

This repo tracks web-ui contracts and canonical assets for running an x07 UI reducer as a pure state machine.

The WIT packages live in `wit/`:

- `x07:web-ui@0.1.0`: JSON-bytes boundary (`UTF-8`) with `init` and `event`.

Phase 2 adds:

- `x07:web-ui@0.2.0`: JSON-bytes boundary (`UTF-8`) with `init` and `step` using dispatch/frame envelopes.

The canonical browser host lives in `host/` (not a registry package artifact).

The canonical X07 package exporting `std.web_ui.*` lives in `packages/std-web-ui/0.1.2/`.

Phase 3 adds a minimal HTTP effect contract:

- `std.web_ui.effects.http` emits `x07.web_ui.effect.http.request` effects.
- The host can execute these effects (against an API prefix) and capture `x07.app.trace@0.1.0`.

Examples:

- `examples/web_ui_counter/`
- `examples/web_ui_form/`
