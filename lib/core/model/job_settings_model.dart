class JobSettingsModel {
  List<JobTypeModel> jobTypes;
  List<WorkLocationModel> workLocations;
  List<JobStatusModel> jobStatuses;
  List<ApplicationStatusModel> applicationStatuses;
  List<LanguageLevelModel> languageLevels;
  List<EducationDegreeModel> educationDegrees;
  List<SkillModel> skills;
  List<QualificationModel> qualifications;
  List<LanguageModel> languages;

  JobSettingsModel({
    required this.jobTypes,
    required this.workLocations,
    required this.jobStatuses,
    required this.applicationStatuses,
    required this.languageLevels,
    required this.educationDegrees,
    required this.skills,
    required this.qualifications,
    required this.languages,
  });
}

// ---------------- Sub Models ----------------

class JobTypeModel {
  String value;
  String label;

  JobTypeModel({
    required this.value,
    required this.label,
  });
}

class WorkLocationModel {
  String value;
  String label;

  WorkLocationModel({
    required this.value,
    required this.label,
  });
}

class JobStatusModel {
  String value;
  String label;

  JobStatusModel({
    required this.value,
    required this.label,
  });
}

class ApplicationStatusModel {
  String value;
  String label;

  ApplicationStatusModel({
    required this.value,
    required this.label,
  });
}

class LanguageLevelModel {
  String value;
  String label;

  LanguageLevelModel({
    required this.value,
    required this.label,
  });
}

class EducationDegreeModel {
  String value;
  String label;
  String type;

  EducationDegreeModel({
    required this.value,
    required this.label,
    required this.type,
  });
}

class SkillModel {
  int id;
  String name;
  String description;

  SkillModel({
    required this.id,
    required this.name,
    required this.description,
  });
}

class QualificationModel {
  int id;
  String name;
  String description;

  QualificationModel({
    required this.id,
    required this.name,
    required this.description,
  });
}

class LanguageModel {
  int id;
  String name;

  LanguageModel({
    required this.id,
    required this.name,
  });
}
