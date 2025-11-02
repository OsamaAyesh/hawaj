class JobItemModel {
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
  final JobItemSubModel? company;
  final String createdAt;
  final String updatedAt;

  JobItemModel({
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
    required this.company,
    required this.createdAt,
    required this.updatedAt,
  });
}

class JobItemSubModel {
  final String id;
  final String companyName;
  final String industry;
  final String mobileNumber;
  final String detailedAddress;
  final String companyDescription;
  final String companyShortDescription;
  final String companyLogo;
  final String contactPersonName;
  final String contactPersonEmail;
  final String memberId;
  final String memberLabel;

  JobItemSubModel({
    required this.id,
    required this.companyName,
    required this.industry,
    required this.mobileNumber,
    required this.detailedAddress,
    required this.companyDescription,
    required this.companyShortDescription,
    required this.companyLogo,
    required this.contactPersonName,
    required this.contactPersonEmail,
    required this.memberId,
    required this.memberLabel,
  });
}
