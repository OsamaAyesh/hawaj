import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/model/organization_min_model.dart';
import 'package:app_mobile/core/response/organization_min_response.dart';

extension OrganizationMinMapper on OrganizationMinResponse {
  OrganizationMinModel toDomain() {
    return OrganizationMinModel(
      id: id.onNull(),
      organization: organization.onNull(),
      organizationServices: organizationServices.onNull(),
      lat: lat.onNull(),
      lng: lng.onNull(),
      address: address.onNull(),
      managerName: managerName.onNull(),
      phoneNumber: phoneNumber.onNull(),
      workingHours: workingHours.onNull(),
      organizationLogo: organizationLogo.onNull(),
      organizationBanner: organizationBanner.onNull(),
    );
  }
}
