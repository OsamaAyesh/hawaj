import 'organization_types_data_model.dart';

class GetOrganizationTypesModel {
  bool error;
  OrganizationTypesDataModel data;
  String message;

  GetOrganizationTypesModel({
    required this.error,
    required this.data,
    required this.message,
  });
}
