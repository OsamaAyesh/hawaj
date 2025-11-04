import 'package:app_mobile/core/model/offer_new_item_model.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OfferCardWidget extends StatelessWidget {
  final OfferNewItemModel offer;

  const OfferCardWidget({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ManagerRadius.r12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(ManagerRadius.r12)),
      child: CachedNetworkImage(
        imageUrl: offer.productImages,
        height: ManagerHeight.h120,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, __) =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (_, __, ___) => Container(
          height: ManagerHeight.h120,
          color: Colors.grey[100],
          child: const Icon(Icons.image_outlined, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: EdgeInsets.all(ManagerWidth.w8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            offer.productName,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s12,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ManagerHeight.h4),
          Text(
            offer.productDescription,
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s9,
              color: Colors.grey[600]!,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ManagerHeight.h6),
          Text(
            "${offer.offerPrice} ر.س",
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s11,
              color: ManagerColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
