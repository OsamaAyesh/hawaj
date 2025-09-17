class OrganizationMinModel {
  int id;
  String organization;
  String organizationServices;
  String lat;
  String lng;
  String address;
  String managerName;
  String phoneNumber;
  String workingHours;
  String organizationLogo;
  String organizationBanner;

  OrganizationMinModel({
    required this.id,
    required this.organization,
    required this.organizationServices,
    required this.lat,
    required this.lng,
    required this.address,
    required this.managerName,
    required this.phoneNumber,
    required this.workingHours,
    required this.organizationLogo,
    required this.organizationBanner,
  });
}
