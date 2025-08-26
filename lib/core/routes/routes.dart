import 'package:app_mobile/features/common/auth/presentation/pages/login_screen.dart';
import 'package:app_mobile/features/common/auth/presentation/pages/otp_login_screen.dart';
import 'package:app_mobile/features/common/auth/presentation/pages/success_login_screen.dart';
import 'package:app_mobile/features/common/choose_language/presentation/pages/choose_language_screen.dart';
import 'package:app_mobile/features/common/hawaj_welcome_start/presentation/pages/hawaj_welcome_start_screen.dart';
import 'package:app_mobile/features/common/map/presenation/pages/map_screen.dart';
import 'package:app_mobile/features/common/profile/presentation/pages/contact_us_screen.dart';
import 'package:app_mobile/features/common/profile/presentation/pages/edit_profile_screen.dart';
import 'package:app_mobile/features/common/profile/presentation/pages/profile_screen.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/presentation/pages/add_offer_provider_screen.dart';
import 'package:app_mobile/features/providers/offers_provider/register_company_offer_provider/presentation/pages/register_company_offer_provider_screen.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/presentation/pages/success_subscription_offer_provider_screen.dart';
import 'package:app_mobile/features/splash_and_boarding/presentation/pages/on_boarding_screen.dart';
import 'package:app_mobile/features/splash_and_boarding/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import '../../features/common/auth/presentation/pages/complete_information_screen.dart';
import '../../features/common/test/test_hawaj_screen.dart';
import '../../features/providers/offers_provider/manage_list_offer/presentation/pages/manage_list_offer_provider_screen.dart';
import '../../features/providers/offers_provider/manager_products_offer_provider/pages/manager_products_offer_provider_screen.dart';
import '../../features/providers/offers_provider/register_company_offer_provider/presentation/pages/success_register_company_offer_provider_screen.dart';
import '../../features/providers/offers_provider/subscription_offer_provider/presentation/pages/subscription_offer_provider_screen.dart';
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


  ///Offer Provider
  static const String managerProductsOfferProviderScreen = '/manager_products_offer_provider_screen';
  static const String subscriptionOfferProviderScreen = '/subscription_offer_provider_screen';
  static const String successSubSubscriptionOfferProviderScreen = '/success_subscription_offer_provider_screen';
  static const String registerCompanyOfferProviderScreen = '/register_company_offer_provider_screen';
  static const String successRegisterCompanyOfferProviderScreen = '/success_register_company_offer_provider_screen';
  static const String addOfferProviderScreen = '/add_offer_provider_screen';
  static const String manageListOfferProviderScreen = '/manage_list_offer_provider_screen';



  ///Common Screens
  static const String profileScreen = '/profile_screen';
  static const String mapScreen = '/map_screen';
  static const String editProfileScreen = '/edit_profile_screen';
  static const String contactUsScreen = '/contact_us_screen';
  static const String hawajWelcomeStartScreen = '/hawaj_welcome_start_screen';




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
        return MaterialPageRoute(builder: (_) =>  LoginScreen());
      case Routes.otpLoginScreen:
        return MaterialPageRoute(builder: (_) => const OtpLoginScreen(phoneNumber: '',));
      case Routes.successLoginScreen:
        return MaterialPageRoute(builder: (_) => const SuccessLoginScreen());
      case Routes.completeInformationScreen:
        return MaterialPageRoute(builder: (_) => const CompleteInformationScreen());
      case Routes.managerProductsOfferProviderScreen:
        return MaterialPageRoute(builder: (_) => const ManagerProductsOfferProviderScreen());
      case Routes.subscriptionOfferProviderScreen:
        return MaterialPageRoute(builder: (_) => const SubscriptionOfferProviderScreen());
      case Routes.successSubSubscriptionOfferProviderScreen:
        return MaterialPageRoute(builder: (_) => const SuccessSubscriptionOfferProviderScreen());
      case Routes.registerCompanyOfferProviderScreen:
        return MaterialPageRoute(builder: (_) => const RegisterCompanyOfferProviderScreen());
      case Routes.successRegisterCompanyOfferProviderScreen:
        return MaterialPageRoute(builder: (_) => const SuccessRegisterCompanyOfferProviderScreen());
      case Routes.addOfferProviderScreen:
        return MaterialPageRoute(builder: (_) => const AddOfferProviderScreen());
      case Routes.manageListOfferProviderScreen:
        return MaterialPageRoute(builder: (_) => const ManageListOfferProviderScreen());
      case Routes.profileScreen:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.mapScreen:
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case Routes.editProfileScreen:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case Routes.contactUsScreen:
        return MaterialPageRoute(builder: (_) => const ContactUsScreen());
      case Routes.hawajWelcomeStartScreen:
        return MaterialPageRoute(builder: (_) => const HawajWelcomeStartScreen());
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
