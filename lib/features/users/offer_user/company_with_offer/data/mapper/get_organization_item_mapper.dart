import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/response/get_organization_item_response.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/model/get_organization_item_model.dart';

extension GetOrganizationItemMapper on GetOrganizationItemResponse {
  GetOrganizationItemModel toDomain() {
    return GetOrganizationItemModel(
      id: id.onNull(),
      organizationName: organizationName.onNull(),
      organizationServices: organizationServices.onNull(),
      organizationType: organizationType.onNull(),
      organizationLocation: organizationLocation.onNull(),
      organizationDetailedAddress: organizationDetailedAddress.onNull(),
      managerName: managerName.onNull(),
      phoneNumber: phoneNumber.onNull(),
      workingHours: workingHours.onNull(),
      organizationLogo: organizationLogo.onNull(),
      organizationBanner: organizationBanner.onNull(),
      commercialRegistrationNumber: commercialRegistrationNumber.onNull(),
      commercialRegistration: commercialRegistration.onNull(),
    );
  }
}
