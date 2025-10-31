class JobCompanyItemModel {
  String id;

  String companyName;

  String industry;

  String mobileNumber;

  String locationLat;

  String locationLng;

  String detailedAddress;

  String companyDescription;

  String companyShortDescription;

  String companyLogo;

  String contactPersonName;

  String contactPersonEmail;

  String commercialRegister;

  String activityLicense;

  String memberId;

  String memberIdLable;

  JobCompanyItemModel({
    required this.id,
    required this.companyName,
    required this.industry,
    required this.mobileNumber,
    required this.locationLat,
    required this.locationLng,
    required this.detailedAddress,
    required this.companyDescription,
    required this.companyShortDescription,
    required this.companyLogo,
    required this.contactPersonName,
    required this.contactPersonEmail,
    required this.commercialRegister,
    required this.activityLicense,
    required this.memberId,
    required this.memberIdLable,
  });
}
