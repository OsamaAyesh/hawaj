import 'package:app_mobile/core/extensions/extensions.dart';

import '../../domain/models/job_item_hawaj_details_model.dart';
import '../response/job_item_hawaj_details_response.dart';

extension JobItemHawajDetailsMapper on JobItemHawajDetailsResponse {
  JobItemHawajDetailsModel toDomain() {
    return JobItemHawajDetailsModel(
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
      companyName: companyName.onNull(),
      createdAt: createdAt.onNull(),
      updatedAt: updatedAt.onNull(),
    );
  }
}
