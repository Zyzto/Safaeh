import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safaeh/safaeh.dart';

void main() {
  Future<void> setPhone(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> setTablet(WidgetTester tester) async {
    tester.view.physicalSize = const Size(900, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('showSafaeh is a phone sheet that morphs into a tablet dialog', (
    tester,
  ) async {
    await setPhone(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showSafaeh<void>(
              context: context,
              title: 'Rename',
              child: const Padding(
                padding: kSheetContentPadding,
                child: Text('sheet-body'),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('sheet-body'), findsOneWidget);
    expect(find.byKey(const ValueKey('safaeh_drag_handle')), findsOneWidget);
    final handle = tester.widget<Container>(
      find.descendant(
        of: find.byKey(const ValueKey('safaeh_drag_handle')),
        matching: find.byType(Container),
      ),
    );
    final handleColor = (handle.decoration! as BoxDecoration).color!;
    expect(handleColor.a, equals(1.0));
    expect(find.byIcon(Icons.close), findsNothing);

    tester.view.physicalSize = const Size(900, 800);
    await tester.pumpAndSettle();
    expect(find.text('sheet-body'), findsOneWidget);
    expect(find.byKey(const ValueKey('safaeh_drag_handle')), findsNothing);
    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.text('Rename'), findsOneWidget);
  });

  testWidgets('tile picker header and disabled option stay put', (
    tester,
  ) async {
    await setPhone(tester);
    String? value;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              value = await showSafaehTilePicker<String>(
                context: context,
                title: 'Choose account',
                selected: 'cash',
                header: const Text('Custom header'),
                options: const [
                  SafaehTileOption(value: 'cash', label: 'Cash'),
                  SafaehTileOption(
                    value: 'offline',
                    label: 'Offline',
                    enabled: false,
                  ),
                ],
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Choose account'), findsWidgets);
    expect(find.text('Custom header'), findsOneWidget);

    await tester.tap(find.text('Offline'));
    await tester.pump();
    expect(value, isNull);
    expect(find.text('Offline'), findsOneWidget);

    await tester.tap(find.text('Cash'));
    await tester.pumpAndSettle();
    expect(value, 'cash');
  });

  testWidgets('buildSafaehSheetShell shows in-body title and actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: buildSafaehSheetShell(
            title: const Text('Shell title'),
            body: const Text('Shell body'),
            actions: [
              TextButton(onPressed: () {}, child: const Text('Cancel')),
              FilledButton(onPressed: () {}, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Shell title'), findsOneWidget);
    expect(find.text('Shell body'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('confirm tablet uses close chrome instead of cancel', (
    tester,
  ) async {
    await setTablet(tester);
    bool? result = true;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showSafaehConfirm(
                context: context,
                title: 'Delete?',
                content: 'Gone forever',
                confirmLabel: 'Delete',
                cancelLabel: 'Cancel',
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('safaeh_cancel')), findsNothing);
    expect(find.byKey(const ValueKey('safaeh_confirm')), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(result, isNull);
  });

  testWidgets('text input cancel pops null', (tester) async {
    await setPhone(tester);
    Object? value = 'pending';
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              value = await showSafaehTextInput(
                context: context,
                title: 'Tag',
                doneLabel: 'Done',
                cancelLabel: 'Cancel',
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('safaeh_cancel')));
    await tester.pumpAndSettle();
    expect(value, isNull);
  });

  testWidgets('picker disabled option does not pop', (tester) async {
    await setPhone(tester);
    int? value;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              value = await showSafaehPicker<int>(
                context: context,
                title: 'How to settle',
                selected: 1,
                options: const [
                  SafaehOption(
                    value: 1,
                    label: 'Minimal',
                    subtitle: 'Fewest transfers',
                    icon: Icons.bolt_outlined,
                  ),
                  SafaehOption(
                    value: 2,
                    label: 'Locked',
                    subtitle: 'Unavailable',
                    icon: Icons.lock_outline,
                    enabled: false,
                  ),
                ],
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Locked'));
    await tester.pump();
    expect(value, isNull);
    expect(find.text('Locked'), findsOneWidget);
  });

  testWidgets('sidenav drawer shows labels and has no expand chevron', (
    tester,
  ) async {
    var index = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: SafaehSidenav(
                asDrawer: true,
                title: 'Safaeh',
                selectedIndex: index,
                onDestinationSelected: (i) => setState(() => index = i),
                destinations: const [
                  SafaehSidenavDestination(
                    label: 'Groups',
                    icon: Icons.group_outlined,
                    selectedIcon: Icons.group,
                  ),
                  SafaehSidenavDestination(
                    label: 'Settings',
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings,
                  ),
                ],
                footer: const Text('v0.1.0'),
              ),
            );
          },
        ),
      ),
    );

    expect(find.byKey(const ValueKey('safaeh_nav_expand')), findsNothing);
    expect(find.byKey(const ValueKey('safaeh_nav_rail')), findsNothing);
    expect(find.text('Groups'), findsOneWidget);
    expect(find.text('v0.1.0'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pump();
    expect(index, 1);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('phone confirm body ignores status-bar SafeArea', (tester) async {
    await setPhone(tester);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(padding: const EdgeInsets.only(top: 47)),
            child: child!,
          );
        },
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showSafaehConfirm(
              context: context,
              title: 'Delete?',
              content: 'Gone forever',
              confirmLabel: 'Delete',
              cancelLabel: 'Cancel',
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    final panelTop = tester.getTopLeft(find.byKey(const ValueKey('safaeh_panel'))).dy;
    final titleTop = tester.getTopLeft(find.text('Delete?')).dy;
    expect(titleTop - panelTop, lessThan(60));
  });

  testWidgets('confirm, text, and tile bodies ignore status-bar inset', (
    tester,
  ) async {
    await setPhone(tester);
    const confirmKey = ValueKey('confirm-body');
    const textKey = ValueKey('text-body');
    const tileKey = ValueKey('tile-body');

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(padding: const EdgeInsets.only(top: 47)),
            child: child!,
          );
        },
        home: const Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                KeyedSubtree(
                  key: confirmKey,
                  child: SafaehConfirmSheet(
                    title: 'Delete?',
                    content: 'Gone forever',
                    confirmLabel: 'Delete',
                    cancelLabel: 'Cancel',
                  ),
                ),
                KeyedSubtree(
                  key: textKey,
                  child: SafaehTextInputSheet(
                    title: 'Tag',
                    doneLabel: 'Done',
                    cancelLabel: 'Cancel',
                  ),
                ),
                KeyedSubtree(
                  key: tileKey,
                  child: SafaehTilePickerBody<String>(
                    title: 'Choose',
                    tabletBreakpoint: 10000,
                    options: [
                      SafaehTileOption(value: 'a', label: 'Alpha'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    void expectNoStatusBarInset(Key host, Finder title) {
      final hostTop = tester.getTopLeft(find.byKey(host)).dy;
      final titleTop = tester.getTopLeft(title).dy;
      expect(
        titleTop - hostTop,
        lessThan(40),
        reason: '$title must not pick up MediaQuery.padding.top (47)',
      );
    }

    expectNoStatusBarInset(confirmKey, find.text('Delete?'));
    expectNoStatusBarInset(textKey, find.text('Tag'));
    expectNoStatusBarInset(tileKey, find.text('Choose'));
  });

  testWidgets('railWidthOf shifts the tablet dialog off the start rail', (
    tester,
  ) async {
    await setTablet(tester);
    late double withoutRail;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showSafaeh<void>(
              context: context,
              title: 'Rename',
              railWidthOf: (_) => 80,
              child: const Text('sheet-body'),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    final withRail = tester.getTopLeft(find.byKey(const ValueKey('safaeh_panel'))).dx;
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showSafaeh<void>(
              context: context,
              title: 'Rename',
              railWidthOf: (_) => 0,
              child: const Text('sheet-body'),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    withoutRail = tester.getTopLeft(find.byKey(const ValueKey('safaeh_panel'))).dx;
    expect(withRail, closeTo(withoutRail + 40, 8));
  });

  testWidgets('railWidthOf in RTL shifts the tablet dialog off the start edge', (
    tester,
  ) async {
    await setTablet(tester);
    Future<double> openWithRail(double rail) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => showSafaeh<void>(
                context: context,
                title: 'Rename',
                railWidthOf: (_) => rail,
                child: const Text('sheet-body'),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return tester.getTopLeft(find.byKey(const ValueKey('safaeh_panel'))).dx;
    }

    final withRail = await openWithRail(80);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    final withoutRail = await openWithRail(0);
    // Start inset is on the right in RTL, so the panel's left edge moves left.
    expect(withRail, closeTo(withoutRail - 40, 8));
  });

  testWidgets('phone sheet lists scroll; handle drag dismisses', (tester) async {
    await setPhone(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showSafaeh<void>(
              context: context,
              title: 'Rows',
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (var i = 0; i < 20; i++)
                    SizedBox(height: 48, child: Text('row-$i')),
                ],
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('safaeh_panel')), findsOneWidget);

    await tester.drag(find.text('row-3'), const Offset(0, -120));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('safaeh_panel')), findsOneWidget);

    await tester.drag(find.text('row-5'), const Offset(0, 220));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('safaeh_panel')), findsOneWidget);

    await tester.drag(
      find.byKey(const ValueKey('safaeh_drag_handle')),
      const Offset(0, 220),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('safaeh_panel')), findsNothing);
  });

  testWidgets('sheet actions remain keyboard-focusable', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: buildSafaehSheetShell(
            title: const Text('Shell title'),
            body: const Text('Shell body'),
            actions: [
              TextButton(onPressed: () {}, child: const Text('Cancel')),
              FilledButton(onPressed: () {}, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );

    final node = Focus.maybeOf(tester.element(find.text('Save')));
    expect(node, isNotNull);
    expect(node!.canRequestFocus, isTrue);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SafaehConfirmSheet(
            title: 'Delete?',
            content: 'Gone forever',
            confirmLabel: 'Delete',
            cancelLabel: 'Cancel',
          ),
        ),
      ),
    );
    final ink = tester.widget<InkWell>(
      find.descendant(
        of: find.byKey(const ValueKey('safaeh_confirm')),
        matching: find.byType(InkWell),
      ),
    );
    expect(ink.canRequestFocus, isTrue);
  });
}
