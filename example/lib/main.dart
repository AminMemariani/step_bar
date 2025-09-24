import 'package:flutter/material.dart';
import 'package:step_bar/step_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StepBar Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const WizardDemo(),
    );
  }
}

class WizardDemo extends StatefulWidget {
  const WizardDemo({super.key});

  @override
  State<WizardDemo> createState() => _WizardDemoState();
}

class _WizardDemoState extends State<WizardDemo> {
  static const List<String> _labels = <String>[
    'Personal Info',
    'Address',
    'Payment',
    'Review',
  ];

  static const List<Icon> _icons = <Icon>[
    Icon(Icons.person, size: 16),
    Icon(Icons.home, size: 16),
    Icon(Icons.credit_card, size: 16),
    Icon(Icons.check_circle, size: 16),
  ];

  final PageController _pageController = PageController();
  int _currentStep = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    setState(() => _currentStep = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _goNext() {
    if (_currentStep < _labels.length - 1) {
      _goTo(_currentStep + 1);
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      _goTo(_currentStep - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StepBar Wizard')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Default styled StepBar with internal padding
          StepBar(
            totalSteps: _labels.length,
            currentStep: _currentStep,
            labels: _labels,
            icons: _icons,
          ),
          const SizedBox(height: 16),
          // Custom themed StepBar with internal padding
          StepBarTheme(
            data: const StepBarThemeData(
              activeColor: Colors.indigo,
              completedColor: Colors.indigo,
              inactiveColor: Color(0xFFE4E7EB),
              connectorColor: Color(0xFFD0D5DD),
              circleSize: 30,
              connectorThickness: 4,
              spacing: 12,
              iconSize: 16,
              activeIconColor: Colors.white,
              completedIconColor: Colors.white,
              inactiveIconColor: Color(0xFF667085),
              labelStyle: TextStyle(fontSize: 11),
              activeLabelStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: StepBar(
              totalSteps: _labels.length,
              currentStep: _currentStep,
              labels: _labels,
              icons: _icons,
            ),
          ),
          // Content area with padding
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (int index) =>
                                  setState(() => _currentStep = index),
                              children: const <Widget>[
                                _StepPage(
                                  title: 'Personal Info',
                                  description: 'Enter your name and email.',
                                ),
                                _StepPage(
                                  title: 'Address',
                                  description: 'Provide your shipping address.',
                                ),
                                _StepPage(
                                  title: 'Payment',
                                  description: 'Add a payment method.',
                                ),
                                _StepPage(
                                  title: 'Review',
                                  description: 'Confirm and submit your order.',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _currentStep == 0
                                        ? null
                                        : _goBack,
                                    child: const Text('Back'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: FilledButton(
                                    onPressed:
                                        _currentStep == _labels.length - 1
                                        ? null
                                        : _goNext,
                                    child: const Text('Next'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    children: List<Widget>.generate(_labels.length, (int i) {
                      return ActionChip(
                        label: Text('Go to ${i + 1}'),
                        onPressed: () => _goTo(i),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepPage extends StatelessWidget {
  const _StepPage({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
