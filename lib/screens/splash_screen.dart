import 'package:flutter/material.dart';
import 'package:pomodoro_timer/screens/main_screen.dart';
import 'package:pomodoro_timer/theme/app_colors.dart';
import 'package:rive/rive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = SimpleAnimation(
      'All', // Ganti dengan nama animasi kamu
      autoplay: true,
    );

    Future.delayed(const Duration(seconds: 4), () {
      // Navigasi ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      body: Center(
        child: RiveAnimation.asset(
          'assets/animations/splash_screen.riv',
          controllers: [_controller],
          onInit: (Artboard artboard) {
            print("Artboard name: ${artboard.name}");
            print("Animations count: ${artboard.animations.length}");
          },
        ),

      ),
    );
  }
}

