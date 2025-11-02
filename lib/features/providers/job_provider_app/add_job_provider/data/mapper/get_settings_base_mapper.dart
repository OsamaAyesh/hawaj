import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/mapper/job_settings_mapper.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/data/response/get_settings_base_response.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/domain/models/get_settings_base_model.dart';

extension GetSettingsBaseMapper on GetSettingsBaseResponse {
  GetSettingsBaseModel toDomain() {
    return GetSettingsBaseModel(
        error: error.onNull(),
        message: message.onNull(),
        data: data!.toDomain());
  }
}
