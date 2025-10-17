import 'package:app_mobile/core/model/property_item_owner_model.dart';

class GetPropertyOwnersModel {
  bool error;
  String message;
  List<PropertyItemOwnerModel> data;

  GetPropertyOwnersModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
