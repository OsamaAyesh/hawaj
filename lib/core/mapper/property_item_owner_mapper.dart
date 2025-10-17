import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/model/property_item_owner_model.dart';
import 'package:app_mobile/core/response/property_item_owner_response.dart';

extension PropertyItemOwnerMapper on PropertyItemOwnerResponse {
  PropertyItemOwnerModel toDomain() {
    return PropertyItemOwnerModel(
      id: id.onNull(),
      ownerName: ownerName.onNull(),
      mobileNumber: mobileNumber.onNull(),
      whatsappNumber: whatsappNumber.onNull(),
      locationLat: locationLat.onNull(),
      locationLng: locationLng.onNull(),
      detailedAddress: detailedAddress.onNull(),
      accountType: accountType.onNull(),
      accountTypeLabel: accountTypeLabel.onNull(),
      ownerStatus: ownerStatus.onNull(),
      ownerStatusLabel: ownerStatusLabel.onNull(),
      memberId: memberId.onNull(),
      memberIdLabel: memberIdLabel.onNull(),
      companyName: companyName.onNull(),
      companyLogo: companyLogo.onNull(),
      companyBrief: companyBrief.onNull(),
      brokerageCertificate: brokerageCertificate.onNull(),
      commercialRegister: commercialRegister.onNull(),
    );
  }
}
