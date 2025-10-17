import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/lists/data/response/feature_item_response.dart';
import 'package:app_mobile/features/common/lists/domain/models/feature_item_model.dart';

extension FeatureItemMapper on FeatureItemResponse {
  FeatureItemModel toDomain() {
    return FeatureItemModel(
        id: id.onNull(),
        featureName: featureName.onNull(),
        featureIcon: featureIcon.onNull(),
        featureImage: featureImage.onNull(),
        displayOrder: displayOrder.onNull());
  }
}
