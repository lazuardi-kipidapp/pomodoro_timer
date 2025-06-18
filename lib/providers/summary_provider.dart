import 'package:flutter/material.dart';
import '../controllers/summary_controller.dart';

class SummaryProvider extends ChangeNotifier {
  Map<String, Map<String, dynamic>> _summary = SummaryController.getSummary();

  Map<String, Map<String, dynamic>> get summary => _summary;

  void refresh() {
    _summary = SummaryController.getSummary();
    notifyListeners();
  }

  void resetDaily() {
    SummaryController.resetDailySummary();
    refresh();
  }

  void resetWeekly() {
    SummaryController.resetWeeklySummary();
    refresh();
  }

  void resetAll() {
    SummaryController.resetAllSummary();
    refresh();
  }
  
  Future<void> loadSummary() async {
    _summary = SummaryController.getSummary();
    notifyListeners();
  }


}
