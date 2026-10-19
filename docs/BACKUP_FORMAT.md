# Backup file format

Comma backups (`.comma` files) are UTF-8 JSON. This document lets anyone recover their data without the app. The implementation is in `lib/data/backup/backup.dart`.

## Unencrypted backup

```json
{
  "format": "comma-backup",
  "version": 4,
  "exportedAt": "2026-10-19T14:03:00.000Z",
  "dayLogs": [
    {
      "date": "2026-10-01",
      "flow": "heavy",
      "mucus": "eggWhite",
      "bbt": 36.45,
      "bbtDisturbed": true,
      "lhTest": "positive",
      "pregnancyTest": "negative",
      "note": "free text",
      "products": 4,
      "energy": "low",
      "sleepHours": 7.5,
      "weightKg": 61.2
    }
  ],
  "symptomEntries": [
    { "date": "2026-10-01", "symptom": "cramps", "severity": 2 }
  ],
  "sexEntries": [
    { "date": "2026-10-14", "kind": "partnered", "minuteOfDay": 1350, "protection": "condom", "orgasm": true, "note": "free text" }
  ],
  "customTags": { "custom.migraine_meds": "Migraine meds" },
  "settings": { "default_cycle_length": "28" }
}
```

- `date` is a calendar day (`YYYY-MM-DD`).
- Only `date` and `flow` are always present on a day log. Other fields are left out when empty.
- `flow` is one of: `none`, `spotting`, `light`, `medium`, `heavy`.
- `mucus` is one of: `dry`, `sticky`, `creamy`, `watery`, `eggWhite`.
- `lhTest` and `pregnancyTest` are one of: `negative`, `positive`, `peak`.
- `sexEntries` holds one object per encounter. Several can share a date, and only `date` is required.
  - `kind` is `partnered` or `solo` (masturbation). If it's missing, the entry is `partnered`.
  - `minuteOfDay` is minutes after midnight (1350 = 22:30).
  - `protection` is one of: `unprotected`, `condom`, `withdrawal`, `otherProtection`. It only applies to partnered entries.
- `bbt` is in °C, and `weightKg` is in kilograms. The app converts them for display.
- `products` is how many pads, tampons and so on were used that day.
- `energy` is one of: `low`, `normal`, `high`.
- `customTags` maps tag keys to their labels. A tag logged on a day shows up in `symptomEntries`, with the tag key as its `symptom`.
- `symptom` keys are listed in `lib/domain/models/symptoms.dart`. Moods start with `mood.`, and custom entries start with `custom.`.

## Encrypted backup

```json
{
  "format": "comma-backup-encrypted",
  "version": 1,
  "kdf": { "algorithm": "pbkdf2-hmac-sha256", "iterations": 600000, "salt": "<base64, 16 bytes>" },
  "cipher": { "algorithm": "aes-256-gcm", "nonce": "<base64, 12 bytes>" },
  "data": "<base64>"
}
```

To decrypt:
1. Derive a 32-byte key with PBKDF2-HMAC-SHA256 from the UTF-8 password, using `salt` and `iterations`.
2. `data` is the ciphertext followed by the 16-byte GCM authentication tag. There is no associated data.
3. Decrypting with AES-256-GCM gives the unencrypted backup JSON shown above.

Example in Python (`pip install cryptography`):

```python
import base64, hashlib, json, sys
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

outer = json.load(open(sys.argv[1]))
key = hashlib.pbkdf2_hmac("sha256", sys.argv[2].encode(),
                          base64.b64decode(outer["kdf"]["salt"]),
                          outer["kdf"]["iterations"], 32)
plain = AESGCM(key).decrypt(base64.b64decode(outer["cipher"]["nonce"]),
                            base64.b64decode(outer["data"]), None)
print(json.dumps(json.loads(plain), indent=2))
```

## Versioning

| Version | Change |
|---|---|
| 1 | Initial format. Each day log had an optional `sex` value: `none`, `protected` or `unprotected`. |
| 2 | Sex moved to `sexEntries`, allowing several per day. Comma still imports version 1 files. |
| 3 | Added `kind` to sex entries (`partnered` or `solo`). Older versions of the app refuse these files, so solo entries are never imported as partnered. |
| 4 | Added `products`, `energy`, `sleepHours` and `weightKg` to day logs, and `customTags`. |

`version` goes up only when an older app couldn't read the new file correctly. The app refuses to import backups with a newer version than it understands, instead of losing data.
