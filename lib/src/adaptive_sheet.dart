import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'sheet_handle_drag.dart';
import 'theme.dart';

/// Default inset for free-form sheet bodies.
const EdgeInsets kSheetContentPadding = EdgeInsets.fromLTRB(20, 16, 20, 20);

/// Builds a wide-dialog entrance (fade + scale).
typedef SafaehTransition =
    Widget Function({
      required Animation<double> animation,
      required Widget child,
    });

/// Optional title widget (e.g. bidi-aware [Text] from the host app).
typedef SafaehTitleBuilder =
    Widget Function(BuildContext context, TextStyle? style);

/// Shows [child] as a centered dialog on tablet+ and a bottom sheet on phone.
///
/// The same route morphs when the viewport crosses the tablet breakpoint.
Future<T?> showSafaeh<T>({
  required BuildContext context,
  required Widget child,
  String? title,
  SafaehTitleBuilder? titleBuilder,
  Widget? tabletTopBarAction,
  double? maxWidth,
  double? maxHeight,
  bool useSafeArea = true,
  bool showDragHandle = true,
  bool enableDrag = true,
  ShapeBorder? sheetShape,
  bool barrierDismissible = true,
  EdgeInsetsGeometry? contentPadding,
  double? tabletBreakpoint,
  double? dialogMaxWidth,
  Duration? motion,
  Curve? enterCurve,
  double Function(BuildContext context)? railWidthOf,
  SafaehTransition? fadeScale,
  SafaehTransition? slideUp,
}) {
  final tokens = SafaehTheme.of(context);
  final resolvedMotion = safaehResolvedMotion(context, motion ?? tokens.motion);
  final theme = Theme.of(context);

  return showGeneralDialog<T>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: theme.colorScheme.scrim.withValues(alpha: 0.32),
    transitionDuration: resolvedMotion,
    pageBuilder: (ctx, animation, secondaryAnimation) {
      return _AdaptiveSheetHost(
        title: title,
        titleBuilder: titleBuilder,
        tabletTopBarAction: tabletTopBarAction,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        useSafeArea: useSafeArea,
        showDragHandle: showDragHandle,
        enableDrag: enableDrag,
        sheetShape: sheetShape,
        barrierDismissible: barrierDismissible,
        openAnimation: animation,
        contentPadding: contentPadding,
        tabletBreakpoint: tabletBreakpoint ?? tokens.tabletBreakpoint,
        dialogMaxWidth: dialogMaxWidth ?? tokens.dialogMaxWidth,
        motion: resolvedMotion,
        enterCurve: enterCurve ?? tokens.enterCurve,
        radius: tokens.radius,
        railWidthOf: railWidthOf,
        fadeScale: fadeScale,
        slideUp: slideUp,
        child: child,
      );
    },
    transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
  );
}

class _AdaptiveSheetHost extends StatelessWidget {
  const _AdaptiveSheetHost({
    required this.child,
    required this.barrierDismissible,
    required this.useSafeArea,
    required this.showDragHandle,
    required this.enableDrag,
    required this.openAnimation,
    required this.tabletBreakpoint,
    required this.dialogMaxWidth,
    required this.motion,
    required this.enterCurve,
    required this.radius,
    this.title,
    this.titleBuilder,
    this.tabletTopBarAction,
    this.maxWidth,
    this.maxHeight,
    this.sheetShape,
    this.contentPadding,
    this.railWidthOf,
    this.fadeScale,
    this.slideUp,
  });

  final Widget child;
  final bool barrierDismissible;
  final bool useSafeArea;
  final bool showDragHandle;
  final bool enableDrag;
  final Animation<double> openAnimation;
  final String? title;
  final SafaehTitleBuilder? titleBuilder;
  final Widget? tabletTopBarAction;
  final double? maxWidth;
  final double? maxHeight;
  final ShapeBorder? sheetShape;
  final EdgeInsetsGeometry? contentPadding;
  final double tabletBreakpoint;
  final double dialogMaxWidth;
  final Duration motion;
  final Curve enterCurve;
  final double radius;
  final double Function(BuildContext context)? railWidthOf;
  final SafaehTransition? fadeScale;
  final SafaehTransition? slideUp;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isWide = size.width >= tabletBreakpoint;
    final railWidth = isWide ? (railWidthOf?.call(context) ?? 0.0) : 0.0;

    final availableWidth = math.max(0.0, size.width - railWidth);
    final dialogMax = maxWidth ?? dialogMaxWidth;
    final panelWidth = isWide
        ? math.min(dialogMax, math.max(0.0, availableWidth - 48))
        : availableWidth;
    final heightCap = size.height * (isWide ? 0.85 : 0.92);
    final effectiveMaxHeight = math.min(maxHeight ?? heightCap, heightCap);

    final showTitle =
        (title != null && title!.isNotEmpty) || titleBuilder != null;
    const wideHeaderChromeHeight = 72.0;
    final chromeHeight = isWide
        ? wideHeaderChromeHeight
        : (showDragHandle ? 24.0 : 8.0);
    final bodyMaxHeight = math.max(0.0, effectiveMaxHeight - chromeHeight);

    final BorderRadius panelRadius = isWide
        ? BorderRadius.circular(radius)
        : BorderRadius.vertical(top: Radius.circular(radius));

    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    );
    final titleChild =
        titleBuilder?.call(context, titleStyle) ??
        (title != null
            ? Text(
                title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: titleStyle,
              )
            : null);

    final Widget header = isWide
        ? DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.45),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 12, 12),
              child: Row(
                children: [
                  if (showTitle && titleChild != null)
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 4),
                          child: titleChild,
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  if (tabletTopBarAction != null) ...[
                    Focus(
                      canRequestFocus: false,
                      skipTraversal: true,
                      descendantsAreFocusable: false,
                      child: tabletTopBarAction!,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Tooltip(
                    message: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    child: Material(
                      type: MaterialType.button,
                      color: Colors.transparent,
                      child: InkWell(
                        canRequestFocus: false,
                        onTap: () {
                          final navigator = Navigator.of(
                            context,
                            rootNavigator: true,
                          );
                          if (navigator.canPop()) navigator.pop(null);
                        },
                        customBorder: const CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.close,
                            size: 22,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : showDragHandle
        ? Padding(
            key: const ValueKey('safaeh_drag_handle'),
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          )
        : const SizedBox(height: 8);

    final Widget panelBody = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedSize(
          duration: motion,
          curve: enterCurve,
          alignment: Alignment.topCenter,
          child: header,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: bodyMaxHeight),
            child: FocusScope(
              autofocus: false,
              child: contentPadding != null
                  ? Padding(padding: contentPadding!, child: child)
                  : child,
            ),
          ),
        ),
      ],
    );

    final fill = cs.surfaceContainerLow;
    final outline = cs.outlineVariant.withValues(alpha: 0.45);

    final Widget panel = sheetShape != null
        ? Material(
            key: const ValueKey('safaeh_panel'),
            color: fill,
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: sheetShape,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: effectiveMaxHeight),
              child: panelBody,
            ),
          )
        : ConstrainedBox(
            constraints: BoxConstraints(maxHeight: effectiveMaxHeight),
            child: AnimatedContainer(
              key: const ValueKey('safaeh_panel'),
              duration: motion,
              curve: enterCurve,
              width: panelWidth,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: fill, borderRadius: panelRadius),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: panelRadius,
                  border: Border.all(color: outline),
                ),
                child: Material(color: Colors.transparent, child: panelBody),
              ),
            ),
          );

    Widget sheet = sheetShape != null
        ? ConstrainedBox(
            constraints: BoxConstraints(maxWidth: panelWidth),
            child: panel,
          )
        : panel;
    if (!isWide && enableDrag) {
      sheet = _PhoneSheetDragDismiss(
        motion: motion,
        enterCurve: enterCurve,
        child: sheet,
      );
    }

    final alignedPanel = AnimatedPadding(
      duration: motion,
      curve: enterCurve,
      padding: isWide
          ? const EdgeInsets.symmetric(horizontal: 24, vertical: 24)
          : EdgeInsets.zero,
      child: AnimatedAlign(
        duration: motion,
        curve: enterCurve,
        alignment: isWide ? Alignment.center : Alignment.bottomCenter,
        child: sheet,
      ),
    );

    // Call the transition once. Wrapping another AnimatedBuilder here nested
    // with Hisab's fade/slide builders and doubled work on every tick.
    final entering = isWide
        ? (fadeScale ?? _defaultFadeScale)(
            animation: openAnimation,
            child: alignedPanel,
          )
        : (slideUp ?? _defaultSlideUp)(
            animation: openAnimation,
            child: alignedPanel,
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
            child: SafeArea(
              top: useSafeArea && isWide,
              bottom: useSafeArea && !isWide && viewInsets.bottom <= 0,
              left: false,
              right: false,
              child: entering,
            ),
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

Widget _defaultSlideUp({
  required Animation<double> animation,
  required Widget child,
}) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final t = Curves.easeOutCubic.transform(animation.value.clamp(0.0, 1.0));
      return Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 56),
          child: child,
        ),
      );
    },
    child: child,
  );
}

class _PhoneSheetDragDismiss extends StatefulWidget {
  const _PhoneSheetDragDismiss({
    required this.child,
    required this.motion,
    required this.enterCurve,
  });

  final Widget child;
  final Duration motion;
  final Curve enterCurve;

  @override
  State<_PhoneSheetDragDismiss> createState() => _PhoneSheetDragDismissState();
}

class _PhoneSheetDragDismissState extends State<_PhoneSheetDragDismiss>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<double> _dy = ValueNotifier<double>(0);
  late final AnimationController _snap;
  Animation<double>? _snapAnim;

  @override
  void initState() {
    super.initState();
    _snap = AnimationController(vsync: this, duration: widget.motion)
      ..addListener(_onSnapTick);
  }

  void _onSnapTick() {
    final anim = _snapAnim;
    if (anim != null) _dy.value = anim.value;
  }

  @override
  void dispose() {
    _snap.removeListener(_onSnapTick);
    _snap.dispose();
    _dy.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _snap.stop();
    _snapAnim = null;
    final maxDy = MediaQuery.sizeOf(context).height;
    final next = (_dy.value + (details.primaryDelta ?? details.delta.dy)).clamp(
      0.0,
      maxDy,
    );
    if (next != _dy.value) _dy.value = next;
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (_dy.value >= SheetHandleDrag.dismissDistance ||
        velocity >= SheetHandleDrag.flingVelocity) {
      _tryDismiss();
      return;
    }
    _snapBack();
  }

  void _onDragCancel() {
    if (_dy.value > 0) _snapBack();
  }

  Future<void> _tryDismiss() async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final popped = await navigator.maybePop();
    if (!popped && mounted && _dy.value > 0) {
      _snapBack();
    }
  }

  void _snapBack() {
    final begin = _dy.value;
    if (begin == 0) return;
    _snap.duration = safaehResolvedMotion(context, widget.motion);
    _snapAnim = Tween<double>(
      begin: begin,
      end: 0,
    ).animate(CurvedAnimation(parent: _snap, curve: widget.enterCurve));
    _snap
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      excludeFromSemantics: true,
      gestures: <Type, GestureRecognizerFactory<GestureRecognizer>>{
        VerticalDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(debugOwner: this),
              (VerticalDragGestureRecognizer instance) {
                instance
                  ..onUpdate = _onDragUpdate
                  ..onEnd = _onDragEnd
                  ..onCancel = _onDragCancel
                  ..onlyAcceptDragOnThreshold = true;
              },
            ),
      },
      child: ValueListenableBuilder<double>(
        valueListenable: _dy,
        builder: (context, dy, child) {
          return Transform.translate(offset: Offset(0, dy), child: child);
        },
        child: widget.child,
      ),
    );
  }
}
