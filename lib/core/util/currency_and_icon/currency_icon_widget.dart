import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/manager_colors.dart';

class CurrencyIconWidget extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const CurrencyIconWidget({
    super.key,
    required this.height,
    required this.width,
    this.color = ManagerColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      ManagerIcons.riyalIcon,
      height: height,
      width: width,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
