import 'dart:io';

import 'package:dio/dio.dart';

class UpdateAvatarRequest {
  final File avatar;

  UpdateAvatarRequest({
    required this.avatar,
  });

  Future<FormData> prepareFormData() async {
    final formData = FormData();

    // ===== File Field =====
    formData.files.add(
      MapEntry(
        'avatar',
        await MultipartFile.fromFile(
          avatar.path,
          filename: avatar.path.split('/').last,
        ),
      ),
    );

    return formData;
  }
}
