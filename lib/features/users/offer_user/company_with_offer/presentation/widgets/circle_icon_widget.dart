import 'package:flutter/material.dart';

import '../../../../../../core/resources/manager_colors.dart';
import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_width.dart';
class CircleIconWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const CircleIconWidget ({super.key,required this.icon,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child: Container(
        height: ManagerHeight.h28,
        width: ManagerWidth.w28,
        decoration: const BoxDecoration(
          color: ManagerColors.white,
          shape: BoxShape.circle,
        ),
        child:  Icon(icon,size: 20,),
      ),
    );
  }
}
