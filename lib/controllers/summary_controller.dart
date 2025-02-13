import 'package:shared_preferences/shared_preferences.dart';

class SummaryController {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
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

  static void _increment(String key, [int value = 1]) {
    int current = _prefs.getInt(key) ?? 0;
    _prefs.setInt(key, current + value);
  }
}
