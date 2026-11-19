# Phase 9 — Testing Strategy

## Pyramid

1. **Unit** — domain use cases, crypto, national ID, search boolean filters
2. **Widget** — LoginScreen, EmployeeList empty/error states
3. **Integration** — auth login lockout, employee CRUD against temp DB

## Commands

```bash
flutter test
flutter test test/unit
flutter test --coverage
```

## Minimum Coverage Targets (enterprise)

| Area | Target |
|------|--------|
| Domain use cases | ≥ 85% |
| Security services | ≥ 90% |
| Repositories | ≥ 70% |
| Critical widgets | smoke + golden optional |

## CI Gates

- `flutter analyze` must be clean
- unit + widget tests must pass
- no secrets in repo
