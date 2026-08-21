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

## `titleBuilder`

Every titled sheet accepts `SafaehTitleBuilder`:

```dart
typedef SafaehTitleBuilder =
    Widget Function(BuildContext context, TextStyle? style);
```

Use this for bidi-aware host text (`UserText` in Hisab). The package never
calls `.tr()`. Phone pickers also render the title in the body; tablet+ shows
it in the header only. Pass the same builder to `showSafaeh*` and to
`SafaehTilePickerBody` / confirm / text-input bodies when you wrap the route
yourself.

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

## Thin wrappers

Prefer a host function that maps app types onto package types, then calls
`showSafaeh` or mounts `SafaehTilePickerBody` as the child of the host route.
Do not fork panel layout back into the app.
