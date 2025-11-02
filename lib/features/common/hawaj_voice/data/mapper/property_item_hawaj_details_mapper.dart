import 'package:app_mobile/core/extensions/extensions.dart';

import '../../domain/models/property_item_hawaj_details_model.dart';
import '../response/property_item_hawaj_details_response.dart';

extension PropertyItemHawajDetailsMapper on PropertyItemHawajDetailsResponse {
  PropertyItemHawajDetailsModel toDomain() {
    return PropertyItemHawajDetailsModel(
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
      propertyOwnerName: propertyOwnerName.onNull(),
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
      images: images.onNull(),
      propertyStatus: propertyStatus.onNull(),
      propertyStatusLabel: propertyStatusLabel.onNull(),
    );
  }
}
