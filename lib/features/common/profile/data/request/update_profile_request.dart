// lib/features/.../data/request/update_profile_request.dart
import 'dart:io';

import 'package:dio/dio.dart';

class UpdateProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? dob; // بصيغة yyyy-MM-dd مثلاً
  final File? avatar;

  UpdateProfileRequest({
    this.firstName,
    this.lastName,
    this.gender,
    this.dob,
    this.avatar,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();

    // ===== Text Fields =====
    if (firstName != null && firstName!.isNotEmpty) {
      formData.fields.add(MapEntry('first_name', firstName!));
    }

    if (lastName != null && lastName!.isNotEmpty) {
      formData.fields.add(MapEntry('last_name', lastName!));
    }

    if (gender != null && gender!.isNotEmpty) {
      formData.fields.add(MapEntry('gender', gender!));
    }

    if (dob != null && dob!.isNotEmpty) {
      formData.fields.add(MapEntry('dob', dob!));
    }

    // ===== File Field (avatar) =====
    if (avatar != null) {
      formData.files.add(
        MapEntry(
          'avatar',
          await MultipartFile.fromFile(
            avatar!.path,
            filename: avatar!.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }
}
