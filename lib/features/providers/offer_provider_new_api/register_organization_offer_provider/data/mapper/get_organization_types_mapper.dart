import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/providers/offer_provider_new_api/register_organization_offer_provider/data/mapper/organization_types_data_mapper.dart';

import '../../domain/models/get_organization_types_model.dart';
import '../../domain/models/organization_types_data_model.dart';
import '../response/get_organization_types_response.dart';

extension GetOrganizationTypesMapper on GetOrganizationTypesResponse {
  GetOrganizationTypesModel toDomain() {
    return GetOrganizationTypesModel(
      error: error.onNull(),
      message: message.onNull(),
      data:
          data?.toDomain() ?? OrganizationTypesDataModel(organizationTypes: []),
    );
  }
}
