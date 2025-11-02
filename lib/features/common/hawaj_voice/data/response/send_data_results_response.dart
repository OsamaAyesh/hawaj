import 'package:app_mobile/features/common/hawaj_voice/data/response/job_item_hawaj_details_response.dart';
import 'package:app_mobile/features/common/hawaj_voice/data/response/organization_item_hawaj_details_response.dart';
import 'package:app_mobile/features/common/hawaj_voice/data/response/property_item_hawaj_details_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_data_results_response.g.dart';

@JsonSerializable()
class SendDataResultsResponse {
  @JsonKey(name: "offers")
  List<OrganizationItemHawajDetailsResponse>? offers;

  @JsonKey(name: "properties")
  List<PropertyItemHawajDetailsResponse>? properties;

  @JsonKey(name: "jobs")
  List<JobItemHawajDetailsResponse>? jobs;

  SendDataResultsResponse({
    this.offers,
    this.properties,
    this.jobs,
  });

  factory SendDataResultsResponse.fromJson(Map<String, dynamic> json) =>
      _$SendDataResultsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendDataResultsResponseToJson(this);
}
