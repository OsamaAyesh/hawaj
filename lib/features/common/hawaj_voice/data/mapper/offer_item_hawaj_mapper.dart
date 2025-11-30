import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/hawaj_voice/data/response/offer_item_hawaj_response.dart';
import 'package:app_mobile/features/common/hawaj_voice/domain/models/offer_item_hawaj_model.dart';

extension OfferItemMapper on OfferItemHawajResponse {
  OfferItemHawajModel toDomain() {
    return OfferItemHawajModel(
      id: id.onNull(),
      productName: productName.onNull(),
      productDescription: productDescription.onNull(),
      productImages: productImages.onNull(),
      productPrice: productPrice.onNull(),
      offerType: offerType.onNull(),
      offerPrice: offerPrice.onNull(),
      offerStartDate: offerStartDate.onNull(),
      offerEndDate: offerEndDate.onNull(),
      offerDescription: offerDescription.onNull(),
      images: images.onNull(),
    );
  }
}
