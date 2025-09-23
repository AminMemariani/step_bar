import 'package:flutter/material.dart';
import 'package:step_bar/step_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StepBar Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
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
  static const List<String> _labels = <String>['Account', 'Profile', 'Confirm'];

  int _currentStep = 0;

  void _goNext() {
    setState(() {
      if (_currentStep < _labels.length - 1) {
        _currentStep += 1;
      }
    });
  }

  void _goBack() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StepBar Wizard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StepBar(
              totalSteps: _labels.length,
              currentStep: _currentStep,
              labels: _labels,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: Center(
                  child: Text(
                    'Step ${_currentStep + 1}: ${_labels[_currentStep]}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _currentStep == 0 ? null : _goBack,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _currentStep == _labels.length - 1
                        ? null
                        : _goNext,
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
