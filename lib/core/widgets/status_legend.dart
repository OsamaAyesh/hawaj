import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';

import '../../features/providers/offers_provider/manage_list_offer/presentation/widgets/offer_status_color.dart';

class StatusLegendWidget extends StatelessWidget {
  const StatusLegendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w12,
        vertical: ManagerHeight.h8,
      ),
      padding: EdgeInsets.all(ManagerWidth.w12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ManagerRadius.r12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ManagerStrings.legendTitle,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s13,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: ManagerHeight.h10),
          Wrap(
            spacing: ManagerWidth.w12,
            runSpacing: ManagerHeight.h8,
            children: [
              _buildLegendItem(
                color: OfferStatusHelper.getStatusColor(1),
                label: ManagerStrings.offerStatusPublished,
                icon: Icons.check_circle,
              ),
              _buildLegendItem(
                color: OfferStatusHelper.getStatusColor(2),
                label: ManagerStrings.offerStatusUnpublished,
                icon: Icons.visibility_off,
              ),
              _buildLegendItem(
                color: OfferStatusHelper.getStatusColor(3),
                label: ManagerStrings.offerStatusFinished,
                icon: Icons.schedule,
              ),
              _buildLegendItem(
                color: OfferStatusHelper.getStatusColor(4),
                label: ManagerStrings.offerStatusCanceled,
                icon: Icons.cancel,
              ),
              _buildLegendItem(
                color: OfferStatusHelper.getStatusColor(5),
                label: ManagerStrings.offerStatusPending,
                icon: Icons.pending,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w8,
        vertical: ManagerHeight.h4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ManagerRadius.r8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: ManagerWidth.w4),
          Text(
            label,
            style: getMediumTextStyle(
              fontSize: ManagerFontSize.s11,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
