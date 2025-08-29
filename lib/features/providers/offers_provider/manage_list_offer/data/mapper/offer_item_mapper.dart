import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/data/response/offer_item_response.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/domain/model/offer_item_model.dart';

extension OfferItemMapper on OfferItemResponse{
  OfferItemModel toDomain() {
    return OfferItemModel(id: id.onNull(),
        productName: productName.onNull(),
        productDescription: productDescription.onNull(),
        productImages: productImages?.map((e)=>e.onNull()).toList()??[],
        productPrice: productPrice.onNull(),
        offerType: offerType.onNull(),
        offerPrice: offerPrice.onNull(),
        offerStartDate: offerStartDate.onNull(),
        offerEndDate: offerEndDate.onNull(),
        offerDescription: offerDescription.onNull(),
        organizationId: organizationId.onNull(),
        offerStatus: offerStatus.onNull());
  }
}