import 'package:app_mobile/features/splash_and_boarding/domain/model/on_boarding_data_model.dart';

class OnBoardingModel {
  bool error;
  String message;
  OnBoardingDataModel data;

  OnBoardingModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
