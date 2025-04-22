import 'package:flutter/material.dart';
import 'package:pomodoro_timer/utils/custom_colors.dart';

class TimerDisplay extends StatefulWidget {
  final int timeInSeconds;
  final int totalDuration;
  final VoidCallback onSettingsPressed;

  const TimerDisplay({
    super.key,
    required this.timeInSeconds,
    required this.totalDuration,
    required this.onSettingsPressed,
  });

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  late double _previousProgress;
  late double _currentProgress;

  @override
  void initState() {
    super.initState();
    _currentProgress = 1 - (widget.timeInSeconds / widget.totalDuration);
    _previousProgress = _currentProgress;
  }

  @override
  void didUpdateWidget(covariant TimerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _previousProgress = _currentProgress;
    _currentProgress = 1 - (widget.timeInSeconds / widget.totalDuration);
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${remainingSeconds.toString().padLeft(2, '0')}';
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: _previousProgress, end: _currentProgress),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) => SizedBox(
              width: 220,
              height: 220,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 12,
                backgroundColor: CustomColors.progressPurpleBG,
                valueColor: const AlwaysStoppedAnimation(CustomColors.progressPurpleValue),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(widget.timeInSeconds),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: widget.onSettingsPressed,
                icon: const Icon(Icons.settings),
                color: CustomColors.buttonPurpleBG,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
