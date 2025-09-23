import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/hawaj_voice/data/mapper/send_data_data_mapper.dart';

import '../../domain/models/send_data_model.dart';
import '../response/send_data_response.dart';

extension SendDataMapper on SendDataResponse {
  SendDataModel toDomain() {
    return SendDataModel(
      error: error.onNull(),
      data: data!.toDomain(),
      message: message.onNull(),
    );
  }
}
