import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:step_bar/step_bar.dart';

Finder _circleContainers() {
  return find.byWidgetPredicate((Widget w) {
    if (w is Container) {
      final Decoration? d = w.decoration;
      if (d is BoxDecoration && d.shape == BoxShape.circle) {
        return true;
      }
    }
    return false;
  });
}

void main() {
  testWidgets('renders correct number of steps with labels and indices', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StepBar(
            totalSteps: 4,
            currentStep: 1,
            labels: const ['Personal Info', 'Address', 'Payment', 'Review'],
          ),
        ),
      ),
    );

    // Numbers appear because no icons provided
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    // Labels present
    expect(find.text('Address'), findsOneWidget);
  });

  testWidgets('theme overrides apply to indicator and icon theme', (
    tester,
  ) async {
    const Color active = Colors.teal;
    const Color completed = Colors.teal;
    const Color inactive = Color(0xFFE5E7EB);
    const Color connector = Color(0xFFCBD5E1);
    const Color inactiveIcon = Colors.purple;

    final List<StepBarStep> steps = <StepBarStep>[
      const StepBarStep(status: StepStatus.completed, icon: Icon(Icons.check)),
      const StepBarStep(status: StepStatus.active, icon: Icon(Icons.person)),
      const StepBarStep(status: StepStatus.inactive, icon: Icon(Icons.home)),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StepBarTheme(
            data: const StepBarThemeData(
              activeColor: active,
              completedColor: completed,
              inactiveColor: inactive,
              connectorColor: connector,
              circleSize: 32,
              connectorThickness: 6,
              spacing: 10,
              iconSize: 20,
              inactiveIconColor: inactiveIcon,
            ),
            child: StepBar(steps: steps),
          ),
        ),
      ),
    );

    // There should be 3 circular indicators
    expect(_circleContainers(), findsNWidgets(3));

    // IconThemes under indicators should equal the number of steps
    final Finder iconThemesUnderIndicators = find.descendant(
      of: _circleContainers(),
      matching: find.byType(IconTheme),
    );
    expect(iconThemesUnderIndicators, findsNWidgets(3));

    // Inactive step should have inactive icon color
    final List<IconTheme> iconThemes = tester
        .widgetList<IconTheme>(iconThemesUnderIndicators)
        .toList();
    expect(iconThemes[2].data.color, inactiveIcon);
  });

  testWidgets(
    'currentStep updates states from inactive -> active -> completed',
    (tester) async {
      int current = 0;
      final Widget app = StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return MaterialApp(
            home: Scaffold(
              body: Column(
                children: <Widget>[
                  StepBar(totalSteps: 4, currentStep: current),
                  TextButton(
                    onPressed: () => setState(() => current += 1),
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          );
        },
      );

      await tester.pumpWidget(app);

      // Verify colors of the first two indicators as current changes
      Color decorationColorAt(int index) {
        final Container c = tester
            .widgetList<Container>(_circleContainers())
            .elementAt(index);
        final BoxDecoration d = c.decoration! as BoxDecoration;
        return d.color!;
      }

      final ThemeData theme = ThemeData();
      Color primary = theme.colorScheme.primary;
      Color inactive = theme.colorScheme.outlineVariant;

      expect(decorationColorAt(0), primary); // active
      expect(decorationColorAt(1), inactive); // inactive

      await tester.tap(find.text('Next'));
      await tester.pump();

      // Now step 0 completed (primary), step 1 active (primary)
      expect(decorationColorAt(0), primary);
      expect(decorationColorAt(1), primary);
    },
  );

  testWidgets('per-step API works with active/completed/inactive and labels', (
    tester,
  ) async {
    final List<StepBarStep> steps = <StepBarStep>[
      const StepBarStep(status: StepStatus.completed, label: 'Done'),
      const StepBarStep(status: StepStatus.active, label: 'Now'),
      const StepBarStep(status: StepStatus.inactive, label: 'Next'),
      const StepBarStep(status: StepStatus.inactive, label: 'Later'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: StepBar(steps: steps)),
      ),
    );

    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Now'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Later'), findsOneWidget);
  });

  testWidgets('responsive sizing reduces circle size on narrow widths', (
    tester,
  ) async {
    const double circleSize = 32;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: circleSize * 2.2, // Force narrow width per step
            child: StepBar(
              totalSteps: 3,
              currentStep: 1,
              circleSize: circleSize,
            ),
          ),
        ),
      ),
    );

    // Expect that at least one indicator is smaller than requested size by reading RenderBox size
    final Iterable<Element> elements = tester.elementList(_circleContainers());
    expect(elements.isNotEmpty, true);
    final Iterable<Size> sizes = elements.map(
      (Element e) => e.renderObject!.paintBounds.size,
    );
    final bool anyReduced = sizes.any((Size s) => s.width < circleSize);
    expect(anyReduced, true);
  });

  testWidgets('handles many steps efficiently without exceptions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: StepBar(totalSteps: 100, currentStep: 50)),
      ),
    );

    // Build should complete without exceptions and correct count of indicators exists
    expect(_circleContainers(), findsNWidgets(100));
  });
}
