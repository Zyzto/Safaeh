import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safaeh/safaeh.dart';
import 'package:safaeh_example/app.dart';
import 'package:safaeh_example/catalog.dart';
import 'package:safaeh_example/pages.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

String _t(String key) => translateCatalog(key, 'en');

String _imagePath(String name) {
  final testDir = Directory.current.path;
  final root = testDir.endsWith('example')
      ? Directory.current.parent.path
      : testDir;
  return '$root/screenshots/$name.png';
}

Future<void> _capture(
  WidgetTester tester, {
  required String name,
  required Size size,
  required Widget child,
}) async {
  final controller = WidgetsToImageController();
  tester.view.physicalSize = Size(size.width * 2, size.height * 2);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final theme = catalogTheme(Brightness.light);
  await tester.pumpWidget(
    WidgetsToImage(
      controller: controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: SafaehTheme(
          data: const SafaehThemeData(),
          child: ColoredBox(
            color: theme.colorScheme.surface,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.runAsync(() async {
    final bytes = await controller.capturePng(pixelRatio: 2);
    expect(bytes, isNotNull);
    expect(bytes, isNotEmpty);
    final file = File(_imagePath(name));
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!);
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('card picker image', (tester) async {
    await _capture(
      tester,
      name: 'picker',
      size: const Size(390, 280),
      child: CardPickerDemo(t: _t),
    );
  });

  testWidgets('confirm sheet image', (tester) async {
    await _capture(
      tester,
      name: 'confirm',
      size: const Size(390, 240),
      child: ConfirmDemo(t: _t),
    );
  });

  testWidgets('option tiles image', (tester) async {
    await _capture(
      tester,
      name: 'option-tiles',
      size: const Size(390, 300),
      child: OptionTilesDemo(t: _t),
    );
  });

  testWidgets('sidenav rail image', (tester) async {
    await _capture(
      tester,
      name: 'sidenav',
      size: const Size(720, 400),
      child: SizedBox(height: 360, child: SidenavRailDemo(t: _t)),
    );
  });
}
