import 'package:app_mobile/features/common/hawaj_voice/domain/models/property_item_hawaj_details_model.dart';

import 'job_item_hawaj_details_model.dart';
import 'organization_item_hawaj_details_model.dart';

class SendDataResultsModel {
  final String screen;
  final String lat;
  final String lng;
  final List<dynamic> parameters;
  final String message;
  final String mp3;

  final List<OrganizationItemHawajDetailsModel>? offers;
  final List<PropertyItemHawajDetailsModel>? properties;
  final List<JobItemHawajDetailsModel>? jobs;

  SendDataResultsModel({
    required this.screen,
    required this.lat,
    required this.lng,
    required this.parameters,
    required this.message,
    required this.mp3,
    this.offers,
    this.properties,
    this.jobs,
  });
}
// import 'package:app_mobile/features/common/hawaj_voice/domain/models/property_item_hawaj_details_model.dart';
//
// import 'job_item_hawaj_details_model.dart';
// import 'organization_item_hawaj_details_model.dart';
//
// class SendDataResultsModel {
//   final List<OrganizationItemHawajDetailsModel>? offers;
//   final List<PropertyItemHawajDetailsModel>? properties;
//   final List<JobItemHawajDetailsModel>? jobs;
//
//   SendDataResultsModel({
//     this.offers,
//     this.properties,
//     this.jobs,
//   });
// }
