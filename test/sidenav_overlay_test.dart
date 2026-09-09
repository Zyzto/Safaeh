import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safaeh/safaeh.dart';

void main() {
  testWidgets('overlay sidenav preserves host space and uses its surface', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const hostKey = ValueKey('overlay_nav_host');
    const navKey = ValueKey('overlay_nav');
    final appearance = SafaehFloatingAppearance(
      style: SafaehFloatingSurfaceStyle.glass,
    );
    var collapsed = true;

    await tester.pumpWidget(
      MaterialApp(
        home: SafaehTheme(
          data: SafaehThemeData(floatingAppearance: appearance),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  const SizedBox.expand(
                    key: hostKey,
                    child: ColoredBox(color: Colors.blue),
                  ),
                  SafaehSidenav(
                    overlay: true,
                    collapsed: collapsed,
                    railKey: navKey,
                    onToggleCompact: () =>
                        setState(() => collapsed = !collapsed),
                    title: 'Safaeh',
                    selectedIndex: 0,
                    onDestinationSelected: (_) {},
                    destinations: const [
                      SafaehSidenavDestination(
                        label: 'Groups',
                        icon: Icons.group_outlined,
                        selectedIcon: Icons.group,
                      ),
                    ],
                    profile: SafaehSidenavProfile(
                      label: 'Ada Lovelace',
                      subtitle: 'ada@example.com',
                      onTap: _noop,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(tester.getSize(find.byKey(hostKey)).width, 800);
    expect(tester.getSize(find.byKey(navKey)).width, 72);
    final collapsedDestinationHeight = tester
        .getSize(find.byKey(const ValueKey('safaeh_nav_0')))
        .height;
    final collapsedProfileHeight = tester
        .getSize(find.byKey(const ValueKey('safaeh_nav_profile')))
        .height;

    await tester.tap(find.byKey(const ValueKey('safaeh_nav_expand')));
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byKey(hostKey)).width, 800);
    expect(tester.getSize(find.byKey(navKey)).width, 240);
    expect(
      tester.getSize(find.byKey(const ValueKey('safaeh_nav_0'))).height,
      closeTo(collapsedDestinationHeight, 0.01),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('safaeh_nav_profile'))).height,
      closeTo(collapsedProfileHeight, 0.01),
    );
    expect(find.text('Groups'), findsOneWidget);
  });
}

void _noop() {}
