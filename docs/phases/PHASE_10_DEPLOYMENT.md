# Phase 10 — Deployment

## Prerequisites

1. Install Flutter stable SDK and add `bin` to PATH
2. Enable Windows desktop: `flutter config --enable-windows-desktop`
3. Android SDK + accept licenses
4. Visual Studio 2022 with Desktop C++ workload (Windows builds)

## Bootstrap (first time in this repo)

```powershell
cd C:\Users\Mostafa\Desktop\GAZ
flutter create . --project-name gaz_hrms --org ir.gaz.qaemshahr
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d windows
# or
flutter run -d android
```

## Release Builds

```powershell
.\scripts\build_windows.ps1
.\scripts\build_android.ps1
```

## Distribution

- Windows: zip `build\windows\x64\runner\Release\` + VC++ redistributables
- Android: signed App Bundle / APK via keystore (store outside repo)

## Update Strategy

- Semantic versioning in `pubspec.yaml`
- Drift schema migrations for DB upgrades
- Encrypted backup before each production upgrade
- Signed release artifacts

## Air-gapped Notes

- Vendor Flutter offline cache / pub packages
- Bundle Vazirmatn fonts locally (disable Google Fonts fetch)
- Pre-download SQLCipher native binaries
