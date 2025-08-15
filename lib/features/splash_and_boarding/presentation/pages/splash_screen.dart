import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../../../../core/config/app_config.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_styles.dart';
import '../widgets/logo_in_splash_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    // Slide animation
    _slideController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // يبدأ تحت قليلاً
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // تشغيل الأنيميشن
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.primaryColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Logo with animation
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: const LogoInSplashWidget(),
            ),
          ),

          // Circle Progress Indicator
          Positioned(
            top: ManagerHeight.h710,
            child: const CircularProgressIndicator(
              color: ManagerColors.secondColor,
            ),
          ),

          // Version Application
          Positioned(
            bottom: ManagerHeight.h20,
            child: Text(
              AppConfig.version,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.secondColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
