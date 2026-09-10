import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safaeh/safaeh.dart';
import 'package:toastification/toastification.dart';

void main() {
  tearDown(() {
    // The underlying toast manager is a singleton shared by widget tests.
    toastification.dismissAll(delayForAnimation: false);
  });

  testWidgets('feedback host renders shared messages and actions', (
    tester,
  ) async {
    var actionCount = 0;
    await tester.pumpWidget(
      SafaehFeedbackHost(
        child: MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => context.showSafaehFeedbackWithAction(
                'Deleted',
                actionLabel: 'Undo',
                onAction: () => actionCount++,
              ),
              child: const Text('Show'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Deleted', skipOffstage: false), findsOneWidget);
    expect(find.text('Undo', skipOffstage: false), findsOneWidget);
    await tester.tap(find.text('Undo', skipOffstage: false));
    expect(actionCount, 1);
    await tester.pumpAndSettle();
    expect(find.text('Deleted', skipOffstage: false), findsNothing);
  });

  testWidgets('custom feedback receives a dismissal callback', (tester) async {
    await tester.pumpWidget(
      SafaehFeedbackHost(
        child: MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => context.showSafaehCustomFeedback(
                builder: (context, dismiss) => TextButton(
                  onPressed: dismiss,
                  child: const Text('Close feedback'),
                ),
              ),
              child: const Text('Show'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Close feedback', skipOffstage: false), findsOneWidget);

    await tester.tap(find.text('Close feedback', skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.text('Close feedback', skipOffstage: false), findsNothing);
  });
}
