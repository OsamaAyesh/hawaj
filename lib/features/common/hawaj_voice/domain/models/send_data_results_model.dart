import 'package:app_mobile/features/common/hawaj_voice/domain/models/property_item_hawaj_details_model.dart';

import 'job_item_hawaj_details_model.dart';
import 'organization_item_hawaj_details_model.dart';

class SendDataResultsModel {
  final List<OrganizationItemHawajDetailsModel>? offers;
  final List<PropertyItemHawajDetailsModel>? properties;
  final List<JobItemHawajDetailsModel>? jobs;

  SendDataResultsModel({
    this.offers,
    this.properties,
    this.jobs,
  });
}
