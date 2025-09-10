import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/response/get_offer_item_response.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/model/get_offer_item_model.dart';

extension GetOfferItemMapper on GetOfferItemResponse{
  GetOfferItemModel toDomain() {
    return GetOfferItemModel(id: id.onNull(),
        productName: productName.onNull(),
        productDescription: productDescription.onNull(),
        productImages: productImages.onNull(),
        productPrice: productPrice.onNull(),
        offerType: offerType.onNull(),
        offerPrice: offerPrice.onNull(),
        offerStartDate: offerStartDate.onNull(),
        offerEndDate: offerEndDate.onNull(),
        offerDescription: offerDescription.onNull(),
        organizationId: organizationId.onNull(),
        offerStatus: offerStatus.onNull(),);
  }
}