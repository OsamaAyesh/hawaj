import 'package:app_mobile/core/model/offer_general_item_model.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserOfferCardWidget extends StatelessWidget {
  final OfferGeneralItemModel offer;
  final VoidCallback? onTap;

  const UserOfferCardWidget({
    required this.offer,
    this.onTap,
    super.key,
  });

  /// التحقق إذا كان العرض يحتوي على خصم
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
            Expanded(
              child: _buildContentSection(),
            ),
          ],
        ),
      ),
    );
  }

  /// قسم الصورة
  Widget _buildImageSection() {
    return Stack(
      children: [
        // الصورة الرئيسية
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ManagerRadius.r12),
          ),
          child: CachedNetworkImage(
            imageUrl: offer.offerImage ?? '',
            width: double.infinity,
            height: ManagerHeight.h115,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[100],
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ManagerColors.primaryColor,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[50],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    color: Colors.grey[300],
                    size: 32,
                  ),
                  SizedBox(height: ManagerHeight.h4),
                  Text(
                    'لا توجد صورة',
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s8,
                      color: Colors.grey[400]!,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // شارة الخصم (إذا وجدت)
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
                gradient: LinearGradient(
                  colors: [
                    ManagerColors.primaryColor,
                    ManagerColors.primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(ManagerRadius.r20),
                boxShadow: [
                  BoxShadow(
                    color: ManagerColors.primaryColor.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_offer_rounded,
                    size: 12,
                    color: Colors.white,
                  ),
                  SizedBox(width: ManagerWidth.w3),
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

        // أيقونة المفضلة
        Positioned(
          top: ManagerHeight.h8,
          right: ManagerWidth.w8,
          child: Container(
            height: ManagerHeight.h30,
            width: ManagerWidth.w30,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              size: 15,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  /// قسم المحتوى
  Widget _buildContentSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ManagerWidth.w10,
        ManagerHeight.h10,
        ManagerWidth.w10,
        ManagerHeight.h8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // اسم العرض
          Text(
            offer.offerName ?? 'عرض مميز',
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s11,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: ManagerHeight.h6),

          // قسم السعر
          _buildPriceSection(),

          // استخدام Spacer لدفع التاريخ للأسفل
          const Spacer(),

          // التاريخ (إذا وجد)
          if (offer.offerEndDate != null) _buildDateSection(),
        ],
      ),
    );
  }

  /// قسم السعر
  Widget _buildPriceSection() {
    if (offer.offerPrice == null) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: ManagerWidth.w8,
          vertical: ManagerHeight.h5,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(ManagerRadius.r6),
        ),
        child: Text(
          'السعر غير متوفر',
          style: getRegularTextStyle(
            fontSize: ManagerFontSize.s8,
            color: Colors.grey[600]!,
          ),
        ),
      );
    }

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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${offer.offerPrice!.toStringAsFixed(0)}",
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

  /// قسم التاريخ
  Widget _buildDateSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w8,
        vertical: ManagerHeight.h4,
      ),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(ManagerRadius.r6),
        border: Border.all(
          color: Colors.orange[200]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 10,
            color: Colors.orange[700],
          ),
          SizedBox(width: ManagerWidth.w4),
          Flexible(
            child: Text(
              'ينتهي: ${offer.offerEndDate}',
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s7,
                color: Colors.orange[800]!,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
