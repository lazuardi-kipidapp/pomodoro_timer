import 'package:flutter/material.dart';
import 'package:pomodoro_timer/controllers/summary_controller.dart';
import 'package:pomodoro_timer/utils/custom_colors.dart';
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
    data = SummaryController.getSummary()[widget.type]!;
  }

  void _reset() {
    if (widget.type == 'daily') {
      SummaryController.resetDailySummary();
    } else {
      SummaryController.resetWeeklySummary();
    }

    setState(() {
      data = SummaryController.getSummary()[widget.type]!;
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

}
