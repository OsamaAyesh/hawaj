import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

class MenuIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MenuIconButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: ManagerHeight.h32,
        width: ManagerWidth.w32,
        padding: EdgeInsets.symmetric(
          horizontal: ManagerWidth.w5,
          vertical: ManagerHeight.h5,
        ),
        decoration: BoxDecoration(
          color: ManagerColors.primaryColor,
          borderRadius: BorderRadius.circular(
            ManagerRadius.r6,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ManagerWidth.w2,
            vertical: ManagerHeight.h2,
          ),
          child: Image.asset(
            ManagerIcons.menuIcon,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
