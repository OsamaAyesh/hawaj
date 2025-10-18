// Extension لتسهيل التحويل
import 'package:app_mobile/core/extensions/extensions.dart';

import '../model/real_estate_item_model.dart';
import '../response/real_estate_item_response.dart';

extension RealEstateItemMapper on RealEstateItemResponse {
  RealEstateItemModel toDomain() {
    return RealEstateItemModel(
      id: id.onNull(),
      propertySubject: propertySubject.onNull(),
      propertyType: propertyType.onNull(),
      propertyTypeLabel: propertyTypeLabel.onNull(),
      operationType: operationType.onNull(),
      operationTypeLabel: operationTypeLabel.onNull(),
      advertiserRole: advertiserRole.onNull(),
      advertiserRoleLabel: advertiserRoleLabel.onNull(),
      saleType: saleType.onNull(),
      saleTypeLabel: saleTypeLabel.onNull(),
      keywords: keywords.onNull(),
      propertyOwnerId: propertyOwnerId.onNull(),
      propertyOwnerIdLabel: propertyOwnerIdLabel.onNull(),
      lat: lat.onNull(),
      lng: lng.onNull(),
      propertyDetailedAddress: propertyDetailedAddress.onNull(),
      price: price.onNull(),
      areaSqm: areaSqm.onNull(),
      commissionPercentage: commissionPercentage.onNull(),
      usageType: usageType.onNull(),
      usageTypeLabel: usageTypeLabel.onNull(),
      propertyDescription: propertyDescription.onNull(),
      featureIds: featureIds.onNull(),
      facilityIds: facilityIds.onNull(),
      visitDays: visitDays.onNull(),
      visitTimeFrom: visitTimeFrom.onNull(),
      visitTimeTo: visitTimeTo.onNull(),
      propertyImages: propertyImages.onNull(),
      propertyVideos: propertyVideos.onNull(),
      deedDocument: deedDocument.onNull(),
    );
  }
}
