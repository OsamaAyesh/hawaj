import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/organization_min_mapper.dart';
import 'package:app_mobile/core/model/offer_general_item_model.dart';
import 'package:app_mobile/core/response/offer_general_item_response.dart';

extension OfferGeneralItemMapper on OfferGeneralItemResponse {
  OfferGeneralItemModel toDomain() {
    return OfferGeneralItemModel(
      offerId: offerId.onNull(),
      offerName: offerName.onNull(),
      offerPrice: offerPrice.onNull(),
      offerDescription: offerDescription.onNull(),
      offerImage: offerImage.onNull(),
      offerPercentage: offerPercentage.onNull(),
      offerType: offerType.onNull(),
      offerTypeLabel: offerTypeLabel.onNull(),
      offerStartDate: offerStartDate.onNull(),
      offerEndDate: offerEndDate.onNull(),
      offerStatus: offerStatus.onNull(),
      offerStatusLabel: offerStatusLabel.onNull(),
      organization: organization!.toDomain(),
    );
  }
}
