import 'package:app_mobile/features/splash_and_boarding/data/mapper/on_boarding_item_mapper.dart';
import 'package:app_mobile/features/splash_and_boarding/data/response/on_boarding_data_response.dart';
import 'package:app_mobile/features/splash_and_boarding/domain/model/on_boarding_data_model.dart';

extension OnBoardingDataMapper on OnBoardingDataResponse{
  OnBoardingDataModel toDomain(){
    return OnBoardingDataModel(data: data?.map((e)=>e.toDomain()).toList()??[ ]);
  }
}