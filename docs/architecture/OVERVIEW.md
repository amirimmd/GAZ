# Architecture Overview — GAZ HRMS

```mermaid
flowchart TB
  subgraph presentation [Presentation MVVM]
    Screens
    ViewModels[Riverpod Notifiers]
    Router[go_router]
  end

  subgraph domain [Domain]
    Entities
    UseCases
    RepoIfaces[Repository Interfaces]
  end

  subgraph data [Data]
    Repos[Repository Impl]
    Drift[Drift ORM]
    SQLCipher[(SQLCipher DB)]
    DocStore[Encrypted Doc Store]
  end

  subgraph security [Security Core]
    Argon2[Argon2id]
    AES[AES-256-GCM]
    Keys[KeyManager Secure Storage]
    Backup[BackupService Signed]
    Session[SessionController]
  end

  Screens --> ViewModels
  ViewModels --> UseCases
  UseCases --> RepoIfaces
  Repos --> RepoIfaces
  Repos --> Drift
  Drift --> SQLCipher
  Repos --> DocStore
  DocStore --> AES
  SQLCipher --> Keys
  Backup --> AES
  Backup --> Keys
  ViewModels --> Session
  UseCases --> Argon2
```

## Permission Enforcement Path

UI → PermissionGate / ViewModel check → UseCase → Repository (defense in depth)

## Offline-First

All primary workflows operate against local encrypted SQLite. No cloud dependency for MVP.
