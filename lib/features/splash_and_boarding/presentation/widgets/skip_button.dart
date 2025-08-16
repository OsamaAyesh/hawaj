import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/manager_colors.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SkipButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        ManagerStrings.skip,
        style: getRegularTextStyle(
          fontSize: ManagerFontSize.s12,
          color: ManagerColors.gery1OnBoarding,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
