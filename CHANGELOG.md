# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

Tags are `vX.Y.Z` and must match `version:` in [`pubspec.yaml`](pubspec.yaml).
See [VERSIONING.md](VERSIONING.md).

## [Unreleased]

### Added
- Tile pickers accept `searchMatches` so hosts can filter without ASCII
  `toLowerCase()`.
- `SafaehQrMessageBody.closeTooltip` (defaults to
  `MaterialLocalizations.closeButtonTooltip`).
- Sidenav profile `labelBuilder` also wraps the subtitle (email LTR
  isolate).
- Camera handle labels: `handleExpandLabel` / `handleCollapseLabel` /
  `handleDismissLabel`.
- `showSafaeh` / `SafaehRouteOptions` accept `dismissLabel` and
  `closeTooltip`.

### Changed
- Host integration documents Material localization fallbacks, required
  expand/collapse tooltips, physical-left band math, and the RTL icon
  contract.

### Fixed
- RTL chevrons and back arrows no longer double-flip: helpers keep the
  LTR glyph and let Material `matchTextDirection` mirror once.
- Sidenav destinations, floating-nav tabs, and page-index links announce
  `Semantics.selected`. Option tiles and cards announce selected and
  disabled.
- Page-index headers no longer force Latin `letterSpacing`.
- Overlay page-index pill announces expanded state.
- Tablet sheet close is an `IconButton` (tooltip + button semantics).
- Catalog card subtitles are real sentences in all five locales, not
  raw API tokens.
- Raised phone sheets treat an in-body title as chrome so the host
  child still centers.
- Sidenav titles no longer force negative `letterSpacing`.
- Avatar initials fold only Basic Latin; other scripts keep the first
  letter as written.
- Catalog `translateCatalog` asserts on a missing key in debug. Tests
  require non-allowlisted strings to differ from English.

## [0.2.0] - 2026-08-22

Phone-sheet reach, RTL chrome helpers, catalog phone frames, and the
first pub.dev publish path. See [VERSIONING.md](VERSIONING.md) for the
milestone exception to the usual MINOR = features rule.

### Added
- **`SafaehPhoneSheetPlacement`** / **`safaehPhoneCenterSheetTop`**: grow
  the phone bottom sheet so the first content center aligns with the
  phone center (still docked). Confirm, text input, and both pickers
  forward it.
- **RTL icons:** `safaehChevronEnd`, `safaehChevronStart`,
  `safaehArrowBack`.
- **`SafaehSidenavAvatar`**: primary circular initials when a profile
  has no `leading`.
- **`labelBuilder`** on `SafaehSidenavDestination` and
  `SafaehSidenavProfile`.
- **`SafaehQrScannerOverlay.preview`**: optional host camera feed or
  mock behind the viewfinder (no plugin in the package).
- **`SafaehRouteOptions`**: shared rail / size / motion / barrier /
  navigator bag on titled `show*` routes and `showSafaehDialog`.
- **`useRootNavigator`** / **`SafaehNavigatorScope`** / **`safaehPop`**:
  pickers and sheet chrome pop the same navigator that opened the route.
- **`SafaehLabelBuilder`** / **`safaehTitleFromLabel`**: same label
  wrapper on sidenav, floating nav, and page index; optional bridge for
  sheet titles.
- **`SafaehPageIndexEntry.labelBuilder`**.
- **`SafaehOptionPickerBody`**: embeddable card-picker list.
- **`showSafaehMultiTilePicker`**: multi-select list; confirm pops
  `List<T>`. Tile pickers take `searchHint` / `searchEmptyLabel`.
- **`SafaehStatusBody`**: empty / busy / action chrome (optional
  determinate `progress`). QR permission stays `SafaehQrMessageBody`.
- **`showSafaeh(dismissValue:)`** / **`dismissReturnsFalse`** on confirm.
- **Text-input knobs:** `keyboardType`, `textInputAction`,
  `inputFormatters`, `autocorrect`, `enableSuggestions`, `onChanged`.
- **`safaehFadeScale`** / **`safaehFade`** / **`safaehCurveFor`**:
  shared enter / exit curves. `show*` take `exitCurve`.
- **Camera knobs:** `motion`, `roll`, `railWidthOf`, `enterCurve`,
  `exitCurve`, `barrierDismissible`, `useRootNavigator`.

### Changed
- **CI / release**: Release workflow publishes to pub.dev via OIDC after
  verify + GitHub Release. READMEs use pub-style install.
- Baz Light is no longer registered as a package font, and
  `assets/fonts/baz-Light.otf` is not shipped (SVG outlines only).
- Selected card-picker and option-tile rows no longer show a check mark.
  Selection is the primary container fill, primary border, and
  `onPrimaryContainer` type.
- Option tiles, card-picker cards, confirm, and text-input chrome use
  `SafaehThemeData.radius`.
- Confirm primary action is a `FilledButton` (same as text-input Done).
- Floating nav defaults to `navMotion` and honors `labelBuilder`.
- QR success wash / frame use `ColorScheme.tertiary`.
- `kSheetContentPadding` aliases `kSafaehSheetPadding` on the sides.

### Fixed
- Directional chevrons and back arrows flip in RTL (`safaehChevronEnd`,
  `safaehChevronStart`, `safaehArrowBack`). The phone bezel status strip
  stays LTR so signal icons do not mirror in Arabic.
- Center phone sheets force the panel to the computed height so the
  modal paper stays flush with the bottom (not a shorter card in a tall
  box).
- Catalog phone chrome no longer stacks a status-bar `SafeArea` under the
  fake 9:41 strip. Narrow previews use a collapsed rail, an overlay page
  index, a drawer panel over a host, and a stacked end-aside.
- `SafaehFloatingNavBar` ignores top `SafeArea` so a bottom bar does not
  grow a gap above itself.
- `SafaehPhoneSheetPlacement.center` stays a bottom-docked sheet. The
  vertical center of the first body block after the handle aligns with
  the vertical center of the phone; the sheet no longer pins its top at
  mid-screen or floats as a centered card.
- Phone sheet bodies no longer apply status-bar `SafeArea` (`buildSafaehSheetShell`,
  `SafaehTilePickerBody`).
- Page-index active marker uses `BorderDirectional.start` in RTL.
- Sidenav collapse chevron follows `TextDirection`.
- Phone dismiss drag is limited to the sheet handle so lists can scroll.
- Sheet actions and confirm can take keyboard focus.
- `scrollToPageSection` honors `MediaQuery.disableAnimationsOf`.
- `scrollToPageSection` scrolls only the given controller / nearest
  scrollable. It no longer uses `Scrollable.ensureVisible`, which walked
  every ancestor viewport (and dragged the catalog).
- Phone / camera bottom panels slide the full sheet up from below (and down
  on exit). The old default only nudged 56px.
- Camera paper-roll enter/exit matches other bottom panels: fade plus a
  full-height `FractionalTranslation` (same family as `showSafaeh` /
  QR via `showSafaehCameraSheet`). Handle drag is unchanged.
- Sidenav profile without `leading` shows a primary circular avatar with
  initials (`SafaehSidenavAvatar`) instead of an empty `Icon(null)`.
- Card and tile pickers popped the nearest navigator; they now use
  `safaehPop` (root by default).
- `SafaehTextInputSheet` syncs `initialValue` in `didUpdateWidget`.
- `obscureText` forces `maxLines: 1`.
- Sheet action rows wrap with `OverflowBar`.
- Option tiles can take keyboard focus; `bodyLarge` is no longer
  force-unwrapped.
- Text-input `maxLength` shows the character counter again.
- Phone and camera drag handles expose dismiss semantics.
- Page-index overlay no longer double-`setState`s on close.

### Docs
- Confirm result (`true` / `false` / `null`) is spelled out in both READMEs.
- Example catalog wraps the vertical gallery in `SafaehContentBand`; section
  titles open the standalone demo (live sheet or pushed page). Camera and
  QR titles both use `showSafaehCameraSheet` so the panel slides up. Wide
  bands spread section cards across columns on the same page. Each card has
  its own phone-frame preview (Edadat bezel). Sheet cards include a reach
  toggle above the bezel that raises the sheet so the first content
  center aligns with the phone center. Camera and QR demos fill the
  panel with a mock
  viewfinder so desktop / web (and this catalog, which has no camera
  plugin) are not a black hole. The sheet-shell card is an export-report
  example (`buildSafaehSheetShell` + format tiles + Cancel/Save).
  Catalog also has multi-picker (search + confirm) and status-body
  cards. [docs/host-integration.md](docs/host-integration.md) covers the
  route bag, `safaehPop`, label builders, and confirm dismiss.

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
- First standalone release. Depend via a git tag (`v0.1.0`).
- License is MPL-2.0.
