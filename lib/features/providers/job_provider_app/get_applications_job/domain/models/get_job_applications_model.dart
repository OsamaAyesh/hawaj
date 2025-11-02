class GetJobApplicationsModel {
  final bool error;
  final String? message;
  final GetJobApplicationsDataModel? data;

  GetJobApplicationsModel({
    required this.error,
    this.message,
    this.data,
  });
}

class GetJobApplicationsDataModel {
  final JobModel? job;
  final List<ApplicationModel>? applications;

  GetJobApplicationsDataModel({
    this.job,
    this.applications,
  });
}

class JobModel {
  final String id;
  final String jobTitle;
  final String jobType;
  final String jobTypeLabel;
  final String jobShortDescription;
  final String experienceYears;
  final String salary;
  final String applicationDeadline;
  final String workLocation;
  final String workLocationLabel;
  final String viewsCount;
  final String status;
  final String statusLabel;
  final String companyId;
  final String companyLabel;
  final String createdAt;
  final String updatedAt;

  JobModel({
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
    required this.companyLabel,
    required this.createdAt,
    required this.updatedAt,
  });
}

class ApplicationModel {
  final String id;
  final String resumeId;
  final String jobId;
  final String applicationDate;
  final String status;
  final String statusLabel;
  final JobModel? job;
  final ResumeModel? resume;

  ApplicationModel({
    required this.id,
    required this.resumeId,
    required this.jobId,
    required this.applicationDate,
    required this.status,
    required this.statusLabel,
    this.job,
    this.resume,
  });
}

class ResumeModel {
  final String id;
  final String jobTitlesSeeking;
  final String memberId;
  final String memberLabel;
  final String email;
  final String mobileNumber;
  final String locationLat;
  final String locationLng;
  final String detailedAddress;
  final String personalPhoto;
  final String skills;
  final String skillsLabel;
  final String languages;
  final String languagesLabel;
  final String languageLevel;
  final String languageLevelLabel;
  final String? cvFile;

  ResumeModel({
    required this.id,
    required this.jobTitlesSeeking,
    required this.memberId,
    required this.memberLabel,
    required this.email,
    required this.mobileNumber,
    required this.locationLat,
    required this.locationLng,
    required this.detailedAddress,
    required this.personalPhoto,
    required this.skills,
    required this.skillsLabel,
    required this.languages,
    required this.languagesLabel,
    required this.languageLevel,
    required this.languageLevelLabel,
    this.cvFile,
  });
}
