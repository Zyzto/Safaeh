import 'package:flutter/material.dart';

import 'adaptive_sheet.dart';
import 'sheet_shell.dart';
import 'theme.dart';

/// Text field + action row used by [showSafaehTextInput].
class SafaehTextInputSheet extends StatefulWidget {
  const SafaehTextInputSheet({
    super.key,
    required this.title,
    required this.doneLabel,
    this.hint,
    this.initialValue = '',
    this.maxLines = 1,
    this.maxLength,
    this.obscureText = false,
    this.cancelLabel,
    this.titleBuilder,
    this.tabletBreakpoint,
  });

  final String title;
  final String doneLabel;
  final String? hint;
  final String initialValue;
  final int maxLines;
  final int? maxLength;
  final bool obscureText;
  final String? cancelLabel;
  final SafaehTitleBuilder? titleBuilder;
  final double? tabletBreakpoint;

  @override
  State<SafaehTextInputSheet> createState() => _SafaehTextInputSheetState();
}

class _SafaehTextInputSheetState extends State<SafaehTextInputSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = SafaehTheme.of(context);
    final breakpoint = widget.tabletBreakpoint ?? tokens.tabletBreakpoint;
    final isWide = MediaQuery.sizeOf(context).width >= breakpoint;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    );
    final resolvedCancel =
        widget.cancelLabel ??
        MaterialLocalizations.of(context).cancelButtonLabel;

    return buildSafaehSheetShell(
      showTitleInBody: !isWide,
      title:
          widget.titleBuilder?.call(context, titleStyle) ??
          Text(widget.title, style: titleStyle),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: TextField(
            controller: _controller,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              hintText: widget.hint,
              border: const OutlineInputBorder(),
              counterText: widget.maxLength != null ? '' : null,
              isDense: true,
            ),
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            autofocus: true,
          ),
        ),
      ),
      actions: [
        if (!isWide)
          TextButton(
            key: const ValueKey('safaeh_cancel'),
            onPressed: () {
              final navigator = Navigator.of(context, rootNavigator: true);
              if (navigator.canPop()) navigator.pop(null);
            },
            child: Text(resolvedCancel),
          ),
        FilledButton(
          key: const ValueKey('safaeh_text_done'),
          onPressed: () {
            final navigator = Navigator.of(context, rootNavigator: true);
            if (navigator.canPop()) navigator.pop(_controller.text.trim());
          },
          child: Text(widget.doneLabel),
        ),
      ],
    );
  }
}

/// Adaptive text field. Returns the trimmed value, or `null` if dismissed.
///
/// Hosts pass [doneLabel] / [cancelLabel] — no `.tr()` here.
Future<String?> showSafaehTextInput({
  required BuildContext context,
  required String title,
  required String doneLabel,
  String? hint,
  String initialValue = '',
  int maxLines = 1,
  int? maxLength,
  bool obscureText = false,
  String? cancelLabel,
  SafaehTitleBuilder? titleBuilder,
  double Function(BuildContext context)? railWidthOf,
  SafaehTransition? fadeScale,
  SafaehTransition? slideUp,
  double? tabletBreakpoint,
  Duration? motion,
  Curve? enterCurve,
  double? maxHeight,
}) {
  final height = maxHeight ?? MediaQuery.sizeOf(context).height * 0.5;
  return showSafaeh<String?>(
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
    child: SafaehTextInputSheet(
      title: title,
      doneLabel: doneLabel,
      hint: hint,
      initialValue: initialValue,
      maxLines: maxLines,
      maxLength: maxLength,
      obscureText: obscureText,
      cancelLabel: cancelLabel,
      titleBuilder: titleBuilder,
      tabletBreakpoint: tabletBreakpoint,
    ),
  );
}
