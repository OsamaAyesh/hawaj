import 'package:json_annotation/json_annotation.dart';

import '../../../../../../constants/response_constants/response_constants.dart';

part 'get_job_applications_response.g.dart';

@JsonSerializable()
class GetJobApplicationsResponse {
  @JsonKey(name: ResponseConstants.error)
  bool? error;

  @JsonKey(name: ResponseConstants.message)
  String? message;

  @JsonKey(name: ResponseConstants.data)
  GetJobApplicationsDataResponse? data;

  GetJobApplicationsResponse({
    this.error,
    this.message,
    this.data,
  });

  factory GetJobApplicationsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetJobApplicationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetJobApplicationsResponseToJson(this);
}

@JsonSerializable()
class GetJobApplicationsDataResponse {
  @JsonKey(name: "job")
  JobResponse? job;

  @JsonKey(name: "applications")
  List<ApplicationResponse>? applications;

  GetJobApplicationsDataResponse({
    this.job,
    this.applications,
  });

  factory GetJobApplicationsDataResponse.fromJson(Map<String, dynamic> json) =>
      _$GetJobApplicationsDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetJobApplicationsDataResponseToJson(this);
}

@JsonSerializable()
class JobResponse {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "job_title")
  String? jobTitle;

  @JsonKey(name: "job_type")
  String? jobType;

  @JsonKey(name: "job_type_lable")
  String? jobTypeLabel;

  @JsonKey(name: "job_short_description")
  String? jobShortDescription;

  @JsonKey(name: "experience_years")
  String? experienceYears;

  @JsonKey(name: "salary")
  String? salary;

  @JsonKey(name: "application_deadline")
  String? applicationDeadline;

  @JsonKey(name: "work_location")
  String? workLocation;

  @JsonKey(name: "work_location_lable")
  String? workLocationLabel;

  @JsonKey(name: "views_count")
  String? viewsCount;

  @JsonKey(name: "status")
  String? status;

  @JsonKey(name: "status_lable")
  String? statusLabel;

  @JsonKey(name: "company_id")
  String? companyId;

  @JsonKey(name: "company_id_lable")
  String? companyLabel;

  @JsonKey(name: "created_at")
  String? createdAt;

  @JsonKey(name: "updated_at")
  String? updatedAt;

  JobResponse({
    this.id,
    this.jobTitle,
    this.jobType,
    this.jobTypeLabel,
    this.jobShortDescription,
    this.experienceYears,
    this.salary,
    this.applicationDeadline,
    this.workLocation,
    this.workLocationLabel,
    this.viewsCount,
    this.status,
    this.statusLabel,
    this.companyId,
    this.companyLabel,
    this.createdAt,
    this.updatedAt,
  });

  factory JobResponse.fromJson(Map<String, dynamic> json) =>
      _$JobResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JobResponseToJson(this);
}

@JsonSerializable()
class ApplicationResponse {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "resume_id")
  String? resumeId;

  @JsonKey(name: "job_id")
  String? jobId;

  @JsonKey(name: "application_date")
  String? applicationDate;

  @JsonKey(name: "status")
  String? status;

  @JsonKey(name: "status_label")
  String? statusLabel;

  @JsonKey(name: "job")
  JobResponse? job;

  @JsonKey(name: "resume")
  ResumeResponse? resume;

  ApplicationResponse({
    this.id,
    this.resumeId,
    this.jobId,
    this.applicationDate,
    this.status,
    this.statusLabel,
    this.job,
    this.resume,
  });

  factory ApplicationResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplicationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationResponseToJson(this);
}

@JsonSerializable()
class ResumeResponse {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "job_titles_seeking")
  String? jobTitlesSeeking;

  @JsonKey(name: "member_id")
  String? memberId;

  @JsonKey(name: "member_id_lable")
  String? memberLabel;

  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "mobile_number")
  String? mobileNumber;

  @JsonKey(name: "location_lat")
  String? locationLat;

  @JsonKey(name: "location_lng")
  String? locationLng;

  @JsonKey(name: "detailed_address")
  String? detailedAddress;

  @JsonKey(name: "personal_photo")
  String? personalPhoto;

  @JsonKey(name: "skills")
  String? skills;

  @JsonKey(name: "skills_lable")
  String? skillsLabel;

  @JsonKey(name: "languages")
  String? languages;

  @JsonKey(name: "languages_lable")
  String? languagesLabel;

  @JsonKey(name: "language_level")
  String? languageLevel;

  @JsonKey(name: "language_level_lable")
  String? languageLevelLabel;

  @JsonKey(name: "cv_file")
  String? cvFile;

  ResumeResponse({
    this.id,
    this.jobTitlesSeeking,
    this.memberId,
    this.memberLabel,
    this.email,
    this.mobileNumber,
    this.locationLat,
    this.locationLng,
    this.detailedAddress,
    this.personalPhoto,
    this.skills,
    this.skillsLabel,
    this.languages,
    this.languagesLabel,
    this.languageLevel,
    this.languageLevelLabel,
    this.cvFile,
  });

  factory ResumeResponse.fromJson(Map<String, dynamic> json) =>
      _$ResumeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResumeResponseToJson(this);
}
