import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/lists/data/response/organization_type_item_response.dart';
import 'package:app_mobile/features/common/lists/domain/models/organization_type_item_model.dart';

extension OrganizationTypeItemMapper on OrganizationTypeItemResponse {
  OrganizationTypeItemModel toDomain() {
    return OrganizationTypeItemModel(
        id: id.onNull(), organizationType: organizationType.onNull());
  }
}
