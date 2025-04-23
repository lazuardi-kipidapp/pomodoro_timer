import 'package:flutter/material.dart';
import 'package:pomodoro_timer/utils/time_utils.dart';

class TimerDisplay extends StatelessWidget {
  final int timeInSeconds;
  const TimerDisplay({super.key, required this.timeInSeconds});

  @override
  Widget build(BuildContext context) {
    return Text(
      formatDurationFromSeconds(timeInSeconds),
      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
    );
  }
}
