# Phase 6 — Flutter Project

## Status

Production scaffold created with:

- Clean Architecture + MVVM + Riverpod
- Drift schema + SQLCipher connection bootstrap
- Auth, Employee, Search, Reports, Backup, Users, Audit, Settings screens
- Security services (Argon2id, AES-GCM, KeyManager, BackupService)
- Report builder PDF engine
- go_router navigation with auth redirect

## Required local steps after Flutter install

```powershell
flutter create . --project-name gaz_hrms --org ir.gaz.qaemshahr
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

`build_runner` generates `lib/data/local/database/app_database.g.dart`.

## Default credentials

| User | Password | Note |
|------|----------|------|
| admin | Admin@ChangeMe1 | Must change on first login |

## Module completion matrix

| Module | Domain | Data | UI |
|--------|--------|------|----|
| Login / Session | Done | Done | Done |
| Users / Permissions | Seeded | Partial UI | Matrix UI |
| Employees | Done | Done | List + Detail tabs |
| Documents | Entity + crypto store | Pending full repo | Tab placeholder |
| Search AND/OR/NOT | Query model | Done | Done |
| Reports | PDF builder | — | Builder UI |
| Backup | Service | Jobs table | UI |
| Audit | Entity + repo iface | Auth writes | Viewer UI |
| Settings | Providers | Seed keys | Done |
