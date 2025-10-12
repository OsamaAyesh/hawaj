import 'package:easy_localization/easy_localization.dart';

/// A class defined for strings the app
class ManagerStrings {
  ///Change Language Screen
  static String get chooseLanguageTitle => tr('choose_language_title');

  static String get chooseLanguageSubtitle => tr('choose_language_subtitle');

  static String get arabic => tr('arabic');

  static String get english => tr('english');

  static String get arabicEn => tr('arabic_en');

  static String get englishAr => tr('english_ar');

  ///On Boarding Screen
  // General Actions
  static String get skip => tr('skip');

  static String get next => tr('next');

  static String get login => tr('login');

  // First Page
  static String get page1Title => tr('page1_title');

  static String get page1Text => tr('page1_text');

  // Second Page
  static String get page2Title => tr('page2_title');

  static String get page2Text => tr('page2_text');

  // Third Page
  static String get page3Title => tr('page3_title');

  static String get page3Text => tr('page3_text');

  ///Login Screen
  static String get welcomeTitle => tr('welcome_title');

  static String get welcomeSubtitle => tr('welcome_subtitle');

  static String get phoneLabel => tr('phone_label');

  static String get phoneHint => tr('phone_hint');

  static String get loginButton => tr('login_button');

  ///Otp Login Screen
  static String get otpTitle => tr('otp_title');

  static String get otpSubtitle => tr('otp_subtitle');

  static String get otpDidNotReceive => tr('otp_did_not_receive');

  static String get otpResend => tr('otp_resend');

  static String get otpVerifyButton => tr('otp_verify_button');

  ///Success Login Screen
  static String get verificationSuccessTitle =>
      tr('verification_success_title');

  static String get verificationSuccessSubtitle =>
      tr('verification_success_subtitle');

  static String get completeProfileButton => tr('complete_profile_button');

  static String get viewPoliciesText => tr('view_policies_text');

  ///Complete Information Screen Strings
  static String get profileSetupTitle => tr('profile_setup_title');

  static String get profileSetupSubtitle => tr('profile_setup_subtitle');

  static String get fullNameLabel => tr('full_name_label');

  static String get fullNameHint => tr('full_name_hint');

  static String get emailLabel => tr('email_label');

  static String get emailHint => tr('email_hint');

  static String get locationLabel => tr('location_label');

  static String get locationHint => tr('location_hint');

  static String get locationButton => tr('location_button');

  static String get profileImageLabel => tr('profile_image_label');

  static String get profileImageHint => tr('profile_image_hint');

  static String get profileImageNote => tr('profile_image_note');

  static String get continueButton => tr('continue_button');

  /// Fields
  static String get firstName => tr('first_name');

  static String get lastName => tr('last_name');

  static String get gender => tr('gender');

  static String get dob => tr('dob');

  /// Gender options
  static String get genderMale => tr('gender_male');

  static String get genderFemale => tr('gender_female');

  ///Profile Screen Strings
  static String get profileTitle => tr('profile_title');

  static String get newUser => tr('new_user');

  static String get phoneNumber => tr('phone_number');

  static String get listSettings => tr('list_settings');

  static String get subscribedServices => tr('subscribed_services');

  static String get manageServices => tr('manage_services');

  static String get changePassword => tr('change_password');

  static String get editProfile => tr('edit_profile');

  static String get contactSupport => tr('contact_support');

  static String get termsConditions => tr('terms_conditions');

  static String get logout => tr('logout');

  ///Manager Products
  static String get productManagement => tr('product_management');

  static String get quickAccess => tr('quick_access');

  static String get addProduct => tr('add_product');

  static String get addProductDesc => tr('add_product_desc');

  static String get manageProducts => tr('manage_products');

  static String get manageProductsDesc => tr('manage_products_desc');

  static String get businessDetails => tr('business_details');

  static String get businessDetailsDesc => tr('business_details_desc');

  ///Subscription Offer Provider Strings
  static String get subscribeNow => tr('subscribe_now');

  static String get subscribeDescription => tr('subscribe_description');

  static String get subscribeDescription1 => tr('subscribe_description1');

  static String get popularPlan => tr('popular_plan');

  static String get planName => tr('plan_name');

  static String get planPrice => tr('plan_price');

  static String get institutionType => tr('institution_type');

  static String get subscriptionDuration => tr('subscription_duration');

  static String get includedFeatures => tr('included_features');

  static String get feature1 => tr('feature_1');

  static String get feature2 => tr('feature_2');

  static String get feature3 => tr('feature_3');

  static String get feature4 => tr('feature_4');

  static String get subscribeButton => tr('subscribe_button');

  static String get noteText => tr('note_text');

  ///Success Subscription Screen Strings.
  static String get subscriptionSuccessTitle =>
      tr('subscription_success_title');

  static String get subscriptionSuccessDesc => tr('subscription_success_desc');

  static String get subscriptionSuccessButton =>
      tr('subscription_success_button');

  /// Register Company Offer Provider Screen Strings.
  static String get registerCompany => tr('register_company');

  static String get registerCompanyTitle => tr('register_company_title');

  static String get registerCompanySubtitle => tr('register_company_subtitle');

  static String get companyName => tr('company_name');

  static String get companyNameHint => tr('company_name_hint');

  static String get companyServices => tr('company_services');

  static String get companyServicesHint => tr('company_services_hint');

  static String get setLocation => tr('set_location');

  static String get setLocationButton => tr('set_location_button');

  static String get detailedAddress => tr('detailed_address');

  static String get detailedAddressHint => tr('detailed_address_hint');

  static String get responsiblePerson => tr('responsible_person');

  static String get responsiblePersonHint => tr('responsible_person_hint');

  static String get phoneNumberHint => tr('phone_number_hint');

  static String get workingHours => tr('working_hours');

  static String get workingHoursHint => tr('working_hours_hint');

  static String get companyLogo => tr('company_logo');

  static String get companyLogoHint => tr('company_logo_hint');

  static String get companyLogoHint2 => tr('company_logo_hint2');

  static String get commercialNumber => tr('commercial_number');

  static String get commercialNumberHint => tr('commercial_number_hint');

  static String get commercialRecord => tr('commercial_record');

  static String get commercialRecordHint => tr('commercial_record_hint');

  static String get commercialRecordHint2 => tr('commercial_record_hint2');

  static String get submitButton => tr('submit_button');

  ///======> Confirm Dialog Strings Offer Provider
  static String get confirmAddOrgTitle => tr('confirm_add_org_title');

  static String get confirmAddOrgSubtitle => tr('confirm_add_org_subtitle');

  static String get confirmAddOrgConfirm => tr('confirm_add_org_confirm');

  static String get confirmAddOrgCancel => tr('confirm_add_org_cancel');

  static String get orgAddedMainTitle => tr('org_added_main_title');

  static String get orgAddedSubtitle => tr('org_added_subtitle');

  static String get orgAddedPrimaryBtn => tr('org_added_primary_btn');

  static String get orgAddedSecondaryBtn => tr('org_added_secondary_btn');

  ///===== Add Offer Provider Screen Strings
  static String get offerRegisterTitle => tr('offer_register_title');

  static String get offerAddNew => tr('offer_add_new');

  static String get offerSubtitle => tr('offer_subtitle');

  static String get offerProductName => tr('offer_product_name');

  static String get offerProductDesc1 => tr('offer_product_desc1');

  static String get offerProductDesc => tr('offer_product_desc');

  static String get offerProductDescHint => tr('offer_product_desc_hint');

  static String get offerProductImages => tr('offer_product_images');

  static String get offerProductImagesHint => tr('offer_product_images_hint');

  static String get offerProductImagesHint2 => tr('offer_product_images_hint2');

  static String get offerProductPrice => tr('offer_product_price');

  static String get offerProductPriceHint => tr('offer_product_price_hint');

  static String get offerProductType => tr('offer_product_type');

  static String get offerType => tr('offer_type');

  static String get offerTypeHint => tr('offer_type_hint');

  static String get offerPrice => tr('offer_price');

  static String get offerPriceHint => tr('offer_price_hint');

  static String get offerFromDate => tr('offer_from_date');

  static String get offerFromDateHint => tr('offer_from_date_hint');

  static String get offerToDate => tr('offer_to_date');

  static String get offerTDateHint => tr('offer_to_date_hint');

  static String get offerDesc => tr('offer_desc');

  static String get offerDescHint => tr('offer_desc_hint');

  static String get offerSubmit => tr('offer_submit');

  static String get offerTypeDiscount => tr('offer_type_discount');

  static String get offerTypeNormal => tr('offer_type_normal');

  static String get confirmAddProductTitle => tr('confirm_add_product_title');

  static String get confirmAddProductSubtitle =>
      tr('confirm_add_product_subtitle');

  static String get confirmAddProductConfirm =>
      tr('confirm_add_product_confirm');

  static String get confirmAddProductCancel => tr('confirm_add_product_cancel');

  static String get productList => tr('product_list');

  ///Logout Dialog Confirm
  static String get titleConfirmation => tr('title_confirmation');

  static String get messageSignout => tr('message_signout');

  static String get buttonContinue => tr('button_continue');

  static String get buttonCancel => tr('button_cancel');

  /// Edit Profile Screen Strings.
  static String get personalAccountInfo => tr('personal_account_info');

  static String get fullName => tr('full_name');

  static String get edit => tr('edit');

  ///Contact Us Screen
  static String get contactUsTitle => tr('contact_us_title');

  static String get contactUsHeader => tr('contact_us_header');

  static String get contactUsSubtitle => tr('contact_us_subtitle');

  static String get contactUsFieldLabel => tr('contact_us_field_label');

  static String get contactUsFieldHint => tr('contact_us_field_hint');

  static String get sendMessageButton => tr('send_message_button');

  ///Drawer Strings.
  // User
  static String get userProfile => tr('user_profile');

  static String get userDailyOffers => tr('user_daily_offers');

  static String get userContracts => tr('user_contracts');

  static String get userRealEstate => tr('user_real_estate');

  static String get userDelivery => tr('user_delivery');

  static String get userJobs => tr('user_jobs');

  // Provider
  static String get providerManageOffers => tr('provider_manage_offers');

  static String get providerManageContracts => tr('provider_manage_contracts');

  static String get providerRealEstateManage =>
      tr('provider_real_estate_manage');

  static String get providerDeliveryDashboard =>
      tr('provider_delivery_dashboard');

  static String get providerManageJobs => tr('provider_manage_jobs');

  static String get publishOffersTitle => tr('publish_offers_title');

  static String get publishOffersSubTitle => tr('publish_offers_subtitle');

  static String get myOrganization => tr('my_organization');

  static String get selectedPlan => tr('selected_plan');

  static String get chooseSubscriptionDuration =>
      tr('choose_subscription_duration');

  static String get subscribeThisPlan => tr('subscribe_this_plan');

  static String get changePlanNote => tr('change_plan_note');

  static String get noData => tr('no_data');

  ///  Validation Completed Screen Strings.
  static String get firstNameRequired => tr('first_name_required');

  static String get lastNameRequired => tr('last_name_required');

  static String get genderRequired => tr('gender_required');

  static String get dobRequired => tr('dob_required');

  ///Register Company Service Provider Contract Commercial
  static String get serviceProviderSubscription =>
      tr('service_provider_subscription');

  static String get serviceProviderDescription =>
      tr('service_provider_description');

  static String get businessName => tr('business_name');

  static String get activityType => tr('activity_type');

  static String get commercialLicenseNumber => tr('commercial_license_number');

  static String get aboutProvider => tr('about_provider');

  static String get establishmentDate => tr('establishment_date');

  static String get mobileNumber => tr('mobile_number');

  static String get officeLicense => tr('office_license');

  static String get officeLogo => tr('office_logo');

  static String get continueBtn => tr('continue');

  static String get subscribeServiceProvider =>
      tr('subscribe_service_provider');

  static String get setYourLocation => tr('set_your_location');

  // الخصم
  static String get offerDiscountPercent => tr('offer_discount_percent');

  static String get offerDiscountPercentHint =>
      tr('offer_discount_percent_hint');

  static String get offerToDateHint => tr('offer_to_date_hint');

  // حالة العرض
  static String get offerStatus => tr('offer_status');

  static String get offerStatusHint => tr('offer_status_hint');

  /// ===== Map / Location Strings =====
  static String get errorTitle => tr('error_title');

  static String get locationPermissionDenied =>
      tr('location_permission_denied');

  static String get setLocationTitle => tr('set_location_title');

  static String get setLocationError => tr('set_location_error');

  static String get retryLocation => tr('retry_location');

  static String get setLocationConfirm => tr('set_location_confirm');

  // Used when the provider has not registered a company yet
  static String get noCompanyTitle => tr('no_company_title');

  static String get noCompanySubtitle => tr('no_company_subtitle');

  static String get goToRegisterCompany => tr('go_to_register_company');

  static String get retry => tr('retry');

  static String get offerStatusPending => tr('offer_status_pending');

  static String get offerStatusPublished => tr('offer_status_published');

  static String get offerStatusUnpublished => tr('offer_status_unpublished');

  static String get offerStatusFinished => tr('offer_status_finished');

  static String get offerStatusCanceled => tr('offer_status_canceled');

  static String get legendTitle => tr('legend_title');

  static String get companyDetailsTitle => tr('company_details_title');

  static String get settingsList => tr('settings_list');

  static String get editCompanyData => tr('edit_company_data');

  static String get subscriptionInfo => tr('subscription_info');

  static String get currentOffers => tr('current_offers');

  static String get location => tr('location');

  static String get noRegisteredCompanyTitle =>
      tr('no_registered_company_title');

  static String get noRegisteredCompanySubtitle =>
      tr('no_registered_company_subtitle');

  static String get retryButton => tr('retry_button');

  static String get completeSubscriptionTitle =>
      tr('complete_subscription_title');

  static String get completeSubscriptionSubtitle =>
      tr('complete_subscription_subtitle');

  static String get completeSubscriptionButton =>
      tr('complete_subscription_button');

  static String get completeSubscriptionLater =>
      tr('complete_subscription_later');

  static String get requestNewServiceTitle => tr('request_new_service_title');

  static String get requestNewServiceSubtitle =>
      tr('request_new_service_subtitle');

  static String get serviceLabel => tr('service_label');

  static String get serviceHint => tr('service_hint');

  static String get serviceDescLabel => tr('service_desc_label');

  static String get serviceDescHint => tr('service_desc_hint');

  static String get serviceBtnSubmit => tr('service_btn_submit');

  static String get confirmSendRequestTitle => tr('confirm_send_request_title');

  static String get confirmSendRequestSubtitle =>
      tr('confirm_send_request_subtitle');

  static String get confirmSendRequestConfirm =>
      tr('confirm_send_request_confirm');

  static String get confirmSendRequestCancel =>
      tr('confirm_send_request_cancel');

  static String get contractsServicesTitle => tr('contracts_services_title');

  static String get quickAccessTitle => tr('quick_access_title');

  static String get myRequestsTitle => tr('my_requests_title');

  static String get myRequestsSubtitle => tr('my_requests_subtitle');

  static String get addRequestTitle => tr('add_request_title');

  static String get addRequestSubtitle => tr('add_request_subtitle');

  static String get manageRequestsTitle => tr('manage_requests_title');

  static String get pendingRequestsTab => tr('pending_requests_tab');

  static String get activeRequestsTab => tr('active_requests_tab');

  static String get serviceProviderSubscriptionSubtitle =>
      tr("serviceProviderSubscriptionSubtitle");

  static String get serviceProviderTradeName => tr("serviceProviderTradeName");

  static String get serviceProviderTradeNameHint =>
      tr("serviceProviderTradeNameHint");

  static String get serviceProviderActivityType =>
      tr("serviceProviderActivityType");

  static String get serviceProviderActivityTypeHint =>
      tr("serviceProviderActivityTypeHint");

  static String get serviceProviderCommercialRegistrationNumber =>
      tr("serviceProviderCommercialRegistrationNumber");

  static String get serviceProviderCommercialRegistrationNumberHint =>
      tr("serviceProviderCommercialRegistrationNumberHint");

  static String get serviceProviderShortDescription =>
      tr("serviceProviderShortDescription");

  static String get serviceProviderShortDescriptionHint =>
      tr("serviceProviderShortDescriptionHint");

  static String get serviceProviderAboutProvider =>
      tr("serviceProviderAboutProvider");

  static String get serviceProviderAboutProviderHint =>
      tr("serviceProviderAboutProviderHint");

  static String get serviceProviderFoundationDate =>
      tr("serviceProviderFoundationDate");

  static String get serviceProviderFoundationDateHint =>
      tr("serviceProviderFoundationDateHint");

  static String get serviceProviderPhoneNumber =>
      tr("serviceProviderPhoneNumber");

  static String get serviceProviderPhoneNumberHint =>
      tr("serviceProviderPhoneNumberHint");

  static String get serviceProviderSetLocation =>
      tr("serviceProviderSetLocation");

  static String get serviceProviderSetLocationHint =>
      tr("serviceProviderSetLocationHint");

  static String get serviceProviderChooseLocation =>
      tr("serviceProviderChooseLocation");

  static String get serviceProviderDetailedAddress =>
      tr("serviceProviderDetailedAddress");

  static String get serviceProviderDetailedAddressHint =>
      tr("serviceProviderDetailedAddressHint");

  static String get serviceProviderLicenseFile =>
      tr("serviceProviderLicenseFile");

  static String get serviceProviderLicenseFileHint =>
      tr("serviceProviderLicenseFileHint");

  static String get serviceProviderLicenseFileNote =>
      tr("serviceProviderLicenseFileNote");

  static String get serviceProviderLogoFile => tr("serviceProviderLogoFile");

  static String get serviceProviderLogoFileHint =>
      tr("serviceProviderLogoFileHint");

  static String get serviceProviderLogoFileNote =>
      tr("serviceProviderLogoFileNote");

  static String get serviceProviderConfirmSubscriptionTitle =>
      tr("serviceProviderConfirmSubscriptionTitle");

  static String get serviceProviderConfirmSubscriptionSubtitle =>
      tr("serviceProviderConfirmSubscriptionSubtitle");

  static String get serviceProviderConfirm => tr("serviceProviderConfirm");

  static String get serviceProviderCancel => tr("serviceProviderCancel");

  static String get subscriptionCommercialTitle =>
      tr("subscriptionCommercialTitle");

  static String get subscriptionCommercialMainTitle =>
      tr("subscriptionCommercialMainTitle");

  static String get subscriptionCommercialSubTitle =>
      tr("subscriptionCommercialSubTitle");

  static String get subscriptionCommercialPlanTitle =>
      tr("subscriptionCommercialPlanTitle");

  static String get subscriptionCommercialPlanName =>
      tr("subscriptionCommercialPlanName");

  static String get subscriptionCommercialPlanPrice =>
      tr("subscriptionCommercialPlanPrice");

  static String get subscriptionCommercialDuration =>
      tr("subscriptionCommercialDuration");

  static String get subscriptionCommercialDurationHint =>
      tr("subscriptionCommercialDurationHint");

  static String get subscriptionCommercialIncludedFeatures =>
      tr("subscriptionCommercialIncludedFeatures");

  static String get subscriptionCommercialFeature1 =>
      tr("subscriptionCommercialFeature1");

  static String get subscriptionCommercialFeature2 =>
      tr("subscriptionCommercialFeature2");

  static String get subscriptionCommercialFeature3 =>
      tr("subscriptionCommercialFeature3");

  static String get subscriptionCommercialFeature4 =>
      tr("subscriptionCommercialFeature4");

  static String get subscriptionCommercialButton =>
      tr("subscriptionCommercialButton");

  static String get subscriptionCommercialNote =>
      tr("subscriptionCommercialNote");

  ///Manager Commercial Contract Service Strings.
  // Contracts Services
  static String get contractsQuickAccess => tr("contractsQuickAccess");

  static String get contractsAddServiceTitle => tr("contractsAddServiceTitle");

  static String get contractsAddServiceSubTitle =>
      tr("contractsAddServiceSubTitle");

  static String get contractsNeedsMapTitle => tr("contractsNeedsMapTitle");

  static String get contractsNeedsMapSubTitle =>
      tr("contractsNeedsMapSubTitle");

  static String get contractsDataManagementTitle =>
      tr("contractsDataManagementTitle");

  static String get contractsDataManagementSubTitle =>
      tr("contractsDataManagementSubTitle");

  static String get contractsMyServicesTitle => tr("contractsMyServicesTitle");

  static String get contractsMyServicesSubTitle =>
      tr("contractsMyServicesSubTitle");

  static String get contractsSubmittedOffersTitle =>
      tr("contractsSubmittedOffersTitle");

  static String get contractsSubmittedOffersSubTitle =>
      tr("contractsSubmittedOffersSubTitle");

  // ================= Request For A New Service Commercial Contracts =================
  static String get requestForServiceTitle => tr("requestForServiceTitle");

  static String get requestForServicePrice => tr("requestForServicePrice");

  static String get requestForServicePriceHint =>
      tr("requestForServicePriceHint");

  static String get requestForServiceTechnicalOffer =>
      tr("requestForServiceTechnicalOffer");

  static String get requestForServiceTechnicalOfferHint =>
      tr("requestForServiceTechnicalOfferHint");

  static String get requestForServiceTechnicalOfferNote =>
      tr("requestForServiceTechnicalOfferNote");

  static String get requestForServiceContactNumber =>
      tr("requestForServiceContactNumber");

  static String get requestForServiceContactNumberHint =>
      tr("requestForServiceContactNumberHint");

  static String get requestForServiceSubmit => tr("requestForServiceSubmit");

// ===== Dialog Confirm =====
  static String get requestForServiceConfirmTitle =>
      tr("requestForServiceConfirmTitle");

  static String get requestForServiceConfirmSubtitle =>
      tr("requestForServiceConfirmSubtitle");

  static String get requestForServiceConfirm => tr("requestForServiceConfirm");

  static String get requestForServiceCancel => tr("requestForServiceCancel");

  static String get addNewServiceTitle => tr("addNewServiceTitle");

  static String get addNewServiceSubTitle => tr("addNewServiceSubTitle");

  static String get serviceNameLabel => tr("serviceNameLabel");

  static String get serviceNameHint => tr("serviceNameHint");

  static String get serviceDescriptionLabel => tr("serviceDescriptionLabel");

  static String get serviceDescriptionHint => tr("serviceDescriptionHint");

  static String get serviceInitialPriceLabel => tr("serviceInitialPriceLabel");

  static String get serviceInitialPriceHint => tr("serviceInitialPriceHint");

  static String get serviceUploadImageLabel => tr("serviceUploadImageLabel");

  static String get serviceUploadImageHint => tr("serviceUploadImageHint");

  static String get serviceUploadImageNote => tr("serviceUploadImageNote");

  static String get addServiceButton => tr("addServiceButton");

  static String get confirmAddServiceTitle => tr("confirmAddServiceTitle");

  static String get confirmAddServiceSubTitle =>
      tr("confirmAddServiceSubTitle");

  static String get confirm => tr("confirm");

  static String get followUpOrdersTitle => tr('follow_up_orders_title');

  static String get ordersListTitle => tr('orders_list_title');

  static String get offerDateLabel => tr('offer_date_label');

  static String get offerTitle => tr('offer_title');

  static String get offerPriceLabel => tr('offer_price_label');

  static String get offerDescription => tr('offer_description');

  static String get downloadOfferButton => tr('download_offer_button');

  static String get manageServicesTitle => tr("manageServicesTitle");

  static String get activeServices => tr("activeServices");

  static String get disabledServices => tr("disabledServices");

  static String get servicePrice => tr("servicePrice");

  static String get updateService => tr("updateService");

  static String get disableService => tr("disableService");

  static String get enableService => tr("enableService");

  // 🏠 Register To Real Estate Provider Screen Strings
  static String get joinAsRealEstateProvider =>
      tr('join_as_real_estate_provider');

  static String get startListingProperties => tr('start_listing_properties');

  static String get completeInfoToPublish => tr('complete_info_to_publish');

  static String get enterFullName => tr('enter_full_name');

  static String get enterPhoneNumber => tr('enter_phone_number');

  static String get realEstateManagementTitle =>
      tr('real_estate_management_title');

  static String get myPropertiesTitle => tr('my_properties_title');

  static String get myPropertiesSubtitle => tr('my_properties_subtitle');

  static String get addPropertyTitle => tr('add_property_title');

  static String get addPropertySubtitle => tr('add_property_subtitle');

  static String get editMyDataTitle => tr('edit_my_data_title');

  static String get editMyDataSubtitle => tr('edit_my_data_subtitle');

  static String get whatsappNumber => tr('whatsapp_number');

  static String get enterWhatsappNumber => tr('enter_whatsapp_number');

  static String get enterLocationDetails => tr('enter_location_details');

  static String get activityDescription => tr('activity_description');

  static String get enterActivityDescription =>
      tr('enter_activity_description');

  static String get uploadLogoLabel => tr('upload_logo_label');

  static String get uploadLogoHint => tr('upload_logo_hint');

  static String get uploadLogoNote => tr('upload_logo_note');

  static String get accountType => tr('account_type');

  static String get officeAccount => tr('office_account');

  static String get personalAccount => tr('personal_account');

  static String get brokerageCertificate => tr('brokerage_certificate');

  static String get uploadBrokerageHint => tr('upload_brokerage_hint');

  static String get uploadBrokerageNote => tr('upload_brokerage_note');

  static String get uploadCommercialHint => tr('upload_commercial_hint');

  static String get uploadCommercialNote => tr('upload_commercial_note');

  static String get addButton => tr('add_button');

  /// Config Strings
  static String get noRouteFound => tr('noRouteFound');

  static String get success => tr('success');

  static String get noContent => tr('noContent');

  static String get badRequest => tr('badRequest');

  static String get forbidden => tr('forbidden');

  static String get unAuthorized => tr('unAuthorized');

  static String get notFound => tr('notFound');

  static String get internalServerError => tr('internalServerError');

  static String get connectTimeOut => tr('connectTimeOut');

  static String get cancel => tr('cancel');

  static String get receiveTimeOut => tr('receiveTimeOut');

  static String get sendTimeOut => tr('sendTimeOut');

  static String get cacheError => tr('cacheError');

  static String get noInternetConnection => tr('noInternetConnection');

  static String get unKnown => tr('unKnown');

  static String get sessionFinished => tr('sessionFinished');

  static String get invalidEmptyEmail => tr('invalidEmptyEmail');

  static String get invalidEmail => tr('invalidEmail');

  static String get doYouWantToChangeIt => tr('doYouWantToChangeIt');

  static String get invalidPasswordLength => tr('invalidEmptyPassword');

  static String get invalidPasswordUpper => tr('invalidPasswordUpper');

  static String get invalidPasswordLower => tr('invalidPasswordLower');

  static String get invalidPasswordDigit => tr('invalidPasswordDigit');

  static String get passwordNotMatch => tr('passwordNotMatch');

  static String get invalidEmptyPhoneNumber => tr('invalidEmptyPhoneNumber');

  static String get invalidEmptyCode => tr('invalidEmptyCode');

  static String get invalidPhoneNumber => tr('invalidPhoneNumber');

  static String get notVerifiedEmail => tr('notVerifiedEmail');

  static String get invalidFullName => tr('invalidFullName');

  static String get sorryFailed => tr('sorryFailed');

  static String get invalidEmptyDateOfBirth => tr('invalidEmptyDateOfBirth');

  static String get invalidEmptyFullName => tr('invalidEmptyFullName');

  static String get addRealEstateTitle => tr('add_real_estate_title');

  static String get addRealEstateSubtitle => tr('add_real_estate_subtitle');

  static String get propertyType => tr('property_type');

  static String get selectPropertyType => tr('select_property_type');

  static String get city => tr('city');

  static String get selectCity => tr('select_city');

  static String get district => tr('district');

  static String get selectDistrict => tr('select_district');

  static String get propertyLocation => tr('property_location');

  static String get setPropertyLocation => tr('set_property_location');

  static String get propertyPrice => tr('property_price');

  static String get enterPropertyPrice => tr('enter_property_price');

  static String get propertyArea => tr('property_area');

  static String get enterPropertyArea => tr('enter_property_area');

  static String get constructionYear => tr('construction_year');

  static String get enterConstructionYear => tr('enter_construction_year');

  static String get bathroomsCount => tr('bathrooms_count');

  static String get enterBathroomsCount => tr('enter_bathrooms_count');

  static String get bedroomsCount => tr('bedrooms_count');

  static String get enterBedroomsCount => tr('enter_bedrooms_count');

  static String get livingroomsCount => tr('livingrooms_count');

  static String get enterLivingroomsCount => tr('enter_livingrooms_count');

  static String get streetWidth => tr('street_width');

  static String get enterStreetWidth => tr('enter_street_width');

  static String get propertyFacing => tr('property_facing');

  static String get selectPropertyFacing => tr('select_property_facing');

  static String get propertyUsage => tr('property_usage');

  static String get selectPropertyUsage => tr('select_property_usage');

  static String get propertyDescription => tr('property_description');

  static String get enterPropertyDescription =>
      tr('enter_property_description');

  static String get propertyFeatures => tr('property_features');

  static String get selectPropertyFeatures => tr('select_property_features');

  static String get visitDays => tr('visit_days');

  static String get selectVisitDays => tr('select_visit_days');

  static String get propertyImages => tr('property_images');

  static String get uploadPropertyImages => tr('upload_property_images');

  static String get submitProperty => tr('submit_property');
}
