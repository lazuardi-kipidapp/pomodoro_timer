import 'package:flutter/material.dart';
import 'package:pomodoro_timer/theme/app_button_styles.dart';
import 'package:pomodoro_timer/theme/app_colors.dart';
import 'package:pomodoro_timer/theme/app_text_styles.dart';
import 'package:pomodoro_timer/utils/utils.dart';
import 'package:pomodoro_timer/widgets/duration_input_field.dart';

class CustomTimerDialog extends StatefulWidget {
  final int initialWorkDuration;
  final int initialBreakDuration;

  const CustomTimerDialog({
    super.key,
    required this.initialWorkDuration,
    required this.initialBreakDuration,
  });

  @override
  _CustomTimerDialogState createState() => _CustomTimerDialogState();
}

class _CustomTimerDialogState extends State<CustomTimerDialog> {
  late TextEditingController _workController;
  late TextEditingController _breakController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _workController = TextEditingController(
      text: TimeUtils.formatDurationFromSeconds(widget.initialWorkDuration),
    );
    _breakController = TextEditingController(
      text: TimeUtils.formatDurationFromSeconds(widget.initialBreakDuration),
    );
  }

  @override
  void dispose() {
    _workController.dispose();
    _breakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPresetButton('15/3', () => _setPreset(15, 3)),
                      const SizedBox(width: 10),
                      _buildPresetButton('25/5', () => _setPreset(25, 5)),
                      const SizedBox(width: 10),
                      _buildPresetButton('45/10', () => _setPreset(45, 10)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  DurationInputField(
                    controller: _workController,
                    label: 'Work Duration',
                    hintText: 'HH:MM:SS',
                  ),
                  DurationInputField(
                    controller: _breakController,
                    label: 'Break Duration',
                    hintText: 'HH:MM:SS',
                  ),
                  const SizedBox(height: 20),
        
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, null),
                          style: AppButtonStyles.secondary,
                          child: Text("Cancel", style: AppTextStyles.button),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final workDuration = TimeUtils.parseHHMMSS(_workController.text);
                              final breakDuration = TimeUtils.parseHHMMSS(_breakController.text);
                              Navigator.pop(context, {
                                'work': workDuration,
                                'break': breakDuration,
                              });
                            }
                          },
                          style: AppButtonStyles.regular,
                          child: Text("Set", style: AppTextStyles.button),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setPreset(int workMinutes, int breakMinutes) {
    setState(() {
      _workController.text = TimeUtils.formatDurationFromSeconds(workMinutes * 60);
      _breakController.text = TimeUtils.formatDurationFromSeconds(breakMinutes * 60);
    });
  }

  Widget _buildPresetButton(String label, VoidCallback callBack) {
    return Expanded(
      child: ElevatedButton(
        onPressed: callBack,
        style: AppButtonStyles.regular,
        child: Text(label, style: AppTextStyles.button),
      ),
    );
  }
}
