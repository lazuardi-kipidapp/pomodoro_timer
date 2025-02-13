// File: custom_timer_dialog.dart
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _workController = TextEditingController(
      text: (widget.initialWorkDuration ~/ 60).toString(),
    );
    _breakController = TextEditingController(
      text: (widget.initialBreakDuration ~/ 60).toString(),
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
      _workController.text = workMinutes.toString();
      _breakController.text = breakMinutes.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Custom Timer'),
      content: Column(
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
          TextField(
            controller: _workController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Work Duration (minutes)'),
          ),
          TextField(
            controller: _breakController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Break Duration (minutes)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            int workDuration = int.tryParse(_workController.text) ?? 25;
            int breakDuration = int.tryParse(_breakController.text) ?? 5;
            Navigator.pop(context, {'work': workDuration * 60, 'break': breakDuration * 60});
          },
          child: const Text('Set Timer'),
        ),
      ],
    );
  }
}
