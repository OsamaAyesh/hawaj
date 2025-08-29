import 'dart:io';
import 'package:dio/dio.dart';
import 'package:app_mobile/core/extensions/extensions.dart';

class UpdateAvatarRequest {

  final File? avatar;

  UpdateAvatarRequest({
    this.avatar,
  });

  Future<FormData> prepareFormData() async {
    final formData = FormData();

    if (avatar != null) {
      formData.files.add(MapEntry(
        "avatar",
        await MultipartFile.fromFile(
          avatar!.path,
          filename: avatar!.path.split('/').last,
        ),
      ));
    }

    return formData;
  }
}
