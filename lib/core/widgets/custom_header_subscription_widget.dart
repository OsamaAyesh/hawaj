import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';

import '../resources/manager_colors.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;

  const CustomHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      color: ManagerColors.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              title,
              style: getBoldTextStyle(fontSize: ManagerFontSize.s16, color: ManagerColors.white),
            ),
          ),

          Align(
            alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
            child: CircleIconButton(
              icon: isRTL ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
              onTap: onBack,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final Color backgroundColor;
  final double size;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.deepPurple,
    this.backgroundColor = Colors.white,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Transform.translate(
            offset: Directionality.of(context) == TextDirection.rtl
                ? const Offset(-3, 0) // للغة العربية (RTL)
                : const Offset(3, 0), // للغة الإنجليزية (LTR)
            child: Icon(
              icon,
              color: iconColor,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
