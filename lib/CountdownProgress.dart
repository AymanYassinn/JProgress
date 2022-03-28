import 'package:flutter/material.dart';
import 'jprogress.dart';

class CountdownProgress extends StatefulWidget {
  final ProgressController controller;
  final VoidCallback onTimeout;
  final Function onUpdate;
  final double size;
  final ProgressWidget progressWidget;
  final ProgressType progressType;
  final Color backgroundColor;
  final Color valueColor;
  final TextStyle? textStyle;
  final double strokeWidth;
  const CountdownProgress(
      {Key? key,
      required this.controller,
      required this.onTimeout,
      required this.onUpdate,
      this.size = 40,
      this.backgroundColor = Colors.blue,
      this.valueColor = Colors.white,
      this.textStyle,
      this.strokeWidth = 3.0,
      this.progressType = ProgressType.Circular,
      this.progressWidget = ProgressWidget.TEXT})
      : super(key: key);

  @override
  State<CountdownProgress> createState() => _CountdownProgressState();
}

class _CountdownProgressState extends State<CountdownProgress> {
  ProgressController get controller => widget.controller;

  VoidCallback get onTimeout => widget.onTimeout;
  Function get update => widget.onUpdate;

  @override
  void initState() {
    controller.progressStream.listen((_) => update());
    controller.timeoutStream.listen((_) => onTimeout());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.progressWidget == ProgressWidget.Indicator
        ? CustomProgress(
            title: controller.countDown,
            valueColor: widget.valueColor,
            backgroundColor: widget.backgroundColor,
            textStyle: widget.textStyle,
            strokeWidth: widget.strokeWidth,
            size: widget.size,
            progressType: widget.progressType,
            value: controller.valuePercent,
          )
        : CustomProgress(
            title: controller.countDown,
            size: widget.size,
            progressType: widget.progressType,
            value: 0.0,
          );
  }
}
