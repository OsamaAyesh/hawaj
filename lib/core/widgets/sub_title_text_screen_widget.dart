import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';

class SubTitleTextScreenWidget extends StatelessWidget {
  final String subTitle;

  const SubTitleTextScreenWidget({
    super.key,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      subTitle,
      style: getRegularTextStyle(
        fontSize: ManagerFontSize.s14,
        color: ManagerColors.colorGrey,
      ),
    );
  }
}
