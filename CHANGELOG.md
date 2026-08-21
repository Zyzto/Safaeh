# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

Tags are `vX.Y.Z` and must match `version:` in [`pubspec.yaml`](pubspec.yaml).
See [VERSIONING.md](VERSIONING.md).

## [Unreleased]

### Fixed
- Phone sheet bodies no longer apply status-bar `SafeArea` (`buildSafaehSheetShell`,
  `SafaehTilePickerBody`).
- Page-index active marker uses `BorderDirectional.start` in RTL.
- Sidenav collapse chevron follows `TextDirection`.
- Phone dismiss drag is limited to the sheet handle so lists can scroll.
- Sheet actions and confirm can take keyboard focus.
- `scrollToPageSection` honors `MediaQuery.disableAnimationsOf`.

### Changed
- Baz Light is no longer registered as a package font, and
  `assets/fonts/baz-Light.otf` is not shipped (SVG outlines only).
- `SafaehSidenavDestination` accepts optional `labelBuilder`.

### Docs
- Confirm result (`true` / `false` / `null`) is spelled out in both READMEs.

## [0.1.0] - 2026-08-21

First standalone release (extracted from Hisab). Host apps keep i18n,
routing, Riverpod, and camera plugins.

### Added
- **Sheets:** `showSafaeh` (phone sheet ↔ tablet dialog morph),
  `showSafaehPicker` / `SafaehOption` (card picker, `enabled`),
  `showSafaehTilePicker` / `SafaehTileOption` / `SafaehTilePickerBody`
  (list-row picker, optional `header` / `leading` / `enabled`),
  `showSafaehConfirm` / `SafaehConfirmSheet`,
  `showSafaehTextInput` / `SafaehTextInputSheet`,
  `buildSafaehSheetShell`, `SafaehOptionList`, `SafaehOptionTile`,
  `kSheetContentPadding`.
- **Dialog:** `showSafaehDialog` with optional `railWidthOf`.
- **Camera / QR chrome:** `showSafaehCameraSheet`, `SafaehCameraSheetHost`,
  `SafaehQrScannerOverlay`, `SafaehQrTopBar`, `SafaehQrMessageBody`,
  `SafaehQrFramePainter`, `SheetHandleBar`, `SheetHandleDrag`.
- **Nav:** `SafaehSidenav` (rail or `asDrawer: true`),
  `SafaehSidenavDestination`, `SafaehSidenavProfile`,
  `SafaehFloatingNavBar`.
- **Page index:** `SafaehPageIndex`, `SafaehPageIndexOverlay`,
  `scrollToPageSection`, `safaehActivePageSectionId`.
- **Content layout:** `SafaehContentBand`, `safaehBandMetrics`,
  `SafaehEndAsideLayout`, `SafaehContentAlignedAppBar`,
  `SafaehContentAlignedFabLocation`.
- **Tokens:** `SafaehTheme` / `SafaehThemeData` / `copyWith`,
  `safaehResolvedMotion` (zeros when `MediaQuery.disableAnimationsOf`).
- **Branding:** Baz Light vendored at `assets/fonts/baz-Light.otf`.
- **Docs:** bilingual READMEs, [docs/host-integration.md](docs/host-integration.md),
  this changelog, versioning notes, package CI template.

### Notes
- Not published to pub.dev. Depend via a git tag (`v0.1.0`).
- License is MPL-2.0.
