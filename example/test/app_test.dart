import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safaeh_example/catalog.dart';
import 'package:safaeh_example/gallery.dart';

import 'screenshot_harness.dart';

Future<void> _reveal(WidgetTester tester, String id) async {
  final section = find.byKey(ValueKey('catalog_$id'));
  final gallery = tester.state<CatalogGalleryState>(
    find.byType(CatalogGallery),
  );
  final controller = gallery.controller;
  if (section.evaluate().isEmpty && controller.offset > 0) {
    controller.jumpTo(0);
    await tester.pumpAndSettle();
  }
  for (var i = 0; i < 48 && section.evaluate().isEmpty; i++) {
    final next = (controller.offset + 280).clamp(
      0.0,
      controller.position.maxScrollExtent,
    );
    if (next == controller.offset) break;
    controller.jumpTo(next);
    await tester.pumpAndSettle();
  }
  expect(section, findsOneWidget);
  await tester.ensureVisible(section);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('catalog lists every public chrome entry', (tester) async {
    await pumpExampleApp(tester);

    expect(find.text('Safaeh'), findsWidgets);
    for (final item in catalogItems) {
      await _reveal(tester, item.id);
      expect(find.text(translateCatalog(item.titleKey, 'en')), findsWidgets);
    }
  });

  testWidgets('language toggle switches the catalog to Arabic', (tester) async {
    await pumpExampleApp(tester);

    expect(find.byIcon(Icons.language_outlined), findsOneWidget);
    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('language_toggle')));
    await tester.pumpAndSettle();

    expect(find.text('صفائح'), findsWidgets);
    expect(find.text('ورقة متكيفة'), findsOneWidget);
    expect(find.text('Adaptive sheet'), findsNothing);
  });

  testWidgets('sheet, picker, confirm, and dialog are visible inline', (
    tester,
  ) async {
    await pumpExampleApp(tester);

    expect(find.byKey(const ValueKey('safaeh_panel')), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);

    await _reveal(tester, 'picker');
    expect(find.text('How to settle'), findsOneWidget);
    expect(find.text('Minimal'), findsOneWidget);

    await _reveal(tester, 'confirm');
    expect(find.text('This cannot be undone.'), findsOneWidget);
    expect(find.byKey(const ValueKey('safaeh_confirm')), findsOneWidget);

    await _reveal(tester, 'dialog');
    expect(find.text('showSafaehDialog'), findsWidgets);
  });

  testWidgets('tile picker shows header and skips a disabled row', (
    tester,
  ) async {
    await pumpExampleApp(tester);

    await _reveal(tester, 'tile_picker');
    expect(find.text('Choose account'), findsWidgets);
    expect(find.text('Custom header above the list'), findsOneWidget);
    expect(find.text('Offline'), findsOneWidget);

    await tester.tap(find.text('Offline'));
    await tester.pump();
    expect(find.text('Offline'), findsOneWidget);

    await tester.tap(find.text('Card'));
    await tester.pumpAndSettle();
    expect(find.text('Offline'), findsOneWidget);
  });

  testWidgets('sheet shell, option tiles, and morph stay on the gallery', (
    tester,
  ) async {
    await pumpExampleApp(tester);

    await _reveal(tester, 'sheet_shell');
    expect(find.text('Shared title, body, and action row.'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);

    await _reveal(tester, 'option_tiles');
    expect(find.text('Selected'), findsOneWidget);
    expect(find.text('Disabled'), findsOneWidget);
    expect(find.text('Destructive'), findsOneWidget);

    await _reveal(tester, 'sheet_morph');
    expect(find.text('400'), findsOneWidget);
    expect(find.text('900'), findsOneWidget);
    expect(find.text('Phone sheet ↔ tablet dialog'), findsWidgets);
  });

  testWidgets('sidenav rail, drawer, and floating nav', (tester) async {
    await pumpExampleApp(tester);

    await _reveal(tester, 'sidenav');
    expect(find.text('Toggle the rail chevron'), findsOneWidget);
    expect(find.byKey(const ValueKey('safaeh_nav_rail')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await _reveal(tester, 'sidenav_drawer');
    expect(find.byKey(const ValueKey('safaeh_nav_expand')), findsNothing);
    expect(find.text('Groups'), findsOneWidget);

    await _reveal(tester, 'floating_nav');
    expect(find.text('Selected 0'), findsOneWidget);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Selected 1'), findsOneWidget);
  });

  testWidgets('page index rail and overlay', (tester) async {
    await pumpExampleApp(tester);

    await _reveal(tester, 'page_index');
    expect(find.text('Alpha'), findsWidgets);
    expect(find.text('On this page'), findsWidgets);

    await _reveal(tester, 'page_index_overlay');
    expect(find.text('On this page'), findsWidgets);
    expect(find.text('Beta'), findsWidgets);
  });

  testWidgets('content band, aside, and aligned chrome pages', (tester) async {
    await pumpExampleApp(tester);

    await _reveal(tester, 'content_band');
    expect(find.textContaining('SafaehContentBand'), findsOneWidget);

    await _reveal(tester, 'end_aside');
    expect(find.textContaining('SafaehEndAsideLayout'), findsOneWidget);

    await _reveal(tester, 'aligned_chrome');
    expect(find.text('Aligned title'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('camera host and QR chrome pages', (tester) async {
    await pumpExampleApp(tester);

    await _reveal(tester, 'camera');
    expect(find.text('Mock preview'), findsOneWidget);
    expect(find.byKey(const ValueKey('safaeh_camera_panel')), findsOneWidget);

    await _reveal(tester, 'qr_overlay');
    expect(find.text('Scan invite'), findsOneWidget);
    expect(find.text('Point at a code'), findsOneWidget);

    await _reveal(tester, 'qr_message');
    expect(find.text('Need camera permission'), findsOneWidget);
    expect(find.text('Open settings'), findsOneWidget);
  });

  testWidgets('theme toggle switches Material brightness', (tester) async {
    await pumpExampleApp(tester);

    expect(
      Theme.of(tester.element(find.text('Safaeh').first)).brightness,
      Brightness.light,
    );
    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_outlined), findsNothing);

    await tester.tap(find.byKey(const ValueKey('theme_toggle')));
    await tester.pumpAndSettle();

    expect(
      Theme.of(tester.element(find.text('Safaeh').first)).brightness,
      Brightness.dark,
    );
    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    expect(find.byIcon(Icons.light_mode_outlined), findsNothing);
  });

  testWidgets('toggles stay tappable over page-index overlay chrome', (
    tester,
  ) async {
    await pumpExampleApp(tester);

    await _reveal(tester, 'page_index_overlay');
    expect(find.text('On this page'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('language_toggle')));
    await tester.pumpAndSettle();
    expect(find.text('صفائح'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('theme_toggle')));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('صفائح').first)).brightness,
      Brightness.dark,
    );
  });
}
