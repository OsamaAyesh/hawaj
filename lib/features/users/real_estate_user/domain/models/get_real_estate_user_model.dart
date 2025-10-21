import 'package:app_mobile/core/model/real_estate_item_model.dart';

class GetRealEstateUserModel {
  bool error;
  String message;
  RealEstateItemModel data;

  GetRealEstateUserModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
