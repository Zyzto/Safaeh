import 'package:flutter/material.dart';

import 'adaptive_sheet.dart';
import 'option_tile.dart';
import 'sheet_shell.dart';
import 'theme.dart';

/// One list row in [showSafaehTilePicker].
///
/// Distinct from [SafaehOption] (card picker): optional [subtitle], a custom
/// [leading] widget, and [enabled]. Do not mix the two option types.
class SafaehTileOption<T> {
  const SafaehTileOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
    this.enabled = true,
  });

  final T value;
  final String label;
  final String? subtitle;
  final Widget? leading;
  final bool enabled;
}

/// Builds a custom row for [SafaehTilePickerBody]. Owns tap / pop behavior.
typedef SafaehTileBuilder<T> =
    Widget Function(
      BuildContext context,
      SafaehTileOption<T> option,
      bool selected,
    );

/// List-row picker body: optional in-body title, [header], [SafaehOptionList].
///
/// Hosts that already wrap [showSafaeh] (or Hisab `showResponsiveSheet`) can
/// mount this widget as the child. [showSafaehTilePicker] does that for you.
class SafaehTilePickerBody<T> extends StatelessWidget {
  const SafaehTilePickerBody({
    super.key,
    required this.options,
    this.title,
    this.titleBuilder,
    this.header,
    this.selected,
    this.tileBuilder,
    this.tabletBreakpoint,
  });

  final String? title;
  final SafaehTitleBuilder? titleBuilder;
  final Widget? header;
  final List<SafaehTileOption<T>> options;
  final T? selected;
  final SafaehTileBuilder<T>? tileBuilder;
  final double? tabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    final tokens = SafaehTheme.of(context);
    final breakpoint = tabletBreakpoint ?? tokens.tabletBreakpoint;
    final showInBodyTitle = MediaQuery.sizeOf(context).width < breakpoint;
    final titleStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    final titleText = title ?? '';
    final showTitle =
        showInBodyTitle &&
        ((title != null && title!.isNotEmpty) || titleBuilder != null);

    return SafeArea(
      top: false,
      bottom: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showTitle)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child:
                      titleBuilder?.call(context, titleStyle) ??
                      Text(titleText, style: titleStyle),
                ),
              if (header != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: header,
                ),
              SafaehOptionList(
                children: [
                  for (final opt in options)
                    tileBuilder?.call(
                          context,
                          opt,
                          selected != null && opt.value == selected,
                        ) ??
                        SafaehOptionTile(
                          title: Text(opt.label),
                          subtitle: opt.subtitle != null
                              ? Text(opt.subtitle!)
                              : null,
                          leading: opt.leading,
                          enabled: opt.enabled,
                          selected: selected != null && opt.value == selected,
                          onTap: opt.enabled
                              ? () => Navigator.of(context).pop(opt.value)
                              : null,
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// List-row single-select picker. Wide = dialog, phone = bottom sheet.
Future<T?> showSafaehTilePicker<T>({
  required BuildContext context,
  required List<SafaehTileOption<T>> options,
  String? title,
  SafaehTitleBuilder? titleBuilder,
  Widget? header,
  T? selected,
  SafaehTileBuilder<T>? tileBuilder,
  double Function(BuildContext context)? railWidthOf,
  double? tabletBreakpoint,
  double? maxWidth,
  double? maxHeight,
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
    tabletBreakpoint: breakpoint,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    motion: motion,
    enterCurve: enterCurve,
    railWidthOf: railWidthOf,
    fadeScale: fadeScale,
    slideUp: slideUp,
    child: SafaehTilePickerBody<T>(
      title: title,
      titleBuilder: titleBuilder,
      header: header,
      options: options,
      selected: selected,
      tileBuilder: tileBuilder,
      tabletBreakpoint: breakpoint,
    ),
  );
}
