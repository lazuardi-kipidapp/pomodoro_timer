import 'package:flutter/material.dart';
import 'package:pomodoro_timer/screens/timer_screen.dart';
import 'package:pomodoro_timer/screens/summary_screen.dart';
import 'package:pomodoro_timer/controllers/summary_controller.dart';
import 'package:pomodoro_timer/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SummaryController.init();
  await NotificationService().initializeNotifications();
  runApp(const PomodoroTimerApp());
}

class PomodoroTimerApp extends StatelessWidget {
  const PomodoroTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TimerScreen(),
      routes: {
        '/summary': (context) => const SummaryScreen(),
      },
    );
  }
}