import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/real_estate_item_mapper.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/response/get_my_real_estates_response.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/domain/models/get_my_real_estates_model.dart';

extension GetMyRealEstatesMapper on GetMyRealEstatesResponse {
  GetMyRealEstatesModel toDomain() {
    return GetMyRealEstatesModel(
      error: error.onNull(),
      message: message.onNull(),
      data: data?.map((e) => e.toDomain()).toList() ?? [],
    );
  }
}
