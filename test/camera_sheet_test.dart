import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safaeh/safaeh.dart';

void main() {
  testWidgets('compact ↔ full height toggle animates panel height', (
    tester,
  ) async {
    const screenH = 800.0;
    tester.view.physicalSize = const Size(400, screenH);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: SafaehCameraSheetHost(
          builder: (context, sheet) => IconButton(
            key: const ValueKey('toggle'),
            onPressed: sheet.toggleExpanded,
            icon: Icon(
              sheet.expanded ? Icons.close_fullscreen : Icons.open_in_full,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final compactBox = tester.renderObject<RenderBox>(
      find.byKey(const ValueKey('safaeh_camera_panel')),
    );
    expect(
      compactBox.size.height,
      closeTo(screenH * kSafaehCameraCompactHeightFraction, 0.5),
    );

    await tester.tap(find.byKey(const ValueKey('toggle')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 320));
    await tester.pumpAndSettle();

    final fullBox = tester.renderObject<RenderBox>(
      find.byKey(const ValueKey('safaeh_camera_panel')),
    );
    expect(fullBox.size.height, closeTo(screenH, 0.5));
  });

  testWidgets('showSafaehCameraSheet rolls up and scrim dismisses', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showSafaehCameraSheet<void>(
              context: context,
              builder: (context, sheet) => const Center(child: Text('lens')),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('lens'), findsOneWidget);
    expect(find.byKey(const ValueKey('safaeh_camera_panel')), findsOneWidget);

    await tester.tapAt(const Offset(200, 20));
    await tester.pumpAndSettle();
    expect(find.text('lens'), findsNothing);
  });

  testWidgets('handle drag does not rebuild the preview builder', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var builds = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: SafaehCameraSheetHost(
          builder: (context, sheet) {
            builds++;
            return IconButton(
              key: const ValueKey('toggle'),
              onPressed: sheet.toggleExpanded,
              icon: const Icon(Icons.open_in_full),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    final afterMount = builds;

    await tester.drag(find.byType(SheetHandleBar), const Offset(0, 40));
    await tester.pump();
    expect(builds, afterMount);

    await tester.tap(find.byKey(const ValueKey('toggle')));
    await tester.pump();
    expect(builds, greaterThan(afterMount));
  });
}
