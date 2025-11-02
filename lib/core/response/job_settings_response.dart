import 'package:json_annotation/json_annotation.dart';

import '../../../../../constants/response_constants/response_constants.dart';

part 'job_settings_response.g.dart';

@JsonSerializable()
class JobSettingsResponse {
  @JsonKey(name: ResponseConstants.jobTypes)
  List<JobTypeResponse>? jobTypes;

  @JsonKey(name: ResponseConstants.workLocations)
  List<WorkLocationResponse>? workLocations;

  @JsonKey(name: ResponseConstants.jobStatuses)
  List<JobStatusResponse>? jobStatuses;

  @JsonKey(name: ResponseConstants.applicationStatuses)
  List<ApplicationStatusResponse>? applicationStatuses;

  @JsonKey(name: ResponseConstants.languageLevels)
  List<LanguageLevelResponse>? languageLevels;

  @JsonKey(name: ResponseConstants.educationDegrees)
  List<EducationDegreeResponse>? educationDegrees;

  @JsonKey(name: ResponseConstants.skills)
  List<SkillResponse>? skills;

  @JsonKey(name: ResponseConstants.qualifications)
  List<QualificationResponse>? qualifications;

  @JsonKey(name: ResponseConstants.languages)
  List<LanguageResponse>? languages;

  JobSettingsResponse({
    this.jobTypes,
    this.workLocations,
    this.jobStatuses,
    this.applicationStatuses,
    this.languageLevels,
    this.educationDegrees,
    this.skills,
    this.qualifications,
    this.languages,
  });

  factory JobSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$JobSettingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JobSettingsResponseToJson(this);
}

// ------------ Sub Models -------------

@JsonSerializable()
class JobTypeResponse {
  @JsonKey(name: ResponseConstants.value)
  String? value;

  @JsonKey(name: ResponseConstants.label)
  String? label;

  JobTypeResponse({this.value, this.label});

  factory JobTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$JobTypeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JobTypeResponseToJson(this);
}

@JsonSerializable()
class WorkLocationResponse {
  @JsonKey(name: ResponseConstants.value)
  String? value;

  @JsonKey(name: ResponseConstants.label)
  String? label;

  WorkLocationResponse({this.value, this.label});

  factory WorkLocationResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkLocationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkLocationResponseToJson(this);
}

@JsonSerializable()
class JobStatusResponse {
  @JsonKey(name: ResponseConstants.value)
  String? value;

  @JsonKey(name: ResponseConstants.label)
  String? label;

  JobStatusResponse({this.value, this.label});

  factory JobStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$JobStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JobStatusResponseToJson(this);
}

@JsonSerializable()
class ApplicationStatusResponse {
  @JsonKey(name: ResponseConstants.value)
  String? value;

  @JsonKey(name: ResponseConstants.label)
  String? label;

  ApplicationStatusResponse({this.value, this.label});

  factory ApplicationStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplicationStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationStatusResponseToJson(this);
}

@JsonSerializable()
class LanguageLevelResponse {
  @JsonKey(name: ResponseConstants.value)
  String? value;

  @JsonKey(name: ResponseConstants.label)
  String? label;

  LanguageLevelResponse({this.value, this.label});

  factory LanguageLevelResponse.fromJson(Map<String, dynamic> json) =>
      _$LanguageLevelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageLevelResponseToJson(this);
}

@JsonSerializable()
class EducationDegreeResponse {
  @JsonKey(name: ResponseConstants.value)
  String? value;

  @JsonKey(name: ResponseConstants.label)
  String? label;

  @JsonKey(name: ResponseConstants.type)
  String? type;

  EducationDegreeResponse({this.value, this.label, this.type});

  factory EducationDegreeResponse.fromJson(Map<String, dynamic> json) =>
      _$EducationDegreeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EducationDegreeResponseToJson(this);
}

@JsonSerializable()
class SkillResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;

  @JsonKey(name: ResponseConstants.name)
  String? name;

  @JsonKey(name: ResponseConstants.description)
  String? description;

  SkillResponse({this.id, this.name, this.description});

  factory SkillResponse.fromJson(Map<String, dynamic> json) =>
      _$SkillResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SkillResponseToJson(this);
}

@JsonSerializable()
class QualificationResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;

  @JsonKey(name: ResponseConstants.name)
  String? name;

  @JsonKey(name: ResponseConstants.description)
  String? description;

  QualificationResponse({this.id, this.name, this.description});

  factory QualificationResponse.fromJson(Map<String, dynamic> json) =>
      _$QualificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QualificationResponseToJson(this);
}

@JsonSerializable()
class LanguageResponse {
  @JsonKey(name: ResponseConstants.id)
  int? id;

  @JsonKey(name: ResponseConstants.name)
  String? name;

  LanguageResponse({this.id, this.name});

  factory LanguageResponse.fromJson(Map<String, dynamic> json) =>
      _$LanguageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageResponseToJson(this);
}
