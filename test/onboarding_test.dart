import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safaeh/safaeh.dart';

Widget _host(Widget child) {
  return MaterialApp(
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    home: Scaffold(body: child),
  );
}

List<SafaehOnboardingStep> _steps() => [
  SafaehOnboardingStep(
    id: 'welcome',
    titleBuilder: (_) => const Text('Welcome'),
    subtitleBuilder: (_) => const Text('A short introduction.'),
    bodyBuilder: (_) => const SafaehOnboardingList(
      children: [
        SafaehOnboardingListItem(
          title: Text('Groups'),
          subtitle: Text('Keep shared work together.'),
          leading: Icon(Icons.groups_outlined),
        ),
      ],
    ),
  ),
  SafaehOnboardingStep(
    id: 'finish',
    titleBuilder: (_) => const Text('Ready'),
    bodyBuilder: (_) => const Text('Finish setup.'),
  ),
];

void main() {
  test('catalog exposes six stable public designs', () {
    expect(SafaehOnboardingDesign.values, hasLength(6));
    expect(SafaehOnboardingDesignCatalog.all, hasLength(6));
    expect(
      SafaehOnboardingDesignCatalog.all.map((info) => info.id),
      orderedEquals(['meadow', 'orbit', 'paper', 'atelier', 'zen', 'prism']),
    );
    expect(
      SafaehOnboardingDesignCatalog.tryParse('orbit'),
      SafaehOnboardingDesign.orbit,
    );
    expect(SafaehOnboardingDesignCatalog.tryParse('missing'), isNull);
  });

  testWidgets('catalog previews are independently renderable', (tester) async {
    for (final info in SafaehOnboardingDesignCatalog.all) {
      await tester.pumpWidget(_host(Builder(builder: info.previewBuilder)));
      await tester.pumpAndSettle();
      expect(find.text(info.displayName), findsOneWidget, reason: info.id);
    }
  });

  testWidgets('every design renders the public onboarding shell', (
    tester,
  ) async {
    for (final design in SafaehOnboardingDesign.values) {
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 480,
            height: 760,
            child: SafaehOnboarding(
              key: ValueKey(design),
              design: design,
              steps: _steps(),
              actions: SafaehOnboardingHostActions(
                languageControl: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.language),
                ),
                themeControl: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.brightness_6),
                ),
                onComplete: () async => SafaehOnboardingResult.completed,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Welcome'), findsOneWidget, reason: design.name);
      expect(find.bySemanticsLabel('Step 1 of 2'), findsWidgets);
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Ready'), findsOneWidget);
    }
  });

  testWidgets('host can switch designs without losing the current step', (
    tester,
  ) async {
    var design = SafaehOnboardingDesign.meadow;
    await tester.pumpWidget(
      _host(
        StatefulBuilder(
          builder: (context, setState) => SizedBox(
            width: 480,
            height: 760,
            child: Column(
              children: [
                Expanded(
                  child: SafaehOnboarding(
                    key: const ValueKey('flow'),
                    design: design,
                    initialStep: 1,
                    steps: _steps(),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      setState(() => design = SafaehOnboardingDesign.prism),
                  child: const Text('Switch'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ready'), findsOneWidget);
    await tester.tap(find.text('Switch'));
    await tester.pumpAndSettle();
    expect(find.text('Ready'), findsOneWidget);
  });

  testWidgets('auth presentation supports every design', (tester) async {
    for (final design in SafaehOnboardingDesign.values) {
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 480,
            height: 760,
            child: SafaehAuthFlow(
              design: design,
              actions: SafaehAuthActions(
                onSubmit: (_) async {},
                onProvider: (_) async {},
                onMagicLink: (_) async {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
    }
  });

  testWidgets('all generic auth states support every design', (tester) async {
    const modes = SafaehAuthMode.values;
    for (final design in SafaehOnboardingDesign.values) {
      for (final mode in modes) {
        await tester.pumpWidget(
          _host(
            SizedBox(
              width: 480,
              height: 760,
              child: SafaehAuthFlow(
                key: ValueKey('$design-$mode'),
                design: design,
                snapshot: SafaehAuthSnapshot(
                  mode: mode,
                  pendingEmail: 'person@example.com',
                ),
                actions: SafaehAuthActions(
                  onSubmit: (_) async {},
                  onProfileSubmit: (_) async {},
                  onProvider: (_) async {},
                  onMagicLink: (_) async {},
                  onPasswordReset: (_) async {},
                  onResend: () async {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(SafaehAuthFlow), findsOneWidget, reason: mode.name);
      }
    }
  });

  testWidgets('localized RTL and accessibility settings remain usable', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: MediaQuery(
          data: const MediaQueryData(
            textScaler: TextScaler.linear(1.35),
            disableAnimations: true,
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: SizedBox(
                width: 480,
                height: 760,
                child: SafaehOnboarding(
                  steps: _steps(),
                  labels: const SafaehOnboardingLabels(
                    back: 'رجوع',
                    next: 'التالي',
                    complete: 'تم',
                  ),
                  actions: SafaehOnboardingHostActions(
                    onComplete: () async => SafaehOnboardingResult.completed,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('التالي'), findsOneWidget);
    expect(find.bySemanticsLabel('Step 1 of 2'), findsWidgets);
  });
}
