import 'package:flutter/material.dart';
import 'package:pomodoro_timer/controllers/summary_controller.dart';
import 'package:pomodoro_timer/theme/app_button_styles.dart';
import 'package:pomodoro_timer/theme/app_colors.dart';
import 'package:pomodoro_timer/theme/app_text_styles.dart';
import 'package:pomodoro_timer/utils/time_utils.dart';

class SummaryCardGroup extends StatefulWidget {
  final String type; // 'daily' or 'weekly'
  final VoidCallback? onResetOverride;

  const SummaryCardGroup(this.type, {super.key, this.onResetOverride});

  @override
  State<SummaryCardGroup> createState() => _SummaryCardGroupState();
}

class _SummaryCardGroupState extends State<SummaryCardGroup> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Tambahkan method ini untuk load data
  void _loadData() {
    data = SummaryController.getSummary()[widget.type]!;
  }

  // Override didUpdateWidget untuk refresh data ketika widget di-rebuild
  @override
  void didUpdateWidget(SummaryCardGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh data setiap kali widget di-update (karena key berubah)
    _loadData();
  }

  void _reset() {
    if (widget.type == 'daily') {
      SummaryController.resetDailySummary();
    } else {
      SummaryController.resetWeeklySummary();
    }

    setState(() {
      _loadData(); // Gunakan method _loadData
    });

    if (widget.onResetOverride != null) {
      widget.onResetOverride!();
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.type == 'daily' ? 'Today' : 'This Week';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.tagBlueBG,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(title, style: AppTextStyles.tag),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildInfoBox('${data['sessions']}', 'Session'),
            _buildInfoBox(TimeUtils.formatDurationFromSeconds(data['time']), 'Duration'),
          ],
        ),
        const SizedBox(height: 12),
        _buildResetButton("Reset", _reset),
      ],
    );
  }

  Widget _buildInfoBox(String value, String label) {
    return Container(
      width: 130,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.strokeBlue),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: AppTextStyles.regular),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.secondaryRegular),
        ],
      ),
    );
  }

  Widget _buildResetButton(String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: AppButtonStyles.regular,
      onPressed: onPressed,
      icon: const Icon(Icons.refresh, color: AppColors.buttonPurpleLabel),
      label: Text(label, style: AppTextStyles.button),
    );
  }
}