import 'package:flutter/material.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import '../../domain/model/offer_item_model.dart';

Color getStatusColor(OfferItemModel offer) {
  switch (offer.offerStatus) {
    case 3: // منتهي
      return ManagerColors.greyStatus;
    case 1: // نشر (شغال)
      return ManagerColors.redStatus;
    case 2: // غير منشور / ongoing
      return ManagerColors.primaryColor;
    default:
      return ManagerColors.greyStatus;
  }
}

String getStatusText(OfferItemModel offer) {
  switch (offer.offerStatus) {
    case 3:
      return "منتهي";
    case 1:
      return "عرض شغال";
    case 2:
      return "مستمر";
    default:
      return "";
  }
}


// import '../../../../../../core/resources/manager_colors.dart';
// import '../model_view/offer_model.dart';
// import "package:flutter/material.dart";
//
// Color getStatusColor(OfferModel offer) {
//   switch (offer.status) {
//     case "expired":
//       return ManagerColors.greyStatus;
//     case "active":
//       return ManagerColors.redStatus;
//     case "ongoing":
//       return ManagerColors.primaryColor;
//     default:
//       return ManagerColors.greyStatus;
//   }
// }
// String getStatusText(OfferModel offer) {
//   switch (offer.status) {
//     case "expired":
//       return "منتهي";
//     case "active":
//       return "عرض شغال";
//     case "ongoing":
//       return "مستمر";
//     default:
//       return "";
//   }
// }