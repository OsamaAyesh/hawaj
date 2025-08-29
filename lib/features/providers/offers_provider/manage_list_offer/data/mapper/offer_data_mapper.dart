import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/data/mapper/offer_item_mapper.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/data/response/offer_data_response.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/domain/model/offer_data_model.dart';

extension OfferDataMapper on OfferDataResponse{
  OfferDataModel toDomain(){
    return OfferDataModel(data: data!.map((e)=>e.toDomain()).toList());
  }
}