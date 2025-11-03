import 'dart:io';

import 'package:dio/dio.dart';

/// Request Model: Add Resume
class AddCvRequest {
  final String jobTitlesSeeking;
  final String email;
  final String mobileNumber;
  final String locationLat;
  final String locationLng;
  final String detailedAddress;
  final String skills;

  /// Optional Lists
  final List<String>? languages;
  final List<String>? education;

  /// File
  final File? personalPhoto;

  AddCvRequest({
    required this.jobTitlesSeeking,
    required this.email,
    required this.mobileNumber,
    required this.locationLat,
    required this.locationLng,
    required this.detailedAddress,
    required this.skills,
    this.languages,
    this.education,
    this.personalPhoto,
  });

  /// Convert all fields to FormData for sending as multipart/form-data
  Future<FormData> toFormData() async {
    final formData = FormData();

    // ===== Required Text Fields =====
    formData.fields.addAll([
      MapEntry('job_titles_seeking', jobTitlesSeeking),
      MapEntry('email', email),
      MapEntry('mobile_number', mobileNumber),
      MapEntry('location_lat', locationLat),
      MapEntry('location_lng', locationLng),
      MapEntry('detailed_address', detailedAddress),
      MapEntry('skills', skills),
    ]);

    // ===== Optional Lists =====
    if (languages != null && languages!.isNotEmpty) {
      for (int i = 0; i < languages!.length; i++) {
        formData.fields.add(MapEntry('languages[$i]', languages![i]));
      }
    }

    if (education != null && education!.isNotEmpty) {
      for (int i = 0; i < education!.length; i++) {
        formData.fields.add(MapEntry('education[$i]', education![i]));
      }
    }

    // ===== File Upload =====
    if (personalPhoto != null) {
      formData.files.add(
        MapEntry(
          'personal_photo',
          await MultipartFile.fromFile(
            personalPhoto!.path,
            filename: personalPhoto!.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }
}
