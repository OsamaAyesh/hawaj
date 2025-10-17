import 'package:app_mobile/features/common/lists/domain/models/get_lists_data_model.dart';

class GetListsModel {
  bool error;

  String message;

  GetListsDataModel data;

  GetListsModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
