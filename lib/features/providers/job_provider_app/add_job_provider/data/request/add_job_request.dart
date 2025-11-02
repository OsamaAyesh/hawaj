import 'package:dio/dio.dart';

/// ✅ Add Job Request (Final Reviewed)
/// نفس أسلوبك تمامًا لكن بتحسينات طفيفة داخلية من حيث الموثوقية والوضوح
class AddJobRequest {
  /// 🏷️ الحقول الأساسية
  final String jobTitle;
  final String jobType;
  final String jobShortDescription;
  final String experienceYears;
  final String salary;
  final String applicationDeadline;
  final String workLocation;
  final String companyId;

  /// 📋 الحقول الاختيارية (قوائم متعددة)
  final List<String>? languages;
  final List<String>? skills;
  final List<String>? qualifications;

  /// ⚙️ حالة الوظيفة (1=نشطة، 2=غير نشطة)
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

  /// 🧩 تحويل إلى FormData (multipart/form-data)
  Future<FormData> toFormData() async {
    final formData = FormData();

    // ===== Text Fields =====
    void addIfNotEmpty(String key, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        formData.fields.add(MapEntry(key, value.trim()));
      }
    }

    addIfNotEmpty('job_title', jobTitle);
    addIfNotEmpty('job_type', jobType);
    addIfNotEmpty('job_short_description', jobShortDescription);
    addIfNotEmpty('experience_years', experienceYears); // ✅ إصلاح هنا
    addIfNotEmpty('salary', salary);
    addIfNotEmpty('application_deadline', applicationDeadline);
    addIfNotEmpty('work_location', workLocation);
    addIfNotEmpty('company_id', companyId);

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
    if (status != null && status!.isNotEmpty) {
      formData.fields.add(MapEntry('status', status!));
    }

    return formData;
  }

  /// 🔍 لتسهيل الـ Debugging
  @override
  String toString() {
    return '''
AddJobRequest(
  jobTitle: $jobTitle,
  jobType: $jobType,
  jobShortDescription: $jobShortDescription,
  experienceYears: $experienceYears,
  salary: $salary,
  applicationDeadline: $applicationDeadline,
  workLocation: $workLocation,
  companyId: $companyId,
  languages: $languages,
  skills: $skills,
  qualifications: $qualifications,
  status: $status
)
''';
  }
}
