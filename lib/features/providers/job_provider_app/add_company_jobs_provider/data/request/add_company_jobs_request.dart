import 'dart:io';

import 'package:dio/dio.dart';

/// Request Model: Add Company Jobs
class AddCompanyJobsRequest {
  final String companyName;
  final String industry;
  final String mobileNumber;
  final String locationLat;
  final String locationLng;
  final String detailedAddress;
  final String companyDescription;
  final String contactPersonName;
  final String contactPersonEmail;

  /// Files
  final File? companyLogo;
  final File? commercialRegister;
  final File? activityLicense;

  AddCompanyJobsRequest({
    required this.companyName,
    required this.industry,
    required this.mobileNumber,
    required this.locationLat,
    required this.locationLng,
    required this.detailedAddress,
    required this.companyDescription,
    required this.contactPersonName,
    required this.contactPersonEmail,
    this.companyLogo,
    this.commercialRegister,
    this.activityLicense,
  });

  /// Convert all fields to FormData for sending as multipart/form-data
  Future<FormData> toFormData() async {
    final formData = FormData();

    // ===== Text Fields =====
    formData.fields.addAll([
      MapEntry('company_name', companyName),
      MapEntry('industry', industry),
      MapEntry('mobile_number', mobileNumber),
      MapEntry('location_lat', locationLat),
      MapEntry('location_lng', locationLng),
      MapEntry('detailed_address', detailedAddress),
      MapEntry('company_description', companyDescription),
      MapEntry('contact_person_name', contactPersonName),
      MapEntry('contact_person_email', contactPersonEmail),
    ]);

    // ===== Files =====

    //  Company logo
    if (companyLogo != null) {
      formData.files.add(
        MapEntry(
          'company_logo',
          await MultipartFile.fromFile(
            companyLogo!.path,
            filename: companyLogo!.path.split('/').last,
          ),
        ),
      );
    }

    // Commercial register document
    if (commercialRegister != null) {
      formData.files.add(
        MapEntry(
          'commercial_register',
          await MultipartFile.fromFile(
            commercialRegister!.path,
            filename: commercialRegister!.path.split('/').last,
          ),
        ),
      );
    }

    //  Activity license document
    if (activityLicense != null) {
      formData.files.add(
        MapEntry(
          'activity_license',
          await MultipartFile.fromFile(
            activityLicense!.path,
            filename: activityLicense!.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }
}
