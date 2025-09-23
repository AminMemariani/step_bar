import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_bar/step_bar.dart';

void main() {
  testWidgets('renders with three steps and highlights current', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StepBar(
            totalSteps: 3,
            currentStep: 1,
            labels: const ['One', 'Two', 'Three'],
          ),
        ),
      ),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
  });
}
