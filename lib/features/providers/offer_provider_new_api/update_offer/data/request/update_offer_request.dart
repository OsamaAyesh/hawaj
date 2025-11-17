// update_offer_request.dart
import 'dart:io';

import 'package:dio/dio.dart';

/// Request body for updating an existing offer.
class UpdateOfferRequest {
  final String offerId; // Required - ID of the offer to update
  final String? productName;
  final String? productDescription;
  final File? productImage; // New image (optional)
  final String? productPrice;
  final String? offerType;
  final String? offerPrice;
  final String? offerStartDate;
  final String? offerEndDate;
  final String? offerDescription;
  final int? organizationId;
  final String? offerStatus;

  UpdateOfferRequest({
    required this.offerId,
    this.productName,
    this.productDescription,
    this.productImage,
    this.productPrice,
    this.offerType,
    this.offerPrice,
    this.offerStartDate,
    this.offerEndDate,
    this.offerDescription,
    this.organizationId,
    this.offerStatus,
  });

  /// Converts the data to FormData for multipart/form-data requests
  Future<FormData> toFormData() async {
    final formData = FormData();

    // Add offer ID
    formData.fields.add(MapEntry('id', offerId));

    // ==== Text Fields - Only add if not null ====
    if (productName?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('product_name', productName!));
    }
    if (productDescription?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('product_description', productDescription!));
    }
    if (productPrice?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('product_price', productPrice!));
    }
    if (offerType?.isNotEmpty ?? false) {
      formData.fields.add(MapEntry('offer_type', offerType!));
    }
    if (organizationId != null) {
      formData.fields
          .add(MapEntry('organization_id', organizationId.toString()));
    }
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

    // ==== File Field - Only add if new image is selected ====
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
