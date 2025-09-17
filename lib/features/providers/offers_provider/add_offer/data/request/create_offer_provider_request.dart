import 'dart:io';

import 'package:dio/dio.dart';

class CreateOfferProviderRequest {
  final String? productName;
  final String? productDescription;
  final File? productImage;
  final String productPrice; // مطلوب
  final String offerType; // مطلوب (1, 2, 3)
  final String? offerPrice;
  final String? offerStartDate;
  final String? offerEndDate;
  final String? offerDescription;
  final int organizationId; // مطلوب
  final String?
      offerStatus; // (1 نشر, 2 غير منشور, 3 منتهي, 4 ملغي, 5 قيد المعاينة)

  CreateOfferProviderRequest({
    this.productName,
    this.productDescription,
    this.productImage,
    required this.productPrice,
    required this.offerType,
    this.offerPrice,
    this.offerStartDate,
    this.offerEndDate,
    this.offerDescription,
    required this.organizationId,
    this.offerStatus,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();

    // ==== Text Fields ====
    if (productName?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('product_name', productName!));
    }
    if (productDescription?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('product_description', productDescription!));
    }
    formData.fields.add(MapEntry('product_price', productPrice));
    formData.fields.add(MapEntry('offer_type', offerType));
    formData.fields.add(MapEntry('organization_id', organizationId.toString()));

    if (offerPrice?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('offer_price', offerPrice!));
    }
    if (offerStartDate?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('offer_start_date', offerStartDate!));
    }
    if (offerEndDate?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('offer_end_date', offerEndDate!));
    }
    if (offerDescription?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('offer_description', offerDescription!));
    }
    if (offerStatus?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('offer_status', offerStatus!));
    }

    // ==== File Field ====
    if (productImage != null) {
      formData.files.add(MapEntry(
        'product_images',
        await MultipartFile.fromFile(
          productImage!.path,
          filename: productImage!.path.split('/').last,
        ),
      ));
    }

    return formData;
  }
}
