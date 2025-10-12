import 'package:flutter/material.dart';
import 'package:get/get.dart'; // لا تنسَ إضافة get في pubspec.yaml

class CurrencyTextWidget extends StatelessWidget {
  final TextStyle style;

  const CurrencyTextWidget({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == 'ar';

    return Text(
      isArabic ? "الدولار الأمريكي" : "US Dollar",
      style: style,
    );
  }
}
