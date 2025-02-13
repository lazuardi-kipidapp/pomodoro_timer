import 'package:flutter/material.dart';
import 'package:pomodoro_timer/controllers/summary_controller.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late Map<String, Map<String, dynamic>> summary;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  void _loadSummary() {
    setState(() {
      summary = SummaryController.getSummary();
    });
  }

  void _resetDailySummary() {
    SummaryController.resetDailySummary();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Daily summary reset!')),
    );
    _loadSummary();
  }

  void _resetWeeklySummary() {
    SummaryController.resetWeeklySummary();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Weekly summary reset!')),
    );
    _loadSummary();
  }

  void _resetAllSummary() {
    SummaryController.resetAllSummary();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All summary reset!')),
    );
    _loadSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daily Summary: ${summary['daily']!['sessions']} sessions, ${summary['daily']!['time']} min'),
            const SizedBox(height: 10),
            Text('Weekly Summary: ${summary['weekly']!['sessions']} sessions, ${summary['weekly']!['time']} min'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetDailySummary,
              child: const Text('Reset Daily Summary'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetWeeklySummary,
              child: const Text('Reset Weekly Summary'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetAllSummary,
              child: const Text('Reset All Summary'),
            ),
          ],
        ),
      ),
    );
  }
}
