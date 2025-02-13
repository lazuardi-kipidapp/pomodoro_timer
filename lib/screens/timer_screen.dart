import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodoro_timer/utils/strings.dart';
import 'package:pomodoro_timer/models/timer_model.dart';
import 'package:pomodoro_timer/services/notification_service.dart';
import 'package:pomodoro_timer/controllers/summary_controller.dart';
import 'package:pomodoro_timer/widgets/timer_display.dart';
import 'package:pomodoro_timer/widgets/timer_buttons.dart';
import 'package:pomodoro_timer/widgets/custom_timer_dialog.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late TimerModel timerModel;
  bool isRunning = false;
  Timer? timer;
  final NotificationService _notificationService = NotificationService();

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
    setState(() => isRunning = true);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerModel.remainingTime > 0) {
        setState(() => timerModel.remainingTime--);
      } else {
        _notificationService.showNotification(timerModel.isWorkSession);
        if (timerModel.isWorkSession) {
          SummaryController.recordWorkSession(timerModel.workDuration ~/ 60);
        }
        _switchSession();
      }
    });
  }

  void _stopTimer() {
    setState(() => isRunning = false);
    timer?.cancel();
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      timerModel.remainingTime = timerModel.isWorkSession ? timerModel.workDuration : timerModel.breakDuration;
    });
  }

  void _switchSession() {
    _stopTimer();
    setState(() {
      timerModel.isWorkSession = !timerModel.isWorkSession;
      timerModel.remainingTime = timerModel.isWorkSession ? timerModel.workDuration : timerModel.breakDuration;
    });
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
    Map<String, dynamic> dailySummary = SummaryController.getSummary()['daily']!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.pomodoroTimerTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.pushNamed(context, '/summary'),
          ),
          IconButton(
            icon: const Icon(Icons.timer),
            onPressed: _showCustomTimerDialog,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimerDisplay(timeInSeconds: timerModel.remainingTime),
            Text(
              timerModel.isWorkSession ? 'Work Session' : 'Break Session',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TimerButtons(
              isRunning: isRunning,
              onStart: _startTimer,
              onStop: _stopTimer,
              onReset: _resetTimer,
            ),
            const SizedBox(height: 20),
            Text('Today: ${dailySummary['sessions']} sessions, ${dailySummary['time']} min'),
          ],
        ),
      ),
    );
  }
}