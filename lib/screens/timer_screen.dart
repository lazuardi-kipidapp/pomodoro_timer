
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
    timerModel = TimerModel(workDuration: 25 * 60, breakDuration: 5 * 60, remainingTime: 25 * 60, isWorkSession: true);
  }

  void _startTimer() {
    setState(() => isRunning = true);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerModel.remainingTime > 0) {
        setState(() => timerModel.remainingTime--);
      } else {
        _notificationService.showNotification(timerModel.isWorkSession);
        if (timerModel.isWorkSession) {
          SummaryController.recordWorkSession(25);
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
      timerModel.remainingTime = timerModel.isWorkSession ? timerModel.workDuration : timerModel.breakDuration;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final summary = SummaryController.getSummary();
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
            Text(
            timerModel.isWorkSession ? 'Work Session' : 'Break Session',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
            Text(
              'Today: ${summary['daily']?['sessions']} sessions, ${summary['daily']?['time']} minutes',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            TimerDisplay(timeInSeconds: timerModel.remainingTime),
            const SizedBox(height: 20),
            TimerButtons(
              isRunning: isRunning,
              onStart: _startTimer,
              onStop: _stopTimer,
              onReset: _resetTimer,
            ),
          ],
        ),
      ),
    );
  }
}

