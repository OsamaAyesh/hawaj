import '../../../../../../core/resources/manager_colors.dart';
import '../model_view/offer_model.dart';
import "package:flutter/material.dart";

Color getStatusColor(OfferModel offer) {
  switch (offer.status) {
    case "expired":
      return ManagerColors.greyStatus;
    case "active":
      return ManagerColors.redStatus;
    case "ongoing":
      return ManagerColors.primaryColor;
    default:
      return ManagerColors.greyStatus;
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