class TimerModel {
  int workDuration;
  int breakDuration;
  int remainingTime;
  bool isWorkSession;

  TimerModel({
    required this.workDuration,
    required this.breakDuration,
    required this.remainingTime,
    required this.isWorkSession,
  });
}
