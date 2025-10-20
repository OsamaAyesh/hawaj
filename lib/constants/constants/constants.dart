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

  ///Base Url Attachments.
  static const String baseUrlAttachments = 'https://hawaj.lezaz.org/storage';

  ///===== provider Offer Manager Widget =====
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

  ///======= Manager Contracts User Widget =======
  static List<Map<String, String>> itemsManagerContracts = [
    {
      'icon': ManagerIcons.addRequestContractIcon,
      'title': ManagerStrings.addRequestTitle,
      'subtitle': ManagerStrings.addRequestSubtitle,
    },
    {
      'icon': ManagerIcons.myRequestsIcon,
      'title': ManagerStrings.myRequestsTitle,
      'subtitle': ManagerStrings.myRequestsSubtitle,
    },
  ];

  ///===== Manger Contract Provider Widget. =======
  static List<Map<String, String>> itemsManagerProviderContracts = [
    {
      'icon': ManagerIcons.addServiceIcon,
      'title': ManagerStrings.contractsAddServiceTitle,
      'subtitle': ManagerStrings.contractsAddServiceSubTitle,
    },
    {
      'icon': ManagerIcons.managerDataProviderIcon,
      'title': ManagerStrings.contractsDataManagementTitle,
      'subtitle': ManagerStrings.contractsDataManagementSubTitle,
    },
    {
      'icon': ManagerIcons.managerMyServicesProviderIcon,
      'title': ManagerStrings.contractsMyServicesTitle,
      'subtitle': ManagerStrings.contractsMyServicesSubTitle,
    },
    {
      'icon': ManagerIcons.myProposalRequested,
      'title': ManagerStrings.contractsSubmittedOffersTitle,
      'subtitle': ManagerStrings.contractsSubmittedOffersSubTitle,
    },
    {
      'icon': ManagerIcons.needsMapIcon,
      'title': ManagerStrings.contractsNeedsMapTitle,
      'subtitle': ManagerStrings.contractsNeedsMapSubTitle,
    },
  ];

  ///====== Manager Real Estate Provider Widget. ======
  static List<Map<String, String>> itemsManagerProviderRealEstate = [
    {
      'icon': ManagerIcons.providerRealStateManager1,
      'title': ManagerStrings.myPropertiesTitle,
      'subtitle': ManagerStrings.myPropertiesSubtitle,
    },
    {
      'icon': ManagerIcons.providerRealStateManager2,
      'title': ManagerStrings.addPropertyTitle,
      'subtitle': ManagerStrings.addPropertySubtitle,
    },
    {
      'icon': ManagerIcons.providerRealStateManager3,
      'title': ManagerStrings.editMyDataTitle,
      'subtitle': ManagerStrings.editMyDataSubtitle,
    },
  ];

  ///===== Manager Provider Jobs App Features.
  static List<Map<String, String>> itemsManagerProviderJobs = [
    {
      'icon': ManagerIcons.providerJobsManager1,
      'title': "إضافة وظيفة",
      'subtitle': "أدخل تفاصيل الوظيفة لتظهر للباحثين وتستقبل الطلبات بسهولة.",
    },
    {
      'icon': ManagerIcons.providerJobsManager2,
      'title': "إدارة الوظائف",
      'subtitle':
          "راجع الوظائف التي نشرتها سابقًا، وقم بتعديل التفاصيل أو إيقاف النشر حسب الحاجة",
    },
    {
      'icon': ManagerIcons.providerJobsManager3,
      'title': "إدارة بيانات الشركة",
      'subtitle': "حدث بيانات شركتك لتحافظ على ظهورك بشكل احترافي.",
    },
  ];
}
