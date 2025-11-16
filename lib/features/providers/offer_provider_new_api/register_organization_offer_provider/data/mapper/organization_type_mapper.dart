import 'package:app_mobile/core/extensions/extensions.dart';

import '../../domain/models/organization_type_model.dart';
import '../response/organization_type_response.dart';

extension OrganizationTypeMapper on OrganizationTypeResponse {
  OrganizationTypeModel toDomain() {
    return OrganizationTypeModel(
      id: id.onNull(),
      organizationType: organizationType.onNull(),
    );
  }
}
