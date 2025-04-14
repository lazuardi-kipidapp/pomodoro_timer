import 'package:flutter/material.dart';
import 'package:pomodoro_timer/utils/custom_colors.dart';
import 'package:pomodoro_timer/widgets/summary_card_group.dart';
import 'package:pomodoro_timer/widgets/timer_navpills.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool isWorkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Mode Switcher
              NavPills(
                isWorkMode: isWorkMode,
                onTap: (bool value) {
                  setState(() {
                    isWorkMode = value;
                    // ubah mode dan state lainnya
                  });
                },
              ),
          
              const SizedBox(height: 30),
          
              // Circular Timer Display
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: 0.5,
                        strokeWidth: 12,
                        backgroundColor: CustomColors.progressPurpleBG,
                        valueColor: const AlwaysStoppedAnimation(CustomColors.progressPurpleValue),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("25:00", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.settings),
                          color: CustomColors.buttonPurpleBG,
                        )
                      ],
                    )
                  ],
                ),
              ),
          
              const SizedBox(height: 30),
          
              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(Icons.play_arrow, "Start", () {}),
                  const SizedBox(width: 20),
                  _buildControlButton(Icons.pause, "Pause", () {}),
                  const SizedBox(width: 20),
                  _buildControlButton(Icons.stop, "Reset", () {}),
                ],
              ),
          
              const SizedBox(height: 36),
          
              // Today Summary Card Group
              const SummaryCardGroup('daily'),
            ],
          ),
        ),
      ),
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
