import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/get_organization_item_with_offer_mappers.dart';
import 'package:app_mobile/features/providers/offer_provider_new_api/details_my_organization/data/response/get_my_organization_details_response.dart';
import 'package:app_mobile/features/providers/offer_provider_new_api/details_my_organization/domain/models/get_my_organization_details_model.dart';

extension GetMyOrganizationDetailsMapper on GetMyOrganizationDetailsResponse {
  GetMyOrganizationDetailsModel toDomain() {
    return GetMyOrganizationDetailsModel(
      error: error.onNull(),
      message: message.onNull(),
      data: data!.toDomain(),
    );
  }
}
