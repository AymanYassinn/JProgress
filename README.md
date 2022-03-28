
JProgress: It is a package that contains time-based progress widgets and also allows values based on user choice.

## Features

- Timing Control -- Start - Stop - Duration ..etc

## Getting started
- Circular Timing Progress
- Circular Custom Progress
- Linear Timing Progress
- Linear Custom Progress

## Usage
To Use `ProgressController` You Must Initialize & dispose
```dart
 late ProgressController controller;
  @override
  void initState() {
    controller = ProgressController(
        duration: const Duration(minutes: 3),
        timeFormat: DateFormatN.SecMin,
        tickPeriod: const Duration(milliseconds: 1000));
    super.initState();
  }
// Dispose
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
```
## Additional information

Provided By [Just Codes Developers](https://jucodes.com/)
"# JProgress" 
