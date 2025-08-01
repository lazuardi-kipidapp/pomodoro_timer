import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_timer/providers/summary_provider.dart';
import 'package:pomodoro_timer/providers/timer_provider.dart';
import 'package:pomodoro_timer/screens/main_screen.dart';
import 'package:pomodoro_timer/controllers/summary_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro_timer/screens/splash_screen.dart';
import 'package:pomodoro_timer/services/notification_service.dart';
import 'package:pomodoro_timer/theme/app_colors.dart';
import 'package:provider/provider.dart';

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
  runApp(PomodoroTimerApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class PomodoroTimerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimerProvider()),
        ChangeNotifierProvider(create: (context) => SummaryProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.backgroundBlue,
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
      home: SplashScreen(),
    ),
    );
  }
}

