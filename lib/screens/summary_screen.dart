import 'package:flutter/material.dart';
import 'package:pomodoro_timer/controllers/summary_controller.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final summary = SummaryController.getSummary();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummarySection('Daily Summary', summary['daily']!),
            const SizedBox(height: 20),
            _buildSummarySection('Weekly Summary', summary['weekly']!),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(String title, Map<String, dynamic> data) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Sessions: ${data['sessions']}'),
            Text('Time Spent: ${data['time']} minutes'),
          ],
        ),
      ),
    );
  }
}
