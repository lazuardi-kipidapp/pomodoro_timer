import 'package:flutter/material.dart';
import 'package:pomodoro_timer/utils/custom_colors.dart';
import 'package:pomodoro_timer/controllers/summary_controller.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late Map<String, Map<String, dynamic>> summary;

  @override
  void initState() {
    super.initState();
    summary = SummaryController.getSummary();
  }

  void _resetDaily() {
    SummaryController.resetDailySummary();
    setState(() {
      summary = SummaryController.getSummary();
    });
  }

  void _resetWeekly() {
    SummaryController.resetWeeklySummary();
    setState(() {
      summary = SummaryController.getSummary();
    });
  }

  void _resetAll() {
    SummaryController.resetAllSummary();
    setState(() {
      summary = SummaryController.getSummary();
    });
  }

  Widget _buildSummaryCard(String title, Map<String, dynamic> data, VoidCallback onReset) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            color: CustomColors.tagBlueBG,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildInfoBox('${data['sessions']}', 'Session'),
            _buildInfoBox(_formatDuration(data['time']), 'Duration'),
          ],
        ),
        const SizedBox(height: 12),
        _buildResetButton("Reset", onReset),
      ],
    );
  }

  Widget _buildInfoBox(String value, String label) {
    return Container(
      width: 130,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.strokeBlue),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildResetButton(String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.buttonPurpleBG,
        foregroundColor: CustomColors.buttonPurpleLabel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.refresh),
      label: Text(label),
    );
  }

  String _formatDuration(int minutes) {
    final d = Duration(minutes: minutes);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${d.inHours}:${twoDigits(d.inMinutes.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              _buildSummaryCard("Today", summary['daily']!, _resetDaily),
              const SizedBox(height: 24),
              _buildSummaryCard("This Week", summary['weekly']!, _resetWeekly),
              const SizedBox(height: 24),
              _buildResetButton("Reset All", _resetAll),
            ],
          ),
        ),
      ),
    );
  }
}
