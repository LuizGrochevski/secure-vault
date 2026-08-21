# Secure Vault

Local-first password vault em Flutter + Bloc.

## Features
- AES-256 encryption (flutter_secure_storage + encrypt)
- Biometric lock (local_auth)
- HaveIBeenPwned leak check (k-anonymity)
- Password generator (Random.secure)
- 100% offline storage

## Stack
- Flutter + Bloc only
- Clean architecture (domain / data / presentation)

## Run
```bash
flutter pub get
flutter run
```

## Structure
```
lib/
├── core/           # encryption, hibp, constants
├── features/
│   ├── auth/       # biometric login
│   ├── vault/      # CRUD senhas
│   └── generator/  # gerador
└── shared/         # theme
```

## Tests
```bash
flutter test
```
