import 'package:flutter/material.dart';
import 'package:pomodoro_timer/providers/summary_provider.dart';
import 'package:pomodoro_timer/theme/app_button_styles.dart';
import 'package:pomodoro_timer/theme/app_colors.dart';
import 'package:pomodoro_timer/controllers/summary_controller.dart';
import 'package:pomodoro_timer/theme/app_text_styles.dart';
import 'package:pomodoro_timer/widgets/summary_card_group.dart';
import 'package:provider/provider.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.microtask(() {
      final provider = context.read<SummaryProvider>();
      provider.refresh();
    });
  }

  void _resetAll() {
    context.read<SummaryProvider>().resetAll();
  }

  Widget _buildResetAllButton() {
    return ElevatedButton.icon(
      style: AppButtonStyles.regular,
      onPressed: _resetAll,
      icon: const Icon(Icons.refresh, color: AppColors.buttonPurpleLabel),
      label: const Text("Reset All", style: AppTextStyles.button),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
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

