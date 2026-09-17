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

  testWidgets('two plus two', (tester) async {
    //setup
    await tester.pumpWidget(const MyApp());
    expect(find.byKey(const Key('display')), findsOneWidget);

    // DO SOMETHING
    //press 2
    await tester.tap(find.text('2').last);
    await tester.pump();

    //press +
    await tester.tap(find.text('+').last);
    await tester.pump();

    //press 2
    await tester.tap(find.text('2').last);
    await tester.pump();

    //press =
    await tester.tap(find.text('=').last);
    await tester.pump();
    //check something

    expect(find.text('4'), findsNWidgets(2));
  });

  testWidgets('one minus one equals zero', (tester) async {
    await tester.pumpWidget(const MyApp());
    for (final key in ['1', '−', '1', '=']) {
      await tester.tap(find.byKey(Key('button_$key')));
      await tester.pump();
    }
    expect(tester.widget<Text>(find.byKey(const Key('display'))).data, '0');
  });

  testWidgets('three times three equals nine', (tester) async {
    await tester.pumpWidget(const MyApp());
    for (final key in ['3', '×', '3', '=']) {
      await tester.tap(find.byKey(Key('button_$key')));
      await tester.pump();
    }
    expect(tester.widget<Text>(find.byKey(const Key('display'))).data, '9');
  });

  testWidgets('six divided by three equals two', (tester) async {
    await tester.pumpWidget(const MyApp());
    for (final key in ['6', '÷', '3', '=']) {
      await tester.tap(find.byKey(Key('button_$key')));
      await tester.pump();
    }
    expect(tester.widget<Text>(find.byKey(const Key('display'))).data, '2');
  });

  testWidgets('one divided by zero shows an error', (tester) async {
    await tester.pumpWidget(const MyApp());
    for (final key in ['1', '÷', '0', '=']) {
      await tester.tap(find.byKey(Key('button_$key')));
      await tester.pump();
    }
    expect(tester.widget<Text>(find.byKey(const Key('display'))).data, 'Error');
  });
}
