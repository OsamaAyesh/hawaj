import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

class SubscriptionInformationWidget extends StatelessWidget {
  final String packageName;
  final String startDate;
  final String endDate;
  final String status; // نص حالة الاشتراك
  final Color statusColor; // لون الحالة

  const SubscriptionInformationWidget({
    super.key,
    required this.packageName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w16,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(ManagerWidth.w16),
        decoration: BoxDecoration(
          color: ManagerColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// العنوان الأساسي
            Text(
              "معلومات الاشتراك",
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.primaryColor,
              ),
            ),
            SizedBox(height: ManagerHeight.h8),

            /// اسم الباقة
            Text(
              "اسم الباقة",
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.greyWithColor,
              ),
            ),
            SizedBox(height: ManagerHeight.h4),

            Text(
              packageName,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s20,
                color: ManagerColors.primaryColor,
              ),
            ),

            SizedBox(height: ManagerHeight.h16),

            /// تواريخ الاشتراك
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDateItem("تاريخ بداية الاشتراك", startDate),
                Container(
                  height: ManagerHeight.h40,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                _buildDateItem("تاريخ نهاية الاشتراك", endDate),
              ],
            ),

            SizedBox(height: ManagerHeight.h16),

            /// حالة الاشتراك
            Text(
              "حالة الاشتراك",
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.greyWithColor,
              ),
            ),
            SizedBox(height: ManagerHeight.h6),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ManagerWidth.w16,
                vertical: ManagerHeight.h8,
              ),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateItem(String title, String date) {
    return Column(
      children: [
        Text(
          title,
          style: getRegularTextStyle(
            fontSize: ManagerFontSize.s12,
            color: ManagerColors.greyWithColor,
          ),
        ),
        SizedBox(height: ManagerHeight.h4),
        Text(
          date,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s14,
            color: ManagerColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
