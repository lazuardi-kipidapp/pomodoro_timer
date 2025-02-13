import 'package:flutter/material.dart';
import 'package:pomodoro_timer/screens/timer_screen.dart';
import 'package:pomodoro_timer/screens/summary_screen.dart';
import 'package:pomodoro_timer/controllers/summary_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SummaryController.init();
  runApp(const PomodoroTimerApp());
}

class PomodoroTimerApp extends StatelessWidget {
  const PomodoroTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TimerScreen(),
      routes: {
        '/summary': (context) => const SummaryScreen(),
      },
    );
  }
}

