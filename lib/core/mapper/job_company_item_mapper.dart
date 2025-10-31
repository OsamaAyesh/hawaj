import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/model/job_company_item_model.dart';
import 'package:app_mobile/core/response/job_company_item_response.dart';

extension JobCompanyItemMapper on JobCompanyItemResponse {
  JobCompanyItemModel toDomain() {
    return JobCompanyItemModel(
      id: id.onNull(),
      companyName: companyName.onNull(),
      industry: industry.onNull(),
      mobileNumber: mobileNumber.onNull(),
      locationLat: locationLat.onNull(),
      locationLng: locationLng.onNull(),
      detailedAddress: detailedAddress.onNull(),
      companyDescription: companyDescription.onNull(),
      companyShortDescription: companyShortDescription.onNull(),
      companyLogo: companyLogo.onNull(),
      contactPersonName: contactPersonName.onNull(),
      contactPersonEmail: contactPersonEmail.onNull(),
      commercialRegister: commercialRegister.onNull(),
      activityLicense: activityLicense.onNull(),
      memberId: memberId.onNull(),
      memberIdLable: memberIdLable.onNull(),
    );
  }
}
