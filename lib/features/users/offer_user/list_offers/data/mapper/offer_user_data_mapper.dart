import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/data/mapper/offer_item_mapper.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/data/response/offer_data_response.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/domain/model/offer_data_model.dart';
import 'package:app_mobile/features/users/offer_user/list_offers/data/mapper/offer_user_item_mapper.dart';

import '../../domain/model/offer_user_data_model.dart';
import '../response/offer_user_data_response.dart';

extension OfferUserDataMapper on OfferUserDataResponse{
  OfferUserDataModel toDomain(){
    return OfferUserDataModel(data: data!.map((e)=>e.toDomain()).toList());
  }
}