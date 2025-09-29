import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:flutter/material.dart';

class OfferStatusHelper {
  static Color getStatusColor(int? status) {
    switch (status) {
      case 1: // Published
        return const Color(0xFF10B981); // Green
      case 2: // Unpublished
        return ManagerColors.primaryColor; // Blue
      case 3: // Expired
        return const Color(0xFF6B7280); // Grey
      case 4: // Canceled
        return const Color(0xFFEF4444); // Red
      case 5: // Pending Review
        return const Color(0xFFF59E0B); // Orange
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  static String getStatusText(int? status) {
    switch (status) {
      case 1:
        return "منشور";
      case 2:
        return "غير منشور";
      case 3:
        return "منتهي";
      case 4:
        return "ملغي";
      case 5:
        return "قيد المراجعة";
      default:
        return "غير محدد";
    }
  }
}
