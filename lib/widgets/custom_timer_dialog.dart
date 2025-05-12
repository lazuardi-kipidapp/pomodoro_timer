import 'package:flutter/material.dart';
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

  void _setPreset(int workMinutes, int breakMinutes) {
    setState(() {
      _workController.text = TimeUtils.formatDurationFromSeconds(workMinutes * 60);
      _breakController.text = TimeUtils.formatDurationFromSeconds(breakMinutes * 60);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Custom Timer (HH:MM:SS)'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => _setPreset(25, 5),
                      child: const Text('Pomodoro\n25/5'),
                    ),
                    ElevatedButton(
                      onPressed: () => _setPreset(15, 3),
                      child: const Text('Short\n15/3'),
                    ),
                    ElevatedButton(
                      onPressed: () => _setPreset(45, 10),
                      child: const Text('Focus\n45/10'),
                    ),
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
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
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
          child: const Text('Set Timer'),
        ),
      ],
    );
  }
}
