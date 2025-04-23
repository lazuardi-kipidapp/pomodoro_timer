import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InputUtils {
  static final hhmmss = MaskTextInputFormatter(
    mask: '##:##:##',
    filter: {"#": RegExp(r'^\d{2}:[0-5]\d:[0-5]\d$')},
    type: MaskAutoCompletionType.lazy,
  );

  static final phone = MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  static bool isValidHHMMSS(String input) {
    final parts = input.trim().split(':');
    if (parts.length != 3) return false;

    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);
    final seconds = int.tryParse(parts[2]);

    if (hours == null || minutes == null || seconds == null) return false;
    if (hours < 0 || hours > 23) return false;
    if (minutes < 0 || minutes > 59) return false;
    if (seconds < 0 || seconds > 59) return false;

    return true;
  }
}
