import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/splash_and_boarding/data/response/on_boarding_item_response.dart';
import 'package:app_mobile/features/splash_and_boarding/domain/model/on_boarding_item_model.dart';

extension OnBoardingItemMapper on OnBoardingItemResponse {
  OnBoardingItemModel toDomain() {
    return OnBoardingItemModel(
      id: id.onNull(),
      mainTitle: mainTitle.onNull(),
      screenName: screenName.onNull(),
      screenOrder: screenOrder.onNull(),
      screenImage: screenImage.onNull(),
      screenDescription: screenDescription.onNull(),
    );
  }
}
