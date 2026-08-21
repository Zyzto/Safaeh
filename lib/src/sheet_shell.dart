import 'package:flutter/material.dart';

const double kSafaehSheetPadding = 20;
const double _kActionsSpacing = 8;
const double _kBodyActionsGap = 20;

/// Shared sheet body: optional in-body title, content, action row.
///
/// Bottom safe/IME inset is owned by [showSafaeh]. Do not wrap this in another
/// bottom [SafeArea].
Widget buildSafaehSheetShell({
  required Widget body,
  List<Widget> actions = const [],
  Widget? title,
  bool showTitleInBody = true,
  double padding = kSafaehSheetPadding,
}) {
  return SafeArea(
    bottom: false,
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: showTitleInBody ? 0 : padding,
          bottom: padding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showTitleInBody && title != null)
              Padding(
                padding: EdgeInsets.fromLTRB(padding, padding, padding, 8),
                child: title,
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: body,
            ),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: _kBodyActionsGap),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (int i = 0; i < actions.length; i++) ...[
                      if (i > 0) const SizedBox(width: _kActionsSpacing),
                      Focus(
                        canRequestFocus: false,
                        skipTraversal: true,
                        descendantsAreFocusable: false,
                        child: actions[i],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

/// Vertical list of option rows with consistent gaps.
class SafaehOptionList extends StatelessWidget {
  const SafaehOptionList({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 8),
    this.spacing = 8,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: spacing),
            children[i],
          ],
        ],
      ),
    );
  }
}
