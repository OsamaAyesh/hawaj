import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/util/currency_and_icon/currency_text_widget.dart';
import 'package:flutter/material.dart';

class RealEstateActionButtonsRow extends StatelessWidget {
  final String title;
  final String price;
  final String infoText;
  final VoidCallback onPriceNotify;
  final VoidCallback onVisitRequest;

  const RealEstateActionButtonsRow({
    super.key,
    required this.title,
    required this.price,
    required this.infoText,
    required this.onPriceNotify,
    required this.onVisitRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ===========================
        // 🏠 معلومات العقار الأساسية
        // ===========================
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.black,
              ),
            ),
            SizedBox(height: ManagerHeight.h4),
            Row(
              children: [
                Text(
                  price,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s20,
                    color: ManagerColors.black,
                  ),
                ),
                SizedBox(width: ManagerWidth.w4),
                CurrencyTextWidget(
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.primaryColor,
                  ),
                )
              ],
            ),
            SizedBox(height: ManagerHeight.h4),
            Text(
              infoText,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.black,
              ),
            ),
          ],
        ),
        const Spacer(),

        // ===========================
        // 📩 أزرار الإجراءات
        // ===========================
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 🔔 زر إشعار السعر
            GestureDetector(
              onTap: onPriceNotify,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
                height: ManagerHeight.h26,
                decoration: BoxDecoration(
                  color: ManagerColors.primaryColor,
                  borderRadius: BorderRadius.circular(ManagerRadius.r4),
                ),
                child: Center(
                  child: Text(
                    "اخبرني عند نزول الاسعار",
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s8,
                      color: ManagerColors.white,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: ManagerHeight.h6),

            // 📅 زر طلب الزيارة
            GestureDetector(
              onTap: onVisitRequest,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
                height: ManagerHeight.h26,
                decoration: BoxDecoration(
                  color: ManagerColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ManagerRadius.r4),
                ),
                child: Center(
                  child: Text(
                    "طلب زيارة",
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s8,
                      color: ManagerColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
