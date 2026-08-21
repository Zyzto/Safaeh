import 'package:flutter/material.dart';

/// Compact fraction of screen height for camera / QR sheets (60–70% band).
const double kSafaehCameraCompactHeightFraction = 0.65;

/// Tokens for safaeh chrome. Override via [SafaehTheme] at the app root.
class SafaehThemeData {
  const SafaehThemeData({
    this.tabletBreakpoint = 600,
    this.dialogMaxWidth = 560,
    this.motion = const Duration(milliseconds: 320),
    this.enterCurve = Curves.easeOutCubic,
    this.radius = 16,
    this.compactNavWidth = 72,
    this.expandedNavWidth = 240,
    this.navMotion = const Duration(milliseconds: 280),
    this.pageIndexMotion = const Duration(milliseconds: 200),
    this.sheetRoll = const Duration(milliseconds: 420),
    this.sheetRollEnter = const Cubic(0.18, 0.7, 0.2, 1.0),
    this.exitCurve = Curves.easeInCubic,
    this.cameraCompactHeightFraction = kSafaehCameraCompactHeightFraction,
    this.contentMaxWidth = 600,
  });

  static const fallback = SafaehThemeData();

  final double tabletBreakpoint;
  final double dialogMaxWidth;
  final Duration motion;
  final Curve enterCurve;
  final double radius;
  final double compactNavWidth;
  final double expandedNavWidth;
  final Duration navMotion;
  final Duration pageIndexMotion;
  final Duration sheetRoll;
  final Curve sheetRollEnter;
  final Curve exitCurve;
  final double cameraCompactHeightFraction;

  /// Max width of the simple content band on wide viewports. Hosts with a shell
  /// rail (Hisab) keep their own band metrics and only use this as a token.
  final double contentMaxWidth;

  /// Copies this theme, replacing any non-null arguments.
  SafaehThemeData copyWith({
    double? tabletBreakpoint,
    double? dialogMaxWidth,
    Duration? motion,
    Curve? enterCurve,
    double? radius,
    double? compactNavWidth,
    double? expandedNavWidth,
    Duration? navMotion,
    Duration? pageIndexMotion,
    Duration? sheetRoll,
    Curve? sheetRollEnter,
    Curve? exitCurve,
    double? cameraCompactHeightFraction,
    double? contentMaxWidth,
  }) {
    return SafaehThemeData(
      tabletBreakpoint: tabletBreakpoint ?? this.tabletBreakpoint,
      dialogMaxWidth: dialogMaxWidth ?? this.dialogMaxWidth,
      motion: motion ?? this.motion,
      enterCurve: enterCurve ?? this.enterCurve,
      radius: radius ?? this.radius,
      compactNavWidth: compactNavWidth ?? this.compactNavWidth,
      expandedNavWidth: expandedNavWidth ?? this.expandedNavWidth,
      navMotion: navMotion ?? this.navMotion,
      pageIndexMotion: pageIndexMotion ?? this.pageIndexMotion,
      sheetRoll: sheetRoll ?? this.sheetRoll,
      sheetRollEnter: sheetRollEnter ?? this.sheetRollEnter,
      exitCurve: exitCurve ?? this.exitCurve,
      cameraCompactHeightFraction:
          cameraCompactHeightFraction ?? this.cameraCompactHeightFraction,
      contentMaxWidth: contentMaxWidth ?? this.contentMaxWidth,
    );
  }

  bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SafaehThemeData &&
            tabletBreakpoint == other.tabletBreakpoint &&
            dialogMaxWidth == other.dialogMaxWidth &&
            motion == other.motion &&
            enterCurve == other.enterCurve &&
            radius == other.radius &&
            compactNavWidth == other.compactNavWidth &&
            expandedNavWidth == other.expandedNavWidth &&
            navMotion == other.navMotion &&
            pageIndexMotion == other.pageIndexMotion &&
            sheetRoll == other.sheetRoll &&
            sheetRollEnter == other.sheetRollEnter &&
            exitCurve == other.exitCurve &&
            cameraCompactHeightFraction == other.cameraCompactHeightFraction &&
            contentMaxWidth == other.contentMaxWidth;
  }

  @override
  int get hashCode => Object.hash(
    tabletBreakpoint,
    dialogMaxWidth,
    motion,
    enterCurve,
    radius,
    compactNavWidth,
    expandedNavWidth,
    navMotion,
    pageIndexMotion,
    sheetRoll,
    sheetRollEnter,
    exitCurve,
    cameraCompactHeightFraction,
    contentMaxWidth,
  );
}

/// Provides [SafaehThemeData] to sheets, page index, and sidenav.
class SafaehTheme extends InheritedWidget {
  const SafaehTheme({super.key, required this.data, required super.child});

  final SafaehThemeData data;

  static SafaehThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SafaehTheme>()?.data ??
        SafaehThemeData.fallback;
  }

  static SafaehThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SafaehTheme>()?.data;
  }

  @override
  bool updateShouldNotify(SafaehTheme oldWidget) => data != oldWidget.data;
}

/// Zero when the platform has asked to disable animations.
Duration safaehResolvedMotion(BuildContext context, Duration motion) {
  if (MediaQuery.disableAnimationsOf(context)) return Duration.zero;
  return motion;
}
