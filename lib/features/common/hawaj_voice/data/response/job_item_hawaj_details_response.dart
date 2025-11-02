import 'package:json_annotation/json_annotation.dart';

part 'job_item_hawaj_details_response.g.dart';

@JsonSerializable()
class JobItemHawajDetailsResponse {
  final String id;

  @JsonKey(name: 'job_title')
  final String jobTitle;

  @JsonKey(name: 'job_type')
  final String jobType;

  @JsonKey(name: 'job_type_lable')
  final String jobTypeLabel;

  @JsonKey(name: 'job_short_description')
  final String jobShortDescription;

  @JsonKey(name: 'experience_years')
  final String experienceYears;

  final String salary;

  @JsonKey(name: 'application_deadline')
  final String applicationDeadline;

  @JsonKey(name: 'work_location')
  final String workLocation;

  @JsonKey(name: 'work_location_lable')
  final String workLocationLabel;

  @JsonKey(name: 'views_count')
  final String viewsCount;

  final String status;

  @JsonKey(name: 'status_lable')
  final String statusLabel;

  @JsonKey(name: 'company_id')
  final String companyId;

  @JsonKey(name: 'company_id_lable')
  final String companyName;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  JobItemHawajDetailsResponse({
    required this.id,
    required this.jobTitle,
    required this.jobType,
    required this.jobTypeLabel,
    required this.jobShortDescription,
    required this.experienceYears,
    required this.salary,
    required this.applicationDeadline,
    required this.workLocation,
    required this.workLocationLabel,
    required this.viewsCount,
    required this.status,
    required this.statusLabel,
    required this.companyId,
    required this.companyName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobItemHawajDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$JobItemHawajDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JobItemHawajDetailsResponseToJson(this);
}
