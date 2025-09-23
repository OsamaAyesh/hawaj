import 'package:app_mobile/features/common/hawaj_voice/domain/models/send_data_data_model.dart';

class SendDataModel {
  bool error;
  SendDataDataModel data;
  String message;

  SendDataModel({
    required this.error,
    required this.data,
    required this.message,
  });
}
