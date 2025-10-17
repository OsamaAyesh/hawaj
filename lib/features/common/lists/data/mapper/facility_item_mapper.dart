import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/lists/data/response/facility_item_response.dart';
import 'package:app_mobile/features/common/lists/domain/models/facility_item_model.dart';

extension FacilityItemMapper on FacilityItemResponse {
  FacilityItemModel toDomain() {
    return FacilityItemModel(
      id: id.onNull(),
      facilityName: facilityName.onNull(),
      facilityIcon: facilityIcon.onNull(),
      facilityImage: facilityImage.onNull(),
      facilityDisplayOrder: facilityDisplayOrder.onNull(),
    );
  }
}
