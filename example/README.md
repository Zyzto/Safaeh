# Safaeh example

Bilingual catalog of `package:safaeh` chrome (`example/lib/app.dart`,
`catalog.dart`, `pages.dart`). EN/AR + light/dark toggles. No
`mobile_scanner`, Riverpod, or `easy_localization`.

No platform folders are generated. `flutter run` on a device needs
`flutter create .` first.

## Analyze & test

```bash
cd example
flutter pub get
dart analyze
flutter test
```

`test/screenshots_test.dart` writes PNGs to [`../screenshots/`](../screenshots/)
for the package READMEs.

## Run on a device (optional)

```bash
cd example
flutter create . --project-name safaeh_example --platforms=android,ios
flutter pub get
flutter run
```

## What it shows

1. **Adaptive sheet** — phone bottom sheet ↔ tablet dialog
2. **Card picker** — `showSafaehPicker`
3. **Tile picker** — `showSafaehTilePicker` + header / disabled row
4. **Confirm / text input / sheet shell**
5. **Sheet morph** — nested 400 and 900 previews
6. **Sidenav** — rail and `asDrawer: true`
7. **Page index** — side rail and overlay
8. **Content-aligned chrome** — `safaehBandMetrics` + app bar + FAB
9. **Camera host / QR overlay / QR message**
10. **Language + theme toggles**
