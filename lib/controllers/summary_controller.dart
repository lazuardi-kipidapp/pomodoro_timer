import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SummaryController {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _checkAndResetDailySummary();
  }

  static void recordWorkSession(int minutes) {
    _increment('daily_sessions');
    _increment('daily_time', minutes);
    _increment('weekly_sessions');
    _increment('weekly_time', minutes);
  }

  static Map<String, Map<String, dynamic>> getSummary() {
    return {
      'daily': {
        'sessions': _prefs.getInt('daily_sessions') ?? 0,
        'time': _prefs.getInt('daily_time') ?? 0,
      },
      'weekly': {
        'sessions': _prefs.getInt('weekly_sessions') ?? 0,
        'time': _prefs.getInt('weekly_time') ?? 0,
      },
    };
  }

  static void saveTimerSettings(int workDuration, int breakDuration) {
    _prefs.setInt('work_duration', workDuration);
    _prefs.setInt('break_duration', breakDuration);
  }

  static Map<String, int> getTimerSettings() {
    return {
      'work_duration': _prefs.getInt('work_duration') ?? 25 * 60,
      'break_duration': _prefs.getInt('break_duration') ?? 5 * 60,
    };
  }

  static void _checkAndResetDailySummary() {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String lastUsedDate = _prefs.getString('last_used_date') ?? '';

    if (today != lastUsedDate) {
      _prefs.setString('last_used_date', today);
      _prefs.setInt('daily_sessions', 0);
      _prefs.setInt('daily_time', 0);
    }
  }

  static void _increment(String key, [int value = 1]) {
    int current = _prefs.getInt(key) ?? 0;
    _prefs.setInt(key, current + value);
  }
}