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
import 'package:app_mobile/features/users/commercial_contract_user/request_new_service_contract_user/presentation/pages/request_new_service_contract_user_screen.dart';
import 'package:flutter/material.dart';

import '../../features/common/auth/presentation/pages/complete_information_screen.dart';
import '../../features/common/test/test_hawaj_screen.dart';
import '../../features/providers/commercial_contracts/add_new_service_commercial_contracts/presentation/pages/add_new_service_commercial_contracts_screen.dart';
import '../../features/providers/commercial_contracts/follow_up_order_in_commercial_contracts/presentation/pages/follow_up_order_in_commercial_contracts_screen.dart';
import '../../features/providers/commercial_contracts/manager_commercial_contracts_services_provider/presentation/pages/manager_commercial_contracts_services_provider_screen.dart';
import '../../features/providers/commercial_contracts/manager_my_services_commercial_contracts/presentation/pages/manager_my_services_commercial_contracts_screen.dart';
import '../../features/providers/commercial_contracts/register_service_provider_contract/pages/register_service_provider_contract_screen.dart';
import '../../features/providers/commercial_contracts/request_for_a_new_service_commercial_contracts/presentation/pages/request_for_a_new_service_commercial_contracts_screen.dart';
import '../../features/providers/commercial_contracts/subscription_commercial_contracts_provider/presentation/pages/subscription_commercial_contracts_provider_screen.dart';
import '../../features/providers/commercial_contracts/subscription_information/presentation/pages/subscription_information_screen.dart';
import '../../features/providers/job_provider_app/add_company_jobs_provider/presentation/pages/add_company_jobs_provider_screen.dart';
import '../../features/providers/job_provider_app/add_job_provider/presentation/pages/add_jobs_provider_screen.dart';
import '../../features/providers/job_provider_app/manage_company_jobs_provider/presentation/pages/manage_company_jobs_provider_screen.dart';
import '../../features/providers/job_provider_app/manager_jobs_provider/presentation/presentation/pages/manager_jobs_provider_screen.dart';
import '../../features/providers/offers_provider/manage_list_offer/presentation/pages/manage_list_offer_provider_screen.dart';
import '../../features/providers/offers_provider/manager_products_offer_provider/presentation/pages/manager_products_offer_provider_screen.dart';
import '../../features/providers/offers_provider/register_company_offer_provider/presentation/pages/success_register_company_offer_provider_screen.dart';
import '../../features/providers/offers_provider/subscription_offer_provider/presentation/pages/subscription_offer_provider_screen.dart';
import '../../features/providers/real_estate_provider/add_real_estate/presentation/pages/add_real_estate_screen.dart';
import '../../features/providers/real_estate_provider/dashboard_real_estate_manager/presentation/pages/dashboard_real_estate_manager_screen.dart';
import '../../features/providers/real_estate_provider/manager_my_real_estate_provider/presentation/pages/manager_my_real_estate_provider_screen.dart';
import '../../features/providers/real_estate_provider/register_to_real_estate_provider_service/presentation/pages/register_to_real_estate_provider_service_screen.dart';
import '../../features/users/commercial_contract_user/manage_contracrs_user/presentation/pages/manage_contract_user_screen.dart';
import '../../features/users/commercial_contract_user/manager_my_requests_contract_user/presentation/pages/manager_my_requests_contract_user_screen.dart';
import '../../features/users/commercial_contract_user/show_details_contract_provider/presentation/pages/show_details_contract_provider_screen.dart';
import '../../features/users/jobs_user_app/add_cv_user/presentation/add_cv_user_screen.dart';
import '../../features/users/offer_user/company_with_offer/presentation/pages/company_with_offer_screen.dart';
import '../../features/users/real_estate_user/show_real_state_details_user/presentation/pages/show_real_state_details_user_screen.dart';
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
  static const String completeInformationScreen =
      '/complete_information_screen';

  ///Test Hawaj Screen
  static const String testHawajScreen = '/test_hawaj_screen';

  ///Offer Provider
  static const String managerProductsOfferProviderScreen =
      '/manager_products_offer_provider_screen';
  static const String subscriptionOfferProviderScreen =
      '/subscription_offer_provider_screen';
  static const String successSubSubscriptionOfferProviderScreen =
      '/success_subscription_offer_provider_screen';
  static const String registerCompanyOfferProviderScreen =
      '/register_company_offer_provider_screen';
  static const String successRegisterCompanyOfferProviderScreen =
      '/success_register_company_offer_provider_screen';
  static const String addOfferProviderScreen = '/add_offer_provider_screen';
  static const String manageListOfferProviderScreen =
      '/manage_list_offer_provider_screen';

  ///Offer Daily User Screens
  static const String companyWithOfferScreen = '/company_with_offer_screen';

  ///Commercial Contract Provider Screen
  static const String registerServiceProviderContractScreen =
      '/register_service_provider_contract_screen';
  static const String subscriptionCommercialContractsProviderScreen =
      '/subscriptionCommercialContractsProviderScreen';
  static const String managerCommercialContractsServicesProviderScreen =
      '/managerCommercialContractsServicesProviderScreen';
  static const String requestForANewServiceCommercialContractsScreen =
      '/requestForANewServiceCommercialContractsScreen';
  static const String addNewServiceCommercialContractsScreen =
      '/addNewServiceCommercialContractsScreen';
  static const String managerMyServicesCommercialContractsScreen =
      '/managerMyServicesCommercialContractsScreen';
  static const String subscriptionInformationScreen =
      '/subscriptionInformationScreen';

  ///Commercial Contract User Screens
  static const String showDetailsContractProviderScreen =
      "show_details_contract_provider_screen";
  static const String requestNewServiceContractUserScreen =
      "request_new_service_contract_user_screen";
  static const String manageContractUserScreen = "manageContractUserScreen";
  static const String managerMyRequestsContractUserScreen =
      "managerMyRequestsContractUserScreen";
  static const String followUpOrderInCommercialContractsScreen =
      "followUpOrderInCommercialContractsScreen";

  /// Real State User
  static const String showRealStateDetailsUserScreen =
      "showRealStateDetailsUserScreen";

  ///====>Real Estate Provider Screens.
  static const String registerToRealEstateProviderServiceScreen =
      "registerToRealEstateProviderServiceScreen";
  static const String dashboardRealEstateManagerScreen =
      "dashboardRealEstateManagerScreen";
  static const String addRealEstateScreen = "addRealEstateScreen";
  static const String managerMyRealEstateProviderScreen =
      "managerMyRealEstateProviderScreen";

  //Jobs User Screen

  static const String addCvUserScreen = "addCvUserScreen";

  /// Jobs Provider
  static const String addCompanyJobsProviderScreen =
      "addCompanyJobsProviderScreen";
  static const String manageCompanyJobsProviderScreen =
      "manageCompanyJobsProviderScreen";
  static const String addJobsProviderScreen = "addJobsProviderScreen";
  static const String managerJobsScreen = "managerJobsScreen";

  ///Common Screens
  static const String profileScreen = '/profile_screen';
  static const String mapScreen = '/map_screen';
  static const String editProfileScreen = '/edit_profile_screen';
  static const String contactUsScreen = '/contact_us_screen';
  static const String hawajWelcomeStartScreen = '/hawaj_welcome_start_screen';
  static const String testScreen = '/test_screen';
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
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.otpLoginScreen:
        return MaterialPageRoute(
            builder: (_) => const OtpLoginScreen(
                  phoneNumber: '',
                ));
      case Routes.successLoginScreen:
        return MaterialPageRoute(builder: (_) => const SuccessLoginScreen());
      case Routes.completeInformationScreen:
        return MaterialPageRoute(
            builder: (_) => const CompleteInformationScreen());
      case Routes.managerProductsOfferProviderScreen:
        return MaterialPageRoute(
            builder: (_) => const ManagerProductsOfferProviderScreen());
      case Routes.subscriptionOfferProviderScreen:
        return MaterialPageRoute(
            builder: (_) => const SubscriptionOfferProviderScreen());
      case Routes.successSubSubscriptionOfferProviderScreen:
        return MaterialPageRoute(
            builder: (_) => const SuccessSubscriptionOfferProviderScreen());
      case Routes.registerCompanyOfferProviderScreen:
        return MaterialPageRoute(
            builder: (_) => const RegisterCompanyOfferProviderScreen());
      case Routes.successRegisterCompanyOfferProviderScreen:
        return MaterialPageRoute(
            builder: (_) => const SuccessRegisterCompanyOfferProviderScreen());
      case Routes.addOfferProviderScreen:
        return MaterialPageRoute(
            builder: (_) => const AddOfferProviderScreen());
      case Routes.manageListOfferProviderScreen:
        return MaterialPageRoute(
            builder: (_) => const ManageListOfferProviderScreen());
      case Routes.profileScreen:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.mapScreen:
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case Routes.editProfileScreen:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case Routes.contactUsScreen:
        return MaterialPageRoute(builder: (_) => const ContactUsScreen());
      case Routes.hawajWelcomeStartScreen:
        return MaterialPageRoute(
            builder: (_) => const HawajWelcomeStartScreen());
      case Routes.testScreen:
        return MaterialPageRoute(builder: (_) => TestScreen());
      case Routes.companyWithOfferScreen:
        return MaterialPageRoute(
            builder: (_) => const CompanyWithOfferScreen(
                  idOrganization: 1,
                ));
      case Routes.registerServiceProviderContractScreen:
        return MaterialPageRoute(
            builder: (_) => RegisterServiceProviderContractScreen());
      case Routes.showDetailsContractProviderScreen:
        return MaterialPageRoute(
            builder: (_) => ShowDetailsContractProviderScreen());
      case Routes.requestNewServiceContractUserScreen:
        return MaterialPageRoute(
            builder: (_) => RequestNewServiceContractUserScreen());
      case Routes.manageContractUserScreen:
        return MaterialPageRoute(builder: (_) => ManageContractUserScreen());
      case Routes.managerMyRequestsContractUserScreen:
        return MaterialPageRoute(
            builder: (_) => ManagerMyRequestsContractUserScreen());
      case Routes.subscriptionCommercialContractsProviderScreen:
        return MaterialPageRoute(
            builder: (_) => SubscriptionCommercialContractsProviderScreen());
      case Routes.managerCommercialContractsServicesProviderScreen:
        return MaterialPageRoute(
            builder: (_) => ManagerCommercialContractsServicesProviderScreen());
      case Routes.requestForANewServiceCommercialContractsScreen:
        return MaterialPageRoute(
            builder: (_) => RequestForANewServiceCommercialContractsScreen());
      case Routes.addNewServiceCommercialContractsScreen:
        return MaterialPageRoute(
            builder: (_) => AddNewServiceCommercialContractsScreen());
      case Routes.managerMyServicesCommercialContractsScreen:
        return MaterialPageRoute(
            builder: (_) => ManagerMyServicesCommercialContractsScreen());
      case Routes.subscriptionInformationScreen:
        return MaterialPageRoute(
          builder: (_) => SubscriptionInformationScreen(),
        );
      case Routes.followUpOrderInCommercialContractsScreen:
        return MaterialPageRoute(
          builder: (_) => FollowUpOrderInCommercialContractsScreen(),
        );
      case Routes.showRealStateDetailsUserScreen:
        return MaterialPageRoute(
          builder: (_) => ShowRealStateDetailsUserScreen(),
        );
      case Routes.registerToRealEstateProviderServiceScreen:
        return MaterialPageRoute(
          builder: (_) => RegisterToRealEstateProviderServiceScreen(),
        );
      case Routes.dashboardRealEstateManagerScreen:
        return MaterialPageRoute(
          builder: (_) => DashboardRealEstateManagerScreen(),
        );
      case Routes.addRealEstateScreen:
        return MaterialPageRoute(
          builder: (_) => AddRealEstateScreen(),
        );
      case Routes.managerMyRealEstateProviderScreen:
        return MaterialPageRoute(
          builder: (_) => ManagerMyRealEstateProviderScreen(),
        );
      case Routes.addCvUserScreen:
        return MaterialPageRoute(
          builder: (_) => AddCvUserScreen(),
        );
      case Routes.addCompanyJobsProviderScreen:
        return MaterialPageRoute(
          builder: (_) => AddCompanyJobsProviderScreen(),
        );
      case Routes.manageCompanyJobsProviderScreen:
        return MaterialPageRoute(
          builder: (_) => ManageCompanyJobsProviderScreen(),
        );
      case Routes.addJobsProviderScreen:
        return MaterialPageRoute(
          builder: (_) => AddJobsProviderScreen(),
        );
      case Routes.managerJobsScreen:
        return MaterialPageRoute(
          builder: (_) => ManagerJobsScreen(),
        );
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
