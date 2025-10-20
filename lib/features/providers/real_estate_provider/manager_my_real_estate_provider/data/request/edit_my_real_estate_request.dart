import 'dart:io';

import 'package:dio/dio.dart';

/// Request Model: Add My Property

class EditMyRealEstateRequest {
  final String propertySubject;
  final String propertyType;
  final String operationType;
  final String advertiserRole;
  final String saleType;
  final String keywords;
  final String lat;
  final String lng;
  final String propertyDetailedAddress;
  final String price;
  final String areaSqm;
  final String commissionPercentage;
  final String usageType;
  final String propertyDescription;
  final String featureIds;
  final String facilityIds;
  final String visitDays;
  final String visitTimeFrom;
  final String visitTimeTo;
  final String propertyOwnerId;

  /// الملفات
  final List<File>? propertyImages;
  final List<File>? propertyVideos;
  final File? deedDocument;

  EditMyRealEstateRequest({
    required this.propertySubject,
    required this.propertyType,
    required this.operationType,
    required this.advertiserRole,
    required this.saleType,
    required this.keywords,
    required this.lat,
    required this.lng,
    required this.propertyDetailedAddress,
    required this.price,
    required this.areaSqm,
    required this.commissionPercentage,
    required this.usageType,
    required this.propertyDescription,
    required this.featureIds,
    required this.facilityIds,
    required this.visitDays,
    required this.visitTimeFrom,
    required this.visitTimeTo,
    required this.propertyOwnerId,
    this.propertyImages,
    this.propertyVideos,
    this.deedDocument,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();

    // ===== Text Fields =====
    formData.fields.addAll([
      MapEntry('property_subject', propertySubject),
      MapEntry('property_type', propertyType),
      MapEntry('operation_type', operationType),
      MapEntry('advertiser_role', advertiserRole),
      MapEntry('sale_type', saleType),
      MapEntry('keywords', keywords),
      MapEntry('lat', lat),
      MapEntry('lng', lng),
      MapEntry('property_detailed_address', propertyDetailedAddress),
      MapEntry('price', price),
      MapEntry('area_sqm', areaSqm),
      MapEntry('commission_percentage', commissionPercentage),
      MapEntry('usage_type', usageType),
      MapEntry('property_description', propertyDescription),
      MapEntry('feature_ids', featureIds),
      MapEntry('facility_ids', facilityIds),
      MapEntry('visit_days', visitDays),
      MapEntry('visit_time_from', visitTimeFrom),
      MapEntry('visit_time_to', visitTimeTo),
      MapEntry('propertyowner_id', propertyOwnerId),
    ]);

    // ===== Files =====

    // ✅ صور العقار
    if (propertyImages != null && propertyImages!.isNotEmpty) {
      for (var image in propertyImages!) {
        formData.files.add(
          MapEntry(
            'property_images',
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          ),
        );
      }
    }

    // ✅ فيديوهات العقار
    if (propertyVideos != null && propertyVideos!.isNotEmpty) {
      for (var video in propertyVideos!) {
        formData.files.add(
          MapEntry(
            'property_videos',
            await MultipartFile.fromFile(
              video.path,
              filename: video.path.split('/').last,
            ),
          ),
        );
      }
    }

    // ✅ وثيقة الملكية (PDF / صورة)
    if (deedDocument != null) {
      formData.files.add(
        MapEntry(
          'deed_document',
          await MultipartFile.fromFile(
            deedDocument!.path,
            filename: deedDocument!.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }
}
