import 'dart:async';
import 'jprogress.dart';

///Main Progress Controller [ProgressController]
/// to handle Progress time
class ProgressController {
  static const double smoothnessConstant = 250;
  final Duration duration;
  final Duration tickPeriod;
  DateFormatN timeFormat;
  double _progress = 0.0;
  Timer _timer = Timer(const Duration(seconds: 1), () {});
  Timer _periodicTimer = Timer(const Duration(seconds: 1), () {});
  String _countDown = "00:00";
  double get valuePercent => _progress;
  String get countDown => _countDown;
  Timer get timer => _timer;
  Stream<void> get progressStream => pProgressController.stream;
  StreamController<void> pProgressController =
      StreamController<void>.broadcast();

  Stream<void> get timeoutStream => pTimeoutController.stream;
  StreamController<void> pTimeoutController =
      StreamController<void>.broadcast();

  ProgressController(
      {required this.duration,
      this.tickPeriod = const Duration(milliseconds: 1000),
      this.timeFormat = DateFormatN.SecMin});

  void start() {
    if (_timer.isActive == false) {
      _timer = Timer(duration, () {
        _cancelTimers();
        _setProgressAndNotify(1, 1);
        pTimeoutController.add(null);
      });
      _periodicTimer = Timer.periodic(
        tickPeriod,
        (Timer timer) {
          double progress = _calculateProgress(timer);
          _setProgressAndNotify(progress, timer.tick);
        },
      );
    } else {
      restart();
    }
  }

  _timeM(int dod2) {
    Duration dod11 = Duration(seconds: duration.inSeconds - dod2);
    int days = 0;
    int hundreds = (dod11.inMilliseconds ~/ 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = seconds ~/ 3600;
    days = seconds ~/ 86400;
    if (days >= 1) {
      int ho = days * 24;
      hours = hours - ho;
    }

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String daysStr = (days % 24).toString().padLeft(2, '0');
    switch (timeFormat) {
      case DateFormatN.SecMin:
        return "$minutesStr:$secondsStr";
      case DateFormatN.SecMinHour:
        return "$hoursStr:$minutesStr:$secondsStr";
      case DateFormatN.SecMinHourDay:
        return "$daysStr:$hoursStr:$minutesStr:$secondsStr";
      case DateFormatN.MinHour:
        return "$hoursStr:$minutesStr";
      case DateFormatN.MinHourDay:
        return "$daysStr:$hoursStr:$minutesStr";
      case DateFormatN.HourDay:
        return "$daysStr:$hoursStr";
      default:
        return "00:00";
    }
  }

  void stop() {
    _cancelTimers();
  }

  void restart() {
    _cancelTimers();
    start();
  }

  Future<void> dispose() async {
    await _cancelStreams();
    _cancelTimers();
  }

  double _calculateProgress(Timer timer) {
    double progress = timer.tick / duration.inSeconds;

    if (progress > 1) return 1;
    if (progress < 0) return 0;
    return progress;
  }

  void _setProgressAndNotify(double value, int p) {
    _progress = value;
    _countDown = _timeM(p);
    pProgressController.add(null);
  }

  Future<void> _cancelStreams() async {
    if (!pProgressController.isClosed) await pProgressController.close();
    if (!pTimeoutController.isClosed) await pTimeoutController.close();
  }

  void _cancelTimers() {
    _countDown = "00:00";
    if (_timer.isActive == true) _timer.cancel();

    if (_periodicTimer.isActive == true) _periodicTimer.cancel();
  }
}
