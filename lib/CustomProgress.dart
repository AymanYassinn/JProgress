import 'package:flutter/material.dart';

import 'jprogress.dart';

///[StatelessWidget] customProgress [CustomProgressLinear]
///Make [LinearProgressIndicator]
class CustomProgressLinear extends StatelessWidget {
  final double height;
  final double value;
  final String title;
  final Color backgroundColor;
  final Color valueColor;
  final TextStyle? style;
  const CustomProgressLinear(
      {Key? key,
      this.height = 20,
      this.value = 0.0,
      this.title = "",
      this.backgroundColor = Colors.white,
      this.valueColor = Colors.blue,
      this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        children: [
          if (title.isNotEmpty)
            Align(
              alignment: Alignment.topRight,
              child: Text(
                title,
                textScaleFactor: 1,
                style: style,
              ),
            ),
          if (value != 0.0)
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation(valueColor),
                value: value,
                backgroundColor: backgroundColor,
                minHeight: 3.0,
              ),
            ),
        ],
      ),
    );
  }
}

///[StatelessWidget] customProgress [CustomProgressCircle]
///Make [CircleProgressIndicator]
class CustomProgressCircle extends StatelessWidget {
  final double size;
  final double value;
  final String title;
  final Color backgroundColor;
  final Color valueColor;
  final TextStyle? style;
  final double strokeWidth;
  const CustomProgressCircle(
      {Key? key,
      this.size = 40,
      this.value = 0.0,
      this.title = '',
      this.backgroundColor = Colors.blue,
      this.valueColor = Colors.white,
      this.style,
      this.strokeWidth = 3.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: <Widget>[
              if (title.isNotEmpty)
                Center(
                  child: Text(
                    title,
                    textScaleFactor: 1,
                    style: style,
                  ),
                ),
              if (value != 0.0)
                CircularProgressIndicator(
                  value: value,
                  valueColor: AlwaysStoppedAnimation(valueColor),
                  backgroundColor: backgroundColor,
                  strokeWidth: strokeWidth,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

///[StatelessWidget] customProgress [CustomProgress]
///is the main [Widget] that user call it
class CustomProgress extends StatelessWidget {
  final double size;
  final double value;
  final String title;
  final Color backgroundColor;
  final Color valueColor;
  final TextStyle? textStyle;
  final double strokeWidth;
  final ProgressType progressType;
  const CustomProgress(
      {Key? key,
      this.size = 40,
      this.value = 0.0,
      this.title = '',
      this.backgroundColor = Colors.blue,
      this.valueColor = Colors.white,
      this.textStyle,
      this.strokeWidth = 3.0,
      this.progressType = ProgressType.Circular})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (progressType) {
      case ProgressType.Circular:
        return CustomProgressCircle(
          valueColor: valueColor,
          value: value,
          size: size,
          backgroundColor: backgroundColor,
          title: title,
          style: textStyle,
          strokeWidth: strokeWidth,
        );
      case ProgressType.Linear:
        return CustomProgressLinear(
          value: value,
          valueColor: valueColor,
          style: textStyle,
          height: size / 2,
          title: title,
        );
      default:
        return const SizedBox();
    }
  }
}
