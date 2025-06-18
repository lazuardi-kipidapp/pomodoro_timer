// timer_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodoro_timer/controllers/summary_controller.dart';
import 'package:pomodoro_timer/main.dart';
import 'package:pomodoro_timer/models/timer_model.dart';
import 'package:pomodoro_timer/providers/summary_provider.dart';
import 'package:pomodoro_timer/services/notification_service.dart';
import 'package:provider/provider.dart';

class TimerProvider extends ChangeNotifier {
  late TimerModel _timerModel;
  bool _isRunning = false;
  bool _isResumable = false;
  Timer? _timer;
  final NotificationService _notificationService = NotificationService();
  String _selectedMode = 'Work';

  // Getters
  TimerModel get timerModel => _timerModel;
  bool get isRunning => _isRunning;
  bool get isResumable => _isResumable;
  String get selectedMode => _selectedMode;

  TimerProvider() {
    _initializeTimer();
    _notificationService.initializeNotifications();
  }

  void _initializeTimer() {
    Map<String, int> settings = SummaryController.getTimerSettings();
    _timerModel = TimerModel(
      workDuration: settings['work_duration']!,
      breakDuration: settings['break_duration']!,
      remainingTime: settings['work_duration']!,
      isWorkSession: true,
    );
  }

  void startTimer() {
    _isRunning = true;
    _isResumable = true;
    notifyListeners();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerModel.remainingTime > 0) {
        _timerModel.remainingTime--;
        notifyListeners();
      } else {
        _notificationService.showNotification(_timerModel.isWorkSession);
        if (_timerModel.isWorkSession) {
          final workedSeconds = _timerModel.workDuration;
          SummaryController.recordWorkSession(workedSeconds);
          
          // Refresh summary provider
          if (navigatorKey.currentContext != null) {
            final context = navigatorKey.currentContext!;
            context.read<SummaryProvider>().refresh();
          }
        }

        _switchSession();
      }
    });
  }

  void stopTimer() {
    _isRunning = false;
    _isResumable = false;
    _timer?.cancel();
    notifyListeners();
  }

  void resetTimer() {
    stopTimer();
    _timerModel.remainingTime = _timerModel.isWorkSession 
        ? _timerModel.workDuration 
        : _timerModel.breakDuration;
    notifyListeners();
  }

  void changeMode(String newMode) {
    _selectedMode = newMode;
    _timerModel.isWorkSession = _selectedMode == 'Work';
    _timerModel.remainingTime = _timerModel.isWorkSession
        ? _timerModel.workDuration
        : _timerModel.breakDuration;
    notifyListeners();
  }

  void _switchSession() {
    stopTimer();
    changeMode(_timerModel.isWorkSession ? 'Break' : 'Work');
  }

  void updateTimerSettings(int workDuration, int breakDuration) {
    _timerModel.workDuration = workDuration;
    _timerModel.breakDuration = breakDuration;
    _timerModel.remainingTime = workDuration;
    SummaryController.saveTimerSettings(workDuration, breakDuration);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}