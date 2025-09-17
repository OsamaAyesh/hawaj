import 'organization_min_model.dart';

class OfferGeneralItemModel {
  int offerId;
  String offerName;
  double offerPrice;
  String offerDescription;
  String offerImage;
  double offerPercentage;
  int offerType;
  String offerTypeLabel;
  String offerStartDate;
  String offerEndDate;
  int offerStatus;
  String offerStatusLabel;
  OrganizationMinModel organization;

  OfferGeneralItemModel(
      {required this.offerId,
      required this.offerName,
      required this.offerPrice,
      required this.offerDescription,
      required this.offerImage,
      required this.offerPercentage,
      required this.offerType,
      required this.offerTypeLabel,
      required this.offerStartDate,
      required this.offerEndDate,
      required this.offerStatus,
      required this.offerStatusLabel,
      required this.organization});
}
