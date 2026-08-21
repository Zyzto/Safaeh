import 'package:flutter/material.dart';

import 'adaptive_sheet.dart';
import 'sheet_shell.dart';
import 'theme.dart';

/// Confirmation body used by [showSafaehConfirm].
///
/// Phone: cancel sits in the action row. Tablet+: the sheet close control is
/// the dismiss path — do not duplicate cancel here.
class SafaehConfirmSheet extends StatelessWidget {
  const SafaehConfirmSheet({
    super.key,
    required this.title,
    required this.content,
    required this.confirmLabel,
    this.cancelLabel,
    this.isDestructive = false,
    this.titleBuilder,
    this.contentBuilder,
    this.tabletBreakpoint,
  });

  final String title;
  final String content;
  final String confirmLabel;
  final String? cancelLabel;
  final bool isDestructive;
  final SafaehTitleBuilder? titleBuilder;
  final SafaehTitleBuilder? contentBuilder;
  final double? tabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    final tokens = SafaehTheme.of(context);
    final breakpoint = tabletBreakpoint ?? tokens.tabletBreakpoint;
    final isWide = MediaQuery.sizeOf(context).width >= breakpoint;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    );
    final contentStyle = theme.textTheme.bodyMedium?.copyWith(
      color: cs.onSurfaceVariant,
    );
    final resolvedCancel =
        cancelLabel ?? MaterialLocalizations.of(context).cancelButtonLabel;

    return buildSafaehSheetShell(
      showTitleInBody: !isWide,
      title:
          titleBuilder?.call(context, titleStyle) ??
          Text(title, style: titleStyle),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.45)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child:
              contentBuilder?.call(context, contentStyle) ??
              Text(content, style: contentStyle),
        ),
      ),
      actions: [
        if (!isWide)
          TextButton(
            key: const ValueKey('safaeh_cancel'),
            onPressed: () {
              final navigator = Navigator.of(context, rootNavigator: true);
              if (navigator.canPop()) navigator.pop(false);
            },
            child: Text(resolvedCancel),
          ),
        _SafaehConfirmButton(
          label: confirmLabel,
          isDestructive: isDestructive,
          onConfirm: () {
            final navigator = Navigator.of(context, rootNavigator: true);
            if (navigator.canPop()) navigator.pop(true);
          },
        ),
      ],
    );
  }
}

/// Adaptive confirm. Hosts pass every label — no `.tr()` here.
///
/// Returns `true` if confirmed, `false` if cancelled, `null` if dismissed.
Future<bool?> showSafaehConfirm({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmLabel,
  String? cancelLabel,
  bool isDestructive = false,
  SafaehTitleBuilder? titleBuilder,
  SafaehTitleBuilder? contentBuilder,
  double Function(BuildContext context)? railWidthOf,
  SafaehTransition? fadeScale,
  SafaehTransition? slideUp,
  double? tabletBreakpoint,
  Duration? motion,
  Curve? enterCurve,
  double? maxHeight,
}) {
  final height = maxHeight ?? MediaQuery.sizeOf(context).height * 0.75;
  return showSafaeh<bool>(
    context: context,
    title: title,
    titleBuilder: titleBuilder,
    maxHeight: height,
    tabletBreakpoint: tabletBreakpoint,
    motion: motion,
    enterCurve: enterCurve,
    railWidthOf: railWidthOf,
    fadeScale: fadeScale,
    slideUp: slideUp,
    child: SafaehConfirmSheet(
      title: title,
      content: content,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      isDestructive: isDestructive,
      titleBuilder: titleBuilder,
      contentBuilder: contentBuilder,
      tabletBreakpoint: tabletBreakpoint,
    ),
  );
}

/// Ink confirm so taps fire when stacked on another modal (no focus steal).
class _SafaehConfirmButton extends StatelessWidget {
  const _SafaehConfirmButton({
    required this.label,
    required this.isDestructive,
    required this.onConfirm,
  });

  final String label;
  final bool isDestructive;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = isDestructive
        ? colorScheme.error
        : colorScheme.primary;
    final foregroundColor = isDestructive
        ? colorScheme.onError
        : colorScheme.onPrimary;

    return Material(
      key: const ValueKey('safaeh_confirm'),
      color: backgroundColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        canRequestFocus: false,
        onTap: onConfirm,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
