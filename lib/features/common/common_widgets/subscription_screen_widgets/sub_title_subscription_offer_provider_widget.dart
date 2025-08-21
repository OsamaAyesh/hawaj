import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
class SubTitleSubscriptionOfferProviderWidget extends StatelessWidget {
  final String subTitleString;
  const SubTitleSubscriptionOfferProviderWidget ({super.key,required this.subTitleString,});

  @override
  Widget build(BuildContext context) {
    return Text(
      subTitleString,
      style: getRegularTextStyle(
        fontSize: ManagerFontSize.s12,
        color: ManagerColors.white,
      ),
    );
  }
}
