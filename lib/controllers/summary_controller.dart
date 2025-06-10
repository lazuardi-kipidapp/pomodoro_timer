import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SummaryController {
  static late SharedPreferences _prefs;

  // init() sekarang akan memanggil pengecekan harian dan mingguan
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Pengecekan dilakukan secara berurutan
    _checkAndResetDailySummary();
    _checkAndResetWeeklySummary(); // <-- Tambahan baru
  }

  static void recordWorkSession(int seconds) {
    _increment('daily_sessions');
    _increment('daily_time', seconds);
    _increment('weekly_sessions');
    _increment('weekly_time', seconds);
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

  static void resetDailySummary() {
    _prefs.setInt('daily_sessions', 0);
    _prefs.setInt('daily_time', 0);
  }

  static void resetWeeklySummary() {
    _prefs.setInt('weekly_sessions', 0);
    _prefs.setInt('weekly_time', 0);
  }

  static void resetAllSummary() {
    resetDailySummary();
    resetWeeklySummary();
  }

  static void _checkAndResetDailySummary() {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String lastUsedDate = _prefs.getString('last_used_date') ?? '';

    if (today != lastUsedDate) {
      _prefs.setString('last_used_date', today);
      resetDailySummary();
    }
  }

  // --- METHOD BARU UNTUK LOGIKA MINGGUAN ---
  static void _checkAndResetWeeklySummary() {
    DateTime today = DateTime.now();
    
    // Hitung tanggal hari Senin pada minggu ini.
    // Properti `weekday` mengembalikan 1 untuk Senin, 2 untuk Selasa, ..., 7 untuk Minggu.
    // Jadi, kita kurangi tanggal hari ini dengan (hari_ke_berapa - 1) hari.
    // Contoh: jika hari ini Rabu (weekday = 3), Senin adalah 3 - 1 = 2 hari yang lalu.
    DateTime startOfCurrentWeek = today.subtract(Duration(days: today.weekday - 1));
    
    // Format tanggal Senin menjadi string untuk disimpan dan dibandingkan
    String startOfCurrentWeekStr = DateFormat('yyyy-MM-dd').format(startOfCurrentWeek);
    
    // Ambil tanggal Senin dari minggu terakhir aplikasi dibuka
    String startOfLastWeekStr = _prefs.getString('start_of_last_week') ?? '';

    // Jika tanggal Senin minggu ini berbeda dengan yang tersimpan,
    // berarti ini adalah minggu baru.
    if (startOfCurrentWeekStr != startOfLastWeekStr) {
      // Simpan tanggal Senin minggu ini sebagai penanda baru
      _prefs.setString('start_of_last_week', startOfCurrentWeekStr);
      // Reset data mingguan
      resetWeeklySummary();
    }
  }
  // ------------------------------------------

  static void _increment(String key, [int value = 1]) {
    int current = _prefs.getInt(key) ?? 0;
    _prefs.setInt(key, current + value);
  }
}