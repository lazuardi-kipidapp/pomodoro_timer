import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DurationInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;

  const DurationInputField({
    Key? key,
    required this.controller,
    this.label = 'Duration (HH:MM:SS)',
    this.hintText = '__:__:__',
  }) : super(key: key);

  @override
  State<DurationInputField> createState() => _DurationInputFieldState();
}

class _DurationInputFieldState extends State<DurationInputField> {
  final String _mask = '##:##:##';
  final String _placeholder = '__:__:__';
  late final MaskTextInputFormatter _maskFormatter;

@override
void initState() {
  super.initState();

  _maskFormatter = MaskTextInputFormatter(
    mask: _mask,
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  // Bersihkan input awal dari karakter non-digit
  final initialDigits = widget.controller.text.replaceAll(RegExp(r'\D'), '');

  if (initialDigits.isNotEmpty) {
    final masked = _maskFormatter.maskText(initialDigits);
    final withPlaceholder = masked + _placeholder.substring(masked.length);

    final initialValue = TextEditingValue(
      text: withPlaceholder,
      selection: TextSelection.collapsed(offset: masked.length),
    );

    widget.controller.value = initialValue;

    // ✅ Sinkronisasi internal state masker
    _maskFormatter.formatEditUpdate(
      const TextEditingValue(),
      initialValue,
    );
  } else {
    widget.controller.text = _placeholder;
  }
}



  void _onChanged(String _) {
    final raw = _maskFormatter.getUnmaskedText();
    final masked = _maskFormatter.maskText(raw);
    final withPlaceholder = masked + _placeholder.substring(masked.length);

    if (widget.controller.text != withPlaceholder) {
      widget.controller.value = TextEditingValue(
        text: withPlaceholder,
        selection: TextSelection.collapsed(offset: masked.length),
      );
    }
  }

  bool _isValidTime(String input) {
    final parts = input.split(':');
    if (parts.length != 3) return false;

    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final s = int.tryParse(parts[2]);

    if (h == null || m == null || s == null) return false;
    if (h > 99 || m > 59 || s > 59) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [_maskFormatter],
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
      ),
      onChanged: _onChanged,
      validator: (value) {
        if (value == null || value.isEmpty || !_isValidTime(value)) {
          return 'Invalid time format. Use HH:MM:SS.';
        }
        return null;
      },
    );
  }
}
