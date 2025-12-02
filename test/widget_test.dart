import 'package:flutter_test/flutter_test.dart';
import 'package:what_is/app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WhatIsApp());
    expect(find.text('What would you like explained?'), findsNothing);
  });
}
