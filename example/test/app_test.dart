import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safaeh_example/catalog.dart';

import 'screenshot_harness.dart';

Future<void> _open(WidgetTester tester, String id) async {
  final tile = find.byKey(ValueKey('catalog_$id'));
  final scrollable = find.byType(Scrollable).first;
  if (tile.evaluate().isEmpty) {
    final position = tester.state<ScrollableState>(scrollable).position;
    position.jumpTo(0);
    await tester.pumpAndSettle();
  }
  for (var i = 0; i < 24 && tile.evaluate().isEmpty; i++) {
    await tester.drag(scrollable, const Offset(0, -220));
    await tester.pumpAndSettle();
  }
  expect(tile, findsOneWidget);
  await tester.ensureVisible(tile);
  await tester.pumpAndSettle();
  await tester.tap(tile);
  await tester.pumpAndSettle();
}

Future<void> _pop(WidgetTester tester) async {
  final popped = await tester.binding.handlePopRoute();
  expect(popped, isTrue);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('catalog lists every public chrome entry', (tester) async {
    await pumpExampleApp(tester);

    expect(find.text('Safaeh'), findsOneWidget);
    for (final item in catalogItems) {
      final tile = find.byKey(ValueKey('catalog_${item.id}'));
      for (var i = 0; i < 24 && tile.evaluate().isEmpty; i++) {
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -220));
        await tester.pumpAndSettle();
      }
      expect(tile, findsOneWidget);
      expect(find.text(translateCatalog(item.titleKey, 'en')), findsWidgets);
    }
  });

  testWidgets('language toggle switches the catalog to Arabic', (tester) async {
    await pumpExampleApp(tester);

    await tester.tap(find.byKey(const ValueKey('language_toggle')));
    await tester.pumpAndSettle();

    expect(find.text('صفائح'), findsOneWidget);
    expect(find.text('ورقة متكيفة'), findsOneWidget);
    expect(find.text('Adaptive sheet'), findsNothing);
  });

  testWidgets('adaptive sheet, picker, confirm, and dialog open', (
    tester,
  ) async {
    await pumpExampleApp(tester);

    await _open(tester, 'sheet');
    expect(find.byKey(const ValueKey('safaeh_panel')), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    await tester.tapAt(const Offset(200, 20));
    await tester.pumpAndSettle();

    await _open(tester, 'picker');
    expect(find.text('How to settle'), findsWidgets);
    expect(find.text('Minimal'), findsOneWidget);
    await tester.tapAt(const Offset(200, 20));
    await tester.pumpAndSettle();

    await _open(tester, 'confirm');
    expect(find.text('This cannot be undone.'), findsOneWidget);
    expect(find.byKey(const ValueKey('safaeh_confirm')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('safaeh_cancel')));
    await tester.pumpAndSettle();

    await _open(tester, 'dialog');
    expect(find.text('showSafaehDialog'), findsWidgets);
  });

  testWidgets('tile picker shows header and skips a disabled row', (
    tester,
  ) async {
    await pumpExampleApp(tester);

    await _open(tester, 'tile_picker');
    expect(find.text('Choose account'), findsWidgets);
    expect(find.text('Custom header above the list'), findsOneWidget);
    expect(find.text('Offline'), findsOneWidget);

    await tester.tap(find.text('Offline'));
    await tester.pump();
    expect(find.text('Offline'), findsOneWidget);

    await tester.tap(find.text('Card'));
    await tester.pumpAndSettle();
    expect(find.text('Offline'), findsNothing);
  });

  testWidgets('sheet shell, option tiles, and morph pages', (tester) async {
    await pumpExampleApp(tester);

    await _open(tester, 'sheet_shell');
    expect(find.text('Shared title, body, and action row.'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    await _pop(tester);

    await _open(tester, 'option_tiles');
    expect(find.text('Selected'), findsOneWidget);
    expect(find.text('Disabled'), findsOneWidget);
    expect(find.text('Destructive'), findsOneWidget);
    await _pop(tester);

    await _open(tester, 'sheet_morph');
    expect(find.text('400'), findsOneWidget);
    expect(find.text('900'), findsOneWidget);
    await tester.tap(find.text('Adaptive sheet').first);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('safaeh_panel')), findsOneWidget);
  });

  testWidgets('sidenav rail, drawer, and floating nav', (tester) async {
    await pumpExampleApp(tester);

    await _open(tester, 'sidenav');
    expect(find.text('Toggle the rail chevron'), findsOneWidget);
    expect(find.byKey(const ValueKey('safaeh_nav_rail')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    await _open(tester, 'sidenav_drawer');
    expect(find.byKey(const ValueKey('safaeh_nav_expand')), findsNothing);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text('Groups'), findsOneWidget);
    await tester.tap(find.text('Groups'));
    await tester.pumpAndSettle();
    await _pop(tester);

    await _open(tester, 'floating_nav');
    expect(find.text('Selected 0'), findsOneWidget);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Selected 1'), findsOneWidget);
  });

  testWidgets('page index rail and overlay', (tester) async {
    await pumpExampleApp(tester);

    await _open(tester, 'page_index');
    expect(find.text('Alpha'), findsWidgets);
    expect(find.text('On this page'), findsOneWidget);
    await _pop(tester);

    await _open(tester, 'page_index_overlay');
    expect(find.text('On this page'), findsOneWidget);
    await tester.tap(find.text('On this page'));
    await tester.pumpAndSettle();
    expect(find.text('Beta'), findsWidgets);
  });

  testWidgets('content band, aside, and aligned chrome pages', (tester) async {
    await pumpExampleApp(tester);

    await _open(tester, 'content_band');
    expect(find.textContaining('SafaehContentBand'), findsOneWidget);
    await _pop(tester);

    await _open(tester, 'end_aside');
    expect(find.textContaining('SafaehEndAsideLayout'), findsOneWidget);
    await _pop(tester);

    await _open(tester, 'aligned_chrome');
    expect(find.text('Aligned title'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('camera host and QR chrome pages', (tester) async {
    await pumpExampleApp(tester);

    await _open(tester, 'camera');
    expect(find.text('Mock preview'), findsOneWidget);
    expect(find.byKey(const ValueKey('safaeh_camera_panel')), findsOneWidget);
    await tester.tapAt(const Offset(200, 20));
    await tester.pumpAndSettle();

    await _open(tester, 'qr_overlay');
    expect(find.text('Scan invite'), findsOneWidget);
    expect(find.text('Point at a code'), findsOneWidget);
    await _pop(tester);

    await _open(tester, 'qr_message');
    expect(find.text('Need camera permission'), findsOneWidget);
    expect(find.text('Open settings'), findsOneWidget);
  });

  testWidgets('theme toggle switches Material brightness', (tester) async {
    await pumpExampleApp(tester);

    expect(
      Theme.of(tester.element(find.text('Safaeh'))).brightness,
      Brightness.light,
    );

    await tester.tap(find.byKey(const ValueKey('theme_toggle')));
    await tester.pumpAndSettle();

    expect(
      Theme.of(tester.element(find.text('Safaeh'))).brightness,
      Brightness.dark,
    );
  });
}
