import 'package:app_mobile/core/extensions/extensions.dart';

import '../../domain/models/get_job_applications_model.dart';
import '../response/get_job_applications_response.dart';

extension GetJobApplicationsMapper on GetJobApplicationsResponse {
  GetJobApplicationsModel toDomain() {
    return GetJobApplicationsModel(
      error: error.onNull(),
      message: message.onNull(),
      data: data != null
          ? GetJobApplicationsDataModel(
              job: data!.job?.toDomain(),
              applications:
                  data!.applications?.map((e) => e.toDomain()).toList() ?? [],
            )
          : null,
    );
  }
}

extension JobMapper on JobResponse {
  JobModel toDomain() {
    return JobModel(
      id: id.onNull(),
      jobTitle: jobTitle.onNull(),
      jobType: jobType.onNull(),
      jobTypeLabel: jobTypeLabel.onNull(),
      jobShortDescription: jobShortDescription.onNull(),
      experienceYears: experienceYears.onNull(),
      salary: salary.onNull(),
      applicationDeadline: applicationDeadline.onNull(),
      workLocation: workLocation.onNull(),
      workLocationLabel: workLocationLabel.onNull(),
      viewsCount: viewsCount.onNull(),
      status: status.onNull(),
      statusLabel: statusLabel.onNull(),
      companyId: companyId.onNull(),
      companyLabel: companyLabel.onNull(),
      createdAt: createdAt.onNull(),
      updatedAt: updatedAt.onNull(),
    );
  }
}

extension ApplicationMapper on ApplicationResponse {
  ApplicationModel toDomain() {
    return ApplicationModel(
      id: id.onNull(),
      resumeId: resumeId.onNull(),
      jobId: jobId.onNull(),
      applicationDate: applicationDate.onNull(),
      status: status.onNull(),
      statusLabel: statusLabel.onNull(),
      job: job?.toDomain(),
      resume: resume?.toDomain(),
    );
  }
}

extension ResumeMapper on ResumeResponse {
  ResumeModel toDomain() {
    return ResumeModel(
      id: id.onNull(),
      jobTitlesSeeking: jobTitlesSeeking.onNull(),
      memberId: memberId.onNull(),
      memberLabel: memberLabel.onNull(),
      email: email.onNull(),
      mobileNumber: mobileNumber.onNull(),
      locationLat: locationLat.onNull(),
      locationLng: locationLng.onNull(),
      detailedAddress: detailedAddress.onNull(),
      personalPhoto: personalPhoto.onNull(),
      skills: skills.onNull(),
      skillsLabel: skillsLabel.onNull(),
      languages: languages.onNull(),
      languagesLabel: languagesLabel.onNull(),
      languageLevel: languageLevel.onNull(),
      languageLevelLabel: languageLevelLabel.onNull(),
      cvFile: cvFile,
    );
  }
}
