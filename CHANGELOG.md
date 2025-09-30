## 0.1.3

- **Layout improvements**: Complete restructure of StepBar widget layout
  - Icons and labels now wrapped in individual columns for better organization
  - Connector lines positioned underneath step columns using Stack layout
  - Connectors now properly cross through the center of step circles
  - Connectors are hidden behind opaque step circles for clean visual appearance
  - Connector bounds adjusted to only appear between circles (not extending beyond first/last steps)
- **Visual enhancements**: Added subtle shadow to step circles for better depth perception
- **Improved README**: Updated example README with comprehensive usage documentation

## 0.1.2

- **Documentation**: Added screenshots section to README showcasing package examples
- **Visual showcase**: 2x2 grid layout displaying different step bar configurations

## 0.1.1

- **Layout improvements**: Enhanced label alignment with smart positioning
  - First label: left-aligned (start)
  - Middle labels: center-aligned
  - Last label: right-aligned (end)
- **Connector positioning**: Improved connector placement between step indicators
- **Font sizing**: Added default font size (11px) for better single-line label display
- **Full-width support**: Step bars now properly extend to screen edges
- **Code formatting**: Applied Dart formatter standards

## 0.1.0

- Initial public release of StepBar
- Themable `StepBarThemeData` and `StepBarTheme`
- Per-step config with `StepBarStep` and `StepStatus`
- Responsive layout and accessibility semantics
- Example app with 4-step wizard (default + custom theme)
- Comprehensive tests and coverage setup

## 0.0.1

- Internal scaffold
