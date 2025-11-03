import 'package:app_mobile/core/extensions/extensions.dart';

import '../model/get_organization_item_with_offer_model.dart';
import '../response/get_organization_item_with_offer_response.dart';
import 'offer_new_item_mapper.dart';

extension GetOrganizationItemWithOfferMapper
    on GetOrganizationItemWithOfferResponse {
  GetOrganizationItemWithOfferModel toDomain() {
    return GetOrganizationItemWithOfferModel(
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
      offers: offers?.map((offer) => offer.toDomain()).toList() ?? [],
    );
  }
}
