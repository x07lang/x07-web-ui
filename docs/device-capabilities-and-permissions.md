# Device Capabilities And Permissions

`std-web-ui@0.2.6` separates two concerns:

- **Capabilities** are the build-time allowlist from `device.capabilities.json`.
- **Permissions** are the runtime OS/browser decision for a request.

The host checks capabilities first. If a reducer requests an operation that the target profile does not allow, the host returns a structured device result with `status: "unsupported"` and does not attempt the runtime operation.

The builder-I/O surface uses these capability names:

- `audio.playback`
- `haptics.present`
- `clipboard.read_text`
- `clipboard.write_text`
- `files.pick`
- `files.pick_multiple`
- `files.save`
- `files.drop`
- `share.present`
- `camera.photo`
- `location.foreground`
- `notifications.local`

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

Device helpers use these reserved result paths:

- `state.__x07_device.audio.result`
- `state.__x07_device.haptics.result`
- `state.__x07_device.clipboard.result`
- `state.__x07_device.files.result`
- `state.__x07_device.share.result`

Host-generated lifecycle and connectivity events arrive as normal reducer events:

- `lifecycle.foreground`
- `lifecycle.background`
- `lifecycle.resume`
- `connectivity.online`
- `connectivity.offline`
- `files.drop`

Those events are independent of permission state and can be replayed deterministically from captured traces.
