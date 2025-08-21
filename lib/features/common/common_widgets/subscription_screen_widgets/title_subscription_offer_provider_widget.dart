import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';

class TitleSubscriptionOfferProviderWidget extends StatelessWidget {
  final String title;

  const TitleSubscriptionOfferProviderWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: getBoldTextStyle(
        fontSize: ManagerFontSize.s16,
        color: ManagerColors.white,
      ),
      textAlign: TextAlign.start,
    );
  }
}
