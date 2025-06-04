import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app/pages/splash/onboarding_page.dart';
import 'package:mobile_app/shared/theme/app_color.dart';
import 'package:mobile_app/shared/utils/constants/asset_paths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    debugPrint('SplashScreen initState called');

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
        debugPrint('SplashScreen visibility set to true');
      }
    });

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        debugPrint('Navigating to OnboardingScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building SplashScreen');
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with opacity
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              background2,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Error loading background image: $error');
                return Container(color: AppColors.primary);
              },
            ),
          ),

          // Centered logo and app name
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: _visible ? 1.0 : 0.0,
              child: AnimatedScale(
                scale: _visible ? 1.0 : 0.6,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "InShorts",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
