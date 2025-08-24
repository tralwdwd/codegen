# codegen

A TOTP code generator for Google Family Link, using a shared secret.

## Usage

1. Enter your Family Link shared secret in the app.
2. The app will display the current TOTP code and the time remaining until it expires.

## Build Instructions (Android)

1. Install dependencies:
   ```sh
   flutter pub get
   ```

2. Generate the Android launcher icon (optional, requires your icon at `assets/icon/icon.png`):
   ```sh
   flutter pub run flutter_launcher_icons
   ```

3. Build and run the app on Android:
   ```sh
   flutter run
   ```

---
