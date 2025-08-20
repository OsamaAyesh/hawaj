import 'package:app_mobile/features/common/auth/presentation/pages/login_screen.dart';
import 'package:app_mobile/features/common/auth/presentation/pages/otp_login_screen.dart';
import 'package:app_mobile/features/common/auth/presentation/pages/success_login_screen.dart';
import 'package:app_mobile/features/common/choose_language/presentation/pages/choose_language_screen.dart';
import 'package:app_mobile/features/splash_and_boarding/presentation/pages/on_boarding_screen.dart';
import 'package:app_mobile/features/splash_and_boarding/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import '../../features/common/auth/presentation/pages/complete_information_screen.dart';
import '../../features/common/test/test_hawaj_screen.dart';
import '../resources/manager_strings.dart';

/// A class defined for all routes constants
class Routes {
  static const String splash = '/splash';
  static const String chooseLanguageScreen = '/change_language_screen';
  static const String onBoardingScreen = '/on_boarding_screen';

  ///Auth Screens
  static const String loginScreen = '/login_screen';
  static const String otpLoginScreen = '/otp_login_screen';
  static const String successLoginScreen = '/success_login_screen';
  static const String completeInformationScreen = '/complete_information_screen';


  ///Test Hawaj Screen
  static const String testHawajScreen = '/test_hawaj_screen';


}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.chooseLanguageScreen:
        return MaterialPageRoute(builder: (_) => const ChooseLanguageScreen());
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.otpLoginScreen:
        return MaterialPageRoute(builder: (_) => const OtpLoginScreen());
      case Routes.successLoginScreen:
        return MaterialPageRoute(builder: (_) => const SuccessLoginScreen());
      case Routes.completeInformationScreen:
        return MaterialPageRoute(builder: (_) => const CompleteInformationScreen());
      // case Routes.testHawajScreen:
      //   return MaterialPageRoute(builder: (_) => const SpeechScreen());

      default:
        return unDefinedRoute();
    }
  }

  /// If PushNamed Failed Return This Page With No Actions
  /// This Screen Will Tell The User This Page Is Not Exist
  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(
            ManagerStrings.noRouteFound,
          ),
        ),
        body: Center(
          child: Text(
            ManagerStrings.noRouteFound,
          ),
        ),
      ),
    );
  }
}
