import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/model/get_organization_item_with_out_offer_model.dart'
    show GetOrganizationItemWithOutOfferModel;

import '../response/get_organization_item_with_out_offer_response.dart'; // ✅ التصحيح هنا

extension GetOrganizationItemWithOutOfferMapper
    on GetOrganizationItemWithOutOfferResponse {
  // ✅ التصحيح هنا
  GetOrganizationItemWithOutOfferModel toDomain() {
    return GetOrganizationItemWithOutOfferModel(
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
      commercialRegistrationNumber: commercialRegistrationNumber.onNull(),
      commercialRegistration: commercialRegistration.onNull(),
      organizationStatus: organizationStatus.onNull(),
      organizationStatusLabel: organizationStatusLabel.onNull(),
      memberId: memberId.onNull(),
      memberIdLabel: memberIdLabel.onNull(),
    );
  }
}
