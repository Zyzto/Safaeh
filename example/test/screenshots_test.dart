import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('catalog English light', (tester) async {
    await pumpExampleApp(tester);
    await saveScreenshot(tester, 'catalog-en');
  });

  testWidgets('catalog English dark', (tester) async {
    await pumpExampleApp(tester, themeMode: ThemeMode.dark);
    await saveScreenshot(tester, 'catalog-en-dark');
  });

  testWidgets('catalog Arabic light', (tester) async {
    await pumpExampleApp(tester, language: 'ar');
    await saveScreenshot(tester, 'catalog-ar');
  });

  testWidgets('catalog Arabic dark', (tester) async {
    await pumpExampleApp(tester, language: 'ar', themeMode: ThemeMode.dark);
    await saveScreenshot(tester, 'catalog-ar-dark');
  });

  testWidgets('picker English', (tester) async {
    await pumpExampleApp(tester);
    await _reveal(tester, 'picker');
    await saveScreenshot(tester, 'picker-en');
  });

  testWidgets('sidenav English', (tester) async {
    await pumpExampleApp(tester);
    await _reveal(tester, 'sidenav');
    await saveScreenshot(tester, 'sidenav-en');
  });

  testWidgets('page index overlay English', (tester) async {
    await pumpExampleApp(tester);
    await _reveal(tester, 'page_index_overlay');
    await tester.tap(find.text('On this page').last);
    await tester.pumpAndSettle();
    await saveScreenshot(tester, 'page-index-en');
  });
}
