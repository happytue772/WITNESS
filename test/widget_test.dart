import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_witness/app.dart';
import 'package:first_witness/core/navigation/home_navigation_action.dart';

void main() {
  testWidgets(
    'THE FIRST WITNESS welcome screen loads',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const FirstWitnessApp(),
      );

      expect(
        find.text('THE FIRST\nWITNESS'),
        findsOneWidget,
      );
      expect(
        find.text('나의 여정 시작하기'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Home footer asks before leaving unfinished work',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('작업 중'),
            ),
            bottomNavigationBar:
                HomeNavigationBottomBar(
              warningTitle: '작업을 중단할까요?',
              warningMessage:
                  '저장되지 않은 작업이 있습니다.',
            ),
          ),
        ),
      );

      await tester.tap(
        find.text('홈으로'),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('작업을 중단할까요?'),
        findsOneWidget,
      );
      expect(
        find.text('저장되지 않은 작업이 있습니다.'),
        findsOneWidget,
      );
      expect(
        find.text('계속 진행'),
        findsOneWidget,
      );
      expect(
        find.text('홈으로 이동'),
        findsOneWidget,
      );

      await tester.tap(
        find.text('계속 진행'),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('작업 중'),
        findsOneWidget,
      );
    },
  );
}
