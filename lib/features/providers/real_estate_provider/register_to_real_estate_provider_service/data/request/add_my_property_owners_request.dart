// data/request/add_my_property_owners_request.dart
import 'dart:io';

import 'package:dio/dio.dart';

class AddMyPropertyOwnersRequest {
  final String ownerName;
  final String mobileNumber;
  final String whatsappNumber;
  final String locationLat;
  final String locationLng;
  final String detailedAddress;
  final String accountType;
  final String companyName;
  final String companyBrief;
  final File? commercialRegister;
  final File? companyLogo;
  final File? commercialRegistration;

  AddMyPropertyOwnersRequest({
    required this.ownerName,
    required this.mobileNumber,
    required this.whatsappNumber,
    required this.locationLat,
    required this.locationLng,
    required this.detailedAddress,
    required this.accountType,
    required this.companyName,
    required this.companyBrief,
    this.commercialRegister,
    this.companyLogo,
    this.commercialRegistration,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();

    // ==== Text Fields ====
    formData.fields.add(MapEntry('owner_name', ownerName));
    formData.fields.add(MapEntry('mobile_number', mobileNumber));
    formData.fields.add(MapEntry('whatsapp_number', whatsappNumber));
    formData.fields.add(MapEntry('location_lat', locationLat));
    formData.fields.add(MapEntry('location_lng', locationLng));
    formData.fields.add(MapEntry('detailed_address', detailedAddress));
    formData.fields.add(MapEntry('account_type', accountType));
    formData.fields.add(MapEntry('company_name', companyName));
    formData.fields.add(MapEntry('company_brief', companyBrief));

    // ==== File Fields ====
    if (commercialRegister != null) {
      formData.files.add(MapEntry(
        'commercial_register',
        await MultipartFile.fromFile(
          commercialRegister!.path,
          filename: commercialRegister!.path.split('/').last,
        ),
      ));
    }

    if (companyLogo != null) {
      formData.files.add(MapEntry(
        'company_logo',
        await MultipartFile.fromFile(
          companyLogo!.path,
          filename: companyLogo!.path.split('/').last,
        ),
      ));
    }

    if (commercialRegistration != null) {
      formData.files.add(MapEntry(
        'commercial_registration',
        await MultipartFile.fromFile(
          commercialRegistration!.path,
          filename: commercialRegistration!.path.split('/').last,
        ),
      ));
    }

    return formData;
  }
}
