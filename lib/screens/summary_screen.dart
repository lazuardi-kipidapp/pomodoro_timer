import 'package:flutter/material.dart';
import 'package:pomodoro_timer/utils/custom_colors.dart';
import 'package:pomodoro_timer/controllers/summary_controller.dart';
import 'package:pomodoro_timer/widgets/summary_card_group.dart';

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

  void _resetAll() {
    SummaryController.resetAllSummary();
    setState(() {
      summary = SummaryController.getSummary();
    });
  }

  Widget _buildResetAllButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.buttonPurpleBG,
        foregroundColor: CustomColors.buttonPurpleLabel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      onPressed: _resetAll,
      icon: const Icon(Icons.refresh),
      label: const Text("Reset All"),
    );
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
              SummaryCardGroup('daily'),
              const SizedBox(height: 24),
              SummaryCardGroup('weekly'),
              const SizedBox(height: 24),
              Center(child: _buildResetAllButton()),
            ],
          ),
        ),
      ),
    );
  }
}