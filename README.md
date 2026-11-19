# GAZ HRMS

سامانه مدیریت منابع انسانی — شرکت گاز، شعبه قائم‌شهر

Enterprise Flutter HRMS (Windows + Android), offline-first, SQLCipher-encrypted.

## Architecture

Clean Architecture · MVVM · Repository · Riverpod · Drift · SQLCipher · Argon2id · AES-256-GCM

## Documentation

All ten phases are under `docs/phases/`:

1. Requirements  
2. Architecture  
3. Database  
4. Folder Structure  
5. UI Design  
6. Flutter Project  
7. Security  
8. Reporting  
9. Testing  
10. Deployment  

## Quick start

Flutter SDK is required on this machine.

```powershell
# 1) Install Flutter stable and add to PATH, then:
cd C:\Users\Mostafa\Desktop\GAZ
flutter create . --project-name gaz_hrms --org ir.gaz.qaemshahr
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d windows
```

### Default admin

- Username: `admin`
- Password: `Admin@ChangeMe1` (forced change on first login)

## Security highlights

- Encrypted SQLite (SQLCipher)
- Argon2id password hashing
- AES-256-GCM document & backup encryption
- HMAC backup signatures
- Session timeout + auto-lock + brute-force lockout
- Append-only audit log
- Fine-grained permission matrix

## Platforms

Primary: Windows 10/11, Android  
Ready for later: macOS, Linux, Web, iOS (same codebase)
