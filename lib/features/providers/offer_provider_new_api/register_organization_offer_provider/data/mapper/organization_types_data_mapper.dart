import 'package:app_mobile/features/providers/offer_provider_new_api/register_organization_offer_provider/data/mapper/organization_type_mapper.dart';

import '../../domain/models/organization_types_data_model.dart';
import '../response/organization_types_data_response.dart';

extension OrganizationTypesDataMapper on OrganizationTypesDataResponse {
  OrganizationTypesDataModel toDomain() {
    return OrganizationTypesDataModel(
      organizationTypes:
          (organizationTypes ?? []).map((type) => type.toDomain()).toList(),
    );
  }
}
