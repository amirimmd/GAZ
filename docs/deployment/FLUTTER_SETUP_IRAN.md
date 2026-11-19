# Flutter Setup Note (Iran / Restricted Networks)

Cloning the Flutter repo works, but downloading the Dart SDK from Google storage
may fail with `AccessDenied` / "not available in your location".

## Options

1. Use a VPN or network that can reach `storage.googleapis.com`, then run:
   ```powershell
   C:\src\flutter\bin\flutter.bat doctor
   ```
2. Download a Flutter **Windows ZIP** from a mirror / SDK archive on another machine,
   copy to `C:\src\flutter`, and add `C:\src\flutter\bin` to PATH.
3. After Flutter works:
   ```powershell
   cd C:\Users\Mostafa\Desktop\GAZ
   flutter create . --project-name gaz_hrms --org ir.gaz.qaemshahr
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   flutter run -d windows
   ```

The GAZ HRMS source scaffold does **not** require Flutter to be present to review
architecture, security design, or Dart sources — only to compile and run.
