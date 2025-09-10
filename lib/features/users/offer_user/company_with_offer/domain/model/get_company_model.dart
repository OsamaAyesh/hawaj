import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/model/get_company_data_model.dart';

class GetCompanyModel {
  bool error;
  String message;
  GetCompanyDataModel data;

  GetCompanyModel({
    required this.error,
    required this.message,
    required this.data,
  });
}
