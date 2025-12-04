import 'package:app_mobile/core/extensions/extensions.dart';

import '../../domain/models/send_data_results_model.dart';
import '../response/send_data_results_response.dart';
import 'job_item_hawaj_details_mapper.dart';
import 'organization_item_hawaj_details_mapper.dart';
import 'property_item_hawaj_details_mapper.dart';

extension SendDataResultsMapper on SendDataResultsResponse {
  SendDataResultsModel toDomain() {
    return SendDataResultsModel(
      screen: screen.onNull(),
      lat: lat.onNull(),
      lng: lng.onNull(),
      // parameters: parameters ?? [],
      message: message.onNull(),
      mp3: mp3.onNull(),
      offers: offers?.map((e) => e.toDomain()).toList(),
      properties: properties?.map((e) => e.toDomain()).toList(),
      jobs: jobs?.map((e) => e.toDomain()).toList(),
    );
  }
}
// import '../../domain/models/send_data_results_model.dart';
// import '../response/send_data_results_response.dart';
// import 'job_item_hawaj_details_mapper.dart';
// import 'organization_item_hawaj_details_mapper.dart';
// import 'property_item_hawaj_details_mapper.dart';
//
// extension SendDataResultsMapper on SendDataResultsResponse {
//   SendDataResultsModel toDomain() {
//     return SendDataResultsModel(
//       offers: offers?.map((e) => e.toDomain()).toList(),
//       properties: properties?.map((e) => e.toDomain()).toList(),
//       jobs: jobs?.map((e) => e.toDomain()).toList(),
//     );
//   }
// }
