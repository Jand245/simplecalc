import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simplecalc/main.dart';

void main() {
  testWidgets('calculates and clears', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byKey(const Key('display')), findsOneWidget);

    for (final key in ['8', '÷', '2', '=']) {
      await tester.tap(find.byKey(Key('button_$key')));
      await tester.pump();
    }
    expect(tester.widget<Text>(find.byKey(const Key('display'))).data, '4');

    await tester.tap(find.byKey(const Key('button_AC')));
    await tester.pump();
    expect(find.text('0'), findsNWidgets(2));
  });

  testWidgets('division by zero shows an error', (tester) async {
    await tester.pumpWidget(const MyApp());
    for (final key in ['8', '÷', '0', '=']) {
      await tester.tap(find.byKey(Key('button_$key')));
      await tester.pump();
    }
    expect(find.text('Error'), findsOneWidget);
  });
}
