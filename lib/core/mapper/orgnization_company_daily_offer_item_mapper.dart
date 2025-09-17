import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/offer_general_item_mapper.dart';
import 'package:app_mobile/core/model/orgnization_company_daily_offer_item_model.dart';
import 'package:app_mobile/core/response/organization_company_daily_offer_item_response.dart';

extension OrgnizationCompanyDailyOfferItemMapper
    on OrganizationCompanyDailyOfferItemResponse {
  OrganizationCompanyDailyOfferItemModel toDomain() {
    return OrganizationCompanyDailyOfferItemModel(
      id: id.onNull(),
      organization: organization.onNull(),
      organizationServices: organizationServices.onNull(),
      lat: lat.onNull(),
      lng: lng.onNull(),
      address: address.onNull(),
      managerName: managerName.onNull(),
      phoneNumber: phoneNumber.onNull(),
      workingHours: workingHours.onNull(),
      organizationLogo: organizationLogo.onNull(),
      organizationBanner: organizationBanner.onNull(),
      offersCount: offersCount.onNull(),
      offers: offers!.map((e) => e.toDomain()).toList(),
    );
  }
}
