import 'package:flutter/material.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_styles.dart';

class TitleAuthTextWidget extends StatelessWidget {
  final String title;

  const TitleAuthTextWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: getBoldTextStyle(
        fontSize: ManagerFontSize.s16, color: ManagerColors.black,),);
  }
}
