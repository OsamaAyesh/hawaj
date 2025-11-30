import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/hawaj_voice/data/mapper/offer_item_hawaj_mapper.dart';

import '../../domain/models/organization_item_hawaj_details_model.dart';
import '../response/organization_item_hawaj_details_response.dart';

extension OrganizationItemHawajDetailsMapper
    on OrganizationItemHawajDetailsResponse {
  OrganizationItemHawajDetailsModel toDomain() {
    return OrganizationItemHawajDetailsModel(
      id: id.onNull(),
      organizationName: organizationName.onNull(),
      organizationServices: organizationServices.onNull(),
      organizationType: organizationType.onNull(),
      organizationTypeLabel: organizationTypeLabel.onNull(),
      organizationLocationLat: organizationLocationLat.onNull(),
      organizationLocationLng: organizationLocationLng.onNull(),
      organizationDetailedAddress: organizationDetailedAddress.onNull(),
      managerName: managerName.onNull(),
      phoneNumber: phoneNumber.onNull(),
      workingHours: workingHours.onNull(),
      organizationLogo: organizationLogo.onNull(),
      organizationBanner: organizationBanner.onNull(),
      // ✅ تحويل العروض
      offers: offers?.map((e) => e.toDomain()).toList() ?? [],
    );
  }
}
// import 'package:app_mobile/core/extensions/extensions.dart';

//
// import '../../domain/models/organization_item_hawaj_details_model.dart';
// import '../response/organization_item_hawaj_details_response.dart';
//
// extension OrganizationItemHawajDetailsMapper
//     on OrganizationItemHawajDetailsResponse {
//   OrganizationItemHawajDetailsModel toDomain() {
//     return OrganizationItemHawajDetailsModel(
//       id: id.onNull(),
//       organizationName: organizationName.onNull(),
//       organizationServices: organizationServices.onNull(),
//       organizationType: organizationType.onNull(),
//       organizationTypeLabel: organizationTypeLabel.onNull(),
//       organizationLocationLat: organizationLocationLat.onNull(),
//       organizationLocationLng: organizationLocationLng.onNull(),
//       organizationDetailedAddress: organizationDetailedAddress.onNull(),
//       managerName: managerName.onNull(),
//       phoneNumber: phoneNumber.onNull(),
//       workingHours: workingHours.onNull(),
//       organizationLogo: organizationLogo.onNull(),
//       organizationBanner: organizationBanner.onNull(),
//       commercialRegistrationNumber: commercialRegistrationNumber.onNull(),
//       commercialRegistration: commercialRegistration.onNull(),
//       organizationStatus: organizationStatus.onNull(),
//       organizationStatusLabel: organizationStatusLabel.onNull(),
//       memberId: memberId.onNull(),
//       memberIdLabel: memberIdLabel.onNull(),
//     );
//   }
// }
