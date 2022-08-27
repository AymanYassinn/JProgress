import 'dart:async';
import 'jprogress.dart';

///Main Progress Controller [ProgressController]
/// to handle Progress time
class ProgressController {
  ProgressController(
      {required this.duration,
      this.tickPeriod = const Duration(milliseconds: 1000),
      this.timeFormat = DateFormatN.SecMin});

  ///[double] const value [smoothnessConstant]
  static const double smoothnessConstant = 250;

  ///[Duration]  value [duration]
  final Duration duration;

  ///[Duration]  value [tickPeriod]
  final Duration tickPeriod;

  ///[DateFormatN]  value [timeFormat]
  DateFormatN timeFormat;

  ///[double] value [_progress]
  double _progress = 0.0;

  ///[Timer] value [_timer]
  Timer _timer = Timer(const Duration(seconds: 1), () {});

  ///[Timer] value [_periodicTimer]
  Timer _periodicTimer = Timer(const Duration(seconds: 1), () {});

  ///[String] value [_countDown]
  String _countDown = "00:00";

  ///[double] getter [valuePercent] from [_progress]
  double get valuePercent => _progress;

  ///[String] getter [countDown] from [_countDown]
  String get countDown => _countDown;

  ///[Timer] getter [timer] from [_timer]
  Timer get timer => _timer;

  /// [StreamController] value [pProgressController]
  StreamController<void> pProgressController =
      StreamController<void>.broadcast();

  /// [StreamController] value [pTimeoutController]
  StreamController<void> pTimeoutController =
      StreamController<void>.broadcast();

  /// [Stream] getter [progressStream] from [pProgressController.stream]
  Stream<void> get progressStream => pProgressController.stream;

  /// [Stream] getter [timeoutStream] from [pTimeoutController.stream]
  Stream<void> get timeoutStream => pTimeoutController.stream;

  /// method  [start] to initialize
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

  /// method  [_timeM] to get [String] time
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

  /// method  [stop] to Stop controller
  void stop() {
    _cancelTimers();
  }

  /// method  [restart] to restart controller
  void restart() {
    _cancelTimers();
    start();
  }

  /// [Future] method  [dispose] to cancelStreams and Timers
  Future<void> dispose() async {
    await _cancelStreams();
    _cancelTimers();
  }

  /// [double] method  [_calculateProgress] to cancel Progress
  double _calculateProgress(Timer timer) {
    double progress = timer.tick / duration.inSeconds;

    if (progress > 1) return 1;
    if (progress < 0) return 0;
    return progress;
  }

  ///  method  [_setProgressAndNotify] to set progress and notify
  void _setProgressAndNotify(double value, int p) {
    _progress = value;
    _countDown = _timeM(p);
    pProgressController.add(null);
  }

  /// [Future] method  [_cancelStreams] to cancel Streams
  Future<void> _cancelStreams() async {
    if (!pProgressController.isClosed) await pProgressController.close();
    if (!pTimeoutController.isClosed) await pTimeoutController.close();
  }

  /// method  [_cancelTimers] to cancel Timers
  void _cancelTimers() {
    _countDown = "00:00";
    if (_timer.isActive == true) _timer.cancel();

    if (_periodicTimer.isActive == true) _periodicTimer.cancel();
  }
}
