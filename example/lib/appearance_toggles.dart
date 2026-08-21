import 'package:flutter/material.dart';

import 'catalog.dart';

/// Language + light/dark controls. Copied from Fukaha's M3 icon buttons:
/// outlined language / light_mode / dark_mode, circular IconButton ripple.
///
/// Lives in a [Stack] above the navigator (see [SafaehExampleApp]) so gallery
/// scroll, demo stacks, and FABs cannot swallow taps. Tooltips are omitted
/// because this layer sits outside [MaterialApp]'s [Overlay]; labels use
/// [Semantics] instead.
class CatalogAppearanceToggles extends StatelessWidget {
  const CatalogAppearanceToggles({
    super.key,
    required this.localeCode,
    required this.themeMode,
    required this.onToggleLocale,
    required this.onToggleTheme,
  });

  final String localeCode;
  final ThemeMode themeMode;
  final VoidCallback onToggleLocale;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dark = themeMode == ThemeMode.dark;
    String t(String key) => translateCatalog(key, localeCode);
    final buttonStyle = IconButton.styleFrom(
      foregroundColor: cs.onSurface,
      minimumSize: const Size(44, 44),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
    );
    final themeLabel =
        '${t('theme')}: ${dark ? t('theme_dark') : t('theme_light')}';

    return Positioned.directional(
      textDirection: Directionality.of(context),
      top: 0,
      end: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(end: 4, top: 2),
          child: Material(
            color: cs.surfaceContainerHighest,
            elevation: 3,
            shadowColor: cs.shadow.withValues(alpha: 0.32),
            shape: StadiumBorder(side: BorderSide(color: cs.outline)),
            clipBehavior: Clip.antiAlias,
            child: IconTheme(
              data: IconThemeData(color: cs.onSurface, size: 22),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    button: true,
                    label: t('language'),
                    child: IconButton(
                      key: const ValueKey('language_toggle'),
                      style: buttonStyle,
                      onPressed: onToggleLocale,
                      icon: const Icon(Icons.language_outlined),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: themeLabel,
                    child: IconButton(
                      key: const ValueKey('theme_toggle'),
                      style: buttonStyle,
                      onPressed: onToggleTheme,
                      icon: Icon(
                        dark
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
