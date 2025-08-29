import 'package:app_mobile/features/common/profile/domain/model/get_profile_data_model.dart';

class GetProfileModel {
  bool error;
  String message;
  GetProfileDataModel data;

  GetProfileModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
