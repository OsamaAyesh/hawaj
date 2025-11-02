import 'package:app_mobile/core/model/job_item_model.dart';
import 'package:app_mobile/core/response/job_item_response.dart';

extension JobItemMapper on JobItemResponse {
  JobItemModel toDomain() => JobItemModel(
        id: id ?? '',
        jobTitle: jobTitle ?? '',
        jobType: jobType ?? '',
        jobTypeLabel: jobTypeLabel ?? '',
        jobShortDescription: jobShortDescription ?? '',
        experienceYears: experienceYears ?? '',
        salary: salary ?? '',
        applicationDeadline: applicationDeadline ?? '',
        workLocation: workLocation ?? '',
        workLocationLabel: workLocationLabel ?? '',
        viewsCount: viewsCount ?? '',
        status: status ?? '',
        statusLabel: statusLabel ?? '',
        companyId: companyId ?? '',
        companyLabel: companyLabel ?? '',
        company: company?.toDomain(),
        createdAt: createdAt ?? '',
        updatedAt: updatedAt ?? '',
      );
}

extension AddJobCompanyMapper on JobItemSubResponse {
  JobItemSubModel toDomain() => JobItemSubModel(
        id: id ?? '',
        companyName: companyName ?? '',
        industry: industry ?? '',
        mobileNumber: mobileNumber ?? '',
        detailedAddress: detailedAddress ?? '',
        companyDescription: companyDescription ?? '',
        companyShortDescription: companyShortDescription ?? '',
        companyLogo: companyLogo ?? '',
        contactPersonName: contactPersonName ?? '',
        contactPersonEmail: contactPersonEmail ?? '',
        memberId: memberId ?? '',
        memberLabel: memberLabel ?? '',
      );
}
