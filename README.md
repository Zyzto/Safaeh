<!-- markdownlint-disable MD033 MD060 -->

<p align="center">
  <img src="assets/safaeh-logo.svg" alt="Safaeh" width="220" />
</p>

<h1 align="center">Safaeh - صفائح</h1>

<p align="center">
  <strong>safaeh</strong><br/>
  Adaptive sheets, camera / QR chrome, page index, and sidenav for Flutter —<br/>
  host app keeps i18n, routing, and the camera plugin.
</p>

<p align="center">
  <a href="https://github.com/Zyzto/Safaeh"><img alt="repo" src="https://img.shields.io/badge/github-Zyzto%2FSafaeh-C0C0C0?style=flat-square" /></a>
  <img alt="flutter" src="https://img.shields.io/badge/Flutter-%3E%3D3.11-C0C0C0?style=flat-square&logo=flutter&logoColor=white" />
  <a href="LICENSE"><img alt="license" src="https://img.shields.io/badge/license-MPL--2.0-8B6914?style=flat-square" /></a>
  <img alt="status" src="https://img.shields.io/badge/publish-git%20tag-2E7D32?style=flat-square" />
</p>

<p align="center">
  <a href="#install">Install</a> ·
  <a href="#quick-start">Quick start</a> ·
  <a href="#screenshots">Screenshots</a> ·
  <a href="#features-at-a-glance">Features</a> ·
  <a href="#what-stays-in-the-host">Host app</a> ·
  <a href="#example">Example</a> ·
  <a href="https://zyzto.github.io/Safaeh/">Live demo</a> ·
  <a href="CHANGELOG.md">Changelog</a> ·
  <a href="VERSIONING.md">Versioning</a> ·
  <a href="docs/host-integration.md">Host integration</a> ·
  <a href="README.ar.md">العربية</a>
</p>

<p align="center">
  The name <strong>safaeh</strong> comes from Arabic
  <span dir="rtl"><strong>صفائح</strong></span>
  (<em>ṣafāʾiḥ</em>): sheets / plates —
  plural of <span dir="rtl"><em>صفيحة</em></span> (<em>ṣafīḥa</em>).
</p>

---

## Why

Flutter apps accumulate one-off bottom sheets, dialogs, rails, and camera
overlays. Then you need:

- the same route to be a phone sheet and a tablet dialog, and morph when the
  viewport crosses the breakpoint
- chrome that honors `MediaQuery.disableAnimationsOf`
- no `easy_localization`, Riverpod, `go_router`, or `mobile_scanner` inside the
  package

**Safaeh** is that chrome layer. Hisab wraps it with `UserText`, rail width,
permissions, and the live camera / QR decoder.

Repo: [Zyzto/Safaeh](https://github.com/Zyzto/Safaeh). Not published to pub.dev.
Hisab is the reference host.

---

## Screenshots

<p align="center">
  <img src="screenshots/catalog-en.png" alt="Safaeh catalog (English)" width="180" />
  <img src="screenshots/catalog-ar.png" alt="Safaeh catalog (Arabic)" width="180" />
  <img src="screenshots/picker-en.png" alt="Card picker" width="180" />
</p>

<p align="center">
  <sub>English catalog · Arabic RTL · Card picker</sub>
</p>

<details>
<summary>Dark theme and more chrome</summary>

<p align="center">
  <img src="screenshots/catalog-en-dark.png" alt="Safaeh catalog, dark (English)" width="140" />
  <img src="screenshots/catalog-ar-dark.png" alt="Safaeh catalog, dark (Arabic)" width="140" />
  <img src="screenshots/sidenav-en.png" alt="Sidenav rail" width="140" />
  <img src="screenshots/page-index-en.png" alt="Page index overlay" width="140" />
</p>

<p align="center">
  <sub>English dark · Arabic dark · Sidenav · Page index</sub>
</p>

</details>

---

## Features at a glance

| Area | What you get |
|------|----------------|
| **Sheets** | `showSafaeh` morphs phone sheet ↔ tablet dialog; `showSafaehPicker` / `SafaehOption` (cards, `enabled`); `showSafaehTilePicker` / `SafaehTileOption` (list rows, `header` / `leading` / `enabled`); `showSafaehConfirm`, `showSafaehTextInput`, `buildSafaehSheetShell`, `SafaehOptionList`, `SafaehOptionTile` |
| **Dialog** | `showSafaehDialog` centered panel with optional `railWidthOf` |
| **Theme** | `SafaehTheme` / `SafaehThemeData` for breakpoint, motion, radius, rail widths, camera compact height, `contentMaxWidth`; `copyWith` |
| **Motion** | `safaehResolvedMotion` zeros durations when animations are disabled |
| **Nav** | `SafaehSidenav` temporary drawer (`asDrawer: true`) or clipping rail; `SafaehFloatingNavBar` (same `SafaehSidenavDestination`) |
| **Page index** | `SafaehPageIndex`, overlay, `scrollToPageSection`, `safaehActivePageSectionId` (ids + keys only — no `.tr()` on scroll) |
| **Content** | `safaehBandMetrics`, `SafaehContentBand`, `SafaehEndAsideLayout`, `SafaehContentAlignedAppBar`, `SafaehContentAlignedFabLocation` |
| **Camera** | `showSafaehCameraSheet` / `SafaehCameraSheetHost` paper-roll compact ↔ full |
| **QR chrome** | `SafaehQrScannerOverlay`, `SafaehQrTopBar`, `SafaehQrMessageBody`, `SafaehQrFramePainter` |

**Core:** Flutter Material only. Preview, decode, copy, and navigation stay in the host.

---

## Install

Git tag (not `main`):

```yaml
dependencies:
  safaeh:
    git:
      url: https://github.com/Zyzto/Safaeh.git
      ref: v0.1.0
```

```dart
import 'package:safaeh/safaeh.dart';
```

Current version: **0.1.0**. See [CHANGELOG.md](CHANGELOG.md) and
[VERSIONING.md](VERSIONING.md). `publish_to: none` — not on pub.dev.

---

## Quick start

### 1. Wrap the app

```dart
SafaehTheme(
  data: const SafaehThemeData(
    tabletBreakpoint: 600,
    dialogMaxWidth: 560,
  ),
  child: MaterialApp(
    home: const MyHome(),
  ),
);
```

Call-sites can still override breakpoint, motion, and transitions.

### 2. Adaptive sheet

```dart
await showSafaeh<void>(
  context: context,
  title: 'Rename',
  titleBuilder: (context, style) => Text('Rename', style: style),
  child: const TextField(),
);
```

Phone: bottom sheet. Tablet+: centered dialog. The same route morphs when width
crosses `tabletBreakpoint`.

### 3. Option picker

```dart
final choice = await showSafaehPicker<int>(
  context: context,
  title: 'How to settle',
  selected: 1,
  options: const [
    SafaehOption(
      value: 1,
      label: 'Minimal',
      subtitle: 'Fewest transfers',
      icon: Icons.bolt_outlined,
    ),
  ],
);
```

The in-body title hides when the viewport is wide (header title only).
`SafaehOption.enabled` greys the card and ignores taps.

### 4. Tile picker (list rows)

```dart
final mode = await showSafaehTilePicker<String>(
  context: context,
  title: 'Import mode',
  titleBuilder: (context, style) => Text('Import mode', style: style),
  header: const Text('12 new · 3 updated'),
  selected: 'add',
  options: const [
    SafaehTileOption(
      value: 'add',
      label: 'Add copies',
      subtitle: 'Keeps existing data',
      leading: Icon(Icons.add_circle_outline),
    ),
    SafaehTileOption(
      value: 'replace',
      label: 'Replace',
      enabled: false,
    ),
  ],
);
```

Uses `SafaehOptionList` + `SafaehOptionTile`. Hosts that already wrap
`showSafaeh` can mount `SafaehTilePickerBody` as the child. Same knobs as
other `showSafaeh*` helpers (`railWidthOf`, `motion`, …).

### 5. Confirm and text input

Host passes every label. Phone shows cancel in the action row; tablet uses the
sheet close control. `showSafaehConfirm` returns `true` if confirmed, `false`
if the phone cancel button is pressed, and `null` if dismissed (tablet close
or barrier). Treat only `ok == true` as confirmed.

```dart
final ok = await showSafaehConfirm(
  context: context,
  title: 'Delete item',
  content: 'This cannot be undone.',
  confirmLabel: 'Delete',
  cancelLabel: 'Cancel',
  isDestructive: true,
  titleBuilder: (context, style) => Text('Delete item', style: style),
);

final name = await showSafaehTextInput(
  context: context,
  title: 'Tag name',
  doneLabel: 'Done',
  cancelLabel: 'Cancel',
  titleBuilder: (context, style) => Text('Tag name', style: style),
);
```

### 6. Centered dialog

```dart
await showSafaehDialog<void>(
  context: context,
  railWidthOf: (context) => 0,
  builder: (context) => const Card(child: Text('Hello')),
);
```

### 7. Floating nav and content band

```dart
SafaehFloatingNavBar(
  selectedIndex: index,
  onDestinationSelected: (i) => setState(() => index = i),
  destinations: const [
    SafaehSidenavDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
  ],
);

SafaehContentBand(
  aside: const Text('On this page'),
  child: body,
);
```

`SafaehContentBand` centers from incoming constraints and hides `aside` when
narrow (`SafaehThemeData.isWide`). Hosts with a sibling shell rail (Hisab)
keep their own `leftOffset` / `bandWidth` math and use `SafaehEndAsideLayout`.

Band metrics for other apps (app bar, FAB, aside):

```dart
final metrics = safaehBandMetrics(
  contentAreaWidth: constraints.maxWidth,
  maxWidth: 600,
);

SafaehContentAlignedAppBar(
  leftOffset: metrics.leftOffset,
  bandWidth: metrics.bandWidth,
  title: const Text('Title'),
);

SafaehContentAlignedFabLocation.resolve(
  leftOffset: metrics.leftOffset,
  bandWidth: metrics.bandWidth,
  endFree: metrics.endFree,
  textDirection: Directionality.of(context),
);
```

See [docs/host-integration.md](docs/host-integration.md).

### 8. Camera / QR chrome

```dart
await showSafaehCameraSheet<void>(
  context: context,
  builder: (context, sheet) => MyPreview(
    expanded: sheet.expanded,
    onToggle: sheet.toggleExpanded,
    onClose: sheet.dismiss,
  ),
);
```

Embed on a route with `SafaehCameraSheetHost` (omit `openAnimation`, pass
`onDismiss`). Overlay a scanner with `SafaehQrScannerOverlay` — keep
`mobile_scanner` in the app.

---

## What stays in the host

| Concern | Stays in the app |
|---------|------------------|
| Copy | `easy_localization`, `UserText`, `titleBuilder` |
| Routing | `go_router`, reserved rail width via `railWidthOf` |
| Camera | `mobile_scanner`, permissions, `SystemChrome` orientation lock |
| State | Riverpod / whatever the app already uses |
| Tiles | UserText + optional accent colors on `SafaehOptionTile` (`SheetOptionTile` in Hisab) |

Hisab still passes `shell_nav_*` keys into `SafaehSidenav` so existing widget
tests stay green.

---

## UI inventory

**Sheets:** `showSafaeh`, `showSafaehPicker`, `SafaehOption`, `showSafaehTilePicker`, `SafaehTileOption`, `SafaehTilePickerBody`, `SafaehTileBuilder`, `showSafaehConfirm`, `SafaehConfirmSheet`, `showSafaehTextInput`, `SafaehTextInputSheet`, `buildSafaehSheetShell`, `SafaehOptionList`, `SafaehOptionTile`, `kSheetContentPadding`, `kSafaehSheetPadding`, `SafaehTitleBuilder`, `SafaehTransition`

**Dialog:** `showSafaehDialog`

**Camera:** `showSafaehCameraSheet`, `SafaehCameraSheetHost`, `SafaehCameraSheet`, `SheetHandleBar`, `SheetHandleDrag`

**QR:** `SafaehQrScannerOverlay`, `SafaehQrTopBar`, `SafaehQrMessageBody`, `SafaehQrFramePainter`

**Shell:** `SafaehSidenav`, `SafaehSidenavDestination`, `SafaehSidenavProfile`, `SafaehFloatingNavBar`, `SafaehPageIndex`, `SafaehPageIndexOverlay`, `scrollToPageSection`, `safaehActivePageSectionId`, `safaehBandMetrics`, `SafaehContentBand`, `SafaehEndAsideLayout`, `SafaehContentAlignedAppBar`, `SafaehContentAlignedFabLocation`

**Tokens:** `SafaehTheme`, `SafaehThemeData`, `SafaehThemeData.copyWith`, `safaehResolvedMotion`, `kSafaehCameraCompactHeightFraction`

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│         Host app (i18n, GoRouter, camera, UserText)         │
└─────────────────────────────┬───────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────┐
│                      SafaehTheme                             │
│   breakpoint · motion · radius · rail · camera fraction     │
└─────────────────────────────┬───────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────┐
│  showSafaeh / picker / confirm / text / dialog              │
│  SafaehSidenav · floating nav · page index · content band   │
│  camera sheet host · QR overlay chrome                      │
└─────────────────────────────┬───────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────┐
│              Flutter Material (no Riverpod)                 │
└─────────────────────────────────────────────────────────────┘
```

---

## Example

A Riverpod-free catalog lives in [`example/`](example/) — same split as
[Edadat](https://github.com/Zyzto/Edadat): `catalog.dart` (EN/AR copy),
`app.dart` (theme + home), and a vertical gallery of every public API.
Language and theme toggles, no `mobile_scanner`.

Live web build: [zyzto.github.io/Safaeh](https://zyzto.github.io/Safaeh/)

```bash
cd example && dart analyze && flutter test
```

`example/test/screenshots_test.dart` writes PNGs to [`screenshots/`](screenshots/).

Hisab is the reference host: it installs `SafaehTheme`, wraps `showSafaeh` as
`showResponsiveSheet`, and the receipt camera / invite scanner wrap
`showSafaehCameraSheet`.

Package tests:

```bash
dart analyze && flutter test
```

---

## Branding

The logo wordmark uses **[Baz](https://www.1001fonts.com/baz-font.html)** (Baz Light) — the same Arabic typeface as [Edadat](https://github.com/Zyzto/Edadat) and [Siglat](https://github.com/Zyzto/Siglat). The SVG outlines <span dir="rtl">صــفائح</span> (tatweel after <span dir="rtl">ص</span>) so GitHub renders without loading the font. Baz is not registered as a package font and the OTF is not shipped.

---

## License

[MPL-2.0](LICENSE) — weak copyleft, commercial use allowed. Modified package
files stay under MPL; your app can remain closed-source.

Standalone repo (`publish_to: none`). Hisab as a larger work stays AGPL and
depends on a git tag.
