import 'package:flutter_test/flutter_test.dart';
import 'package:first_witness/app.dart';

void main() {
  testWidgets('THE FIRST WITNESS app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const FirstWitnessApp());

    expect(find.text('THE FIRST WITNESS'), findsOneWidget);
  });
}