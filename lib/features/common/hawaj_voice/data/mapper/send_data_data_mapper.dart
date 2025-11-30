import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/features/common/hawaj_voice/data/mapper/send_data_results_mapper.dart';

import '../../domain/models/send_data_data_model.dart';
import '../response/send_data_data_response.dart';

extension SendDataDataMapper on SendDataDataResponse {
  SendDataDataModel toDomain() {
    return SendDataDataModel(
      q: q.onNull(),
      s: s.onNull(),
      d: d!.toDomain(),
    );
  }
}
// import 'package:app_mobile/core/extensions/extensions.dart';
// import 'package:app_mobile/features/common/hawaj_voice/data/mapper/send_data_destination_mapper.dart';
// import 'package:app_mobile/features/common/hawaj_voice/data/mapper/send_data_results_mapper.dart';
//
// import '../../domain/models/send_data_data_model.dart';
// import '../response/send_data_data_response.dart';
//
// extension SendDataDataMapper on SendDataDataResponse {
//   SendDataDataModel toDomain() {
//     return SendDataDataModel(
//       q: q.onNull(),
//       s: s.onNull(),
//       d: d!.toDomain(),
//       aiResponse: aiResponse!.toDomain(),
//     );
//   }
// }
