import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/model/offer_new_item_model.dart';

class UserOfferCardWidget extends StatelessWidget {
  final OfferNewItemModel offer;
  final VoidCallback? onTap;

  const UserOfferCardWidget({required this.offer, this.onTap, super.key});

  bool get hasDiscount =>
      offer.offerPercentage != null && offer.offerPercentage! > 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ManagerRadius.r12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            Expanded(child: _buildContentSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ManagerRadius.r12),
          ),
          child: CachedNetworkImage(
            imageUrl: offer.offerImage,
            width: double.infinity,
            height: ManagerHeight.h115,
            fit: BoxFit.cover,
            placeholder: (_, __) => Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ManagerColors.primaryColor,
              ),
            ),
            errorWidget: (_, __, ___) => Container(
              color: Colors.grey[100],
              alignment: Alignment.center,
              child: Icon(Icons.image_not_supported_outlined,
                  color: Colors.grey[400]),
            ),
          ),
        ),
        if (hasDiscount)
          Positioned(
            top: ManagerHeight.h8,
            left: ManagerWidth.w8,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w10,
                vertical: ManagerHeight.h5,
              ),
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor,
                borderRadius: BorderRadius.circular(ManagerRadius.r20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_offer_rounded,
                      size: 12, color: Colors.white),
                  SizedBox(width: ManagerWidth.w3),
                  Text(
                    '%${offer.offerPercentage!.toStringAsFixed(0)}-',
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
    return Padding(
      padding: EdgeInsets.all(ManagerWidth.w10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            offer.offerName,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s11,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ManagerHeight.h6),
          _buildPriceSection(),
          const Spacer(),
          _buildDateSection(),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w10,
        vertical: ManagerHeight.h5,
      ),
      decoration: BoxDecoration(
        color: hasDiscount
            ? ManagerColors.primaryColor.withOpacity(0.1)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(ManagerRadius.r8),
        border: Border.all(
          color: hasDiscount
              ? ManagerColors.primaryColor.withOpacity(0.3)
              : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            "${offer.offerPriceValue.toStringAsFixed(0)}",
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s12,
              color: hasDiscount ? ManagerColors.primaryColor : Colors.black87,
            ),
          ),
          SizedBox(width: ManagerWidth.w3),
          Text(
            "ر.س",
            style: getMediumTextStyle(
              fontSize: ManagerFontSize.s9,
              color: hasDiscount
                  ? ManagerColors.primaryColor.withOpacity(0.8)
                  : Colors.grey[600]!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return offer.offerEndDate.isEmpty
        ? const SizedBox.shrink()
        : Container(
            padding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w8,
              vertical: ManagerHeight.h4,
            ),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(ManagerRadius.r6),
              border: Border.all(color: Colors.orange[200]!, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 10, color: Colors.orange),
                SizedBox(width: ManagerWidth.w4),
                Flexible(
                  child: Text(
                    'ينتهي: ${offer.offerEndDate}',
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s7,
                      color: Colors.orange[800]!,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
  }
}
