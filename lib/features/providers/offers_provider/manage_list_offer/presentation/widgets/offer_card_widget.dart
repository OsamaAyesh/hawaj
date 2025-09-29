import 'package:app_mobile/core/model/offer_general_item_model.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'offer_status_color.dart';

class OfferCardWidget extends StatelessWidget {
  final OfferGeneralItemModel offer;

  const OfferCardWidget({required this.offer, super.key});

  @override
  Widget build(BuildContext context) {
    final statusColor = OfferStatusHelper.getStatusColor(offer.offerStatus);

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to offer details
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ManagerRadius.r6),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              statusColor,
              statusColor.withOpacity(0.85),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.3),
              blurRadius: ManagerRadius.r6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(statusColor),
            SizedBox(height: ManagerHeight.h8),
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(Color statusColor) {
    return Stack(
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ManagerRadius.r6),
          ),
          child: CachedNetworkImage(
            imageUrl: offer.offerImage ?? '',
            width: double.infinity,
            height: ManagerHeight.h120,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: statusColor,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey[400],
                    size: 40,
                  ),
                  SizedBox(height: ManagerHeight.h4),
                  Text(
                    'لا توجد صورة',
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Status Badge
        Positioned(
          top: ManagerHeight.h8,
          right: ManagerWidth.w8,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w8,
              vertical: ManagerHeight.h4,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(ManagerRadius.r8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(),
                  size: 12,
                  color: statusColor,
                ),
                SizedBox(width: ManagerWidth.w4),
                Text(
                  OfferStatusHelper.getStatusText(offer.offerStatus),
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s9,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Edit Button
        Positioned(
          top: ManagerHeight.h8,
          left: ManagerWidth.w8,
          child: Container(
            height: ManagerHeight.h28,
            width: ManagerWidth.w28,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Icon(
              Icons.edit_outlined,
              size: ManagerWidth.w14,
              color: statusColor,
            ),
          ),
        ),

        // Discount Badge (if applicable)
        if (offer.offerPercentage != null && offer.offerPercentage! > 0)
          Positioned(
            bottom: ManagerHeight.h8,
            right: ManagerWidth.w8,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w10,
                vertical: ManagerHeight.h4,
              ),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(ManagerRadius.r8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.5),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_offer,
                    size: 12,
                    color: Colors.white,
                  ),
                  SizedBox(width: ManagerWidth.w4),
                  Text(
                    '%${offer.offerPercentage!.toInt()}-',
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Name
            Text(
              offer.offerName ?? 'عرض',
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s11,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: ManagerHeight.h6),

            // Price Section
            Row(
              children: [
                if (offer.offerPrice != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ManagerWidth.w10,
                      vertical: ManagerHeight.h4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(ManagerRadius.r6),
                    ),
                    child: Text(
                      "${offer.offerPrice!.toStringAsFixed(0)} ر.س",
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ] else
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ManagerWidth.w10,
                      vertical: ManagerHeight.h4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(ManagerRadius.r6),
                    ),
                    child: Text(
                      'لا يوجد سعر',
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s9,
                        color: Colors.white70,
                      ),
                    ),
                  ),
              ],
            ),

            const Spacer(),

            // Date Section
            if (offer.offerEndDate != null)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ManagerWidth.w8,
                  vertical: ManagerHeight.h4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(ManagerRadius.r6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 10,
                      color: Colors.white,
                    ),
                    SizedBox(width: ManagerWidth.w4),
                    Text(
                      offer.offerEndDate!,
                      style: getMediumTextStyle(
                        fontSize: ManagerFontSize.s9,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: ManagerHeight.h8),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (offer.offerStatus) {
      case 1:
        return Icons.check_circle;
      case 2:
        return Icons.visibility_off;
      case 3:
        return Icons.schedule;
      case 4:
        return Icons.cancel;
      case 5:
        return Icons.pending;
      default:
        return Icons.help_outline;
    }
  }
}
