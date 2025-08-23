import 'package:flutter/material.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_icons.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_width.dart';

class NotificationIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool showDot; // هل يظهر البادج أو لا

  const NotificationIconButton({
    super.key,
    required this.onPressed,
    this.showDot = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // الزر الأساسي
          Container(
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
            child: Image.asset(
              ManagerIcons.notficationIcon,
              fit: BoxFit.contain,
            ),
          ),

          if (showDot)
            Positioned(
              top: ManagerHeight.h6,
              right: ManagerWidth.w6,
              child: Container(
                width: ManagerWidth.w6,
                height: ManagerHeight.h6,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
