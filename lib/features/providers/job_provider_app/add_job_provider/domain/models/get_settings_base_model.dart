import '../../../../../../core/model/job_settings_model.dart';

class GetSettingsBaseModel {
  bool error;

  String message;

  JobSettingsModel data;

  GetSettingsBaseModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
