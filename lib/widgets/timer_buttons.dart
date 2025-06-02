import 'package:flutter/material.dart';
import 'package:pomodoro_timer/theme/app_button_styles.dart';
import 'package:pomodoro_timer/theme/app_colors.dart';
import 'package:pomodoro_timer/constants/strings.dart';
import 'package:pomodoro_timer/theme/app_text_styles.dart';

class TimerButtons extends StatelessWidget {
  final bool isRunning;
  final bool isResumable;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onReset;

  const TimerButtons({
    super.key,
    required this.isRunning,
    required this.isResumable,
    required this.onStart,
    required this.onStop,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isRunning)...[
          _buildControlButton(Icons.pause, Strings.pause, onStop),
          const SizedBox(width: 20),
          _buildControlButton(Icons.stop, Strings.reset, onReset),
        ] else ...[
          _buildControlButton(Icons.play_arrow, isResumable? Strings.resume : Strings.start, onStart),
        ],
      ],
    );
  }

  Widget _buildControlButton(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: AppColors.buttonPurpleLabel,),
      label: Text(label, style: AppTextStyles.button),
      style: AppButtonStyles.regular,
    );
  }
}
