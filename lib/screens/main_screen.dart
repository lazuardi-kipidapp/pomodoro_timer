import 'package:flutter/material.dart';
import 'package:pomodoro_timer/screens/timer_screen.dart';
import 'package:pomodoro_timer/screens/summary_screen.dart';
import 'package:pomodoro_timer/utils/custom_colors.dart';

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
  return Material(
    color: Colors.transparent, // Biar warna navbar tetap sesuai
    child: Ink(
      color: _selectedIndex == index 
          ? CustomColors.navbarSelectedBG 
          : CustomColors.navbarUnselectedBG, // Pastikan warna ada
      child: InkWell(
        onTap: () => _onItemTapped(index),
        splashColor: Colors.white10, // Efek ripple
        highlightColor: Colors.transparent, // Efek highlight
        splashFactory: InkRipple.splashFactory, // Efek lebih smooth
        child: Container(
          height: 64,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Highlight di atas tombol
              Container(
                height: 5,
                width: double.infinity,
                color: _selectedIndex == index 
                    ? CustomColors.navbarSelectedHighlight 
                    : CustomColors.navbarUnselectedHighlight,
              ),
              // Ikon dengan padding
              Padding(
                padding: EdgeInsets.all(4),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Icon(
                    icon,
                    size: 24,
                    color: _selectedIndex == index 
                        ? CustomColors.navbarSelectedLabel 
                        : CustomColors.navbarUnselectedLabel,
                  ),
                ),
              ),
              // Label teks
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: _selectedIndex == index 
                      ? CustomColors.navbarSelectedLabel 
                      : CustomColors.navbarUnselectedLabel,
                ),
              ),
              // Spacer agar ada padding bawah
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
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _buildNavItem(
                icon: Icons.timer,
                index: 0,
                label: 'Timer',
              ),
            ),
            Expanded(
              child: _buildNavItem(
                icon: Icons.history,
                index: 1,
                label: 'Summary',
              ),
            ),
          ],
        ),
      ),
    );
  }
}