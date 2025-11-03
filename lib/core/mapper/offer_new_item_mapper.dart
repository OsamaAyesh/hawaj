import 'package:app_mobile/core/extensions/extensions.dart';

import '../model/offer_new_item_model.dart';
import '../response/offer_new_item_response.dart';

extension OfferNewItemMapper on OfferNewItemResponse {
  OfferNewItemModel toDomain() {
    return OfferNewItemModel(
      id: id.onNull(),
      productName: productName.onNull(),
      productDescription: productDescription.onNull(),
      productImages: productImages.onNull(),
      productPrice: productPrice.onNull(),
      offerType: offerType.onNull(),
      offerTypeLabel: offerTypeLabel.onNull(),
      offerPrice: offerPrice.onNull(),
      offerStartDate: offerStartDate.onNull(),
      offerEndDate: offerEndDate.onNull(),
      offerDescription: offerDescription.onNull(),
      organizationId: organizationId.onNull(),
      organizationIdLabel: organizationIdLabel.onNull(),
      offerStatus: offerStatus.onNull(),
      offerStatusLabel: offerStatusLabel.onNull(),
      images: images.onNull(),
      keywords: keywords.onNull(),
    );
  }
}
