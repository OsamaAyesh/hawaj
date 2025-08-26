import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_height.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/storage/local/app_settings_prefs.dart';
import '../../domain/use_case/on_boarding_use_case.dart';
import '../controller/get_on_boarding_controller.dart';
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

    _initAnimations();
    _startSplashLogic();
  }

  /// تهيئة الأنيميشن
  void _initAnimations() {
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    _slideController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  ///===== Run Splash Logic (Load + Move)
  Future<void> _startSplashLogic() async {
    try {
      /// ======== 1. Preload OnBoarding Data + Images (with timeout)
      final preloadController = Get.put(
        OnBoardingPreloadController(instance<OnBoardingUseCase>()),
      );

      await preloadController
          .preloadOnBoarding()
          .timeout(const Duration(seconds: 5), onTimeout: () {
        // ⚠️ If API or cache loading takes more than 5s, continue anyway
        print("⚠️ Preload onboarding timed out, continue...");
      });

      /// ====== 2. Wait for splash animation period
      await Future.delayed(const Duration(seconds: 2));

      ///=== 3. Navigate by user status
      final prefs = instance<AppSettingsPrefs>();
      final hasChosenLang = prefs.getViewedChooseLanguage();
      final hasSeenOnboarding = prefs.getOutBoardingScreenViewed();
      final isLoggedIn = prefs.getUserLoggedIn();

      if (!hasChosenLang) {
        Get.offAllNamed(Routes.chooseLanguageScreen);
      } else if (!hasSeenOnboarding) {
        Get.offAllNamed(Routes.onBoardingScreen);
      } else if (isLoggedIn) {
        print("Success");
        // Get.offAllNamed(Routes.homeScreen); // ✅ لازم يكون في Navigation هنا
      } else {
        Get.offAllNamed(Routes.loginScreen);
      }
    } catch (e) {
      print("❌ Error in splash logic: $e");
      // Fallback to login screen in case of any error
      Get.offAllNamed(Routes.loginScreen);
    }
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
          /// Logo + Animations
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: const LogoInSplashWidget(),
            ),
          ),

          /// Loader
          Positioned(
            bottom: ManagerHeight.h90,
            child: const CircularProgressIndicator(
              color: ManagerColors.secondColor,
            ),
          ),

          /// Version Text
          Positioned(
            bottom: ManagerHeight.h20,
            child: Text(
              "v${AppConfig.version}",
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
