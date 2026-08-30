# Security model — Secure Vault

Educational / experimental project. Not a production password manager until independent review.

## Current model (v2 ciphertext)

| Component | Detail |
|-----------|--------|
| Cipher | AES-256-GCM (authenticated encryption) |
| Key | 32-byte key from `Key.fromSecureRandom`, stored in `FlutterSecureStorage` (platform keystore / keychain) |
| IV / nonce | **12 random bytes per encryption** (not reused) |
| Payload format | `v2:<base64(iv)>:<base64(ciphertext)>` |
| Auth unlock | Biometrics via `local_auth` (`biometricOnly: true`) |
| Leak check | Have I Been Pwned range API (k-anonymity: only SHA-1 prefix leaves the device) |
| Password generator | `dart:math` `Random.secure()` (CSPRNG) |

## What this does **not** provide yet

- Master password + memory-hard KDF (Argon2id / PBKDF2) — key is only as strong as device secure storage + biometric gate
- PIN fallback when biometrics are unavailable
- Per-field encryption (whole vault JSON is one blob)
- Secure memory zeroization of plaintext passwords
- Formal audit

## Legacy (pre-v2)

Older builds used a **single fixed IV** stored alongside the key and the package default AES mode (typically CBC without authentication). On load, the repository attempts one-shot legacy decrypt and re-saves as v2. If migration fails, clear app data and recreate entries.

## Threat notes

- Rooted/jailbroken device or compromised keystore can expose the AES key.
- Without a user-held master password, offline attacker with keystore access wins.
- GCM provides integrity; tampering with ciphertext should fail decryption.

## Roadmap (crypto)

1. ~~Per-op IV + AES-GCM~~ (done in v2)
2. Master password + Argon2id/PBKDF2 deriving the vault key
3. Biometric unlock of wrapped key (not the only factor)
4. Optional PIN fallback
5. External security review before any real-world use of high-value credentials
