import 'package:flutter_test/flutter_test.dart';
import 'package:dailycalc/main.dart';

void main() {
  testWidgets('DailyCalc home screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const DailyCalcApp());
    expect(find.text('DailyCalc'), findsOneWidget);
    expect(find.text('Everyday Calculator for India'), findsOneWidget);
  });
}
