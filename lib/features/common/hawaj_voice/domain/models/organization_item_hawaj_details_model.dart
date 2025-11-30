import 'offer_item_hawaj_model.dart';

class OrganizationItemHawajDetailsModel {
  final String id;
  final String organizationName;
  final String organizationServices;
  final String organizationType;
  final String organizationTypeLabel;
  final String organizationLocationLat;
  final String organizationLocationLng;
  final String organizationDetailedAddress;
  final String managerName;
  final String phoneNumber;
  final String workingHours;
  final String organizationLogo;
  final String organizationBanner;

  // ✅ إضافة قائمة العروض
  final List<OfferItemHawajModel> offers;

  OrganizationItemHawajDetailsModel({
    required this.id,
    required this.organizationName,
    required this.organizationServices,
    required this.organizationType,
    required this.organizationTypeLabel,
    required this.organizationLocationLat,
    required this.organizationLocationLng,
    required this.organizationDetailedAddress,
    required this.managerName,
    required this.phoneNumber,
    required this.workingHours,
    required this.organizationLogo,
    required this.organizationBanner,
    required this.offers,
  });
}
// class OrganizationItemHawajDetailsModel {
//   final String id;
//   final String organizationName;
//   final String organizationServices;
//   final String organizationType;
//   final String organizationTypeLabel;
//   final String organizationLocationLat;
//   final String organizationLocationLng;
//   final String organizationDetailedAddress;
//   final String managerName;
//   final String phoneNumber;
//   final String workingHours;
//   final String organizationLogo;
//   final String organizationBanner;
//   final String commercialRegistrationNumber;
//   final String commercialRegistration;
//   final String organizationStatus;
//   final String organizationStatusLabel;
//   final String memberId;
//   final String memberIdLabel;
//
//   OrganizationItemHawajDetailsModel({
//     required this.id,
//     required this.organizationName,
//     required this.organizationServices,
//     required this.organizationType,
//     required this.organizationTypeLabel,
//     required this.organizationLocationLat,
//     required this.organizationLocationLng,
//     required this.organizationDetailedAddress,
//     required this.managerName,
//     required this.phoneNumber,
//     required this.workingHours,
//     required this.organizationLogo,
//     required this.organizationBanner,
//     required this.commercialRegistrationNumber,
//     required this.commercialRegistration,
//     required this.organizationStatus,
//     required this.organizationStatusLabel,
//     required this.memberId,
//     required this.memberIdLabel,
//   });
// }
