import 'package:flutter/material.dart';
import 'package:pomodoro_timer/utils/custom_colors.dart';
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
        isRunning ? 
        _buildControlButton(Icons.pause, Strings.pause, onStop) :
        _buildControlButton(Icons.play_arrow, Strings.start, onStart),
        const SizedBox(width: 20),
        _buildControlButton(Icons.stop, Strings.reset, onReset),
      ],
    );
  }

  Widget _buildControlButton(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.buttonPurpleBG,
        foregroundColor: CustomColors.buttonPurpleLabel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
