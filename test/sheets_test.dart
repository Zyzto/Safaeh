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
}
