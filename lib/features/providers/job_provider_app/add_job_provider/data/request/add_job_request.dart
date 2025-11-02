import 'package:dio/dio.dart';

/// Request Model: Add Job
class AddJobRequest {
  final String jobTitle;
  final String jobType;
  final String jobShortDescription;
  final String experienceYears;
  final String salary;
  final String applicationDeadline;
  final String workLocation;
  final String companyId;

  /// Optional lists
  final List<String>? languages;
  final List<String>? skills;
  final List<String>? qualifications;

  /// Job status (1=Active, 2=Inactive)
  final String? status;

  AddJobRequest({
    required this.jobTitle,
    required this.jobType,
    required this.jobShortDescription,
    required this.experienceYears,
    required this.salary,
    required this.applicationDeadline,
    required this.workLocation,
    required this.companyId,
    this.languages,
    this.skills,
    this.qualifications,
    this.status,
  });

  /// Convert all fields to FormData for sending as multipart/form-data
  Future<FormData> toFormData() async {
    final formData = FormData();

    // ===== Text Fields =====
    formData.fields.addAll([
      MapEntry('job_title', jobTitle),
      MapEntry('job_type', jobType),
      MapEntry('job_short_description', jobShortDescription),
      MapEntry('experience_years', experienceYears),
      MapEntry('salary', salary),
      MapEntry('application_deadline', applicationDeadline),
      MapEntry('work_location', workLocation),
      MapEntry('company_id', companyId),
    ]);

    // ===== Optional Lists =====

    if (languages != null && languages!.isNotEmpty) {
      for (int i = 0; i < languages!.length; i++) {
        formData.fields.add(MapEntry('languages[$i]', languages![i]));
      }
    }

    if (skills != null && skills!.isNotEmpty) {
      for (int i = 0; i < skills!.length; i++) {
        formData.fields.add(MapEntry('skills[$i]', skills![i]));
      }
    }

    if (qualifications != null && qualifications!.isNotEmpty) {
      for (int i = 0; i < qualifications!.length; i++) {
        formData.fields.add(MapEntry('qualifications[$i]', qualifications![i]));
      }
    }

    // ===== Optional Status =====
    if (status != null) {
      formData.fields.add(MapEntry('status', status!));
    }

    return formData;
  }
}
