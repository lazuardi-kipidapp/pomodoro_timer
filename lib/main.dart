import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_timer/screens/main_screen.dart';
import 'package:pomodoro_timer/screens/timer_screen.dart';
import 'package:pomodoro_timer/screens/summary_screen.dart';
import 'package:pomodoro_timer/controllers/summary_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro_timer/services/notification_service.dart';
import 'package:pomodoro_timer/utils/custom_colors.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> requestNotificationPermission() async {
  final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  if (androidPlugin != null) {
    bool? granted = await androidPlugin.requestNotificationsPermission();
    if (granted == false) {
      print("Izin notifikasi tidak diberikan oleh pengguna.");
    }
  }
}

Future<void> requestNotificationPermissionWindows() async {
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestNotificationPermission();
  await requestNotificationPermissionWindows();
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
      theme: ThemeData(
        scaffoldBackgroundColor: CustomColors.backgroundBlue,
        primarySwatch: Colors.blue,
        fontFamily: 'Nunito',
        textTheme: TextTheme(
          labelMedium: TextStyle(fontSize: 22,fontWeight: FontWeight.w800),
          labelSmall: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
          displayLarge: TextStyle(fontSize: 48,fontWeight: FontWeight.w700),
          displayMedium: TextStyle(fontSize: 36,fontWeight: FontWeight.w700),
          displaySmall: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),
        ),
      ),
      home: MainScreen(),
    );
  }
}

