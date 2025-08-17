import 'package:flutter/material.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_styles.dart';

class SubTitleTextAuthWidget extends StatelessWidget {
  final String subTitle;


  const SubTitleTextAuthWidget({super.key, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Text(subTitle,
      style: getRegularTextStyle(
        fontSize: ManagerFontSize.s12, color: ManagerColors.gery1OnBoarding,
      ),
      maxLines: 2,
      textAlign: TextAlign.center,);
  }
}
