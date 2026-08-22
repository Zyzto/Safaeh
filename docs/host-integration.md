# Host integration

Safaeh is chrome only. Copy, routing, state, and camera plugins stay in the
host. This note is the contract Hisab (and other apps) should follow.

## `railWidthOf`

`showSafaeh` and `showSafaehDialog` take an optional

```dart
double Function(BuildContext context)? railWidthOf
```

On tablet+ the panel is shifted by that start inset so a permanent sidenav
does not cover the dialog. Return `0` to center in the full viewport (Hisab
`centerInFullViewport: true`). Do not bake GoRouter or shell layout into the
package — pass a closure.

Phone sheets ignore `railWidthOf`.

`showSafaeh` paints the title in the phone body by default
(`paintPhoneTitle: true`). Confirm, text input, and pickers pass
`false` because they already title the in-body list. Raised
(`center`) sheets count that title as handle chrome so the first host
child still lines up with the phone center.

## Phone sheet placement

`showSafaeh` (and confirm / text / pickers that go through it) accepts

```dart
SafaehPhoneSheetPlacement phonePlacement
```

Default is `bottom`. Pass `SafaehPhoneSheetPlacement.center` to grow the
phone bottom sheet upward so the vertical center of the first body
block after the handle aligns with the vertical center of the phone
(still flush with the bottom). Tablet+ dialogs stay centered either
way. Camera / QR paper-roll sheets stay bottom-docked.

## Confirm result

`showSafaehConfirm` returns `true` if confirmed, `false` if the phone
cancel button is pressed, and `null` if the route is dismissed (tablet
close, barrier tap, or system back). Treat only `ok == true` as confirmed.

Pass `dismissReturnsFalse: true` so a barrier tap, tablet close, or
system back also yields `false` (hosts that only check `ok == true` can
ignore this).

## Route bag

Titled `show*` functions and `showSafaehDialog` accept

```dart
SafaehRouteOptions? route
```

Use one object for shared rail, size, motion, barrier, and navigator
settings. Named arguments still work; they fill in around the bag.
`barrierDismissible`, `useRootNavigator`, and `phonePlacement` take the
bag value when it is non-null.

Every `show*` also takes `useRootNavigator` (default `true`). Picker rows
and sheet chrome pop through `safaehPop`, which reads
`SafaehNavigatorScope` so a nested host navigator can opt out.

## `titleBuilder` / `labelBuilder`

Every titled sheet accepts `SafaehTitleBuilder`:

```dart
typedef SafaehTitleBuilder =
    Widget Function(BuildContext context, TextStyle? style);
```

Sidenav, floating nav, and page index use `SafaehLabelBuilder`:

```dart
typedef SafaehLabelBuilder = Widget Function(String data, TextStyle? style);
```

`safaehTitleFromLabel(data, labelBuilder)` adapts a label wrapper for a
sheet title so Hisab can reuse one `UserText` helper. The package never
calls `.tr()`. Phone pickers also render the title in the body; tablet+
shows it in the header only. Pass the same builder to `showSafaeh*` and
to `SafaehTilePickerBody` / confirm / text-input bodies when you wrap the
route yourself.

`labelBuilder` also wraps sidenav profile **subtitles**. Use that to
isolate emails and similar tokens in LTR (`Directionality.ltr`) so an
RTL profile row does not reverse `ada@example.com`.

## Material localizations

Safaeh has no bundled copy. A few chrome strings come from
`MaterialLocalizations` of the current locale:

| Chrome | Fallback |
|--------|----------|
| Sheet handle / barrier | `modalBarrierDismissLabel` (override with `dismissLabel`) |
| Tablet sheet close | `closeButtonTooltip` (override with `closeTooltip`) |
| Camera handle | expand / collapse / dismiss labels, else Material dismiss |
| QR top-bar close | `closeButtonTooltip` |
| QR message close | `closeButtonTooltip` (override with `closeTooltip`) |
| Confirm / text-input cancel | host `cancelLabel` — there is no package default |

Wire `MaterialApp.localizationsDelegates` (and `supportedLocales`) for
every locale the host ships. Missing delegates leave those controls in
English.

Icon-only chrome the host must label:

- Sidenav compact toggle: `expandTooltip` / `collapseTooltip`
- QR expand: `expandTooltip` / `collapseTooltip`
- Camera paper-roll handle: `handleExpandLabel` / `handleCollapseLabel` /
  `handleDismissLabel`
- Phone sheet handle / tablet X: `dismissLabel` / `closeTooltip` on
  `showSafaeh` or `SafaehRouteOptions`

Selected sidenav, floating-nav, page-index, and option tiles announce
`Semantics.selected`. Disabled option tiles / cards announce
`enabled: false`.

## RTL icons

`safaehChevronEnd`, `safaehChevronStart`, and `safaehArrowBack` always
return the LTR glyph (`chevron_right`, `chevron_left`, `arrow_back`).
Those `IconData`s set `matchTextDirection: true`, so Material mirrors
them once in RTL. Do **not** swap to the opposite icon in RTL or the
arrow flips twice.

## Tile search

Default tile-picker filter is ASCII `toLowerCase()` on label and
subtitle. Pass `searchMatches` on `SafaehTilePickerBody` /
`showSafaehTilePicker` / `showSafaehMultiTilePicker` for locale-aware
or token-aware matching. The callback receives the raw query string.

## Accent hooks on tiles

`SafaehOptionTile` defaults to `ColorScheme` fills. Hosts that want a brand
accent pass:

- `selectedFill`
- `selectedBorder`

Hisab `SheetOptionTile` wraps the package tile with `UserText` plus those
colors. Do not import AccentSurfaces into this package.

## Band metrics vs host rail math

`safaehBandMetrics` centers a capped column inside the **incoming** width
(optional physical-left `reservedStartWidth`).

`leftOffset` is always from the **physical left** of that incoming box,
including in RTL. `SafaehEndAsideLayout` takes `isRtl` separately and
places the aside on the end. Do **not** pass a start inset as
`leftOffset` or the band shifts the wrong way in Arabic.

`reservedStartWidth` is the same physical-left reserve (a rail still
included in the incoming width). If the rail is a start-edge sibling
and constraints already exclude it, leave this at 0.

`SafaehContentBand` uses that helper. Feed the same
`(leftOffset, bandWidth, endFree)` into:

- `SafaehEndAsideLayout`
- `SafaehContentAlignedAppBar`
- `SafaehContentAlignedFabLocation` (or `.resolve` when `endFree` is tight)

Hisab `ConstrainedContent` / `ContentAlignedAppBar` / `ContentAlignedFabLocation`
keep `LayoutBreakpoints` because they center in the **full viewport** while a
sibling shell rail eats width (RTL-aware). Do not replace that with
`safaehBandMetrics`.

## Keys the host owns

Hisab still passes `shell_nav_*` keys into `SafaehSidenav` (`railKey`,
`expandKey`, `collapseKey`, destination `tileKey`). Package defaults are
`safaeh_nav_*`. Changing either set breaks existing widget tests.

## What stays in the host

| Concern | Host |
|---------|------|
| Copy | `easy_localization`, `UserText`, every label argument |
| Routing | `go_router`, reserved rail via `railWidthOf` |
| Camera | `mobile_scanner`, permissions, `SystemChrome` |
| State | Riverpod / whatever the app already uses |
| Scroll sheets | Hisab `showResponsiveSheet` `isScrollControlled` (unused flag, kept for call sites) |
| Performance tokens | UiPerf / cheap shadows — not in this package |

## Still host-owned

- Avatar initials fold only Basic Latin (`toUpperCase` on `codeUnit < 0x80`).
  CJK / Arabic letters stay as written. Pass `SafaehSidenavAvatar.initials`
  or a custom `leading` for Turkish İ / ı.
- The catalog example asserts in debug if a key is missing, then falls
  back to English. The package itself has no copy and will not.
- Fonts stay with the host / system. Safaeh does not register a UI face.

## Thin wrappers

Prefer a host function that maps app types onto package types, then calls
`showSafaeh` or mounts `SafaehTilePickerBody` as the child of the host route.
Do not fork panel layout back into the app.

Multi-select + search live on `showSafaehMultiTilePicker` /
`SafaehTilePickerBody` (`searchHint`, `searchEmptyLabel`, `searchMatches`,
`confirmLabel`).
Empty / busy / error chrome for light sheets is `SafaehStatusBody` (optional
determinate `progress`). Camera permission copy stays on
`SafaehQrMessageBody`. Camera sheets take `railWidthOf`, `motion`,
`enterCurve` / `exitCurve`, and `barrierDismissible`; they stay a paper-roll,
not a morphing `showSafaeh` dialog.
