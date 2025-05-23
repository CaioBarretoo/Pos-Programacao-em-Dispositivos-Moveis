// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/bmi_controller.dart';

import 'package:myapp/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Test logic of insert data page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => BMIController(),
        child: const MyApp(),
      ),
    );

    expect(find.text("Please, enter the weight!"), findsNothing);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text("Please, enter the weight!"), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, "55.0");
    await tester.enterText(find.byType(TextFormField).last, "1.79");
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.byType(ElevatedButton), findsNothing);
  });
}
