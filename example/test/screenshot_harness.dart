import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safaeh_example/app.dart';

const screenshotSize = Size(390, 844);

Future<void> pumpExampleApp(
  WidgetTester tester, {
  String language = 'en',
  ThemeMode themeMode = ThemeMode.light,
  Size size = screenshotSize,
}) async {
  tester.view.physicalSize = Size(size.width * 2, size.height * 2);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    RepaintBoundary(
      key: const ValueKey('screenshot_root'),
      child: SafaehExampleApp(
        initialLocale: language,
        initialThemeMode: themeMode,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> saveScreenshot(WidgetTester tester, String name) async {
  await tester.pumpAndSettle();
  await tester.runAsync(() async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey('screenshot_root')),
    );
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) {
      fail('Failed to encode $name.png');
    }
    final file = File(_screenshotPath(name));
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes.buffer.asUint8List());
  });
}

String _screenshotPath(String name) {
  final testDir = Directory.current.path;
  final root = testDir.endsWith('example')
      ? Directory.current.parent.path
      : testDir;
  return '$root/screenshots/$name.png';
}
