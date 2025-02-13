import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      null, // Icon default untuk notifikasi
      [
        NotificationChannel(
          channelKey: 'pomodoro_channel',
          channelName: 'Pomodoro Notifications',
          channelDescription: 'Notifications for Pomodoro Timer',
          defaultColor: const Color(0xFF9D50DD),
          importance: NotificationImportance.High,
          channelShowBadge: true,
        )
      ],
    );
  }

  Future<void> showNotification(bool isWorkSession) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'pomodoro_channel',
        title: isWorkSession ? 'Break Time!' : 'Work Time!',
        body: isWorkSession
            ? 'Time to take a short break.'
            : 'Get back to work and stay focused!',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}