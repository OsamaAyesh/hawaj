import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:flutter/material.dart';


class ContainerPageIndicator extends StatelessWidget {
  double marginEnd;
  bool selected;

  ContainerPageIndicator({super.key,required this.selected,required this.marginEnd});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ManagerHeight.h4,
      width: ManagerHeight.h25,
      margin: EdgeInsetsDirectional.only(end: marginEnd),
      decoration: BoxDecoration(
        color: selected ? ManagerColors.primaryColor : ManagerColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ManagerRadius.r2),
      ),
    );
  }
}
