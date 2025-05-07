class TimeUtils {
  // Display time with HH:MM:SS format
  // Example: 3600 seconds will be displayed as "01:00:00"
  static String formatDurationFromSeconds(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
  }

  // Convert HH:MM:SS format to seconds
  // Example: "01:00:00" will be converted to 3600 seconds
  static int parseHHMMSS(String input) {
    final parts = input.trim().split(':').map(int.tryParse).toList();
    if (parts.length != 3 || parts.contains(null)) return 0;
    return (parts[0]! * 3600) + (parts[1]! * 60) + parts[2]!;
  }
}
