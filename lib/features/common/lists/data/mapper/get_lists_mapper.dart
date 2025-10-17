import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/lists/data/mapper/get_lists_data_mapper.dart';
import 'package:app_mobile/features/common/lists/data/response/get_lists_response.dart';
import 'package:app_mobile/features/common/lists/domain/models/get_lists_model.dart';

extension GetListsMapper on GetListsResponse {
  GetListsModel toDomain() {
    return GetListsModel(
        error: error.onNull(),
        message: message.onNull(),
        data: data!.toDomain());
  }
}
