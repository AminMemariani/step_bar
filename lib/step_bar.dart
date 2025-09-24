import 'package:flutter/material.dart';

/// Step status states for each step in the bar.
enum StepStatus { inactive, active, completed }

/// Per-step configuration: icon, label, color overrides, and status.
class StepBarStep {
  const StepBarStep({
    this.icon,
    this.activeIcon,
    this.label,
    this.color,
    this.activeColor,
    this.completedColor,
    required this.status,
  });

  /// Generic icon for the step.
  final Widget? icon;

  /// Icon to use when the step is active or completed.
  final Widget? activeIcon;

  /// Optional label displayed below the step row.
  final String? label;

  /// Color when inactive, if provided.
  final Color? color;

  /// Color when active, if provided.
  final Color? activeColor;

  /// Color when completed, if provided.
  final Color? completedColor;

  /// The current status for the step.
  final StepStatus status;
}

/// Theme data for StepBar styling.
class StepBarThemeData {
  const StepBarThemeData({
    this.activeColor,
    this.completedColor,
    this.inactiveColor,
    this.connectorColor,
    this.labelStyle,
    this.activeLabelStyle,
    this.circleSize = 28.0,
    this.connectorThickness = 4.0,
    this.spacing = 12.0,
    this.connectorGap = const EdgeInsets.symmetric(horizontal: 8.0),
    this.showStepIndexWhenNoIcon = true,
    this.iconSize = 16.0,
    this.activeIconColor,
    this.completedIconColor,
    this.inactiveIconColor,
  });

  /// Color used for the active step.
  final Color? activeColor;

  /// Color used for completed steps/connectors.
  final Color? completedColor;

  /// Color used for inactive steps/connectors.
  final Color? inactiveColor;

  /// Color for connectors when not completed. If null, derived from theme.
  final Color? connectorColor;

  /// Text style for inactive labels.
  final TextStyle? labelStyle;

  /// Text style for the active label.
  final TextStyle? activeLabelStyle;

  /// Diameter of step indicator circles.
  final double circleSize;

  /// Thickness of connector lines.
  final double connectorThickness;

  /// Vertical space between indicators and labels.
  final double spacing;

  /// Horizontal margin around connectors.
  final EdgeInsets connectorGap;

  /// Whether to render the numeric index if no icon is supplied.
  final bool showStepIndexWhenNoIcon;

  /// Icon size applied via IconTheme inside each indicator.
  final double iconSize;

  /// Icon color for active state.
  final Color? activeIconColor;

  /// Icon color for completed state.
  final Color? completedIconColor;

  /// Icon color for inactive state.
  final Color? inactiveIconColor;

  StepBarThemeData copyWith({
    Color? activeColor,
    Color? completedColor,
    Color? inactiveColor,
    Color? connectorColor,
    TextStyle? labelStyle,
    TextStyle? activeLabelStyle,
    double? circleSize,
    double? connectorThickness,
    double? spacing,
    EdgeInsets? connectorGap,
    bool? showStepIndexWhenNoIcon,
    double? iconSize,
    Color? activeIconColor,
    Color? completedIconColor,
    Color? inactiveIconColor,
  }) {
    return StepBarThemeData(
      activeColor: activeColor ?? this.activeColor,
      completedColor: completedColor ?? this.completedColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      connectorColor: connectorColor ?? this.connectorColor,
      labelStyle: labelStyle ?? this.labelStyle,
      activeLabelStyle: activeLabelStyle ?? this.activeLabelStyle,
      circleSize: circleSize ?? this.circleSize,
      connectorThickness: connectorThickness ?? this.connectorThickness,
      spacing: spacing ?? this.spacing,
      connectorGap: connectorGap ?? this.connectorGap,
      showStepIndexWhenNoIcon:
          showStepIndexWhenNoIcon ?? this.showStepIndexWhenNoIcon,
      iconSize: iconSize ?? this.iconSize,
      activeIconColor: activeIconColor ?? this.activeIconColor,
      completedIconColor: completedIconColor ?? this.completedIconColor,
      inactiveIconColor: inactiveIconColor ?? this.inactiveIconColor,
    );
  }

  static StepBarThemeData of(BuildContext context) {
    final StepBarTheme? theme = StepBarTheme.maybeOf(context);
    return theme?.data ?? _defaultsFor(Theme.of(context));
  }

  static StepBarThemeData _defaultsFor(ThemeData theme) {
    return StepBarThemeData(
      activeColor: theme.colorScheme.primary,
      completedColor: theme.colorScheme.primary,
      inactiveColor: theme.colorScheme.outlineVariant,
      connectorColor: theme.colorScheme.outline,
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color:
            (theme.textTheme.labelMedium?.color ?? theme.colorScheme.onSurface)
                .withValues(alpha: 0.7),
        fontSize: 11,
      ),
      activeLabelStyle: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 11,
      ),
      iconSize: 16.0,
      activeIconColor: theme.colorScheme.onPrimary,
      completedIconColor: theme.colorScheme.onPrimary,
      inactiveIconColor: theme.colorScheme.onSurfaceVariant,
    );
  }
}

/// Inherited theme for StepBar.
class StepBarTheme extends InheritedWidget {
  const StepBarTheme({super.key, required this.data, required super.child});

  final StepBarThemeData data;

  static StepBarTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StepBarTheme>();
  }

  static StepBarThemeData of(BuildContext context) {
    final StepBarTheme? result = maybeOf(context);
    return result?.data ?? StepBarThemeData._defaultsFor(Theme.of(context));
  }

  @override
  bool updateShouldNotify(covariant StepBarTheme oldWidget) =>
      data != oldWidget.data;
}

/// A simple, customizable step progress bar for multi-step flows.
///
/// Displays a horizontal sequence of steps with connectors. Supports per-step
/// icons, labels, and colors. Theming can be provided via [StepBarTheme].
class StepBar extends StatelessWidget {
  StepBar({
    super.key,
    this.steps,
    this.totalSteps,
    this.currentStep,
    this.labels,
    this.icons,
    this.activeColor,
    this.inactiveColor,
    this.completedColor,
    this.connectorColor,
    this.labelStyle,
    this.activeLabelStyle,
    this.circleSize,
    this.connectorThickness,
    this.spacing,
  }) : assert(
         (steps != null && steps.isNotEmpty) ||
             (totalSteps != null && totalSteps > 0 && currentStep != null),
         'Provide either steps or totalSteps with currentStep.',
       ),
       assert(
         steps == null || (totalSteps == null && currentStep == null),
         'Do not provide totalSteps/currentStep when steps are provided.',
       );

  /// Optional explicit list of steps. If provided, overrides other step inputs.
  final List<StepBarStep>? steps;

  /// Total number of steps (when not providing [steps]).
  final int? totalSteps;

  /// The zero-based index of the current step (when not providing [steps]).
  final int? currentStep;

  /// Optional labels for each step (when not providing [steps]).
  final List<String>? labels;

  /// Optional icons for each step (when not providing [steps]).
  final List<Widget>? icons;

  /// Color overrides (highest precedence over theme where applicable).
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? completedColor;
  final Color? connectorColor;

  /// Text style overrides.
  final TextStyle? labelStyle;
  final TextStyle? activeLabelStyle;

  /// Size overrides.
  final double? circleSize;
  final double? connectorThickness;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final StepBarThemeData themeData = StepBarThemeData.of(context);

    final double resolvedCircleSize = circleSize ?? themeData.circleSize;
    final double resolvedConnectorThickness =
        connectorThickness ?? themeData.connectorThickness;
    final double resolvedSpacing = spacing ?? themeData.spacing;

    // Resolve steps list from provided inputs.
    final List<StepBarStep> resolvedSteps =
        steps ??
        _buildStepsFromIndex(
          totalSteps: totalSteps!,
          currentStep: currentStep!,
          labels: labels,
          icons: icons,
        );

    // Resolve colors with proper precedence: per-step -> widget props -> theme -> fallback
    Color resolveColorFor(StepBarStep step) {
      switch (step.status) {
        case StepStatus.active:
          return step.activeColor ??
              activeColor ??
              themeData.activeColor ??
              theme.colorScheme.primary;
        case StepStatus.completed:
          return step.completedColor ??
              completedColor ??
              themeData.completedColor ??
              theme.colorScheme.primary;
        case StepStatus.inactive:
          return step.color ??
              inactiveColor ??
              themeData.inactiveColor ??
              theme.colorScheme.outlineVariant;
      }
    }

    final Color resolvedConnectorColor =
        connectorColor ?? themeData.connectorColor ?? theme.colorScheme.outline;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Basic responsive heuristic: adapt size to per-step width, and collapse connectors when ultra-tight.
        final int numSteps = resolvedSteps.length;
        final double perStepWidth = constraints.maxWidth.isFinite
            ? (constraints.maxWidth / numSteps)
            : resolvedCircleSize * 2.5;
        final bool ultraTight = perStepWidth < resolvedCircleSize;
        final double adaptiveCircle = ultraTight
            ? perStepWidth.clamp(4.0, resolvedCircleSize)
            : (perStepWidth < (resolvedCircleSize * 2)
                  ? (resolvedCircleSize * 0.85).clamp(4.0, resolvedCircleSize)
                  : resolvedCircleSize);

        // Build step indicators and labels separately
        final List<Widget> stepIndicators = <Widget>[];
        final List<Widget> stepLabels = <Widget>[];
        final bool anyLabels = resolvedSteps.any((s) => s.label != null);

        for (int i = 0; i < numSteps; i++) {
          final StepBarStep step = resolvedSteps[i];
          final Color color = resolveColorFor(step);
          final bool isActive = step.status == StepStatus.active;

          // Create step indicator
          stepIndicators.add(
            Expanded(
              child: _StepIndicator(
                index: i,
                circleSize: adaptiveCircle,
                status: step.status,
                color: color,
                inactiveColor:
                    step.color ??
                    inactiveColor ??
                    themeData.inactiveColor ??
                    theme.colorScheme.outlineVariant,
                onColor: _onColorFor(theme, color),
                icon: _iconFor(step),
                showIndexFallback: themeData.showStepIndexWhenNoIcon,
                iconThemeColor: _iconColorFor(themeData, step.status),
                iconThemeSize: themeData.iconSize,
              ),
            ),
          );

          // Create step label
          stepLabels.add(
            Expanded(
              child: anyLabels && step.label != null
                  ? Text(
                      step.label!,
                      textAlign: i == 0
                          ? TextAlign.start
                          : i == numSteps - 1
                          ? TextAlign.end
                          : TextAlign.center,
                      style: isActive
                          ? (activeLabelStyle ?? themeData.activeLabelStyle)
                          : (labelStyle ?? themeData.labelStyle),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : const SizedBox.shrink(),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Icons row with connectors positioned between them
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < numSteps; i++) ...<Widget>[
                    stepIndicators[i],
                    if (i < numSteps - 1)
                      ultraTight
                          ? const SizedBox.shrink()
                          : Expanded(
                              child: _StepConnector(
                                isCompleted:
                                    resolvedSteps[i].status ==
                                        StepStatus.completed ||
                                    resolvedSteps[i].status ==
                                        StepStatus.active,
                                thickness: resolvedConnectorThickness,
                                color:
                                    (resolvedSteps[i].status ==
                                        StepStatus.completed)
                                    ? (resolvedSteps[i].completedColor ??
                                          completedColor ??
                                          themeData.completedColor ??
                                          theme.colorScheme.primary)
                                    : resolvedConnectorColor,
                                gap: themeData.connectorGap,
                              ),
                            ),
                  ],
                ],
              ),
              // Labels row (only if there are labels)
              if (anyLabels) ...<Widget>[
                SizedBox(height: resolvedSpacing),
                Row(children: stepLabels),
              ],
            ],
          ),
        );
      },
    );
  }

  List<StepBarStep> _buildStepsFromIndex({
    required int totalSteps,
    required int currentStep,
    List<String>? labels,
    List<Widget>? icons,
  }) {
    return List<StepBarStep>.generate(totalSteps, (int i) {
      final StepStatus status = i < currentStep
          ? StepStatus.completed
          : (i == currentStep ? StepStatus.active : StepStatus.inactive);
      return StepBarStep(
        icon: icons != null && i < icons.length ? icons[i] : null,
        activeIcon: null,
        label: (labels != null && labels.length == totalSteps)
            ? labels[i]
            : null,
        status: status,
      );
    });
  }

  Widget? _iconFor(StepBarStep step) {
    switch (step.status) {
      case StepStatus.active:
      case StepStatus.completed:
        return step.activeIcon ?? step.icon;
      case StepStatus.inactive:
        return step.icon;
    }
  }

  Color _onColorFor(ThemeData theme, Color background) {
    final Brightness brightness = ThemeData.estimateBrightnessForColor(
      background,
    );
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  Color _iconColorFor(StepBarThemeData themeData, StepStatus status) {
    switch (status) {
      case StepStatus.active:
        return themeData.activeIconColor ?? Colors.white;
      case StepStatus.completed:
        return themeData.completedIconColor ?? Colors.white;
      case StepStatus.inactive:
        return themeData.inactiveIconColor ?? Colors.black54;
    }
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.index,
    required this.circleSize,
    required this.status,
    required this.color,
    required this.inactiveColor,
    required this.onColor,
    required this.icon,
    required this.showIndexFallback,
    required this.iconThemeColor,
    required this.iconThemeSize,
  });

  final int index;
  final double circleSize;
  final StepStatus status;
  final Color color;
  final Color inactiveColor;
  final Color onColor;
  final Widget? icon;
  final bool showIndexFallback;
  final Color iconThemeColor;
  final double iconThemeSize;

  @override
  Widget build(BuildContext context) {
    final bool isActiveOrCompleted =
        status == StepStatus.active || status == StepStatus.completed;
    final Color backgroundColor = isActiveOrCompleted ? color : inactiveColor;

    return Semantics(
      label: 'Step ${index + 1}',
      value: status == StepStatus.active
          ? 'current'
          : (status == StepStatus.completed ? 'completed' : 'upcoming'),
      child: SizedBox(
        width: circleSize,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: IconTheme(
              data: IconThemeData(size: iconThemeSize, color: iconThemeColor),
              child:
                  icon ??
                  (showIndexFallback
                      ? Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: onColor,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : const SizedBox.shrink()),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({
    required this.isCompleted,
    required this.thickness,
    required this.color,
    required this.gap,
  });

  final bool isCompleted;
  final double thickness;
  final Color color;
  final EdgeInsets gap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: gap,
      height: thickness,
      width: double.infinity,
      color: color,
    );
  }
}
