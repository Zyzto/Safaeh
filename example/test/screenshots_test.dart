import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'screenshot_harness.dart';

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
    await tester.tap(find.byKey(const ValueKey('catalog_picker')));
    await tester.pumpAndSettle();
    await saveScreenshot(tester, 'picker-en');
  });

  testWidgets('sidenav English', (tester) async {
    await pumpExampleApp(tester);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('catalog_sidenav')),
      240,
    );
    await tester.tap(find.byKey(const ValueKey('catalog_sidenav')));
    await tester.pumpAndSettle();
    await saveScreenshot(tester, 'sidenav-en');
  });

  testWidgets('page index overlay English', (tester) async {
    await pumpExampleApp(tester);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('catalog_page_index_overlay')),
      240,
    );
    await tester.tap(find.byKey(const ValueKey('catalog_page_index_overlay')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('On this page'));
    await tester.pumpAndSettle();
    await saveScreenshot(tester, 'page-index-en');
  });
}
