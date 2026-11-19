# Phase 7 — Security Architecture

## Controls Implemented

| Control | Implementation |
|---------|----------------|
| DB encryption AES-256 | SQLCipher via `PRAGMA key` + KeyManager |
| Password hashing | Argon2id (PointyCastle) PHC encoded |
| Secure key storage | `flutter_secure_storage` (Windows Credential / Android Keystore) |
| Document encryption | AES-256-GCM + SHA-256 integrity (`DocumentCryptoStore`) |
| Backup encryption | Password-derived Argon2id key + AES-GCM |
| Backup signature | HMAC-SHA256 with install signature key |
| Session timeout | `SessionController` timers |
| Auto-lock | Idle timer → `/lock` |
| Brute force | failed_attempts + locked_until |
| Permissions | Domain-checked permission codes |
| Audit | Append-only `audit_logs` |
| Export control | PermissionCodes.employeesExport / reportsExport |

## Threat Model (summary)

1. Offline DB theft → mitigated by SQLCipher
2. Document folder copy → mitigated by AES-GCM + hash
3. Backup tampering → mitigated by HMAC + content hash
4. Credential stuffing → lockout + Argon2id cost
5. Privilege escalation via UI → use-case permission checks required

## Hardening Checklist (ops)

- [ ] Change default admin password on first login (enforced by flag)
- [ ] Restrict Windows folder ACLs on Application Support
- [ ] Disable USB autorun on kiosk PCs
- [ ] Schedule encrypted backups to offline media
- [ ] Periodic audit log review
