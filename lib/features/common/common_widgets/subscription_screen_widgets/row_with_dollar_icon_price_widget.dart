import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

class RowWithDollarIconPriceWidget extends StatelessWidget {
  final String pricePlan;

  const RowWithDollarIconPriceWidget({super.key, required this.pricePlan});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: ManagerHeight.h16),
          child: Image.asset(ManagerIcons.dollarIcon,
            height: ManagerHeight.h24,
            width: ManagerWidth.w24,
            fit: BoxFit.contain,),
        ),
        SizedBox(width: ManagerWidth.w2,),
        Text(
          pricePlan,
          style: getBoldTextStyle(
            fontSize: ManagerFontSize.s48,
            color: ManagerColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
