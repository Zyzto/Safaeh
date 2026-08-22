import 'package:flutter/material.dart';

import 'adaptive_sheet.dart';
import 'theme.dart';

/// Centered dialog. Optional [railWidthOf] shifts the panel off a host rail.
///
/// Unlike [showSafaeh], this does not morph into a phone bottom sheet.
/// [SafaehRouteOptions.slideUp], [SafaehRouteOptions.phonePlacement], and
/// [SafaehRouteOptions.tabletBreakpoint] are ignored.
Future<T?> showSafaehDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  bool fadeScale = true,
  double Function(BuildContext context)? railWidthOf,
  Duration? motion,
  Curve? enterCurve,
  Curve? exitCurve,
  SafaehTransition? transition,
  bool useRootNavigator = true,
  SafaehRouteOptions? route,
}) {
  final tokens = SafaehTheme.of(context);
  final resolvedBarrier = route?.barrierDismissible ?? barrierDismissible;
  final resolvedRoot = route?.useRootNavigator ?? useRootNavigator;
  final resolvedMotion = safaehResolvedMotion(
    context,
    motion ?? route?.motion ?? tokens.motion,
  );
  final theme = Theme.of(context);

  return showGeneralDialog<T>(
    context: context,
    useRootNavigator: resolvedRoot,
    barrierDismissible: resolvedBarrier,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor:
        barrierColor ?? theme.colorScheme.scrim.withValues(alpha: 0.32),
    transitionDuration: resolvedMotion,
    pageBuilder: (ctx, animation, secondaryAnimation) {
      return _SafaehDialogHost(
        builder: builder,
        barrierDismissible: resolvedBarrier,
        fadeScale: fadeScale,
        openAnimation: animation,
        motion: resolvedMotion,
        enterCurve: enterCurve ?? route?.enterCurve ?? tokens.enterCurve,
        exitCurve: exitCurve ?? route?.exitCurve ?? tokens.exitCurve,
        railWidthOf: railWidthOf ?? route?.railWidthOf,
        maxWidth: route?.maxWidth ?? tokens.dialogMaxWidth,
        maxHeight:
            route?.maxHeight ?? MediaQuery.sizeOf(context).height * 0.85,
        transition: transition ?? route?.fadeScale,
        useRootNavigator: resolvedRoot,
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
    required this.exitCurve,
    this.railWidthOf,
    this.maxWidth,
    this.maxHeight,
    this.transition,
    this.useRootNavigator = true,
  });

  final WidgetBuilder builder;
  final bool barrierDismissible;
  final bool fadeScale;
  final Animation<double> openAnimation;
  final Duration motion;
  final Curve enterCurve;
  final Curve exitCurve;
  final double Function(BuildContext context)? railWidthOf;
  final double? maxWidth;
  final double? maxHeight;
  final SafaehTransition? transition;
  final bool useRootNavigator;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final isWide = SafaehTheme.of(context).isWide(context);
    final railWidth = isWide ? (railWidthOf?.call(context) ?? 0.0) : 0.0;
    Widget panel = ConstrainedBox(
      key: const ValueKey('safaeh_dialog_constraints'),
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: builder(context),
    );
    final child = Align(alignment: Alignment.center, child: panel);
    final entering =
        (transition ?? (fadeScale ? safaehFadeScale : safaehFade))(
          animation: openAnimation,
          child: child,
        );

    return SafaehTheme(
      data: SafaehTheme.of(context).copyWith(
        enterCurve: enterCurve,
        exitCurve: exitCurve,
      ),
      child: SafaehNavigatorScope(
      useRootNavigator: useRootNavigator,
      child: Stack(
      fit: StackFit.expand,
      children: [
        if (barrierDismissible)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => safaehPop(context),
              child: const SizedBox.expand(),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: AnimatedPadding(
            duration: motion,
            curve: enterCurve,
            padding: EdgeInsetsDirectional.only(start: railWidth),
            child: SafeArea(child: entering),
          ),
        ),
      ],
    ),
    ),
    );
  }
}
