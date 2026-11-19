# Phase 1 — Requirement Analysis

## 1.1 Project Identity

| Field | Value |
|-------|-------|
| Product Name | GAZ HRMS (سامانه مدیریت منابع انسانی) |
| Customer | Gas Company — Qaemshahr Branch, Iran |
| Classification | Internal Government Enterprise Software |
| Lifecycle | Long-term production (≥10 years) |
| Primary Platforms | Windows 10/11 Desktop, Android |
| Future Platforms | macOS, Linux, Web, iOS (same codebase) |
| Locale (MVP) | Persian (fa-IR), RTL |
| Secondary Locale | English (en-US), LTR — architecture ready |

## 1.2 Business Goals

1. Centralize all employee HR records for the branch.
2. Operate fully offline-first with encrypted local storage.
3. Enforce role-based access with fine-grained permissions.
4. Produce printable/exportable official reports.
5. Maintain immutable audit trails for compliance.
6. Protect PII with AES-256 (SQLCipher) and Argon2id credentials.
7. Enable secure encrypted backup/restore with integrity verification.

## 1.3 Stakeholders & Personas

| Persona | Needs |
|---------|-------|
| Administrator | Full system control, users, security, backup |
| HR Manager | Employee CRUD, evaluations, documents, reports |
| Operator | Data entry, document upload, limited edit |
| Viewer | Read-only search, view profiles, limited export |
| Custom Role | Permission matrix–defined capabilities |

## 1.4 Functional Requirements (FR)

### FR-AUTH — Authentication & Session
- FR-AUTH-01: Username/password login
- FR-AUTH-02: Remember me (secure token, not plaintext password)
- FR-AUTH-03: Forgot password (admin-assisted reset workflow)
- FR-AUTH-04: Auto-lock after configurable idle timeout
- FR-AUTH-05: Session timeout with re-authentication
- FR-AUTH-06: Brute-force lockout (progressive delay + account lock)
- FR-AUTH-07: Audit every login success/failure

### FR-USER — User & Role Management
- FR-USER-01: CRUD users
- FR-USER-02: Built-in roles: Administrator, HR Manager, Operator, Viewer
- FR-USER-03: Custom roles
- FR-USER-04: Permission matrix (each permission independently toggleable)
- FR-USER-05: Soft-disable users without deleting audit history

### FR-EMP — Employee Management
Complete employee profile covering:
- Personal identity & photo (3×4)
- Contact information
- Social networks
- Organization assignment
- Education
- Skills (unlimited)
- Interests & assessments
- Insurance
- Evaluations (unlimited yearly)
- Documents (unlimited)

### FR-DOC — Document Management
- Categories: employment orders, contracts, national card, birth certificate, education, certificates, awards, letters, insurance, other
- Types: PDF, Word, Excel, Image, ZIP, Video
- Metadata: title, category, description, tags, upload date, version
- Preview / download with permission checks
- Encrypted at rest

### FR-DATA — Data Entry & Bulk Ops
- Manual professional forms
- Excel/CSV import
- Duplicate detection (National ID, Employee Number)
- Validation rules
- Bulk edit / delete / mass update

### FR-SEARCH — Enterprise Search
- Search across all indexed fields
- Boolean: AND / OR / NOT
- Instant search + advanced filters
- Saved filters per user

### FR-RPT — Report Builder
- Select employees/departments/filters/columns
- Sort, group, header/footer, logo, fonts
- Paper size, orientation, watermark, page numbers
- Generated-by / generated-date stamps
- Export: PDF, Excel, CSV, PNG, Print

### FR-BKP — Backup & Restore
- Manual + automatic (daily/weekly/monthly)
- Encrypted, compressed, password-protected
- Digital signature verification
- Restore with integrity checks

### FR-AUD — Audit Log
Log: login, logout, insert, edit, delete, print, export, backup, restore, document view/download

### FR-SET — Settings
Organization logo/name, theme, language, backup, security, user defaults, report defaults

## 1.5 Non-Functional Requirements (NFR)

| ID | Category | Requirement |
|----|----------|-------------|
| NFR-01 | Performance | Cold start < 3s on mid-range Windows; list scroll 60fps for 5k employees |
| NFR-02 | Size | Installer < 80MB Windows; APK < 40MB (arm64) target |
| NFR-03 | Security | AES-256 SQLCipher DB; Argon2id passwords; encrypted docs/backups |
| NFR-04 | Offline | 100% core features offline |
| NFR-05 | Maintainability | Clean Architecture + MVVM + Riverpod + SOLID |
| NFR-06 | Scalability | Modular features; platform adapters for future targets |
| NFR-07 | Accessibility | Large typography; WCAG AA contrast targets |
| NFR-08 | Localization | Persian first; ARB-ready for English |
| NFR-09 | Reliability | Crash-safe writes; backup verification before overwrite |
| NFR-10 | Compliance | Full audit trail; no silent deletes |

## 1.6 Security Requirements

- Database unreadable without SQLCipher key
- Documents encrypted with AES-256-GCM
- Backups password-derived key + HMAC/signature
- Secure storage for master keys (Windows Credential / Android Keystore via flutter_secure_storage)
- Permission checks at domain use-case layer (not UI-only)
- Export gated by permission + audit
- Tamper detection on DB/backup via signature

## 1.7 Constraints

- Single Flutter codebase
- Local SQLite + SQLCipher (no mandatory cloud)
- Government network may be air-gapped
- Must support Windows desktop windowing and Android phones/tablets

## 1.8 Out of Scope (Phase 1 MVP Boundary)

- Multi-branch cloud sync
- Biometric attendance hardware integration
- Payroll calculation engine
- Public internet authentication (SSO/LDAP) — interfaces reserved

## 1.9 Success Criteria

1. All modules architected and scaffolded with production patterns
2. Encrypted DB boots and migrates
3. Auth with lockout and audit works
4. Employee CRUD + documents + search operational
5. Report PDF export works
6. Encrypted backup/restore verified
7. Unit + widget tests for core domains
8. Windows + Android build configs present
