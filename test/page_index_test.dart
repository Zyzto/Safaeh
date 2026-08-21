import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safaeh/safaeh.dart';

void main() {
  testWidgets('SafaehPageIndex lists entries and reports selection', (
    tester,
  ) async {
    final alpha = GlobalKey();
    final beta = GlobalKey();
    String? active = 'alpha';
    final entries = [
      SafaehPageIndexEntry(id: 'alpha', label: 'Alpha', key: alpha),
      SafaehPageIndexEntry(id: 'beta', label: 'Beta', key: beta),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return SafaehPageIndex(
                title: 'On this page',
                entries: entries,
                activeId: active,
                onSelect: (entry) => setState(() => active = entry.id),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('On this page'), findsOneWidget);
    expect(find.text('Alpha'), findsOneWidget);
    await tester.tap(find.text('Beta'));
    await tester.pump();
    expect(active, 'beta');
  });

  testWidgets('SafaehPageIndexOverlay opens the panel', (tester) async {
    final alpha = GlobalKey();
    final entries = [
      SafaehPageIndexEntry(id: 'alpha', label: 'Alpha section', key: alpha),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              const SizedBox.expand(),
              SafaehPageIndexOverlay(
                title: 'On this page',
                entries: entries,
                activeId: 'alpha',
                onSelect: (_) {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Alpha section'), findsOneWidget);
    await tester.tap(find.text('On this page').first);
    await tester.pumpAndSettle();
    expect(find.text('Alpha section'), findsWidgets);
  });

  testWidgets('scrollToPageSection reveals a section key', (tester) async {
    final target = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              const SizedBox(height: 500, child: Text('above')),
              SizedBox(key: target, height: 80, child: const Text('section-z')),
              const SizedBox(height: 500),
            ],
          ),
        ),
      ),
    );

    await scrollToPageSection(target, ensureDuration: Duration.zero);
    await tester.pumpAndSettle();
    expect(find.text('section-z'), findsOneWidget);
    expect(tester.getTopLeft(find.text('section-z')).dy, lessThan(600));
  });

  testWidgets('safaehActivePageSectionId follows the viewport', (tester) async {
    final alpha = GlobalKey();
    final beta = GlobalKey();
    final scrollKey = GlobalKey();
    final controller = ScrollController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            key: scrollKey,
            controller: controller,
            children: [
              SizedBox(key: alpha, height: 400, child: const Text('A')),
              SizedBox(key: beta, height: 400, child: const Text('B')),
              const SizedBox(height: 800),
            ],
          ),
        ),
      ),
    );

    final scrollContext = tester.element(find.byKey(scrollKey));
    expect(
      safaehActivePageSectionId(
        sections: [('alpha', alpha), ('beta', beta)],
        scrollContext: scrollContext,
      ),
      'alpha',
    );

    controller.jumpTo(360);
    await tester.pumpAndSettle();
    expect(
      safaehActivePageSectionId(
        sections: [('alpha', alpha), ('beta', beta)],
        scrollContext: scrollContext,
        activationOffset: 96,
      ),
      'beta',
    );
  });

  testWidgets('empty page index and overlay shrink away', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              SafaehPageIndex(
                title: 'On this page',
                entries: [],
                activeId: null,
                onSelect: _noopSelect,
              ),
              Expanded(
                child: SafaehPageIndexOverlay(
                  title: 'On this page',
                  entries: [],
                  activeId: null,
                  onSelect: _noopSelect,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('On this page'), findsNothing);
  });
}

void _noopSelect(SafaehPageIndexEntry entry) {}
