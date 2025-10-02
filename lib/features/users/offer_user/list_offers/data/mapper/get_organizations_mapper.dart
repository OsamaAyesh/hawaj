import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/orgnization_company_daily_offer_item_mapper.dart';
import 'package:app_mobile/features/users/offer_user/list_offers/domain/models/get_organizations_model.dart';

import '../response/get_organizations_response.dart';

extension GetOrganizationsMapper on GetOrganizationsResponse {
  GetOrganizationsModel toDomain() {
    return GetOrganizationsModel(
      error: error.onNull(),
      message: message.onNull(),
      data: data?.map((e) => e.toDomain()).toList() ?? [],
    );
  }
}
