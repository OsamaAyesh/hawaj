import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/model/job_settings_model.dart';
import 'package:app_mobile/core/response/job_settings_response.dart';

extension JobSettingsMapper on JobSettingsResponse {
  JobSettingsModel toDomain() {
    return JobSettingsModel(
      jobTypes: jobTypes?.map((e) => e.toDomain()).toList() ?? [],
      workLocations: workLocations?.map((e) => e.toDomain()).toList() ?? [],
      jobStatuses: jobStatuses?.map((e) => e.toDomain()).toList() ?? [],
      applicationStatuses:
          applicationStatuses?.map((e) => e.toDomain()).toList() ?? [],
      languageLevels: languageLevels?.map((e) => e.toDomain()).toList() ?? [],
      educationDegrees:
          educationDegrees?.map((e) => e.toDomain()).toList() ?? [],
      skills: skills?.map((e) => e.toDomain()).toList() ?? [],
      qualifications: qualifications?.map((e) => e.toDomain()).toList() ?? [],
      languages: languages?.map((e) => e.toDomain()).toList() ?? [],
    );
  }
}

// --------------- Individual Mappers -----------------

extension JobTypeMapper on JobTypeResponse {
  JobTypeModel toDomain() {
    return JobTypeModel(
      value: value.onNull(),
      label: label.onNull(),
    );
  }
}

extension WorkLocationMapper on WorkLocationResponse {
  WorkLocationModel toDomain() {
    return WorkLocationModel(
      value: value.onNull(),
      label: label.onNull(),
    );
  }
}

extension JobStatusMapper on JobStatusResponse {
  JobStatusModel toDomain() {
    return JobStatusModel(
      value: value.onNull(),
      label: label.onNull(),
    );
  }
}

extension ApplicationStatusMapper on ApplicationStatusResponse {
  ApplicationStatusModel toDomain() {
    return ApplicationStatusModel(
      value: value.onNull(),
      label: label.onNull(),
    );
  }
}

extension LanguageLevelMapper on LanguageLevelResponse {
  LanguageLevelModel toDomain() {
    return LanguageLevelModel(
      value: value.onNull(),
      label: label.onNull(),
    );
  }
}

extension EducationDegreeMapper on EducationDegreeResponse {
  EducationDegreeModel toDomain() {
    return EducationDegreeModel(
      value: value.onNull(),
      label: label.onNull(),
      type: type.onNull(),
    );
  }
}

extension SkillMapper on SkillResponse {
  SkillModel toDomain() {
    return SkillModel(
      id: id ?? 0,
      name: name.onNull(),
      description: description.onNull(),
    );
  }
}

extension QualificationMapper on QualificationResponse {
  QualificationModel toDomain() {
    return QualificationModel(
      id: id ?? 0,
      name: name.onNull(),
      description: description.onNull(),
    );
  }
}

extension LanguageMapper on LanguageResponse {
  LanguageModel toDomain() {
    return LanguageModel(
      id: id ?? 0,
      name: name.onNull(),
    );
  }
}
