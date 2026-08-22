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
  <a href="https://zyzto.github.io/Safaeh/"><img alt="Live demo" src="https://img.shields.io/badge/live%20demo-zyzto.github.io%2FSafaeh-8B6914?style=for-the-badge" /></a>
</p>

<p align="center">
  <a href="https://pub.dev/packages/safaeh"><img alt="pub.dev" src="https://img.shields.io/pub/v/safaeh.svg?style=flat-square&label=pub.dev&color=8B6914" /></a>
  <a href="https://github.com/Zyzto/Safaeh"><img alt="repo" src="https://img.shields.io/badge/github-Zyzto%2FSafaeh-C0C0C0?style=flat-square" /></a>
  <img alt="flutter" src="https://img.shields.io/badge/Flutter-%3E%3D3.11-C0C0C0?style=flat-square&logo=flutter&logoColor=white" />
  <a href="LICENSE"><img alt="license" src="https://img.shields.io/badge/license-MPL--2.0-8B6914?style=flat-square" /></a>
</p>

<p align="center">
  <strong><a href="https://zyzto.github.io/Safaeh/">Live demo</a></strong>
  — open the example catalog in the browser<br/>
  <a href="https://zyzto.github.io/Safaeh/">zyzto.github.io/Safaeh</a>
</p>

<p align="center">
  <a href="https://zyzto.github.io/Safaeh/">Live demo</a> ·
  <a href="#install">Install</a> ·
  <a href="#quick-start">Quick start</a> ·
  <a href="#widgets">Widgets</a> ·
  <a href="#features-at-a-glance">Features</a> ·
  <a href="#what-stays-in-the-host">Host app</a> ·
  <a href="#example">Example</a> ·
  <a href="CHANGELOG.md">Changelog</a> ·
  <a href="VERSIONING.md">Versioning</a> ·
  <a href="doc/host-integration.md">Host integration</a> ·
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

**Safaeh** is that chrome layer. Used in Hisab.

On pub.dev: [`safaeh`](https://pub.dev/packages/safaeh) · Repo: [Zyzto/Safaeh](https://github.com/Zyzto/Safaeh).

---

## Widgets

<p align="center">
  <a href="https://zyzto.github.io/Safaeh/">
    <img src="screenshots/picker.png" alt="Card picker — live demo" width="200" />
    <img src="screenshots/confirm.png" alt="Confirm sheet — live demo" width="200" />
    <img src="screenshots/option-tiles.png" alt="Option tiles — live demo" width="200" />
  </a>
</p>

<p align="center">
  <sub>Card picker · Confirm · Option tiles — <a href="https://zyzto.github.io/Safaeh/">try them in the live demo</a></sub>
</p>

<p align="center">
  <a href="https://zyzto.github.io/Safaeh/">
    <img src="screenshots/sidenav.png" alt="Sidenav rail — live demo" width="320" />
  </a>
</p>

Captured with [`widgets_to_image`](https://pub.dev/packages/widgets_to_image) (`cd example && flutter test test/widget_images_test.dart`).

---

## Features at a glance

| Area | What you get |
|------|----------------|
| **Sheets** | `showSafaeh` morphs phone sheet ↔ tablet dialog; `showSafaehPicker` / `SafaehOption` (cards, `enabled`); `showSafaehTilePicker` / `SafaehTileOption` (list rows, search); `showSafaehMultiTilePicker` (multi-select); `showSafaehConfirm`, `showSafaehTextInput`, `SafaehStatusBody`, `buildSafaehSheetShell`, `SafaehOptionList`, `SafaehOptionTile` |
| **Dialog** | `showSafaehDialog` centered panel with optional `railWidthOf` |
| **Theme** | `SafaehTheme` / `SafaehThemeData` for breakpoint, motion, radius, rail widths, camera compact height, `contentMaxWidth`; `copyWith` |
| **Motion** | `safaehResolvedMotion` zeros durations when animations are disabled |
| **Nav** | `SafaehSidenav` temporary drawer (`asDrawer: true`) or clipping rail; `SafaehFloatingNavBar` (same `SafaehSidenavDestination`) |
| **Page index** | `SafaehPageIndex`, overlay, `scrollToPageSection`, `safaehActivePageSectionId` (ids + keys only — no `.tr()` on scroll) |
| **Content** | `safaehBandMetrics`, `SafaehContentBand`, `SafaehEndAsideLayout`, `SafaehContentAlignedAppBar`, `SafaehContentAlignedFabLocation` |
| **Camera** | `showSafaehCameraSheet` / `SafaehCameraSheetHost` paper-roll compact ↔ full |
| **QR chrome** | `SafaehQrScannerOverlay` (optional host `preview`), `SafaehQrTopBar`, `SafaehQrMessageBody`, `SafaehQrFramePainter` |
| **RTL** | `safaehChevronEnd`, `safaehChevronStart`, `safaehArrowBack` (LTR glyphs; Material `matchTextDirection` mirrors them) |

**Core:** Flutter Material only. Preview, decode, copy, and navigation stay in the host.

---

## Install

```yaml
dependencies:
  safaeh: ^0.2.0
```

Or:

```bash
flutter pub add safaeh
```

Git tag pin (see [VERSIONING.md](VERSIONING.md)):

```yaml
dependencies:
  safaeh:
    git:
      url: https://github.com/Zyzto/Safaeh.git
      ref: v0.2.0
```

```dart
import 'package:safaeh/safaeh.dart';
```

Current version: **0.2.0**.

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
crosses `tabletBreakpoint`. Pass `phonePlacement: SafaehPhoneSheetPlacement.center`
to grow the phone sheet so the first content center aligns with the phone
center (still flush with the bottom).

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
if the phone cancel button is pressed, and `null` if dismissed (tablet close,
barrier, or system back). Treat only `ok == true` as confirmed.

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
narrow (`SafaehThemeData.isWide`). Hosts with a sibling shell rail keep their
own `leftOffset` / `bandWidth` math and use `SafaehEndAsideLayout`.

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

See [doc/host-integration.md](doc/host-integration.md).

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
`onDismiss`). Put `SafaehQrScannerOverlay` / `SafaehQrMessageBody` **inside**
that bottom panel — they are full-bleed overlays, not their own sheet.
Keep `mobile_scanner` in the app.

---

## What stays in the host

| Concern | Stays in the app |
|---------|------------------|
| Copy | `easy_localization`, `UserText`, `titleBuilder` |
| Routing | `go_router`, reserved rail width via `railWidthOf` |
| Camera | `mobile_scanner`, permissions, `SystemChrome` orientation lock |
| State | Riverpod / whatever the app already uses |
| Tiles | `UserText` + optional accent colors on `SafaehOptionTile` |

---

## UI inventory

**Sheets:** `showSafaeh`, `SafaehRouteOptions`, `showSafaehPicker`, `SafaehOption`, `SafaehOptionPickerBody`, `showSafaehTilePicker`, `showSafaehMultiTilePicker`, `SafaehTileOption`, `SafaehTilePickerBody`, `SafaehTileBuilder`, `showSafaehConfirm`, `SafaehConfirmSheet`, `showSafaehTextInput`, `SafaehTextInputSheet`, `SafaehStatusBody`, `buildSafaehSheetShell`, `SafaehOptionList`, `SafaehOptionTile`, `kSheetContentPadding`, `kSafaehSheetPadding`, `SafaehTitleBuilder`, `SafaehLabelBuilder`, `safaehTitleFromLabel`, `safaehPop`, `SafaehTransition`, `safaehFadeScale`, `safaehFade`, `SafaehPhoneSheetPlacement`, `safaehPhoneCenterSheetTop`

**Dialog:** `showSafaehDialog`

**Camera:** `showSafaehCameraSheet`, `SafaehCameraSheetHost`, `SafaehCameraSheet`, `SheetHandleBar`, `SheetHandleDrag`

**QR:** `SafaehQrScannerOverlay`, `SafaehQrTopBar`, `SafaehQrMessageBody`, `SafaehQrFramePainter`

**Shell:** `SafaehSidenav`, `SafaehSidenavDestination`, `SafaehSidenavProfile`, `SafaehSidenavAvatar`, `SafaehFloatingNavBar`, `SafaehPageIndex`, `SafaehPageIndexOverlay`, `scrollToPageSection`, `safaehActivePageSectionId`, `safaehBandMetrics`, `SafaehContentBand`, `SafaehEndAsideLayout`, `SafaehContentAlignedAppBar`, `SafaehContentAlignedFabLocation`

**Tokens:** `SafaehTheme`, `SafaehThemeData`, `SafaehThemeData.copyWith`, `safaehResolvedMotion`, `kSafaehCameraCompactHeightFraction`

**RTL:** `safaehChevronEnd`, `safaehChevronStart`, `safaehArrowBack`

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

**[Live demo — zyzto.github.io/Safaeh](https://zyzto.github.io/Safaeh/)**

The hosted catalog is the `example/` web build. CI deploys it after tests pass
on `main`.

A Riverpod-free catalog lives in [`example/`](example/) — same split as
[Edadat](https://github.com/Zyzto/Edadat): `catalog.dart` (en / ar / ja / zh / es),
`app.dart` (theme + home), and a vertical `SafaehContentBand` gallery of every
public API. Section titles open the standalone demo; wide bands use extra
columns on the same page. Language and theme toggles, no `mobile_scanner`.

The example is package-style (web only in-tree); analyze with:

```bash
cd example && flutter pub get && dart analyze --fatal-infos && flutter test
```

`example/test/widget_images_test.dart` writes widget PNGs to [`screenshots/`](screenshots/).

To run on a device, generate the other platforms (`flutter create . --platforms=android,ios` inside `example/`). Details: [example/README.md](example/README.md).

Package tests:

```bash
dart analyze --fatal-infos && flutter test
```

---

## Branding

The logo wordmark uses **[Baz](https://www.1001fonts.com/baz-font.html)** (Baz Light) — the same Arabic typeface as [Edadat](https://github.com/Zyzto/Edadat) and [Siglat](https://github.com/Zyzto/Siglat). The SVG outlines <span dir="rtl">صــفائح</span> (tatweel after <span dir="rtl">ص</span>) so GitHub renders without loading the font. Baz is not registered as a package font and the OTF is not shipped.

---

## Versioning

See [VERSIONING.md](VERSIONING.md) and [CHANGELOG.md](CHANGELOG.md). Tags are `vX.Y.Z` and must match `pubspec.yaml`.

---

## License

[MPL-2.0](LICENSE) — weak copyleft, commercial use allowed. Modified package
files stay under MPL; your app can remain closed-source.
