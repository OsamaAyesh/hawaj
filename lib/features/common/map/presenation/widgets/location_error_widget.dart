import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const LocationErrorWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 12),
            Text(
              isArabic
                  ? "فشل في تحميل الموقع الحالي"
                  : "Failed to load current location",
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s16,
                color: ManagerColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? "اضغط على الزر بالأسفل للمحاولة مجددًا"
                  : "Tap the button below to try again",
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.greyWithColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                isArabic ? "إعادة المحاولة" : "Retry",
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s14,
                  color: ManagerColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
