# Phase 2 — Software Architecture

## 2.1 Architectural Style

**Clean Architecture** layered with **MVVM** in presentation and **Repository Pattern** for data access.

```
┌─────────────────────────────────────────────────────────┐
│                 Presentation (MVVM)                      │
│  Screens · Widgets · ViewModels · Riverpod Providers     │
└──────────────────────────┬──────────────────────────────┘
                           │ depends on
┌──────────────────────────▼──────────────────────────────┐
│                      Domain                              │
│  Entities · UseCases · Repository Interfaces · Enums     │
└──────────────────────────┬──────────────────────────────┘
                           │ implemented by
┌──────────────────────────▼──────────────────────────────┐
│                       Data                               │
│  Drift DB · DAOs · Mappers · Repository Implementations  │
└─────────────────────────────────────────────────────────┘
           ▲
           │ Cross-cutting
┌──────────┴──────────────────────────────────────────────┐
│  Core: Security · Theme · DI · Errors · Utils · i18n     │
└─────────────────────────────────────────────────────────┘
```

### Dependency Rule
Domain has **zero** Flutter/Drift dependencies. Presentation depends on Domain. Data depends on Domain.

## 2.2 MVVM Mapping

| Layer | Artifact | Responsibility |
|-------|----------|----------------|
| View | `*Screen`, widgets | Render UI, forward intents |
| ViewModel | Riverpod `Notifier` / `AsyncNotifier` | Hold UI state, call use cases |
| Model | Domain entities + use cases | Business rules |

## 2.3 Dependency Injection

Riverpod is the DI container:
- `Provider` / `NotifierProvider` for services & VMs
- `DatabaseProvider` for Drift
- Override in tests via `ProviderContainer`

## 2.4 Module Map (Feature Packages)

Logical modules under `lib/`:

| Module | Package Path | Owns |
|--------|--------------|------|
| Auth | domain/usecases/auth, presentation/screens/login | Login, session, lock |
| Users | domain/usecases/user | Roles, permissions |
| Employees | domain/usecases/employee | Full employee aggregate |
| Documents | domain/usecases/document | Encrypted file store |
| Search | presentation/screens/search | Query DSL |
| Reports | domain/usecases/report | Builder + exporters |
| Backup | domain/usecases/backup | Encrypt/sign/restore |
| Audit | domain/usecases/audit | Append-only logs |
| Settings | domain/usecases/settings | Org/theme/security |

## 2.5 Platform Abstraction

```
core/platform/
  file_picker_adapter.dart
  path_provider_adapter.dart
  secure_storage_adapter.dart
  window_manager_adapter.dart   // desktop only
```

Future Web/iOS/macOS/Linux = new adapters, same contracts.

## 2.6 State Management Conventions

- UI state: immutable freezed-style classes (manual/`equatable`)
- Side effects: use cases return `Result<T, Failure>`
- Navigation: `go_router` with auth redirect guard
- Forms: reactive validation in ViewModel

## 2.7 Error Handling

```
Failure (sealed)
  ├── AuthFailure
  ├── ValidationFailure
  ├── PermissionFailure
  ├── NotFoundFailure
  ├── ConflictFailure      // duplicates
  ├── SecurityFailure
  ├── StorageFailure
  └── UnexpectedFailure
```

## 2.8 Navigation Graph

```
/login
/lock
/app (shell)
  /dashboard
  /employees
  /employees/:id
  /employees/:id/documents
  /search
  /reports
  /reports/builder
  /backup
  /users
  /audit
  /settings
```

## 2.9 Scalability Strategy

1. Feature folders ready for `melos` multi-package split later
2. Drift migrations versioned (`schemaVersion`)
3. Permission codes as stable string constants (never renumber silently)
4. Export/import DTOs versioned (`schemaVersion` in JSON/Excel headers)

## 2.10 Quality Gates

- SOLID across domain/data/presentation
- DRY via shared form widgets & validators
- KISS: no premature microservices
- Unit tests for use cases & security
- Widget tests for critical screens
