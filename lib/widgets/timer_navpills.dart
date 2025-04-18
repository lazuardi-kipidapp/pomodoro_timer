import 'package:flutter/material.dart';
import 'package:pomodoro_timer/utils/custom_colors.dart';

class NavPills extends StatelessWidget {
  final bool isWorkMode;
  final Function(bool) onTap;

  const NavPills({
    super.key,
    required this.isWorkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: ['Work', 'Break'].asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final selected = (index == 0 && isWorkMode) || (index == 1 && !isWorkMode);

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index == 0), // true kalau Work, false kalau Break
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? CustomColors.navbarSelectedBG : CustomColors.navbarUnselectedBG,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(index == 0 ? 30 : 0),
                    right: Radius.circular(index == 1 ? 30 : 0),
                  ),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected ? CustomColors.navbarSelectedLabel : CustomColors.navbarUnselectedLabel,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
