import 'package:flutter/material.dart';

import 'adaptive_sheet.dart';
import 'theme.dart';

/// One card in [showSafaehPicker].
///
/// Card rows use a required [icon] and [subtitle]. List-row pickers use
/// [SafaehTileOption] instead (`leading` widget + optional subtitle).
class SafaehOption<T> {
  const SafaehOption({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.icon,
    this.badge,
    this.enabled = true,
  });

  final T value;
  final String label;
  final String subtitle;
  final IconData icon;
  final String? badge;
  final bool enabled;
}

/// Compact single-select picker. Wide = dialog, phone = bottom sheet.
Future<T?> showSafaehPicker<T>({
  required BuildContext context,
  required String title,
  required List<SafaehOption<T>> options,
  required T selected,
  String? footer,
  SafaehTitleBuilder? titleBuilder,
  double Function(BuildContext context)? railWidthOf,
  double? tabletBreakpoint,
  Duration? motion,
  Curve? enterCurve,
  SafaehTransition? fadeScale,
  SafaehTransition? slideUp,
}) {
  final tokens = SafaehTheme.of(context);
  final breakpoint = tabletBreakpoint ?? tokens.tabletBreakpoint;
  return showSafaeh<T>(
    context: context,
    title: title,
    titleBuilder: titleBuilder,
    contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    tabletBreakpoint: breakpoint,
    motion: motion,
    enterCurve: enterCurve,
    railWidthOf: railWidthOf,
    fadeScale: fadeScale,
    slideUp: slideUp,
    child: _OptionPickerBody<T>(
      title: title,
      titleBuilder: titleBuilder,
      options: options,
      selected: selected,
      footer: footer,
      tabletBreakpoint: breakpoint,
    ),
  );
}

class _OptionPickerBody<T> extends StatelessWidget {
  const _OptionPickerBody({
    required this.title,
    required this.options,
    required this.selected,
    required this.tabletBreakpoint,
    this.titleBuilder,
    this.footer,
  });

  final String title;
  final SafaehTitleBuilder? titleBuilder;
  final List<SafaehOption<T>> options;
  final T selected;
  final String? footer;
  final double tabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showInBodyTitle = MediaQuery.sizeOf(context).width < tabletBreakpoint;
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    );
    return SafeArea(
      top: false,
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showInBodyTitle) ...[
              titleBuilder?.call(context, titleStyle) ??
                  Text(title, style: titleStyle),
              const SizedBox(height: 10),
            ],
            for (var i = 0; i < options.length; i++) ...[
              if (i > 0) const SizedBox(height: 6),
              _OptionCard<T>(
                option: options[i],
                selected: options[i].value == selected,
                onTap: options[i].enabled
                    ? () => Navigator.pop(context, options[i].value)
                    : null,
              ),
            ],
            if (footer != null) ...[
              const SizedBox(height: 10),
              Text(
                footer!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
                  height: 1.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OptionCard<T> extends StatelessWidget {
  const _OptionCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final SafaehOption<T> option;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final enabled = option.enabled;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: selected ? cs.primaryContainer : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? cs.primary : cs.outline),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    option.icon,
                    size: 20,
                    color: selected ? cs.onPrimaryContainer : cs.onSurface,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.label,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: selected
                                ? cs.onPrimaryContainer
                                : cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          option.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: selected
                                ? cs.onPrimaryContainer
                                : cs.onSurfaceVariant,
                            height: 1.25,
                          ),
                        ),
                        if (option.badge != null) ...[
                          const SizedBox(height: 6),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: cs.tertiaryContainer.withValues(
                                  alpha: 0.85,
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                option.badge!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: cs.onTertiaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (selected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: cs.onPrimaryContainer,
                      size: 18,
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
