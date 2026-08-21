import 'package:flutter/material.dart';

import 'adaptive_sheet.dart';
import 'theme.dart';

/// Centered dialog. Optional [railWidthOf] shifts the panel off a host rail.
///
/// Unlike [showSafaeh], this does not morph into a phone bottom sheet.
Future<T?> showSafaehDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  bool fadeScale = true,
  double Function(BuildContext context)? railWidthOf,
  Duration? motion,
  Curve? enterCurve,
  SafaehTransition? transition,
}) {
  final tokens = SafaehTheme.of(context);
  final resolvedMotion = safaehResolvedMotion(context, motion ?? tokens.motion);
  final theme = Theme.of(context);

  return showGeneralDialog<T>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor:
        barrierColor ?? theme.colorScheme.scrim.withValues(alpha: 0.32),
    transitionDuration: resolvedMotion,
    pageBuilder: (ctx, animation, secondaryAnimation) {
      return _SafaehDialogHost(
        builder: builder,
        barrierDismissible: barrierDismissible,
        fadeScale: fadeScale,
        openAnimation: animation,
        motion: resolvedMotion,
        enterCurve: enterCurve ?? tokens.enterCurve,
        railWidthOf: railWidthOf,
        transition: transition,
      );
    },
    transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
  );
}

class _SafaehDialogHost extends StatelessWidget {
  const _SafaehDialogHost({
    required this.builder,
    required this.barrierDismissible,
    required this.fadeScale,
    required this.openAnimation,
    required this.motion,
    required this.enterCurve,
    this.railWidthOf,
    this.transition,
  });

  final WidgetBuilder builder;
  final bool barrierDismissible;
  final bool fadeScale;
  final Animation<double> openAnimation;
  final Duration motion;
  final Curve enterCurve;
  final double Function(BuildContext context)? railWidthOf;
  final SafaehTransition? transition;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final isWide = SafaehTheme.of(context).isWide(context);
    final railWidth = isWide ? (railWidthOf?.call(context) ?? 0.0) : 0.0;
    final child = Align(alignment: Alignment.center, child: builder(context));
    final entering =
        (transition ?? (fadeScale ? _defaultFadeScale : _defaultFade))(
          animation: openAnimation,
          child: child,
        );

    return Stack(
      fit: StackFit.expand,
      children: [
        if (barrierDismissible)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                final navigator = Navigator.of(context, rootNavigator: true);
                if (navigator.canPop()) navigator.pop(null);
              },
              child: const SizedBox.expand(),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: AnimatedPadding(
            duration: motion,
            curve: enterCurve,
            padding: EdgeInsetsDirectional.only(start: railWidth),
            child: entering,
          ),
        ),
      ],
    );
  }
}

Widget _defaultFadeScale({
  required Animation<double> animation,
  required Widget child,
}) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final t = Curves.easeOutCubic.transform(animation.value.clamp(0.0, 1.0));
      return Opacity(
        opacity: t,
        child: Transform.scale(scale: 0.96 + (0.04 * t), child: child),
      );
    },
    child: child,
  );
}

Widget _defaultFade({
  required Animation<double> animation,
  required Widget child,
}) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final t = Curves.easeOutCubic.transform(animation.value.clamp(0.0, 1.0));
      return Opacity(opacity: t, child: child);
    },
    child: child,
  );
}
