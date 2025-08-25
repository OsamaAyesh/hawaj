import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/core/response/with_out_data_response.dart';

extension WithOutDataMapper on WithOutDataResponse{
  WithOutDataModel toDomain(){
    return WithOutDataModel(error: error.onNull(), message: message.onNull());
  }
}