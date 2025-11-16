import 'dart:io';

import 'package:dio/dio.dart';

class RegisterOrganizationOfferProviderRequest {
  final String? organizationName;
  final String? organizationServices;
  final String? organizationType;
  final String? organizationLocation; // lat,long
  final String? organizationDetailedAddress;
  final String? managerName;
  final String? phoneNumber;
  final String? workingHours;
  final File? organizationLogo;
  final File? organizationBanner;
  final String? commercialRegistrationNumber;
  final File? commercialRegistrationFile; // pdf file
  final String? organizationStatus;

  RegisterOrganizationOfferProviderRequest({
    this.organizationName,
    this.organizationServices,
    this.organizationType,
    this.organizationLocation,
    this.organizationDetailedAddress,
    this.managerName,
    this.phoneNumber,
    this.workingHours,
    this.organizationLogo,
    this.organizationBanner,
    this.commercialRegistrationNumber,
    this.commercialRegistrationFile,
    this.organizationStatus,
  });

  Future<FormData> prepareFormData() async {
    final formData = FormData();

    // ===== Text Fields =====
    if (organizationName?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('organization_name', organizationName!));
    }
    if (organizationServices?.isNotEmpty ?? false) {
      formData.fields
          .add(MapEntry('organization_services', organizationServices!));
    }
    if (organizationType?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('organization_type', organizationType!));
    }
    if (organizationLocation?.isNotEmpty ?? false) {
      formData.fields
          .add(MapEntry('organization_location', organizationLocation!));
    }
    if (organizationDetailedAddress?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry(
          'organization_detailed_address', organizationDetailedAddress!));
    }
    if (managerName?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('manager_name', managerName!));
    }
    if (phoneNumber?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('phone_number', phoneNumber!));
    }
    if (workingHours?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('working_hours', workingHours!));
    }
    if (commercialRegistrationNumber?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry(
          'commercial_registration_number', commercialRegistrationNumber!));
    }
    if (organizationStatus?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('organization_status', organizationStatus!));
    }

    // ===== File Fields =====
    if (organizationLogo != null) {
      formData.files.add(MapEntry(
        'organization_logo',
        await MultipartFile.fromFile(
          organizationLogo!.path,
          filename: organizationLogo!.path.split('/').last,
        ),
      ));
    }
    if (organizationBanner != null) {
      formData.files.add(MapEntry(
        'organization_banner',
        await MultipartFile.fromFile(
          organizationBanner!.path,
          filename: organizationBanner!.path.split('/').last,
        ),
      ));
    }
    if (commercialRegistrationFile != null) {
      formData.files.add(MapEntry(
        'commercial_registration',
        await MultipartFile.fromFile(
          commercialRegistrationFile!.path,
          filename: commercialRegistrationFile!.path.split('/').last,
        ),
      ));
    }

    return formData;
  }
}
