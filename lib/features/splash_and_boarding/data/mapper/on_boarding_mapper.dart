import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/splash_and_boarding/data/mapper/on_boarding_data_mapper.dart';
import 'package:app_mobile/features/splash_and_boarding/data/response/on_boarding_response.dart';
import 'package:app_mobile/features/splash_and_boarding/domain/model/on_boarding_model.dart';

extension OnBoardingMapper on OnBoardingResponse {
  OnBoardingModel toDomain() {
    return OnBoardingModel(
      error: error.onNull(),
      message: message.onNull(),
      data: data!.toDomain(),
    );
  }
}
