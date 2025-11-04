class OfferNewItemModel {
  final String id;

  final String productName;

  final String productDescription;

  final String productImages;

  final String productPrice;

  final String offerType;

  final String offerTypeLabel;

  final String offerPrice;

  final String offerStartDate;

  final String offerEndDate;

  final String offerDescription;

  final String organizationId;

  final String organizationIdLabel;

  final String offerStatus;

  final String offerStatusLabel;

  final String images;
  final String keywords;

  OfferNewItemModel({
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.productImages,
    required this.productPrice,
    required this.offerType,
    required this.offerTypeLabel,
    required this.offerPrice,
    required this.offerStartDate,
    required this.offerEndDate,
    required this.offerDescription,
    required this.organizationId,
    required this.organizationIdLabel,
    required this.offerStatus,
    required this.offerStatusLabel,
    required this.images,
    required this.keywords,
  });

  String get offerName => productName;

  String get offerImage => productImages.isNotEmpty ? productImages : images;

  double get offerPriceValue =>
      double.tryParse(offerPrice.isNotEmpty ? offerPrice : productPrice) ?? 0.0;

  double? get offerPercentage {
    if (offerType == "1" && offerPrice.isNotEmpty && productPrice.isNotEmpty) {
      final double p = double.tryParse(productPrice) ?? 0.0;
      final double d = double.tryParse(offerPrice) ?? 0.0;
      if (p > 0 && d > 0 && d < p) {
        return ((p - d) / p) * 100;
      }
    }
    return null;
  }
}
