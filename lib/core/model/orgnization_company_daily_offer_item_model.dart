class OrganizationCompanyDailyOfferItemModel {
  int id;
  String organizationName;
  String organizationServices;
  int organizationType;
  String organizationLocation;
  String organizationDetailedAddress;
  String managerName;
  String phoneNumber;
  String workingHours;
  String organizationLogo;
  String organizationBanner;
  String commercialRegistrationNumber;
  String commercialRegistration;
  int organizationStatus;

  OrganizationCompanyDailyOfferItemModel({
    required this.id,
    required this.organizationName,
    required this.organizationServices,
    required this.organizationType,
    required this.organizationLocation,
    required this.organizationDetailedAddress,
    required this.managerName,
    required this.phoneNumber,
    required this.workingHours,
    required this.organizationLogo,
    required this.organizationBanner,
    required this.commercialRegistrationNumber,
    required this.commercialRegistration,
    required this.organizationStatus,
  });
}
