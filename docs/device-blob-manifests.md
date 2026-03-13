# Device Blob Manifests

The current device helper surface keeps binary payloads out of reducer state.

The host stores captured or imported bytes in a host-owned blob store and injects only a manifest into reducer state. The standard shape is:

```json
{
  "handle": "blob:sha256:<hex>",
  "sha256": "<hex>",
  "mime": "image/jpeg",
  "byte_size": 12345,
  "created_at_ms": 1770000000000,
  "source": "camera",
  "local_state": "present"
}
```

Rules:

- Reducers should persist only the manifest.
- Device effects never include raw file bytes in reducer-visible JSON.
- `blobs.stat` and `blobs.delete` operate on the manifest `handle`.
- Missing or deleted content is represented through `local_state`, not by mutating older manifests in place.

The browser host uses a host-owned blob store implementation and the device host consumes the same reducer-visible manifest contract, so replay fixtures stay stable across targets.

For file import/export flows, `std-web-ui@0.2.6` normalizes reducer-visible file items as:

```json
{
  "name": "report.pdf",
  "mime": "application/pdf",
  "byte_size": 12345,
  "last_modified_ms": 1770000000000,
  "blob": {
    "handle": "blob:sha256:<hex>",
    "sha256": "<hex>",
    "mime": "application/pdf",
    "byte_size": 12345,
    "created_at_ms": 1770000000000,
    "source": "files.pick",
    "local_state": "present"
  }
}
```

Rules for file items:

- Pick and drop events expose `payload.items[]` or `event.items[]`.
- Save/export helpers reuse the same `items[]` array but omit `blob` when the browser only reports the saved file metadata.
- Reducers should persist `blob.handle` or the surrounding item metadata instead of raw bytes.
