// main_screen.dart - Updated version
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_timer/providers/timer_provider.dart';
import 'package:pomodoro_timer/screens/timer_screen.dart';
import 'package:pomodoro_timer/screens/summary_screen.dart';
import 'package:pomodoro_timer/theme/app_colors.dart';
import 'package:pomodoro_timer/theme/app_text_styles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TimerScreen(),
    SummaryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required String label,
  }) {
    return Expanded(
      child: Material(
        color: _selectedIndex == index
           ? AppColors.navbarSelectedBG
           : AppColors.navbarUnselectedBG,
        child: InkWell(
          onTap: () => _onItemTapped(index),
          splashColor: Colors.white10,
          highlightColor: Colors.transparent,
          splashFactory: InkRipple.splashFactory,
          child: Container(
            height: 64,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: Icon(
                          icon,
                          size: 24,
                          color: _selectedIndex == index
                              ? AppColors.navbarSelectedLabel
                              : AppColors.navbarUnselectedLabel,
                        ),
                      ),
                      // Timer indicator - hanya tampil di tab Timer
                      if (index == 0)
                        Consumer<TimerProvider>(
                          builder: (context, timerProvider, child) {
                            if (timerProvider.isRunning) {
                              return Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            }
                            return SizedBox();
                          },
                        ),
                    ],
                  ),
                ),
                Text(
                  label,
                  style: AppTextStyles.navItem.copyWith(
                    color: _selectedIndex == index
                        ? AppColors.navbarSelectedLabel
                        : AppColors.navbarUnselectedLabel,
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Stack(
        children: [
          // Navbar utama
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.timer,
                  index: 0,
                  label: 'Timer',
                ),
                _buildNavItem(
                  icon: Icons.show_chart,
                  index: 1,
                  label: 'Summary',
                ),
              ],
            ),
          ),
          
          // Animasi highlight
          Positioned(
            top: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 5,
              width: MediaQuery.of(context).size.width / 2,
              margin: EdgeInsets.only(
                left: (MediaQuery.of(context).size.width / 2) * _selectedIndex,
              ),
              decoration: BoxDecoration(
                color: AppColors.navbarSelectedHighlight
              ),
            ),
          ),
        ],
      ),
    );
  }
}