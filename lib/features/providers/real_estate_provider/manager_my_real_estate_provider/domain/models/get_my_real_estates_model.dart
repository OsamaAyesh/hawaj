import 'package:app_mobile/core/model/real_estate_item_model.dart';

class GetMyRealEstatesModel {
  bool error;
  String message;
  List<RealEstateItemModel> data;

  GetMyRealEstatesModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
