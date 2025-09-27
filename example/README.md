# StepBar Widget Example

This example demonstrates the **StepBar** widget, a customizable and responsive step progress bar for multi-step flows in Flutter applications.

## Features Demonstrated

### 🎯 **Basic Usage**
- Simple step progress bar with labels and icons
- Automatic step state management (inactive, active, completed)
- Responsive design that adapts to different screen sizes

### 🎨 **Custom Theming**
- Custom color schemes for different step states
- Configurable circle sizes and connector thickness
- Custom label and icon styling
- Theme inheritance using `StepBarTheme`

### 🔧 **Interactive Features**
- Navigation between steps using buttons
- Direct step navigation with action chips
- Smooth page transitions with `PageView`
- Real-time step updates

## Example App Structure

The demo app showcases a **4-step wizard** with the following flow:
1. **Personal Info** - Enter name and email
2. **Address** - Provide shipping address  
3. **Payment** - Add payment method
4. **Review** - Confirm and submit order

## Widget Usage

### Basic StepBar
```dart
StepBar(
  totalSteps: 4,
  currentStep: currentStep,
  labels: ['Personal Info', 'Address', 'Payment', 'Review'],
  icons: [
    Icon(Icons.person),
    Icon(Icons.home),
    Icon(Icons.credit_card),
    Icon(Icons.check_circle),
  ],
)
```

### Custom Themed StepBar
```dart
StepBarTheme(
  data: StepBarThemeData(
    activeColor: Colors.indigo,
    completedColor: Colors.indigo,
    inactiveColor: Color(0xFFE4E7EB),
    circleSize: 30,
    connectorThickness: 4,
    spacing: 12,
  ),
  child: StepBar(
    totalSteps: 4,
    currentStep: currentStep,
    labels: labels,
    icons: icons,
  ),
)
```

## Key Features

- **Responsive Design**: Automatically adapts to different screen sizes
- **Customizable**: Extensive theming options for colors, sizes, and styles
- **Accessible**: Built-in semantics for screen readers
- **Flexible**: Supports both simple and complex step configurations
- **Material Design 3**: Follows modern Material Design guidelines

## Getting Started

1. Run the example:
   ```bash
   cd example
   flutter run
   ```

2. Navigate through the steps using:
   - **Next/Back buttons** at the bottom
   - **Action chips** for direct step navigation
   - **Swipe gestures** on the content area

## Learn More

- [StepBar Package Documentation](https://github.com/AminMemariani/step_bar)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Material Design 3 Guidelines](https://m3.material.io/)
