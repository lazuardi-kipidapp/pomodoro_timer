import 'package:flutter/material.dart';
import 'package:pomodoro_timer/utils/strings.dart';

class TimerButtons extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onReset;

  const TimerButtons({
    super.key,
    required this.isRunning,
    required this.onStart,
    required this.onStop,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: isRunning ? onStop : onStart,
          child: Text(isRunning ? Strings.pause : Strings.start),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: onReset,
          child: const Text(Strings.reset),
        ),
      ],
    );
  }
}
