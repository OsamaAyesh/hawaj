import '../../../../../../core/resources/manager_colors.dart';
import '../model_view/offer_model.dart';
import "package:flutter/material.dart";

Color getStatusColor(OfferModel offer) {
  switch (offer.status) {
    case "expired":
      return ManagerColors.colorGrey.withOpacity(0.6);
    case "active":
      return ManagerColors.redNew;
    case "ongoing":
      return ManagerColors.primaryColor;
    default:
      return ManagerColors.colorGrey;
  }
}
String getStatusText(OfferModel offer) {
  switch (offer.status) {
    case "expired":
      return "منتهي";
    case "active":
      return "عرض شغال";
    case "ongoing":
      return "مستمر";
    default:
      return "";
  }
}