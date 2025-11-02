import 'dart:io';

import 'package:dio/dio.dart';

/// Request Model: Edit Company Jobs
class EditCompanyJobsProviderRequest {
  /// Unique Company ID (required for editing)
  final String? id;

  /// Basic Info (all nullable)
  final String? companyName;
  final String? industry;
  final String? mobileNumber;
  final String? locationLat;
  final String? locationLng;
  final String? detailedAddress;
  final String? companyDescription;
  final String? contactPersonName;
  final String? contactPersonEmail;

  /// Files (Optional)
  final File? companyLogo;
  final File? commercialRegister;
  final File? activityLicense;

  EditCompanyJobsProviderRequest({
    this.id,
    this.companyName,
    this.industry,
    this.mobileNumber,
    this.locationLat,
    this.locationLng,
    this.detailedAddress,
    this.companyDescription,
    this.contactPersonName,
    this.contactPersonEmail,
    this.companyLogo,
    this.commercialRegister,
    this.activityLicense,
  });

  /// Convert non-null fields only to FormData (smart mapping)
  Future<FormData> toFormData() async {
    final formData = FormData();

    // ===== Text Fields =====
    final Map<String, String?> fields = {
      'id': id,
      'company_name': companyName,
      'industry': industry,
      'mobile_number': mobileNumber,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'detailed_address': detailedAddress,
      'company_description': companyDescription,
      'contact_person_name': contactPersonName,
      'contact_person_email': contactPersonEmail,
    };

    // إضافة فقط الحقول غير الفارغة
    fields.forEach((key, value) {
      if (value != null && value.isNotEmpty) {
        formData.fields.add(MapEntry(key, value));
      }
    });

    // ===== Files (Optional) =====
    Future<void> addFileIfNotNull(String key, File? file) async {
      if (file != null) {
        formData.files.add(
          MapEntry(
            key,
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }
    }

    await addFileIfNotNull('company_logo', companyLogo);
    await addFileIfNotNull('commercial_register', commercialRegister);
    await addFileIfNotNull('activity_license', activityLicense);

    return formData;
  }
}
