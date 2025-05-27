import 'package:flutter/material.dart';
import 'package:pomodoro_timer/theme/app_colors.dart';

class AppButtonStyles {
  static final regular = ElevatedButton.styleFrom(
    backgroundColor: AppColors.buttonPurpleBG,
    foregroundColor: AppColors.buttonPurpleLabel,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  );
  static final secondary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.buttonGrayBG,
    foregroundColor: AppColors.buttonGrayLabel,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  );
}