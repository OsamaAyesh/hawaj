import 'package:app_mobile/core/resources/manager_icons.dart';

import '../../core/resources/manager_strings.dart';

class Constants {
  static const String message = "message";
  static const String error = "error";
  static const String errors = "errors";

  /// Testing device sizes
  static const double deviceWidth = 375;
  static const double deviceHeight = 812;

  /// Api Config
  static const int outBoardingDurationTime = 1;
  static const int sessionFinishedDuration = 2;
  static const int sendTimeOutDuration = 120;
  static const int receiveTimeOutDuration = 60;
  static const String bearer = 'Bearer';
  static const String authorization = 'authorization';
  static const String acceptLanguage = 'Accept-Language';
  static const String accept = 'Accept';
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';

  /// Theme consts
  static const String dark = "dark";
  static const String light = "light";

  /// Locales
  static const String arabicName = 'العربية';
  static const String englishName = 'English';
  static const String english = 'en';
  static const String arabic = 'ar';

  static List<Map<String, String>> itemsOfferManagerProvider = [
    {
      'icon': ManagerIcons.offerManagerIcons1,
      'title': ManagerStrings.addProduct,
      'subtitle': ManagerStrings.addProductDesc,
    },
    {
      'icon': ManagerIcons.offerManagerIcons2,
      'title': ManagerStrings.manageProducts,
      'subtitle': ManagerStrings.manageProductsDesc,
    },
    {
      'icon': ManagerIcons.offerManagerIcons3,
      'title': ManagerStrings.businessDetails,
      'subtitle': ManagerStrings.businessDetailsDesc,
    },
  ];

}
