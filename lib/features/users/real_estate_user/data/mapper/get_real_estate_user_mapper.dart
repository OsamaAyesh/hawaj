import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/real_estate_item_mapper.dart';
import 'package:app_mobile/features/users/real_estate_user/data/response/get_real_estate_user_response.dart';
import 'package:app_mobile/features/users/real_estate_user/domain/models/get_real_estate_user_model.dart';

extension GetRealEstateUserMapper on GetRealEstateUserResponse {
  GetRealEstateUserModel toDomain() {
    return GetRealEstateUserModel(
      error: error.onNull(),
      message: message.onNull(),
      data: data!.toDomain(),
    );
  }
}
