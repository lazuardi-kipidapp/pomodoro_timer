// timer_screen.dart - Updated version
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_timer/providers/timer_provider.dart';
import 'package:pomodoro_timer/theme/app_colors.dart';
import 'package:pomodoro_timer/widgets/custom_timer_dialog.dart';
import 'package:pomodoro_timer/widgets/summary_card_group.dart';
import 'package:pomodoro_timer/widgets/timer_buttons.dart';
import 'package:pomodoro_timer/widgets/timer_display.dart';
import 'package:pomodoro_timer/widgets/timer_navpills.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Key summaryKey = UniqueKey();

  void _showCustomTimerDialog() async {
    final timerProvider = context.read<TimerProvider>();
    
    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) => CustomTimerDialog(
        initialWorkDuration: timerProvider.timerModel.workDuration,
        initialBreakDuration: timerProvider.timerModel.breakDuration,
      ),
    );
    
    if (result != null) {
      timerProvider.updateTimerSettings(result['work']!, result['break']!);
      setState(() {
        summaryKey = UniqueKey(); // Force rebuild SummaryCardGroup
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Consumer<TimerProvider>(
              builder: (context, timerProvider, child) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                
                    // Mode Switcher
                    NavPills(
                      onTap: (bool value) {
                        timerProvider.stopTimer();
                        timerProvider.changeMode(value ? 'Work' : 'Break');
                      },
                      isWorkSession: timerProvider.timerModel.isWorkSession,
                    ),
                
                    const SizedBox(height: 30),
                
                    // Circular Timer Display
                    TimerDisplay(
                      timeInSeconds: timerProvider.timerModel.remainingTime,
                      totalDuration: timerProvider.timerModel.isWorkSession 
                          ? timerProvider.timerModel.workDuration 
                          : timerProvider.timerModel.breakDuration,
                      onSettingsPressed: _showCustomTimerDialog,
                    ),
                
                    const SizedBox(height: 30),
                
                    // Control Buttons
                    TimerButtons(
                      isRunning: timerProvider.isRunning,
                      isResumable: timerProvider.isResumable,
                      onStart: timerProvider.startTimer,
                      onStop: timerProvider.stopTimer,
                      onReset: timerProvider.resetTimer,
                    ),
                
                    const SizedBox(height: 36),
                
                    // Today Summary Card Group
                    SummaryCardGroup('daily', key: summaryKey),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}