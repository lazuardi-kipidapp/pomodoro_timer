import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_timer/controllers/summary_controller.dart';
import 'package:pomodoro_timer/models/timer_model.dart';
import 'package:pomodoro_timer/services/notification_service.dart';
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
  late TimerModel timerModel;
  bool isRunning = false;
  bool isResumable = false;
  Timer? timer;
  final NotificationService _notificationService = NotificationService();
  String selectedMode = 'Work';

  Key summaryKey = UniqueKey();
  
  @override
  void initState() {
    super.initState();
    Map<String, int> settings = SummaryController.getTimerSettings();
    timerModel = TimerModel(
      workDuration: settings['work_duration']!,
      breakDuration: settings['break_duration']!,
      remainingTime: settings['work_duration']!,
      isWorkSession: true,
    );
    _notificationService.initializeNotifications();
  }

  void _startTimer() {
    setState(() {
      isRunning = true;
      isResumable = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerModel.remainingTime > 0) {
        setState(() => timerModel.remainingTime--);
      } else {
        _notificationService.showNotification(timerModel.isWorkSession);
        if (timerModel.isWorkSession) {
          final workedSeconds = timerModel.workDuration;
          SummaryController.recordWorkSession(workedSeconds);

          setState(() {
            summaryKey = UniqueKey(); // Force rebuild SummaryCardGroup
          });
        }
        _switchSession();
      }
    });
  }


  void _stopTimer() {
    setState(() {
      isRunning = false; 
      isResumable = false;
    });
    timer?.cancel();
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      timerModel.remainingTime = timerModel.isWorkSession ? timerModel.workDuration : timerModel.breakDuration;
    });
  }

  void _changeMode(String newMode) {
    setState(() {
      selectedMode = newMode;
      timerModel.isWorkSession = selectedMode == 'Work';
      timerModel.remainingTime = timerModel.isWorkSession
          ? timerModel.workDuration
          : timerModel.breakDuration;
    });
  }

  void _switchSession() {
    _stopTimer();
    _changeMode(timerModel.isWorkSession ? 'Break' : 'Work');
  }

  void _showCustomTimerDialog() async {
    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) => CustomTimerDialog(
        initialWorkDuration: timerModel.workDuration,
        initialBreakDuration: timerModel.breakDuration,
      ),
    );
    if (result != null) {
      setState(() {
        timerModel.workDuration = result['work']!;
        timerModel.breakDuration = result['break']!;
        timerModel.remainingTime = timerModel.workDuration;
      });
      SummaryController.saveTimerSettings(timerModel.workDuration, timerModel.breakDuration);
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
            child: Column(
              children: [
                const SizedBox(height: 20),
            
                // Mode Switcher
                NavPills(
                  onTap: (bool value) {
                    setState(() {
                      _stopTimer();
                      timerModel.isWorkSession = value;
                      timerModel.remainingTime = timerModel.isWorkSession
                      ? timerModel.workDuration
                      : timerModel.breakDuration;
                    });
                  }, isWorkSession: timerModel.isWorkSession,
                ),
            
                const SizedBox(height: 30),
            
                // Circular Timer Display
                TimerDisplay(
                  timeInSeconds: timerModel.remainingTime,
                  totalDuration: timerModel.isWorkSession ? timerModel.workDuration : timerModel.breakDuration,
                  onSettingsPressed: _showCustomTimerDialog),
            
                const SizedBox(height: 30),
            
                // Control Buttons
                TimerButtons(
                  isRunning: isRunning,
                  isResumable: isResumable,
                  onStart: _startTimer,
                  onStop: _stopTimer,
                  onReset: _resetTimer,
                ),
            
                const SizedBox(height: 36),
            
                // Today Summary Card Group
                SummaryCardGroup('daily', key: summaryKey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}
