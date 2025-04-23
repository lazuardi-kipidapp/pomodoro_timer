import 'package:flutter/material.dart';
import 'package:pomodoro_timer/utils/custom_colors.dart';
import 'package:pomodoro_timer/utils/time_utils.dart';

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
                TimeUtils.formatDurationFromSeconds(widget.timeInSeconds),
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
