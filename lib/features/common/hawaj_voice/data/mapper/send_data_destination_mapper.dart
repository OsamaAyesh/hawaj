import 'package:app_mobile/core/extensions/extensions.dart';

import '../../domain/models/send_data_destination_model.dart';
import '../response/send_data_destination_response.dart';

extension SendDataDestinationMapper on SendDataDestinationResponse {
  SendDataDestinationModel toDomain() {
    return SendDataDestinationModel(
      section: section.onNull(),
      screen: screen.onNull(),
      parameters: parameters ?? [],
      message: message.onNull(),
      mp3: mp3.onNull(),
    );
  }
}
