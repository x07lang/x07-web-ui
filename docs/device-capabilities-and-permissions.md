# Device Capabilities And Permissions

`std-web-ui@0.2.1` separates two concerns:

- **Capabilities** are the build-time allowlist from `device.capabilities.json`.
- **Permissions** are the runtime OS/browser decision for a request.

The host checks capabilities first. If a reducer requests an operation that the target profile does not allow, the host returns a structured device result with `status: "unsupported"` and does not attempt the runtime operation.

If the capability is allowed, the host then queries or requests the runtime permission state. The current device helper surface normalizes permission state to:

- `granted`
- `denied`
- `prompt`
- `restricted`
- `unsupported`

Reducers should treat permission requests as asynchronous host work:

1. Emit a device effect.
2. Wait for the next reducer dispatch with `state.__x07_device.<family>.result`.
3. Branch on `result.status` and `result.payload`.

Host-generated lifecycle and connectivity events arrive as normal reducer events:

- `lifecycle.foreground`
- `lifecycle.background`
- `lifecycle.resume`
- `connectivity.online`
- `connectivity.offline`

Those events are independent of permission state and can be replayed deterministically from captured traces.
