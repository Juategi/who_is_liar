import 'package:flutter/material.dart';
import 'package:who_is_liar/settings/styles.dart';

class QuestionTimer extends StatefulWidget {
  final String timeUpText;

  const QuestionTimer({super.key, required this.timeUpText});

  @override
  State<QuestionTimer> createState() => _QuestionTimerState();
}

class _QuestionTimerState extends State<QuestionTimer> {
  static const int _totalSeconds = 60;
  late int _remainingSeconds;
  late final Ticker _ticker;
  bool _isTimeUp = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _totalSeconds;
    _ticker = Ticker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    final seconds = _totalSeconds - elapsed.inSeconds;
    if (seconds >= 0) {
      setState(() {
        _remainingSeconds = seconds;
      });
    } else {
      setState(() {
        _isTimeUp = true;
      });
      _ticker.stop();
    }
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _isTimeUp ? widget.timeUpText : _formattedTime,
      style: AppStyles.secondary.copyWith(
        fontSize: 32,
        color: _isTimeUp ? Colors.red : Colors.white,
      ),
    );
  }
}

class Ticker {
  final void Function(Duration) onTick;
  late final Stopwatch _stopwatch;
  late final Duration _interval;
  bool _isActive = false;

  Ticker(this.onTick, [this._interval = const Duration(seconds: 1)]) {
    _stopwatch = Stopwatch();
  }

  void start() {
    _isActive = true;
    _stopwatch.start();
    _tick();
  }

  void _tick() async {
    while (_isActive) {
      await Future.delayed(_interval);
      if (!_isActive) break;
      onTick(_stopwatch.elapsed);
    }
  }

  void stop() {
    _isActive = false;
    _stopwatch.stop();
  }

  void dispose() {
    stop();
  }
}
