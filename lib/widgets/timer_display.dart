import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final int timeInSeconds;
  const TimerDisplay({super.key, required this.timeInSeconds});

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(timeInSeconds),
      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
    );
  }
}
