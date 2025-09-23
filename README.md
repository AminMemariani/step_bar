# step_bar

[![CI](https://github.com/AminMemariani/step_bar/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/AminMemariani/step_bar/actions/workflows/ci.yml)
[![Coverage](https://img.shields.io/badge/coverage-84%25-green)](https://app.codecov.io/gh/AminMemariani/step_bar)
[![pub package](https://img.shields.io/pub/v/step_bar.svg)](https://pub.dev/packages/step_bar)
[![Pub points](https://img.shields.io/pub/points/step_bar)](https://pub.dev/packages/step_bar/score)
[![Pub likes](https://img.shields.io/pub/likes/step_bar)](https://pub.dev/packages/step_bar/score)
[![Popularity](https://img.shields.io/pub/popularity/step_bar)](https://pub.dev/packages/step_bar/score)
[![Example](https://img.shields.io/badge/example-open-blue)](https://github.com/AminMemariani/step_bar/tree/main/example)

A customizable, responsive Step Bar widget for Flutter, ideal for multi-step forms and wizards. Supports per-step icons, labels, colors, and active/completed/inactive states. Provides sensible defaults and full theming via `StepBarTheme`/`StepBarThemeData`.

- Pub: https://pub.dev/packages/step_bar

## Features

- **Steps by count or explicit config**: Use `totalSteps + currentStep` or provide a `steps` list.
- **Per-step customization**: Icons, labels, and color overrides.
- **States**: `inactive`, `active`, `completed`.
- **Theming**: Global defaults via `StepBarThemeData`, with per-widget overrides.
- **Responsive**: Adapts sizes based on available width (mobile and web).
- **Accessible**: Semantics for step index and state.

## Getting started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  step_bar: ^0.1.0
```

Import:

```dart
import 'package:step_bar/step_bar.dart';
```

## Usage

### Quick start (count-based)

```dart
StepBar(
  totalSteps: 4,
  currentStep: 1, // zero-based
  labels: const ['Account', 'Profile', 'Address', 'Confirm'],
  icons: const [
    Icon(Icons.person, size: 16),
    Icon(Icons.badge, size: 16),
    Icon(Icons.home, size: 16),
    Icon(Icons.check, size: 16),
  ],
)
```

### Full control (per-step)

```dart
final steps = [
  StepBarStep(
    status: StepStatus.completed,
    label: 'Account',
    icon: const Icon(Icons.person, size: 16),
  ),
  StepBarStep(
    status: StepStatus.active,
    label: 'Profile',
    icon: const Icon(Icons.badge, size: 16),
    activeColor: Colors.teal,
  ),
  StepBarStep(
    status: StepStatus.inactive,
    label: 'Address',
  ),
  StepBarStep(
    status: StepStatus.inactive,
    label: 'Confirm',
    activeIcon: const Icon(Icons.check, size: 16),
  ),
];

StepBar(steps: steps)
```

### Theming

Wrap with `StepBarTheme` to set defaults:

```dart
StepBarTheme(
  data: const StepBarThemeData(
    activeColor: Colors.indigo,
    completedColor: Colors.indigo,
    inactiveColor: Color(0xFFDFE3E8),
    connectorColor: Color(0xFFCFD4DA),
    circleSize: 28,
    connectorThickness: 4,
    spacing: 12,
    showStepIndexWhenNoIcon: true,
  ),
  child: StepBar(
    totalSteps: 3,
    currentStep: 2,
    labels: const ['One', 'Two', 'Three'],
  ),
)
```

You can still override per `StepBar` using its optional props.

## API

- `StepBar`: main widget.
  - Inputs: `steps` or `totalSteps + currentStep`, optional `labels`, `icons`, colors and sizing overrides.
- `StepBarStep`: per-step config with `status`, `icon`, `activeIcon`, `label`, optional color overrides.
- `StepStatus`: `inactive`, `active`, `completed`.
- `StepBarTheme`/`StepBarThemeData`: theme and defaults.

## Example app

See `/example` for a runnable demo showcasing mobile and web layout.

## Testing

This package includes comprehensive widget tests covering:

- Correct rendering of steps with labels and indices
- Theme and style overrides (including icon styling)
- State transitions as `currentStep` changes
- Responsive behavior under narrow widths
- Performance with many steps (100+)

Run tests:
```bash
flutter test
```

Generate coverage report:
```bash
flutter test --coverage
```

### CI/CD

The package uses GitHub Actions for continuous integration:

- **Tests**: Automatically run on every push and pull request
- **Analysis**: Dart analyzer ensures code quality
- **Coverage**: Test coverage is generated and uploaded to Codecov
- **Flutter Version**: CI uses Flutter 3.32.6 (stable channel)

[View latest CI run](https://github.com/AminMemariani/step_bar/actions)

## License

MIT
