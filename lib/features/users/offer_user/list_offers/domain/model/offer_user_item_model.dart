class OfferUserItemModel {
  int id;
  String productName;
  String productDescription;
  List<String> productImages;
  double productPrice;
  int offerType;
  double offerPrice;
  String offerStartDate;
  String offerEndDate;
  String offerDescription;
  int organizationId;
  int offerStatus;

  OfferUserItemModel({
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.productImages,
    required this.productPrice,
    required this.offerType,
    required this.offerPrice,
    required this.offerStartDate,
    required this.offerEndDate,
    required this.offerDescription,
    required this.organizationId,
    required this.offerStatus
});
}